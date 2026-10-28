import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_motion.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/animations/reduced_motion.dart';

/// Ton sémantique d'un badge. Une seule source de vérité pour la couleur
/// d'un état, quel que soit l'écran.
enum StatusTone { neutral, success, warning, error, info, accent, demo }

/// Badge d'état compact : pastille + libellé, lisible en plein soleil.
class StatusBadge extends StatelessWidget {
  final String label;
  final StatusTone tone;
  final IconData? icon;
  final bool dense;

  const StatusBadge({
    super.key,
    required this.label,
    this.tone = StatusTone.neutral,
    this.icon,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.statusPalette;
    final (color, background) = switch (tone) {
      StatusTone.success => (palette.success, palette.success),
      StatusTone.warning => (palette.warning, palette.warning),
      StatusTone.error => (palette.error, palette.error),
      StatusTone.info => (palette.info, palette.info),
      StatusTone.accent => (palette.accent, palette.accent),
      StatusTone.demo => (palette.demo, palette.demo),
      StatusTone.neutral => (palette.neutral, palette.neutral),
    };

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final duration = motionDuration(context, AppMotion.fast);
    final curve = motionCurve(context, AppMotion.enter);

    return AnimatedContainer(
      duration: duration,
      curve: curve,
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 8 : 10,
        vertical: dense ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: background.withValues(alpha: isDark ? 0.18 : 0.12),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            AnimatedSwitcher(
              duration: duration,
              switchInCurve: curve,
              switchOutCurve: motionCurve(context, AppMotion.exit),
              child: Icon(
                icon,
                key: ValueKey(icon),
                size: dense ? 11 : 13,
                color: color,
              ),
            ),
            const SizedBox(width: 5),
          ] else ...[
            AnimatedContainer(
              duration: duration,
              curve: curve,
              width: dense ? 6 : 7,
              height: dense ? 6 : 7,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
          ],
          AnimatedSwitcher(
            duration: duration,
            switchInCurve: curve,
            switchOutCurve: motionCurve(context, AppMotion.exit),
            child: Text(
              label,
              key: ValueKey(label),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
