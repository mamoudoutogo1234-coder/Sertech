import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/config/app_config.dart';
import '../core/network/connectivity_service.dart';
import '../data/demo/demo_scenario.dart';
import '../data/repositories/in_memory_repositories.dart';
import '../data/repositories/in_memory_rpi_health_repository.dart';
import '../data/repositories/in_memory_dashboard_repository.dart';
import '../data/repositories/supabase_dashboard_repository.dart';
import '../data/repositories/supabase_irrigation_settings_repository.dart';
import '../data/repositories/supabase_profile_repository.dart';
import '../data/repositories/supabase_sensor_data_repository.dart';
import '../data/repositories/supabase_valve_command_repository.dart';
import '../data/repositories/supabase_zone_repository.dart';
import '../data/repositories/unavailable_camera_repository.dart';
import '../data/supabase/supabase_initializer.dart';
import '../domain/models/profile.dart';
import '../domain/repositories/camera_repository.dart';
import '../domain/repositories/dashboard_repository.dart';
import '../domain/repositories/irrigation_settings_repository.dart';
import '../domain/repositories/profile_repository.dart';
import '../domain/repositories/rpi_health_repository.dart';
import '../domain/repositories/sensor_data_repository.dart';
import '../domain/repositories/valve_command_repository.dart';
import '../domain/repositories/zone_repository.dart';

/// Mode de données actif.
///
/// `supabase` : lecture/écriture réelle dans Supabase local.
/// `inMemory` : jeu de données de démonstration, clairement identifié dans
/// l'interface et jamais écrit dans Supabase.
enum DataMode { supabase, inMemory }

final dataModeProvider = StateProvider<DataMode>((ref) {
  return SupabaseInitializer.isInitialized
      ? DataMode.supabase
      : DataMode.inMemory;
});

/// Client Supabase disponible, ou `null` si l'initialisation a échoué.
///
/// Ce provider est le seul point d'accès au client : il permet aux tests et
/// aux environnements sans backend de remplacer Supabase sans toucher aux
/// repositories.
final supabaseClientProvider = Provider<SupabaseClient?>((ref) {
  if (!SupabaseInitializer.isInitialized) return null;
  return SupabaseInitializer.client;
});

/// Supabase est-il réellement exploitable dans cette exécution ?
final supabaseReadyProvider = Provider<bool>((ref) {
  return ref.watch(supabaseClientProvider) != null;
});

/// Mode réellement appliqué aux données.
///
/// Le mode choisi par l'utilisateur est une préférence ; si Supabase n'est pas
/// disponible, l'application retombe explicitement sur les données de
/// démonstration au lieu de prétendre lire le cloud.
final effectiveDataModeProvider = Provider<DataMode>((ref) {
  final mode = ref.watch(dataModeProvider);
  if (mode == DataMode.supabase && ref.watch(supabaseClientProvider) == null) {
    return DataMode.inMemory;
  }
  return mode;
});

/// Scénario de démonstration courant (mode `inMemory` uniquement).
final demoScenarioProvider = StateProvider<DemoScenario>(
  (ref) => DemoScenario.nominal,
);

/// Store de données de démonstration, partagé par tous les repositories
/// mémoire afin que les modifications restent cohérentes entre écrans.
final demoDataStoreProvider = Provider<DemoDataStore>((ref) {
  final scenario = ref.watch(demoScenarioProvider);
  return DemoDataStore(scenario: scenario);
});

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityServiceImpl(Connectivity());
});

/// Connectivité réseau du téléphone uniquement. Elle ne dit rien de la
/// disponibilité du serveur Supabase ni du Raspberry Pi.
final isOnlineProvider = StreamProvider<bool>((ref) {
  return ref.watch(connectivityServiceProvider).onConnectivityChanged();
});

final zoneRepositoryProvider = Provider<ZoneRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  if (ref.watch(effectiveDataModeProvider) == DataMode.supabase &&
      client != null) {
    return SupabaseZoneRepository(client);
  }
  return InMemoryZoneRepository(ref.watch(demoDataStoreProvider));
});

final sensorDataRepositoryProvider = Provider<SensorDataRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  if (ref.watch(effectiveDataModeProvider) == DataMode.supabase &&
      client != null) {
    return SupabaseSensorDataRepository(client);
  }
  return InMemorySensorDataRepository(ref.watch(demoDataStoreProvider));
});

final irrigationSettingsRepositoryProvider =
    Provider<IrrigationSettingsRepository>((ref) {
      final client = ref.watch(supabaseClientProvider);
      if (ref.watch(effectiveDataModeProvider) == DataMode.supabase &&
          client != null) {
        return SupabaseIrrigationSettingsRepository(client);
      }
      return InMemoryIrrigationSettingsRepository(
        ref.watch(demoDataStoreProvider),
      );
    });

final valveCommandRepositoryProvider = Provider<ValveCommandRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  if (ref.watch(effectiveDataModeProvider) == DataMode.supabase &&
      client != null) {
    return SupabaseValveCommandRepository(client);
  }
  return InMemoryValveCommandRepository(ref.watch(demoDataStoreProvider));
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  if (ref.watch(effectiveDataModeProvider) == DataMode.supabase &&
      client != null) {
    return SupabaseProfileRepository(client);
  }
  return const _DemoProfileRepository();
});

final rpiHealthRepositoryProvider = Provider<RpiHealthRepository>((ref) {
  return const InMemoryRpiHealthRepository();
});

final cameraRepositoryProvider = Provider<CameraRepository>((ref) {
  return UnavailableCameraRepository();
});

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  if (ref.watch(effectiveDataModeProvider) == DataMode.supabase &&
      client != null) {
    return SupabaseDashboardRepository(
      zoneRepository: ref.watch(zoneRepositoryProvider),
      sensorDataRepository: ref.watch(sensorDataRepositoryProvider),
      irrigationSettingsRepository: ref.watch(
        irrigationSettingsRepositoryProvider,
      ),
      valveCommandRepository: ref.watch(valveCommandRepositoryProvider),
    );
  }
  return InMemoryDashboardRepository(
    zoneRepository: ref.watch(zoneRepositoryProvider),
    sensorDataRepository: ref.watch(sensorDataRepositoryProvider),
    irrigationSettingsRepository: ref.watch(
      irrigationSettingsRepositoryProvider,
    ),
    valveCommandRepository: ref.watch(valveCommandRepositoryProvider),
  );
});

/// La configuration Supabase est-elle exploitable ?
final supabaseConfiguredProvider = Provider<bool>((ref) {
  return AppConfig.hasSupabaseConfig;
});

/// Profil de démonstration : aucun utilisateur réel n'est exposé.
class _DemoProfileRepository implements ProfileRepository {
  const _DemoProfileRepository();

  @override
  Future<Profile?> getCurrentProfile() async => const Profile(
    id: 'demo-user-local',
    displayName: 'Utilisateur de démonstration',
  );

  @override
  Future<Profile> upsertProfile({
    required String userId,
    String? displayName,
  }) async {
    return Profile(id: userId, displayName: displayName);
  }
}
