import 'dart:async';

import '../../domain/models/irrigation_settings.dart';
import '../../domain/models/sensor_data.dart';
import '../../domain/models/valve_command.dart';
import '../../domain/models/zone.dart';
import '../../domain/repositories/irrigation_settings_repository.dart';
import '../../domain/repositories/sensor_data_repository.dart';
import '../../domain/repositories/valve_command_repository.dart';
import '../../domain/repositories/zone_repository.dart';
import '../demo/demo_data_factory.dart';
import '../demo/demo_scenario.dart';

/// Store en mémoire partageant le même jeu de données entre tous les
/// repositories de démonstration. Les modifications faite par l'interface
/// (création de zone, demande de commande) restent visibles partout.
class DemoDataStore {
  DemoDataStore({required DemoScenario scenario, DateTime? reference})
    : _factory = DemoDataFactory(reference: reference),
      _scenario = scenario {
    _seed();
  }

  final DemoDataFactory _factory;
  DemoScenario _scenario;

  final Map<String, Zone> _zones = {};
  final Map<String, List<SensorData>> _measurements = {};
  final Map<String, IrrigationSettings> _settings = {};
  final List<ValveCommand> _commands = [];
  int _commandCounter = 0;

  DemoScenario get scenario => _scenario;
  DateTime get reference => _factory.reference;

  void _seed() {
    _zones.clear();
    _measurements.clear();
    _settings.clear();
    _commands.clear();
    _commandCounter = 0;

    final zones = _factory.buildZones(_scenario);
    for (final zone in zones) {
      _zones[zone.id] = zone;
    }
    _measurements.addAll(_factory.buildMeasurements(zones, _scenario));
    _settings.addAll(_factory.buildSettings(zones, _scenario));
    _commands.addAll(_factory.buildCommands(zones, _scenario));
    _commandCounter = _commands.length;
  }

  /// Change de scénario et réinitialise le jeu de données.
  void useScenario(DemoScenario scenario) {
    _scenario = scenario;
    _seed();
  }

  List<Zone> get zones => _zones.values.toList();

  Zone? zone(String id) => _zones[id];

  List<SensorData> measurements(String zoneId) =>
      List.unmodifiable(_measurements[zoneId] ?? const <SensorData>[]);

  List<ValveCommand> get commands => List.unmodifiable(_commands);

  IrrigationSettings? settings(String zoneId) => _settings[zoneId];

  void putZone(Zone zone) => _zones[zone.id] = zone;

  void removeZone(String zoneId) {
    _zones.remove(zoneId);
    _measurements.remove(zoneId);
    _settings.remove(zoneId);
    _commands.removeWhere((c) => c.zoneId == zoneId);
  }

  void putSettings(IrrigationSettings settings) =>
      _settings[settings.zoneId] = settings;

  void removeSettings(String zoneId) => _settings.remove(zoneId);

  void addCommand(ValveCommand command) => _commands.insert(0, command);

  String nextCommandId() => 'demo-cmd-${++_commandCounter}';
}

class InMemoryZoneRepository implements ZoneRepository {
  final DemoDataStore _store;

  InMemoryZoneRepository(this._store);

  @override
  Future<List<Zone>> getZones() async => _store.zones;

  @override
  Future<Zone?> getZone(String zoneId) async => _store.zone(zoneId);

  @override
  Future<Zone> createZone({
    required String userId,
    required String name,
    String? description,
    bool isActive = true,
  }) async {
    final zone = Zone(
      id: 'demo-zone-${DateTime.now().microsecondsSinceEpoch}',
      userId: userId,
      name: name,
      description: description,
      isActive: isActive,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _store.putZone(zone);
    return zone;
  }

  @override
  Future<Zone> updateZone(Zone zone) async {
    final updated = zone.copyWith(updatedAt: DateTime.now());
    _store.putZone(updated);
    return updated;
  }

  @override
  Future<void> deleteZone(String zoneId) async {
    _store.removeZone(zoneId);
  }
}

class InMemorySensorDataRepository implements SensorDataRepository {
  final DemoDataStore _store;

  InMemorySensorDataRepository(this._store);

  @override
  Future<SensorData?> getLatest(String zoneId) async {
    final list = _store.measurements(zoneId);
    if (list.isEmpty) return null;
    return list.last;
  }

  @override
  Future<List<SensorData>> getHistory(String zoneId, {int limit = 50}) async {
    final list = _store.measurements(zoneId);
    if (list.length <= limit) return list;
    return list.sublist(list.length - limit);
  }

  @override
  Future<List<SensorData>> getHistoryForPeriod(
    String zoneId,
    HistoryPeriod period, {
    DateTime? now,
  }) async {
    final reference = now ?? DateTime.now();
    final start = period.startFrom(reference);
    return _store
        .measurements(zoneId)
        .where((m) => m.recordedAt.isAfter(start))
        .toList();
  }

  @override
  Future<Map<String, SensorData>> getLatestForZones(
    List<String> zoneIds,
  ) async {
    final result = <String, SensorData>{};
    for (final zoneId in zoneIds) {
      final latest = await getLatest(zoneId);
      if (latest != null) result[zoneId] = latest;
    }
    return result;
  }

  @override
  Stream<SensorData?> watchLatest(String zoneId) async* {
    yield await getLatest(zoneId);
  }
}

class InMemoryIrrigationSettingsRepository
    implements IrrigationSettingsRepository {
  final DemoDataStore _store;

  InMemoryIrrigationSettingsRepository(this._store);

  @override
  Future<IrrigationSettings?> getForZone(String zoneId) async =>
      _store.settings(zoneId);

  @override
  Future<Map<String, IrrigationSettings>> getAll() async => {
    for (final zone in _store.zones)
      if (_store.settings(zone.id) != null) zone.id: _store.settings(zone.id)!,
  };

  @override
  Future<void> upsert(IrrigationSettings settings) async {
    _store.putSettings(settings);
  }

  @override
  Future<void> delete(String zoneId) async {
    _store.removeSettings(zoneId);
  }
}

class InMemoryValveCommandRepository implements ValveCommandRepository {
  final DemoDataStore _store;

  InMemoryValveCommandRepository(this._store);

  @override
  Future<ValveCommand> requestOpen(
    String zoneId, {
    String? origin,
    String? reason,
  }) => _create(zoneId, ValveCommandType.open, origin, reason);

  @override
  Future<ValveCommand> requestClose(
    String zoneId, {
    String? origin,
    String? reason,
  }) => _create(zoneId, ValveCommandType.close, origin, reason);

  Future<ValveCommand> _create(
    String zoneId,
    ValveCommandType type,
    String? origin,
    String? reason,
  ) async {
    final command = ValveCommand(
      id: _store.nextCommandId(),
      zoneId: zoneId,
      type: type,
      // Une commande créée depuis l'application reste « en attente ».
      status: ValveCommandStatus.pending,
      origin: origin ?? 'mobile_app',
      reason: reason ?? 'manual',
      requestedAt: DateTime.now(),
    );
    _store.addCommand(command);
    return command;
  }

  @override
  Future<List<ValveCommand>> getHistory(String zoneId, {int limit = 20}) async {
    final list = _store.commands.where((c) => c.zoneId == zoneId).toList();
    return list.length <= limit ? list : list.sublist(0, limit);
  }

  @override
  Future<List<ValveCommand>> getRecent({int limit = 50}) async {
    final list = _store.commands;
    return list.length <= limit ? list : list.sublist(0, limit);
  }

  @override
  Future<ValveCommand?> getById(String commandId) async {
    for (final command in _store.commands) {
      if (command.id == commandId) return command;
    }
    return null;
  }

  @override
  Stream<List<ValveCommand>> watchForZone(String zoneId) async* {
    yield await getHistory(zoneId);
  }
}
