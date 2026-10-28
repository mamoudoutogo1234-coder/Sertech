import 'package:flutter_test/flutter_test.dart';
import 'package:sertech/domain/models/irrigation_settings.dart';
import 'package:sertech/domain/rules/settings_validation.dart';

void main() {
  group('SettingsValidation', () {
    test('validateFields returns valid for correct values', () {
      final result = SettingsValidation.validateFields(
        startThreshold: '40',
        stopThreshold: '60',
        maxDurationSeconds: '1800',
        minIntervalSeconds: '3600',
      );

      expect(result.isValid, isTrue);
      expect(result.errors, isEmpty);
      expect(result.startThreshold, 40.0);
      expect(result.stopThreshold, 60.0);
      expect(result.maxDurationSeconds, 1800);
      expect(result.minIntervalSeconds, 3600);
    });

    test('validateFields parses comma as decimal separator', () {
      final result = SettingsValidation.validateFields(
        startThreshold: '35,5',
        stopThreshold: '65,0',
        maxDurationSeconds: '900',
        minIntervalSeconds: '1800',
      );

      expect(result.isValid, isTrue);
      expect(result.startThreshold, 35.5);
      expect(result.stopThreshold, 65.0);
    });

    test('startThreshold required', () {
      final result = SettingsValidation.validateFields(
        startThreshold: null,
        stopThreshold: '60',
        maxDurationSeconds: '1800',
        minIntervalSeconds: '3600',
      );

      expect(result.isValid, isFalse);
      expect(result.has(SettingsFieldError.startThresholdRequired), isTrue);
    });

    test('startThreshold empty is treated as required', () {
      final result = SettingsValidation.validateFields(
        startThreshold: '   ',
        stopThreshold: '60',
        maxDurationSeconds: '1800',
        minIntervalSeconds: '3600',
      );

      expect(result.isValid, isFalse);
      expect(result.has(SettingsFieldError.startThresholdRequired), isTrue);
    });

    test('startThreshold out of range', () {
      final result = SettingsValidation.validateFields(
        startThreshold: '-1',
        stopThreshold: '60',
        maxDurationSeconds: '1800',
        minIntervalSeconds: '3600',
      );

      expect(result.isValid, isFalse);
      expect(result.has(SettingsFieldError.startThresholdRange), isTrue);

      final result2 = SettingsValidation.validateFields(
        startThreshold: '101',
        stopThreshold: '60',
        maxDurationSeconds: '1800',
        minIntervalSeconds: '3600',
      );

      expect(result2.isValid, isFalse);
      expect(result2.has(SettingsFieldError.startThresholdRange), isTrue);
    });

    test('stopThreshold required', () {
      final result = SettingsValidation.validateFields(
        startThreshold: '40',
        stopThreshold: null,
        maxDurationSeconds: '1800',
        minIntervalSeconds: '3600',
      );

      expect(result.isValid, isFalse);
      expect(result.has(SettingsFieldError.stopThresholdRequired), isTrue);
    });

    test('stopThreshold out of range', () {
      final result = SettingsValidation.validateFields(
        startThreshold: '40',
        stopThreshold: '-5',
        maxDurationSeconds: '1800',
        minIntervalSeconds: '3600',
      );

      expect(result.isValid, isFalse);
      expect(result.has(SettingsFieldError.stopThresholdRange), isTrue);

      final result2 = SettingsValidation.validateFields(
        startThreshold: '40',
        stopThreshold: '150',
        maxDurationSeconds: '1800',
        minIntervalSeconds: '3600',
      );

      expect(result2.isValid, isFalse);
      expect(result2.has(SettingsFieldError.stopThresholdRange), isTrue);
    });

    test('hysteresis invalid when startThreshold > stopThreshold', () {
      final result = SettingsValidation.validateFields(
        startThreshold: '70',
        stopThreshold: '50',
        maxDurationSeconds: '1800',
        minIntervalSeconds: '3600',
      );

      expect(result.isValid, isFalse);
      expect(result.has(SettingsFieldError.hysteresisInvalid), isTrue);
    });

    test('hysteresis valid when equal', () {
      final result = SettingsValidation.validateFields(
        startThreshold: '50',
        stopThreshold: '50',
        maxDurationSeconds: '1800',
        minIntervalSeconds: '3600',
      );

      expect(result.isValid, isTrue);
    });

    test('maxDuration required', () {
      final result = SettingsValidation.validateFields(
        startThreshold: '40',
        stopThreshold: '60',
        maxDurationSeconds: null,
        minIntervalSeconds: '3600',
      );

      expect(result.isValid, isFalse);
      expect(result.has(SettingsFieldError.maxDurationRequired), isTrue);
    });

    test('maxDuration out of range', () {
      final result = SettingsValidation.validateFields(
        startThreshold: '40',
        stopThreshold: '60',
        maxDurationSeconds: '10',
        minIntervalSeconds: '3600',
      );

      expect(result.isValid, isFalse);
      expect(result.has(SettingsFieldError.maxDurationRange), isTrue);

      final result2 = SettingsValidation.validateFields(
        startThreshold: '40',
        stopThreshold: '60',
        maxDurationSeconds: '${6 * 60 * 60 + 1}',
        minIntervalSeconds: '3600',
      );

      expect(result2.isValid, isFalse);
      expect(result2.has(SettingsFieldError.maxDurationRange), isTrue);
    });

    test('maxDuration valid at boundaries', () {
      final resultMin = SettingsValidation.validateFields(
        startThreshold: '40',
        stopThreshold: '60',
        maxDurationSeconds: '30',
        minIntervalSeconds: '0',
      );

      expect(resultMin.isValid, isTrue);

      final resultMax = SettingsValidation.validateFields(
        startThreshold: '40',
        stopThreshold: '60',
        maxDurationSeconds: '${6 * 60 * 60}',
        minIntervalSeconds: '${24 * 60 * 60}',
      );

      expect(resultMax.isValid, isTrue);
    });

    test('minInterval required', () {
      final result = SettingsValidation.validateFields(
        startThreshold: '40',
        stopThreshold: '60',
        maxDurationSeconds: '1800',
        minIntervalSeconds: null,
      );

      expect(result.isValid, isFalse);
      expect(result.has(SettingsFieldError.minIntervalRequired), isTrue);
    });

    test('minInterval negative or too large', () {
      final result = SettingsValidation.validateFields(
        startThreshold: '40',
        stopThreshold: '60',
        maxDurationSeconds: '1800',
        minIntervalSeconds: '-1',
      );

      expect(result.isValid, isFalse);
      expect(result.has(SettingsFieldError.minIntervalNegative), isTrue);

      final result2 = SettingsValidation.validateFields(
        startThreshold: '40',
        stopThreshold: '60',
        maxDurationSeconds: '1800',
        minIntervalSeconds: '${24 * 60 * 60 + 1}',
      );

      expect(result2.isValid, isFalse);
      expect(result2.has(SettingsFieldError.minIntervalNegative), isTrue);
    });

    test('minInterval can be zero', () {
      final result = SettingsValidation.validateFields(
        startThreshold: '40',
        stopThreshold: '60',
        maxDurationSeconds: '1800',
        minIntervalSeconds: '0',
      );

      expect(result.isValid, isTrue);
    });

    test('validate with IrrigationSettings object', () {
      final settings = IrrigationSettings(
        id: 'test-id',
        zoneId: 'zone-id',
        autoEnabled: true,
        startThreshold: 35,
        stopThreshold: 65,
        maxDurationSeconds: 1200,
        minIntervalSeconds: 7200,
      );

      final result = SettingsValidation.validate(settings);

      expect(result.isValid, isTrue);
      expect(settings.isValid, isTrue);
      expect(settings.isHysteresisValid, isTrue);
    });

    test('validate with invalid IrrigationSettings object', () {
      final settings = IrrigationSettings(
        id: 'test-id',
        zoneId: 'zone-id',
        autoEnabled: true,
        startThreshold: 80,
        stopThreshold: 60,
        maxDurationSeconds: 1200,
        minIntervalSeconds: 7200,
      );

      final result = SettingsValidation.validate(settings);

      expect(result.isValid, isFalse);
      expect(settings.isValid, isFalse);
      expect(settings.isHysteresisValid, isFalse);
      expect(result.has(SettingsFieldError.hysteresisInvalid), isTrue);
    });

    test('multiple errors can be reported', () {
      final result = SettingsValidation.validateFields(
        startThreshold: '200',
        stopThreshold: null,
        maxDurationSeconds: '10',
        minIntervalSeconds: '-5',
      );

      expect(result.isValid, isFalse);
      expect(result.errors.length, greaterThanOrEqualTo(3));
    });
  });
}
