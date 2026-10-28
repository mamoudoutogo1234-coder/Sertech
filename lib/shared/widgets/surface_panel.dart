import 'package:flutter/material.dart';

import '../../app/theme/app_motion.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/animations/reduced_motion.dart';

/// Panneau de surface du design system.
///
/// Toutes les cartes de contenu partagent la même géométrie : rayon 24,
/// bordure d'un pixel, aucune ombre lourde. `accent` permet de teinter un
/// panneau sans dupliquer de décoration dans les écrans.
class SurfacePanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? background;
  final Color? borderColor;
  final bool emphasise;

  const SurfacePanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.s16),
    this.onTap,
    this.background,
    this.borderColor,
    this.emphasise = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = BorderRadius.circular(
      emphasise ? AppSpacing.radiusXl : AppSpacing.radiusLg,
    );
    final duration = motionDuration(context, AppMotion.fast);
    final curve = motionCurve(context, AppMotion.enter);

    final panel = AnimatedContainer(
      duration: duration,
      curve: curve,
      decoration: BoxDecoration(
        color: background ?? theme.colorScheme.surface,
        borderRadius: radius,
        border: Border.all(
          color: borderColor ?? theme.colorScheme.outlineVariant,
        ),
        boxShadow: emphasise
            ? [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.18),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );

    return panel;
  }
}
