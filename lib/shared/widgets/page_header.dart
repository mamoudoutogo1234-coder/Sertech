import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';

/// En-tête de page : sur-titre, titre large, sous-titre et actions.
///
/// Le titre porte la hiérarchie à lui seul — pas de barre d'application
/// lourde. Les actions restent des cibles tactiles de 44 px.
class PageHeader extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final Widget? badge;
  final Widget? leading;

  const PageHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    this.subtitle,
    this.actions = const [],
    this.badge,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondary = theme.colorScheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: AppSpacing.s4),
              ],
              Expanded(
                child: Text(
                  eyebrow.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    letterSpacing: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (actions.isNotEmpty) ...[
                const SizedBox(width: AppSpacing.s8),
                Row(mainAxisSize: MainAxisSize.min, children: actions),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(title, style: theme.textTheme.headlineLarge),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.s8),
            Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(color: secondary),
            ),
          ],
          if (badge != null) ...[
            const SizedBox(height: AppSpacing.s12),
            badge!,
          ],
        ],
      ),
    );
  }
}
