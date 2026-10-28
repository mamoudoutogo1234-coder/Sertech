import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_theme.dart';

/// Panneau héro : dégradé de marque, coins très arrondis, contenu libre.
///
/// Il sert d'ancre visuelle en haut des écrans de supervision. Aucune image :
/// le relief vient d'un halo interne et du dégradé.
class BrandHero extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  const BrandHero({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.s20),
    this.radius = AppSpacing.radiusXl,
  });

  @override
  Widget build(BuildContext context) {
    final extension = Theme.of(context).extension<AppThemeExtension>();
    final gradient =
        extension?.heroGradient ??
        const LinearGradient(colors: [Color(0xFF044B2D), Color(0xFF0A723B)]);
    final accent = extension?.heroAccent ?? const Color(0xFF4EB427);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.last.withValues(alpha: 0.16),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Stack(
          children: [
            Positioned(
              top: -70,
              right: -50,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      accent.withValues(alpha: 0.18),
                      accent.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
            Padding(padding: padding, child: child),
          ],
        ),
      ),
    );
  }
}
