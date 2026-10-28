import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';
import 'ambient_background.dart';

/// Coquille commune aux écrans.
///
/// Remplace les `Scaffold` + `AppBar` répétés : fond ambiant, zone sûre,
/// padding horizontal constant. L'en-tête de page vit dans le contenu pour
/// pouvoir défiler avec lui.
class SertechScaffold extends StatelessWidget {
  final Widget body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool safeBottom;

  const SertechScaffold({
    super.key,
    required this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.safeBottom = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: AmbientBackground(
        child: SafeArea(bottom: safeBottom, child: body),
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}

/// Padding horizontal standard des pages.
const EdgeInsets kPagePadding = EdgeInsets.fromLTRB(
  AppSpacing.screenPadding,
  AppSpacing.s8,
  AppSpacing.screenPadding,
  AppSpacing.s32,
);

/// Variante pour les listes qui commencent par un en-tête de page.
const EdgeInsets kPagePaddingWithHeader = EdgeInsets.fromLTRB(
  AppSpacing.screenPadding,
  AppSpacing.s20,
  AppSpacing.screenPadding,
  AppSpacing.s32,
);
