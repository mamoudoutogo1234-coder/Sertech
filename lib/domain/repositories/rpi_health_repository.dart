class RpiHealth {
  final bool reachable;
  final DateTime? lastHeartbeatAt;
  final String status;

  const RpiHealth({
    required this.reachable,
    this.lastHeartbeatAt,
    this.status = 'unknown',
  });
}

abstract class RpiHealthRepository {
  Future<RpiHealth> getHealth();
  Stream<RpiHealth> watchHealth();
}
