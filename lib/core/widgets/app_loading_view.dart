import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';

/// Squelette de chargement : structure suggestive, sans contenu fictif.
class AppLoadingView extends StatelessWidget {
  final String? message;
  final bool skeleton;

  const AppLoadingView({super.key, this.message, this.skeleton = false});

  @override
  Widget build(BuildContext context) {
    if (skeleton) {
      return const _LoadingSkeleton();
    }
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              strokeWidth: 2.6,
              color: theme.colorScheme.primary,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.s16),
            Text(
              message!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LoadingSkeleton extends StatelessWidget {
  const _LoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget bar(double height, {double widthFactor = 1}) => Container(
      height: height,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: AppSpacing.s4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
    );

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.s16),
      children: [
        Container(
          height: 88,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
        ),
        const SizedBox(height: AppSpacing.s16),
        Row(
          children: [
            Expanded(child: bar(80)),
            const SizedBox(width: AppSpacing.s12),
            Expanded(child: bar(80)),
          ],
        ),
        const SizedBox(height: AppSpacing.s16),
        bar(140),
        const SizedBox(height: AppSpacing.s16),
        bar(64),
      ],
    );
  }
}
