import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/utils/freshness_utils.dart';
import '../../core/utils/number_formatter.dart';
import '../../domain/models/sensor_data.dart';
import '../../domain/models/zone.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/l10n_extensions.dart';
import 'status_badge.dart';
import 'surface_panel.dart';

/// Résumé d'une zone : nom, humidité disponible et fraîcheur des données.
class ZoneSummaryTile extends StatelessWidget {
  final Zone zone;
  final SensorData? measurement;
  final VoidCallback? onTap;
  final Widget? trailing;

  const ZoneSummaryTile({
    super.key,
    required this.zone,
    this.measurement,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final freshness = FreshnessUtils.of(measurement);
    final hasValue = measurement?.moisturePercent != null;

    final (tone, label) = switch (freshness) {
      ReadingFreshness.fresh => (StatusTone.success, l10n.dataFresh),
      ReadingFreshness.expired => (StatusTone.warning, l10n.dataStale),
      ReadingFreshness.unavailable => (StatusTone.neutral, l10n.noMeasurements),
    };

    final palette = context.statusPalette;
    final toneColor = switch (tone) {
      StatusTone.success => palette.success,
      StatusTone.warning => palette.warning,
      StatusTone.error => palette.error,
      StatusTone.info => palette.info,
      StatusTone.accent => palette.accent,
      StatusTone.demo => palette.demo,
      StatusTone.neutral => palette.neutral,
    };
    final moisture = measurement?.moisturePercent;

    return SurfacePanel(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.s16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Icon(
                  Icons.grass,
                  color: theme.colorScheme.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      zone.name,
                      style: theme.textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        StatusBadge(label: label, tone: tone, dense: true),
                        if (measurement != null) ...[
                          const SizedBox(width: AppSpacing.s8),
                          Flexible(
                            child: Text(
                              context.relativeTime(measurement!.recordedAt),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              if (hasValue)
                Text(
                  NumberFormatter.percent(measurement!.moisturePercent!),
                  style: theme.textTheme.titleLarge?.copyWith(
                    letterSpacing: -0.4,
                  ),
                )
              else
                Text(
                  l10n.noData,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ?trailing,
            ],
          ),
          if (moisture != null) ...[
            const SizedBox(height: AppSpacing.s12),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
              child: LinearProgressIndicator(
                value: (moisture / 100).clamp(0, 1),
                minHeight: 4,
                backgroundColor: theme.colorScheme.onSurface.withValues(
                  alpha: 0.06,
                ),
                valueColor: AlwaysStoppedAnimation(toneColor),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Tuile d'action rapide avec icône, libellé et chevron.
class QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final StatusTone tone;

  const QuickActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.tone = StatusTone.neutral,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.statusPalette;
    final color = switch (tone) {
      StatusTone.success => palette.success,
      StatusTone.warning => palette.warning,
      StatusTone.error => palette.error,
      StatusTone.info => palette.info,
      StatusTone.accent => palette.accent,
      StatusTone.demo => palette.demo,
      StatusTone.neutral => theme.colorScheme.primary,
    };
    return SurfacePanel(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s8,
        vertical: AppSpacing.s16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: AppSpacing.s8),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
