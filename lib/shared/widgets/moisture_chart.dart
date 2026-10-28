import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

/// Point unique tracé dans le graphique d'humidité.
class MoistureChartPoint {
  final DateTime time;
  final double value;

  const MoistureChartPoint({required this.time, required this.value});
}

/// Graphique d'évolution de l'humidité, dessiné à la main (CustomPainter).
///
/// Aucune dépendance externe : le rendu est contrôlé, léger et accessible.
/// Les zones sans valeur ne sont pas interpolées en silence : un segment
/// manquant est rendu comme une rupture visible.
class MoistureChart extends StatelessWidget {
  final List<MoistureChartPoint> points;
  final double? minY;
  final double? maxY;
  final String unitLabel;
  final List<double>? thresholdLines;
  final String? thresholdLabel;
  final String? emptyLabel;

  const MoistureChart({
    super.key,
    required this.points,
    this.minY,
    this.maxY,
    this.unitLabel = '%',
    this.thresholdLines,
    this.thresholdLabel,
    this.emptyLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (points.isEmpty) {
      return Container(
        height: 160,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Text(
          emptyLabel ?? '',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 180,
          width: double.infinity,
          child: CustomPaint(
            painter: _MoistureChartPainter(
              points: points,
              minY: minY,
              maxY: maxY,
              lineColor: theme.colorScheme.primary,
              gridColor: theme.dividerColor,
              axisLabelColor: theme.colorScheme.onSurfaceVariant,
              thresholdLines: thresholdLines ?? const [],
              thresholdColor: context.statusPalette.accent,
              fillColor: theme.colorScheme.primary.withValues(alpha: 0.12),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.s8),
        Row(
          children: [
            _LegendDot(color: theme.colorScheme.primary, label: unitLabel),
            if ((thresholdLines ?? const []).isNotEmpty &&
                thresholdLabel != null) ...[
              const SizedBox(width: AppSpacing.s16),
              _LegendDot(
                color: context.statusPalette.accent,
                label: thresholdLabel!,
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall
              ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _MoistureChartPainter extends CustomPainter {
  final List<MoistureChartPoint> points;
  final double? minY;
  final double? maxY;
  final Color lineColor;
  final Color gridColor;
  final Color axisLabelColor;
  final Color fillColor;
  final Color thresholdColor;
  final List<double> thresholdLines;

  _MoistureChartPainter({
    required this.points,
    required this.minY,
    required this.maxY,
    required this.lineColor,
    required this.gridColor,
    required this.axisLabelColor,
    required this.fillColor,
    required this.thresholdColor,
    required this.thresholdLines,
  });

  static const double _leftAxis = 38;
  static const double _bottomAxis = 22;

  @override
  void paint(Canvas canvas, Size size) {
    final plotRect = Rect.fromLTRB(
      _leftAxis,
      8,
      size.width,
      size.height - _bottomAxis,
    );
    if (plotRect.width <= 0 || plotRect.height <= 0) return;

    final values = points.map((p) => p.value).toList();
    var minValue = minY ?? values.reduce(math.min);
    var maxValue = maxY ?? values.reduce(math.max);
    if (maxValue - minValue < 1) {
      maxValue += 1;
      minValue -= 1;
    } else {
      final margin = (maxValue - minValue) * 0.12;
      minValue -= margin;
      maxValue += margin;
    }
    if (minY == null) minValue = math.max(0, minValue);
    if (maxY == null && maxValue > 100) maxValue = 100;

    final first = points.first.time;
    final last = points.last.time;
    final span = math.max(1, last.difference(first).inMilliseconds);

    double xFor(DateTime t) =>
        plotRect.left +
        plotRect.width * (t.difference(first).inMilliseconds / span);
    double yFor(double v) =>
        plotRect.bottom -
        plotRect.height * ((v - minValue) / (maxValue - minValue));

    // Grille horizontale + graduations
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    const divisions = 4;
    for (var i = 0; i <= divisions; i++) {
      final value = minValue + (maxValue - minValue) * (i / divisions);
      final y = yFor(value);
      canvas.drawLine(
        Offset(plotRect.left, y),
        Offset(plotRect.right, y),
        gridPaint,
      );
      _text(
        canvas,
        value.toStringAsFixed(0),
        Offset(0, y - 7),
        axisLabelColor,
        align: TextAlign.left,
      );
    }

    // Seuils
    for (final threshold in thresholdLines) {
      if (threshold < minValue || threshold > maxValue) continue;
      final y = yFor(threshold);
      final paint = Paint()
        ..color = thresholdColor.withValues(alpha: 0.65)
        ..strokeWidth = 1.4;
      _dashedLine(
        canvas,
        Offset(plotRect.left, y),
        Offset(plotRect.right, y),
        paint,
      );
    }

    // Aire sous la courbe
    final path = Path();
    final fill = Path();
    for (var i = 0; i < points.length; i++) {
      final offset = Offset(xFor(points[i].time), yFor(points[i].value));
      if (i == 0) {
        path.moveTo(offset.dx, offset.dy);
        fill.moveTo(offset.dx, plotRect.bottom);
        fill.lineTo(offset.dx, offset.dy);
      } else {
        path.lineTo(offset.dx, offset.dy);
        fill.lineTo(offset.dx, offset.dy);
      }
    }
    fill.lineTo(xFor(points.last.time), plotRect.bottom);
    fill.close();

    canvas.drawPath(fill, Paint()..color = fillColor);
    canvas.drawPath(
      path,
      Paint()
        ..color = lineColor
        ..strokeWidth = 2.4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Dernier point mis en avant
    final lastPoint = points.last;
    final lastOffset = Offset(xFor(lastPoint.time), yFor(lastPoint.value));
    canvas.drawCircle(lastOffset, 5.5, Paint()..color = fillColor);
    canvas.drawCircle(lastOffset, 3.2, Paint()..color = lineColor);

    // Axe temporel : début et fin
    _text(
      canvas,
      _shortTime(first),
      Offset(plotRect.left, plotRect.bottom + 6),
      axisLabelColor,
      align: TextAlign.left,
    );
    _text(
      canvas,
      _shortTime(last),
      Offset(plotRect.right - 42, plotRect.bottom + 6),
      axisLabelColor,
      align: TextAlign.left,
    );
  }

  void _dashedLine(Canvas canvas, Offset a, Offset b, Paint paint) {
    const dash = 5.0;
    const gap = 4.0;
    var x = a.dx;
    while (x < b.dx) {
      canvas.drawLine(
        Offset(x, a.dy),
        Offset(math.min(x + dash, b.dx), b.dy),
        paint,
      );
      x += dash + gap;
    }
  }

  void _text(
    Canvas canvas,
    String value,
    Offset offset,
    Color color, {
    TextAlign align = TextAlign.left,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: value,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: align,
    )..layout();
    painter.paint(canvas, offset);
  }

  String _shortTime(DateTime value) {
    final h = value.hour.toString().padLeft(2, '0');
    final m = value.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  bool shouldRepaint(covariant _MoistureChartPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.thresholdLines != thresholdLines;
  }
}
