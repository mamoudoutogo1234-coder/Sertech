import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';

/// En-tête de section : sur-titre discret, filet, action optionnelle.
///
/// Il marque une rupture dans la page sans ajouter de carte ni d'ombre.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(
        top: AppSpacing.s24,
        bottom: AppSpacing.s12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 1.3,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          if (actionLabel != null && onAction != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8),
                minimumSize: const Size(44, 36),
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                textStyle: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
              child: Text(actionLabel!),
            ),
        ],
      ),
    );
  }
}
