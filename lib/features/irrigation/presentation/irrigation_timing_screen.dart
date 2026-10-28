import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../domain/models/irrigation_settings.dart';
import '../../../domain/rules/settings_validation.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/page_header.dart';
import '../../../shared/widgets/sertech_scaffold.dart';
import '../../../shared/widgets/surface_panel.dart';
import '../../irrigation/application/irrigation_providers.dart';

class IrrigationTimingScreen extends ConsumerStatefulWidget {
  final String zoneId;

  const IrrigationTimingScreen({super.key, required this.zoneId});

  @override
  ConsumerState<IrrigationTimingScreen> createState() =>
      _IrrigationTimingScreenState();
}

class _IrrigationTimingScreenState
    extends ConsumerState<IrrigationTimingScreen> {
  late TextEditingController start;
  late TextEditingController stop;
  late TextEditingController maxDur;
  late TextEditingController minInt;
  bool enabled = false;
  bool saving = false;
  SettingsValidationResult? validation;

  @override
  void initState() {
    super.initState();
    final settings = ref
        .read(irrigationSettingsProvider)
        .valueOrNull?[widget.zoneId];
    _load(settings);
  }

  void _load(IrrigationSettings? s) {
    final v = s ?? defaultSettingsFor(widget.zoneId);
    start = TextEditingController(text: v.startThreshold.toStringAsFixed(0));
    stop = TextEditingController(text: v.stopThreshold.toStringAsFixed(0));
    maxDur = TextEditingController(
      text: (v.maxDurationSeconds / 60).toStringAsFixed(0),
    );
    minInt = TextEditingController(
      text: (v.minIntervalSeconds / 3600).toStringAsFixed(0),
    );
    enabled = v.autoEnabled;
    validation = SettingsValidation.validate(v);
  }

  @override
  void dispose() {
    start.dispose();
    stop.dispose();
    maxDur.dispose();
    minInt.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final st = double.tryParse(start.text.replaceAll(',', '.'));
    final sp = double.tryParse(stop.text.replaceAll(',', '.'));
    final md = int.tryParse(maxDur.text.trim());
    final mi = int.tryParse(minInt.text.trim());
    if (st == null || sp == null || md == null || mi == null) {
      setState(
        () => validation = const SettingsValidationResult(
          {SettingsFieldError.startThresholdRequired},
          null,
          null,
          null,
          null,
        ),
      );
      return;
    }
    final base =
        ref.read(irrigationSettingsProvider).valueOrNull?[widget.zoneId] ??
        defaultSettingsFor(widget.zoneId);
    final s = base.copyWith(
      autoEnabled: enabled,
      startThreshold: st,
      stopThreshold: sp,
      maxDurationSeconds: md * 60,
      minIntervalSeconds: mi * 3600,
    );
    final val = SettingsValidation.validate(s);
    setState(() => validation = val);
    if (!val.isValid) return;
    setState(() => saving = true);
    try {
      await ref.read(irrigationActionsProvider).saveSettings(s);
      if (!mounted) return;
      setState(() => saving = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.settingsSaved)));
      context.pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n.settingsSaveFailed} — $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return SertechScaffold(
      body: ListView(
        padding: kPagePaddingWithHeader,
        children: [
          PageHeader(
            eyebrow: l10n.appName,
            title: l10n.configureIrrigation,
            actions: [
              IconButton(
                tooltip: l10n.cancel,
                icon: const Icon(Icons.close),
                onPressed: () => context.pop(),
              ),
            ],
          ),
          SurfacePanel(
            padding: const EdgeInsets.all(AppSpacing.s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.automation,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.s8),
                SwitchListTile(
                  value: enabled,
                  onChanged: (v) => setState(() => enabled = v),
                  title: Text(l10n.automationEnabled),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s12),
          SurfacePanel(
            padding: const EdgeInsets.all(AppSpacing.s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.irrigationTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.s4),
                Text(
                  l10n.executionUnavailableDesc,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.s16),
                Text(l10n.maxDuration, style: theme.textTheme.labelLarge),
                const SizedBox(height: AppSpacing.s8),
                TextFormField(
                  controller: maxDur,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: l10n.maxDuration,
                    suffixText: 'min',
                    helperText: l10n.durationRange,
                  ),
                ),
                const SizedBox(height: AppSpacing.s16),
                Text(l10n.minInterval, style: theme.textTheme.labelLarge),
                const SizedBox(height: AppSpacing.s8),
                TextFormField(
                  controller: minInt,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: l10n.minInterval,
                    suffixText: 'h',
                    helperText: l10n.intervalRange,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s12),
          SurfacePanel(
            padding: const EdgeInsets.all(AppSpacing.s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.soilMoisture,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.s12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: start,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                        ],
                        decoration: InputDecoration(
                          labelText: l10n.startThreshold,
                          suffixText: '%',
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s12),
                    Expanded(
                      child: TextFormField(
                        controller: stop,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                        ],
                        decoration: InputDecoration(
                          labelText: l10n.stopThreshold,
                          suffixText: '%',
                        ),
                      ),
                    ),
                  ],
                ),
                if (validation != null && !validation!.isValid) ...[
                  const SizedBox(height: AppSpacing.s12),
                  Text(
                    _err(l10n, validation!),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s20),
          FilledButton(
            onPressed: saving ? null : _save,
            child: saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.save),
          ),
          const SizedBox(height: AppSpacing.s8),
          TextButton(
            onPressed: saving ? null : () => context.pop(),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }
}

String _err(AppLocalizations l10n, SettingsValidationResult r) {
  final e = r.errors;
  if (e.contains(SettingsFieldError.hysteresisInvalid)) {
    return l10n.hysteresisInvalid;
  }
  if (e.contains(SettingsFieldError.maxDurationRange)) {
    return l10n.durationRange;
  }
  if (e.contains(SettingsFieldError.minIntervalNegative)) {
    return l10n.intervalRange;
  }
  if (e.contains(SettingsFieldError.startThresholdRange) ||
      e.contains(SettingsFieldError.stopThresholdRange)) {
    return l10n.thresholdRange;
  }
  if (e.contains(SettingsFieldError.startThresholdRequired) ||
      e.contains(SettingsFieldError.stopThresholdRequired) ||
      e.contains(SettingsFieldError.maxDurationRequired) ||
      e.contains(SettingsFieldError.minIntervalRequired)) {
    return l10n.fieldRequired;
  }
  return l10n.actionFailed;
}
