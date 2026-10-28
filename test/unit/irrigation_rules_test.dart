import 'package:flutter_test/flutter_test.dart';
import 'package:sertech/domain/rules/irrigation_rules.dart';

void main() {
  group('IrrigationRules', () {
    final rules = IrrigationRules();
    final now = DateTime(2026, 1, 1, 12, 0);

    test('denies start if moisture >= startThreshold', () {
      final result = rules.canStartAutomation(
        currentMoisturePercent: 50,
        isFresh: true,
        lastMeasurementAt: now,
        now: now,
        startThreshold: 40,
        stopThreshold: 60,
        minIntervalSeconds: 3600,
        lastIrrigationEndAt: null,
      );
      expect(result.canStart, isFalse);
    });

    test('allows start if moisture < startThreshold and fresh', () {
      final result = rules.canStartAutomation(
        currentMoisturePercent: 30,
        isFresh: true,
        lastMeasurementAt: now,
        now: now,
        startThreshold: 40,
        stopThreshold: 60,
        minIntervalSeconds: 3600,
        lastIrrigationEndAt: null,
      );
      expect(result.canStart, isTrue);
    });

    test('denies start if data not fresh', () {
      final result = rules.canStartAutomation(
        currentMoisturePercent: 30,
        isFresh: false,
        lastMeasurementAt: now,
        now: now,
        startThreshold: 40,
        stopThreshold: 60,
        minIntervalSeconds: 3600,
        lastIrrigationEndAt: null,
      );
      expect(result.canStart, isFalse);
    });

    test('denies start if measurement too old', () {
      final result = rules.canStartAutomation(
        currentMoisturePercent: 30,
        isFresh: true,
        lastMeasurementAt: now.subtract(const Duration(hours: 2)),
        now: now,
        startThreshold: 40,
        stopThreshold: 60,
        minIntervalSeconds: 3600,
        lastIrrigationEndAt: null,
      );
      expect(result.canStart, isFalse);
    });

    test('denies start if min interval not elapsed', () {
      final result = rules.canStartAutomation(
        currentMoisturePercent: 30,
        isFresh: true,
        lastMeasurementAt: now,
        now: now,
        startThreshold: 40,
        stopThreshold: 60,
        minIntervalSeconds: 3600,
        lastIrrigationEndAt: now.subtract(const Duration(minutes: 30)),
      );
      expect(result.canStart, isFalse);
    });

    test('denies if hysteresis invalid', () {
      final result = rules.canStartAutomation(
        currentMoisturePercent: 30,
        isFresh: true,
        lastMeasurementAt: now,
        now: now,
        startThreshold: 60,
        stopThreshold: 40,
        minIntervalSeconds: 3600,
        lastIrrigationEndAt: null,
      );
      expect(result.canStart, isFalse);
    });

    test('shouldStop returns true if not fresh', () {
      expect(
        rules.shouldStop(
          currentMoisturePercent: 50,
          isFresh: false,
          elapsedSeconds: 10,
          maxDurationSeconds: 600,
          stopThreshold: 60,
        ),
        isTrue,
      );
    });

    test('shouldStop returns true if max duration reached', () {
      expect(
        rules.shouldStop(
          currentMoisturePercent: 50,
          isFresh: true,
          elapsedSeconds: 600,
          maxDurationSeconds: 600,
          stopThreshold: 60,
        ),
        isTrue,
      );
    });

    test('shouldStop returns true if moisture >= stopThreshold', () {
      expect(
        rules.shouldStop(
          currentMoisturePercent: 65,
          isFresh: true,
          elapsedSeconds: 100,
          maxDurationSeconds: 600,
          stopThreshold: 60,
        ),
        isTrue,
      );
    });
  });
}
