import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kOnboardingKey = 'sertech_onboarding_completed';

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((
  ref,
) async {
  return SharedPreferences.getInstance();
});

final onboardingCompletedProvider = FutureProvider<bool>((ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return prefs.getBool(_kOnboardingKey) ?? false;
});

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, AsyncValue<bool>>((ref) {
      return OnboardingController(ref);
    });

class OnboardingController extends StateNotifier<AsyncValue<bool>> {
  OnboardingController(this.ref) : super(const AsyncValue.loading()) {
    _load();
  }

  final Ref ref;

  Future<void> _load() async {
    try {
      final prefs = await ref.read(sharedPreferencesProvider.future);
      state = AsyncValue.data(prefs.getBool(_kOnboardingKey) ?? false);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> complete() async {
    try {
      final prefs = await ref.read(sharedPreferencesProvider.future);
      await prefs.setBool(_kOnboardingKey, true);
      state = const AsyncValue.data(true);
      ref.invalidate(onboardingCompletedProvider);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
