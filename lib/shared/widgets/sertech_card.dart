import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';
import 'surface_panel.dart';

/// Carte de contenu générique, alignée sur [SurfacePanel].
class SertechCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const SertechCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.s16),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SurfacePanel(padding: padding, onTap: onTap, child: child);
  }
}
