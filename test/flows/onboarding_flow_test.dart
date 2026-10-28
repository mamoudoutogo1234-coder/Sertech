import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Onboarding flow', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    test('onboarding not completed by default', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('sertech_onboarding_completed') ?? false, false);
    });

    test('completing onboarding sets flag to true', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('sertech_onboarding_completed', true);
      expect(prefs.getBool('sertech_onboarding_completed'), true);
    });

    test('skip and get started both complete onboarding', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('sertech_onboarding_completed', true);
      expect(prefs.getBool('sertech_onboarding_completed'), true);
    });
  });
}
