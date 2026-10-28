import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/activity/presentation/activity_screen.dart';
import '../../features/activity/presentation/command_detail_screen.dart';
import '../../features/auth/application/auth_providers.dart';
import '../../features/camera/presentation/camera_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/irrigation/application/irrigation_providers.dart';
import '../../features/irrigation/presentation/irrigation_screen.dart';
import '../../features/irrigation/presentation/irrigation_timing_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/onboarding/application/onboarding_providers.dart';
import '../../features/measurements/presentation/measurements_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/zones/presentation/zone_detail_screen.dart';
import '../../features/zones/presentation/zones_screen.dart';
import '../../shared/widgets/app_shell.dart';
import 'route_names.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final onboarding = ref.watch(onboardingCompletedProvider);
  final onboardingCompleted = onboarding.when(
    data: (value) => value,
    loading: () => false,
    error: (_, _) => false,
  );
  final signedIn = ref.watch(isSignedInProvider);
  final router = AppRouter.createRouter(
    onboardingCompleted: onboardingCompleted,
    signedIn: signedIn,
  );
  ref.onDispose(router.dispose);
  return router;
});

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static GoRouter createRouter({
    bool onboardingCompleted = true,
    bool signedIn = true,
  }) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: onboardingCompleted
          ? (signedIn ? RoutePaths.dashboard : RoutePaths.login)
          : RoutePaths.onboarding,
      redirect: (context, state) {
        final location = state.matchedLocation;
        final isOnboarding = location == RoutePaths.onboarding;
        final isLogin = location == RoutePaths.login;
        final isRegister = location == RoutePaths.register;
        final isAuthRoute = isOnboarding || isLogin || isRegister;

        if (!onboardingCompleted && !isOnboarding) {
          return RoutePaths.onboarding;
        }
        if (onboardingCompleted && isOnboarding) {
          return signedIn ? RoutePaths.dashboard : RoutePaths.login;
        }
        if (onboardingCompleted && !signedIn && !isAuthRoute) {
          return RoutePaths.login;
        }
        if (onboardingCompleted && signedIn && (isLogin || isRegister)) {
          return RoutePaths.dashboard;
        }
        return null;
      },
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              AppShell(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RoutePaths.dashboard,
                  name: RouteNames.dashboard,
                  builder: (context, state) => const DashboardScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RoutePaths.zones,
                  name: RouteNames.zones,
                  builder: (context, state) => const ZonesScreen(),
                  routes: [
                    GoRoute(
                      path: ':id',
                      name: RouteNames.zoneDetail,
                      builder: (context, state) =>
                          ZoneDetailScreen(zoneId: state.pathParameters['id']!),
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RoutePaths.measurements,
                  name: RouteNames.measurements,
                  builder: (context, state) => const MeasurementsScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RoutePaths.irrigation,
                  name: RouteNames.irrigation,
                  builder: (context, state) => const IrrigationScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RoutePaths.activity,
                  name: RouteNames.activity,
                  builder: (context, state) => const ActivityScreen(),
                  routes: [
                    GoRoute(
                      path: ':id',
                      name: RouteNames.commandDetail,
                      builder: (context, state) => CommandDetailScreen(
                        commandId: state.pathParameters['id']!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: RoutePaths.settings,
          name: RouteNames.settings,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: RoutePaths.notifications,
          name: RouteNames.notifications,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const NotificationsScreen(),
        ),
        GoRoute(
          path: RoutePaths.camera,
          name: RouteNames.camera,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const CameraScreen(),
        ),
        GoRoute(
          path: RoutePaths.irrigationTiming,
          name: RouteNames.irrigationTiming,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            String zoneId = extra?['zoneId'] as String? ?? '';
            if (zoneId.isEmpty && state.uri.queryParameters.containsKey('zoneId')) {
              zoneId = state.uri.queryParameters['zoneId'] ?? '';
            }
            if (zoneId.isEmpty) {
              try {
                final container = ProviderScope.containerOf(context);
                zoneId = container.read(irrigationZoneProvider) ?? '';
              } catch (_) {}
            }
            return IrrigationTimingScreen(zoneId: zoneId);
          },
        ),
        GoRoute(
          path: RoutePaths.onboarding,
          name: RouteNames.onboarding,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: RoutePaths.login,
          name: RouteNames.login,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: RoutePaths.register,
          name: RouteNames.register,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const RegisterScreen(),
        ),
      ],
    );
  }
}
