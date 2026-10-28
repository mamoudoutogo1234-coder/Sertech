import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Onboarding prefs', () {
    test('defaults to false when key missing', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('sertech_onboarding_completed'), isNull);
      expect(prefs.getBool('sertech_onboarding_completed') ?? false, false);
    });

    test('can be set to true', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('sertech_onboarding_completed', true);
      expect(prefs.getBool('sertech_onboarding_completed'), true);
    });
  });
}
