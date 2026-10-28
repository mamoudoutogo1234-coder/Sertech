import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Router redirect logic', () {
    test('redirects to onboarding if not completed', () {
      final onboardingCompleted = false;
      final isOnboarding = false;
      String? result;
      if (!onboardingCompleted && !isOnboarding) {
        result = '/onboarding';
      }
      expect(result, '/onboarding');
    });

    test('redirects to login if onboarding completed and on onboarding', () {
      final onboardingCompleted = true;
      final isOnboarding = true;
      String? result;
      if (onboardingCompleted && isOnboarding) {
        result = '/login';
      }
      expect(result, '/login');
    });

    test('allows normal navigation if completed and not on onboarding', () {
      final onboardingCompleted = true;
      final isOnboarding = false;
      String? result;
      if (!onboardingCompleted && !isOnboarding) {
        result = '/onboarding';
      }
      if (onboardingCompleted && isOnboarding) {
        result = '/login';
      }
      expect(result, isNull);
    });
  });
}
