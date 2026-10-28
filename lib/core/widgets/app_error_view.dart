import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../l10n/app_localizations.dart';

/// Vue d'erreur : message court, cause technique optionnelle et action de
/// reprise. Aucune donnée fictive n'est substituée à une erreur.
class AppErrorView extends StatelessWidget {
  final String message;
  final String? technicalDetails;
  final VoidCallback? onRetry;
  final String? retryLabel;

  const AppErrorView({
    super.key,
    required this.message,
    this.technicalDetails,
    this.onRetry,
    this.retryLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final palette = context.statusPalette;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.s16),
                decoration: BoxDecoration(
                  color: palette.error.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.cloud_off_outlined,
                  size: 30,
                  color: palette.error,
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              Text(
                message,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              if (technicalDetails != null) ...[
                const SizedBox(height: AppSpacing.s8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.s12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Text(
                    technicalDetails!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontFamily: 'monospace',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              if (onRetry != null) ...[
                const SizedBox(height: AppSpacing.s20),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: Text(retryLabel ?? l10n?.retry ?? 'Réessayer'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
