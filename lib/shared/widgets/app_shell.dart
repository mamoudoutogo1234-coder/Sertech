import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/router/route_names.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../features/auth/application/auth_providers.dart';
import '../../l10n/app_localizations.dart';

class AppShell extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final dataMode = ref.watch(effectiveDataModeProvider);
    final signedIn = ref.watch(isSignedInProvider);
    final needsSession = dataMode == DataMode.supabase && !signedIn;

    if (needsSession) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        final location = GoRouterState.of(context).matchedLocation;
        if (location == RoutePaths.login || location == RoutePaths.register) {
          return;
        }
        context.goNamed(RouteNames.login);
      });
      return const Scaffold(body: SafeArea(child: SizedBox.shrink()));
    }

    return Scaffold(
      body: Column(
        children: [
          if (dataMode == DataMode.inMemory)
            _DemoBanner(
              label: l10n.demoModeEnabled,
              description: l10n.dataModeDesc,
              onTap: () => context.pushNamed(RouteNames.settings),
            ),
          Expanded(child: navigationShell),
        ],
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          backgroundColor: Colors.transparent,
          onDestinationSelected: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.space_dashboard_outlined),
              selectedIcon: const Icon(Icons.space_dashboard),
              label: l10n.navAccueil,
            ),
            NavigationDestination(
              icon: const Icon(Icons.grid_view_outlined),
              selectedIcon: const Icon(Icons.grid_view),
              label: l10n.navZones,
            ),
            NavigationDestination(
              icon: const Icon(Icons.show_chart_outlined),
              selectedIcon: const Icon(Icons.show_chart),
              label: l10n.measurements,
            ),
            NavigationDestination(
              icon: const Icon(Icons.water_drop_outlined),
              selectedIcon: const Icon(Icons.water_drop),
              label: l10n.navIrrigation,
            ),
            NavigationDestination(
              icon: const Icon(Icons.history_outlined),
              selectedIcon: const Icon(Icons.history),
              label: l10n.navActivity,
            ),
          ],
        ),
      ),
    );
  }
}

class _DemoBanner extends StatelessWidget {
  final String label;
  final String description;
  final VoidCallback onTap;

  const _DemoBanner({
    required this.label,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.statusPalette;
    final theme = Theme.of(context);
    return Material(
      color: palette.demo.withValues(alpha: 0.14),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s16,
            vertical: AppSpacing.s8,
          ),
          child: Row(
            children: [
              Icon(Icons.science_outlined, size: 15, color: palette.demo),
              const SizedBox(width: AppSpacing.s8),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: palette.demo,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Tooltip(
                message: description,
                child: Icon(
                  Icons.info_outline,
                  size: 15,
                  color: palette.demo.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
