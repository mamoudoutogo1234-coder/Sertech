import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';

/// Fond ambiant de l'application.
///
/// Deux halos très doux (marque en haut, eau en bas) donnent de la profondeur
/// sans image et sans coût de rendu. Le contenu reste toujours prioritaire :
/// les halos sont à moins de 10 % d'opacité.
class AmbientBackground extends StatelessWidget {
  final Widget child;

  const AmbientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final extension = Theme.of(context).extension<AppThemeExtension>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final brand = extension?.brandGlow ?? Colors.transparent;
    final water = extension?.waterGlow ?? Colors.transparent;
    final boost = isDark ? 1.35 : 1.0;

    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  brand.withValues(alpha: _alpha(brand, boost)),
                  Colors.transparent,
                  water.withValues(alpha: _alpha(water, boost)),
                ],
                stops: const [0, 0.5, 1],
              ),
            ),
          ),
        ),
        Positioned(
          top: -140,
          right: -120,
          child: _Glow(color: brand, size: 320, opacity: 0.55 * boost),
        ),
        Positioned(
          bottom: -160,
          left: -140,
          child: _Glow(color: water, size: 300, opacity: 0.4 * boost),
        ),
        Positioned.fill(child: child),
      ],
    );
  }

  static double _alpha(Color color, double boost) =>
      (color.a * boost).clamp(0.0, 1.0);
}

class _Glow extends StatelessWidget {
  final Color color;
  final double size;
  final double opacity;

  const _Glow({required this.color, required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: (color.a * opacity).clamp(0.0, 1.0)),
              color.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}
