import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sertech/app/providers.dart';
import 'package:sertech/data/repositories/in_memory_repositories.dart';
import 'package:sertech/data/repositories/supabase_irrigation_settings_repository.dart';
import 'package:sertech/data/repositories/supabase_profile_repository.dart';
import 'package:sertech/data/repositories/supabase_sensor_data_repository.dart';
import 'package:sertech/data/repositories/supabase_valve_command_repository.dart';
import 'package:sertech/data/repositories/supabase_zone_repository.dart';
import 'package:sertech/features/auth/application/auth_providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _MockSupabaseClient extends Mock implements SupabaseClient {}

void main() {
  late SupabaseClient client;

  setUp(() {
    client = _MockSupabaseClient();
  });

  ProviderContainer buildContainer({
    required DataMode mode,
    SupabaseClient? client,
  }) {
    return ProviderContainer(
      overrides: [
        dataModeProvider.overrideWith((ref) => mode),
        supabaseClientProvider.overrideWithValue(client),
      ],
    );
  }

  void expectDemoRepositories(ProviderContainer container) {
    expect(
      container.read(zoneRepositoryProvider),
      isA<InMemoryZoneRepository>(),
    );
    expect(
      container.read(sensorDataRepositoryProvider),
      isA<InMemorySensorDataRepository>(),
    );
    expect(
      container.read(irrigationSettingsRepositoryProvider),
      isA<InMemoryIrrigationSettingsRepository>(),
    );
    expect(
      container.read(valveCommandRepositoryProvider),
      isA<InMemoryValveCommandRepository>(),
    );
    expect(
      container.read(profileRepositoryProvider),
      isNot(isA<SupabaseProfileRepository>()),
    );
  }

  void expectSupabaseRepositories(ProviderContainer container) {
    expect(
      container.read(zoneRepositoryProvider),
      isA<SupabaseZoneRepository>(),
    );
    expect(
      container.read(sensorDataRepositoryProvider),
      isA<SupabaseSensorDataRepository>(),
    );
    expect(
      container.read(irrigationSettingsRepositoryProvider),
      isA<SupabaseIrrigationSettingsRepository>(),
    );
    expect(
      container.read(valveCommandRepositoryProvider),
      isA<SupabaseValveCommandRepository>(),
    );
    expect(
      container.read(profileRepositoryProvider),
      isA<SupabaseProfileRepository>(),
    );
  }

  group('data mode switching', () {
    test('demo mode returns in-memory repositories', () async {
      final container = buildContainer(mode: DataMode.inMemory);
      addTearDown(container.dispose);

      expectDemoRepositories(container);
      final profile = await container
          .read(profileRepositoryProvider)
          .getCurrentProfile();
      expect(profile?.id, 'demo-user-local');
    });

    test('supabase mode returns Supabase repositories', () {
      final container = buildContainer(mode: DataMode.supabase, client: client);
      addTearDown(container.dispose);

      expect(container.read(effectiveDataModeProvider), DataMode.supabase);
      expectSupabaseRepositories(container);
    });

    test('switching mode rebuilds every repository', () {
      final container = buildContainer(mode: DataMode.inMemory, client: client);
      addTearDown(container.dispose);

      expectDemoRepositories(container);

      container.read(dataModeProvider.notifier).state = DataMode.supabase;
      expectSupabaseRepositories(container);

      container.read(dataModeProvider.notifier).state = DataMode.inMemory;
      expectDemoRepositories(container);
    });

    test('supabase preference falls back to demo without a client', () {
      final container = buildContainer(mode: DataMode.supabase);
      addTearDown(container.dispose);

      expect(container.read(effectiveDataModeProvider), DataMode.inMemory);
      expectDemoRepositories(container);
    });
  });

  group('demo authentication guards', () {
    test('the session stays empty in demo mode', () async {
      final container = buildContainer(mode: DataMode.inMemory);
      addTearDown(container.dispose);

      expect(await container.read(authSessionProvider.future), isNull);
      expect(container.read(isSignedInProvider), isTrue);
    });

    test('signOut completes safely in demo mode', () async {
      final container = buildContainer(mode: DataMode.inMemory);
      addTearDown(container.dispose);

      await container.read(authControllerProvider).signOut();
    });

    test('signIn fails with an explicit StateError in demo mode', () async {
      final container = buildContainer(mode: DataMode.inMemory);
      addTearDown(container.dispose);

      await expectLater(
        container
            .read(authControllerProvider)
            .signIn(email: 'demo@sertech.app', password: 'secret'),
        throwsA(
          isA<StateError>().having(
            (error) => error.message,
            'message',
            contains('démonstration'),
          ),
        ),
      );
    });
  });
}
