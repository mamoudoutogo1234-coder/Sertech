import 'package:equatable/equatable.dart';

enum ValveCommandType { open, close }

enum ValveCommandStatus { pending, executing, executed, failed }

ValveCommandType valveCommandTypeFromString(String? value) {
  return value == 'close' ? ValveCommandType.close : ValveCommandType.open;
}

ValveCommandStatus valveCommandStatusFromString(String? value) {
  return switch (value) {
    'executing' => ValveCommandStatus.executing,
    'executed' => ValveCommandStatus.executed,
    'failed' => ValveCommandStatus.failed,
    _ => ValveCommandStatus.pending,
  };
}

class ValveCommand extends Equatable {
  final String id;
  final String zoneId;
  final ValveCommandType type;
  final ValveCommandStatus status;
  final String? origin;
  final String? reason;
  final DateTime? requestedAt;
  final DateTime? executedAt;
  final String? errorMessage;

  const ValveCommand({
    required this.id,
    required this.zoneId,
    required this.type,
    required this.status,
    this.origin,
    this.reason,
    this.requestedAt,
    this.executedAt,
    this.errorMessage,
  });

  factory ValveCommand.fromJson(Map<String, dynamic> json) {
    return ValveCommand(
      id: json['id'] as String,
      zoneId: json['zone_id'] as String,
      type: valveCommandTypeFromString(json['type'] as String?),
      status: valveCommandStatusFromString(json['status'] as String?),
      origin: json['origin'] as String?,
      reason: json['reason'] as String?,
      requestedAt: json['requested_at'] != null
          ? DateTime.parse(json['requested_at'] as String)
          : null,
      executedAt: json['executed_at'] != null
          ? DateTime.parse(json['executed_at'] as String)
          : null,
      errorMessage: json['error_message'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'zone_id': zoneId,
    'type': type.name,
    'status': status.name,
    'origin': origin,
    'reason': reason,
    'requested_at': requestedAt?.toIso8601String(),
    'executed_at': executedAt?.toIso8601String(),
    'error_message': errorMessage,
  };

  ValveCommand copyWith({
    String? id,
    String? zoneId,
    ValveCommandType? type,
    ValveCommandStatus? status,
    String? origin,
    String? reason,
    DateTime? requestedAt,
    DateTime? executedAt,
    String? errorMessage,
  }) {
    return ValveCommand(
      id: id ?? this.id,
      zoneId: zoneId ?? this.zoneId,
      type: type ?? this.type,
      status: status ?? this.status,
      origin: origin ?? this.origin,
      reason: reason ?? this.reason,
      requestedAt: requestedAt ?? this.requestedAt,
      executedAt: executedAt ?? this.executedAt,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    id,
    zoneId,
    type,
    status,
    origin,
    reason,
    requestedAt,
    executedAt,
    errorMessage,
  ];
}
