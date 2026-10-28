import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';

/// État vide homogène : icône, titre, description et action optionnelle.
class AppEmptyState extends StatelessWidget {
  final String title;
  final String? description;
  final IconData? icon;
  final Widget? action;
  final bool compact;

  const AppEmptyState({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.action,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(compact ? AppSpacing.s16 : AppSpacing.s32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(AppSpacing.s16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: compact ? 22 : 30,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.s16),
              ],
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              if (description != null) ...[
                const SizedBox(height: AppSpacing.s8),
                Text(
                  description!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (action != null) ...[
                const SizedBox(height: AppSpacing.s20),
                action!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
