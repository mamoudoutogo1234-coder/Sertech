import 'irrigation_settings.dart';

/// État d'automatisation d'une zone.
enum AutomationState {
  enabled,
  disabled,
  unknown;

  bool get isEnabled => this == AutomationState.enabled;
}

/// État d'automatisation déduit des paramètres enregistrés.
AutomationState automationStateFor(IrrigationSettings? settings) {
  if (settings == null) return AutomationState.unknown;
  return settings.autoEnabled
      ? AutomationState.enabled
      : AutomationState.disabled;
}
