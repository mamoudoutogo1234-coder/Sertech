import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/utils/freshness_utils.dart';
import 'status_badge.dart';

/// Indique la fraîcheur d'une mesure. L'obsolescence est toujours visible :
/// aucune donnée périmée n'est présentée comme actuelle.
class FreshnessBadge extends StatelessWidget {
  final ReadingFreshness freshness;
  final String label;

  const FreshnessBadge({
    super.key,
    required this.freshness,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final (tone, icon) = switch (freshness) {
      ReadingFreshness.fresh => (
        StatusTone.success,
        Icons.check_circle_outline,
      ),
      ReadingFreshness.expired => (
        StatusTone.warning,
        Icons.history_toggle_off,
      ),
      ReadingFreshness.unavailable => (StatusTone.neutral, Icons.help_outline),
    };
    return StatusBadge(label: label, tone: tone, icon: icon, dense: true);
  }
}

/// Bandeau affiché en haut des écrans lorsque l'application tourne avec des
/// données de démonstration. Rend le mode `INMEMORY` impossible à confondre
/// avec des données réelles.
class DemoModeBanner extends StatelessWidget {
  final String label;
  final String description;

  const DemoModeBanner({super.key, required this.label, this.description = ''});

  @override
  Widget build(BuildContext context) {
    final palette = context.statusPalette;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s12,
      ),
      decoration: BoxDecoration(
        color: palette.demo.withValues(alpha: 0.10),
        border: Border.all(color: palette.demo.withValues(alpha: 0.35)),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        children: [
          Icon(Icons.science_outlined, size: 18, color: palette.demo),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge
                      ?.copyWith(color: palette.demo),
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
