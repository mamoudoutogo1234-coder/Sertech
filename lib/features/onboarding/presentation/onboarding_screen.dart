import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../onboarding/application/onboarding_providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  final _controller = PageController();
  int _page = 0;
  late final AnimationController _zoomController;
  late Animation<double> _scale;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _zoomController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 1.12,
    ).animate(CurvedAnimation(parent: _zoomController, curve: Curves.easeOut));
    _offset = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.008, -0.012),
    ).animate(CurvedAnimation(parent: _zoomController, curve: Curves.easeOut));
    _zoomController.forward();
    _controller.addListener(_onPageChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      precacheImage(
        const AssetImage('assets/onboarding_img/onboard1.jpg'),
        context,
      );
      precacheImage(
        const AssetImage('assets/onboarding_img/onboard2.jpg'),
        context,
      );
      precacheImage(
        const AssetImage('assets/onboarding_img/onboard3.jpg'),
        context,
      );
    });
  }

  void _onPageChange() {
    final page = _controller.page?.round() ?? _page;
    if (page != _page) {
      setState(() => _page = page);
      _restartAnimation();
    }
  }

  void _restartAnimation() {
    _zoomController.reset();
    _zoomController.forward();
  }

  @override
  void dispose() {
    _controller.removeListener(_onPageChange);
    _controller.dispose();
    _zoomController.dispose();
    super.dispose();
  }

  Future<void> _complete() async {
    await ref.read(onboardingControllerProvider.notifier).complete();
    if (!mounted) return;
    context.goNamed(RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isLast = _page == 2;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          ClipRect(
            child: AnimatedBuilder(
              animation: _zoomController,
              builder: (context, child) {
                final tx = _offset.value.dx * MediaQuery.of(context).size.width;
                final ty =
                    _offset.value.dy * MediaQuery.of(context).size.height;
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.diagonal3Values(
                    _scale.value,
                    _scale.value,
                    1.0,
                  )..translateByDouble(tx, ty, 0.0, 1.0),
                  child: child,
                );
              },
              child: PageView(
                controller: _controller,
                physics: const BouncingScrollPhysics(),
                children: const [
                  _OnboardingPage(
                    image: 'assets/onboarding_img/onboard1.jpg',
                    icon: Icons.sensors_outlined,
                    titleKey: _TitleKey.surveille,
                  ),
                  _OnboardingPage(
                    image: 'assets/onboarding_img/onboard2.jpg',
                    icon: Icons.water_drop_outlined,
                    titleKey: _TitleKey.irrigue,
                  ),
                  _OnboardingPage(
                    image: 'assets/onboarding_img/onboard3.jpg',
                    icon: Icons.auto_graph_outlined,
                    titleKey: _TitleKey.automatise,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + AppSpacing.s12,
            right: AppSpacing.s20,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isLast ? 0 : 1,
              child: IgnorePointer(
                ignoring: isLast,
                child: TextButton(
                  onPressed: _complete,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s16,
                      vertical: AppSpacing.s8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.onboardingSkip,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward, size: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0x80000000),
                    Color(0xF0000000),
                  ],
                  stops: [0.0, 0.4, 1.0],
                ),
              ),
              padding: EdgeInsets.fromLTRB(
                AppSpacing.s24,
                AppSpacing.s48,
                AppSpacing.s24,
                MediaQuery.of(context).padding.bottom + AppSpacing.s24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _PageIndicator(current: _page, count: 3),
                  const SizedBox(height: AppSpacing.s20),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        if (isLast) {
                          _complete();
                        } else {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOutCubic,
                          );
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isLast
                                ? l10n.onboardingGetStarted
                                : l10n.onboardingNext,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            isLast ? Icons.check : Icons.arrow_forward,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _TitleKey { surveille, irrigue, automatise }

class _OnboardingPage extends StatelessWidget {
  final String image;
  final _TitleKey titleKey;
  final IconData icon;

  const _OnboardingPage({
    required this.image,
    required this.titleKey,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final (title, desc) = switch (titleKey) {
      _TitleKey.surveille => (l10n.onboardingTitle1, l10n.onboardingDesc1),
      _TitleKey.irrigue => (l10n.onboardingTitle2, l10n.onboardingDesc2),
      _TitleKey.automatise => (
          l10n.onboardingTitle3,
          l10n.onboardingDesc3,
        ),
    };

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          image,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          errorBuilder: (context, error, stackTrace) => Container(
            color: AppColors.primaryDeep,
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Color(0x40000000),
                Color(0xCC000000),
                Color(0xF5000000),
              ],
              stops: [0.25, 0.55, 0.85, 1.0],
            ),
          ),
        ),
        Positioned(
          left: AppSpacing.s24,
          right: AppSpacing.s24,
          bottom: MediaQuery.of(context).padding.bottom + 140,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                ),
                child: Icon(icon, color: Colors.white, size: 26),
              ),
              const SizedBox(height: AppSpacing.s16),
              Text(
                title,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      height: 1.08,
                      letterSpacing: -0.8,
                      shadows: const [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 24,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
              ),
              const SizedBox(height: AppSpacing.s14),
              Text(
                desc,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      height: 1.8,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1,
                      shadows: const [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 18,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final int current;
  final int count;

  const _PageIndicator({required this.current, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeInOut,
            margin: EdgeInsets.only(right: i == count - 1 ? 0 : 6),
            height: 6,
            width: current == i ? 32 : 8,
            decoration: BoxDecoration(
              color: current == i ? Colors.white : Colors.white.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12),
              boxShadow: current == i
                  ? [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.3),
                        blurRadius: 12,
                      ),
                    ]
                  : null,
            ),
          ),
      ],
    );
  }
}
