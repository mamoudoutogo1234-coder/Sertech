import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import 'status_badge.dart';
import 'surface_panel.dart';

/// Carte de métrique : une valeur, son unité, une icône et un pied optionnel.
class MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;
  final IconData icon;
  final Widget? footer;
  final StatusTone tone;
  final bool emphasise;

  const MetricTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.unit,
    this.footer,
    this.tone = StatusTone.neutral,
    this.emphasise = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.statusPalette;
    final accent = switch (tone) {
      StatusTone.success => palette.success,
      StatusTone.warning => palette.warning,
      StatusTone.error => palette.error,
      StatusTone.info => palette.info,
      StatusTone.accent => palette.accent,
      StatusTone.demo => palette.demo,
      StatusTone.neutral => theme.colorScheme.primary,
    };

    return SurfacePanel(
      padding: const EdgeInsets.all(AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    letterSpacing: 0.8,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              Icon(icon, size: 18, color: accent),
            ],
          ),
          const SizedBox(height: AppSpacing.s12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: Text(
                  value,
                  style:
                      (emphasise
                              ? theme.textTheme.headlineMedium
                              : theme.textTheme.titleLarge)
                          ?.copyWith(
                            color: theme.colorScheme.onSurface,
                            letterSpacing: -0.6,
                          ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (unit != null && unit!.isNotEmpty) ...[
                const SizedBox(width: 4),
                Text(
                  unit!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
          if (footer != null) ...[
            const SizedBox(height: AppSpacing.s8),
            footer!,
          ],
        ],
      ),
    );
  }
}

/// Variante compacte utilisée dans les listes (une ligne par indicateur).
class MetricRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Widget? trailing;

  const MetricRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s8),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppSpacing.s8),
            trailing!,
          ],
        ],
      ),
    );
  }
}

/// Ligne d'information label / valeur, utilisée dans les fiches de détail.
class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Widget? trailing;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: AppSpacing.s12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppSpacing.s8),
            trailing!,
          ],
        ],
      ),
    );
  }
}
