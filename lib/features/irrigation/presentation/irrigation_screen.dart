import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../app/router/route_names.dart' show RoutePaths;
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_error_view.dart';
import '../../../core/widgets/app_loading_view.dart';
import '../../../domain/models/irrigation_settings.dart';
import '../../../domain/models/valve_command.dart';
import '../../../domain/models/zone.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/l10n_extensions.dart';
import '../../../shared/widgets/command_status_badge.dart';
import '../../../shared/widgets/page_header.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/sertech_scaffold.dart';
import '../../../shared/widgets/surface_panel.dart';
import '../../irrigation/application/irrigation_providers.dart';
import '../../zones/application/zones_providers.dart';
import '../../../app/providers.dart';

class IrrigationScreen extends ConsumerStatefulWidget {
  const IrrigationScreen({super.key});

  @override
  ConsumerState<IrrigationScreen> createState() => _IrrigationScreenState();
}

class _IrrigationScreenState extends ConsumerState<IrrigationScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final zonesAsync = ref.watch(zonesProvider);
    final selected = ref.watch(irrigationZoneProvider);
    final settingsAsync = ref.watch(irrigationSettingsProvider);
    final commandsAsync = ref.watch(recentCommandsProvider);

    return SertechScaffold(
      body: zonesAsync.when(
        loading: () => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: kPagePaddingWithHeader,
          children: const [
            _IrrigationHeader(),
            SizedBox(height: AppSpacing.s48),
            SizedBox(height: 120, child: AppLoadingView()),
          ],
        ),
        error: (error, _) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: kPagePaddingWithHeader,
          children: [
            const _IrrigationHeader(),
            const SizedBox(height: AppSpacing.s24),
            AppErrorView(
              message: l10n.genericErrorTitle,
              technicalDetails: '$error',
              retryLabel: l10n.retry,
              onRetry: () => ref.invalidate(zonesProvider),
            ),
          ],
        ),
        data: (zones) {
          if (zones.isEmpty) {
            return ListView(
              padding: kPagePaddingWithHeader,
              children: [
                const _IrrigationHeader(),
                const SizedBox(height: AppSpacing.s24),
                AppEmptyState(
                  icon: Icons.water_drop_outlined,
                  title: l10n.noZonesConfigured,
                  description: l10n.noZonesConfiguredDesc,
                  action: FilledButton(
                    onPressed: () => context.goNamed(RouteNames.zones),
                    child: Text(l10n.createZone),
                  ),
                ),
              ],
            );
          }
          final zoneId =
              selected ??
              zones.firstWhere((z) => z.isActive, orElse: () => zones.first).id;
          final zone = _find(zones, zoneId);
          final settingsMap = settingsAsync.valueOrNull;
          final settings = settingsMap?[zoneId];
          final commands = commandsAsync.valueOrNull ?? [];
          final zoneCommands = commands
              .where((c) => c.zoneId == zoneId)
              .toList();
          final hasActiveCommand = zoneCommands.any(
            (c) =>
                c.status == ValveCommandStatus.pending ||
                c.status == ValveCommandStatus.executing,
          );
          final latestOpen =
              zoneCommands
                  .where(
                    (c) =>
                        c.type == ValveCommandType.open &&
                        (c.status == ValveCommandStatus.executing ||
                            c.status == ValveCommandStatus.executed ||
                            c.status == ValveCommandStatus.pending),
                  )
                  .toList()
                ..sort((a, b) {
                  final ta = a.requestedAt ?? DateTime(0);
                  final tb = b.requestedAt ?? DateTime(0);
                  return tb.compareTo(ta);
                });
          final irrigationInProgress =
              latestOpen.isNotEmpty &&
              (latestOpen.first.status == ValveCommandStatus.pending ||
                  latestOpen.first.status == ValveCommandStatus.executing);

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(irrigationSettingsProvider);
              ref.invalidate(recentCommandsProvider);
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: kPagePaddingWithHeader,
              children: [
                const _IrrigationHeader(),
                const SizedBox(height: AppSpacing.s8),
                SurfacePanel(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s16,
                    vertical: AppSpacing.s10,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primarySoft,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.grass_outlined,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s12),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: zoneId,
                            isExpanded: true,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                            items: [
                              for (final item in zones)
                                DropdownMenuItem(
                                  value: item.id,
                                  child: Text(
                                    item.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                ref
                                        .read(irrigationZoneProvider.notifier)
                                        .state =
                                    value;
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.s12),
                _ModeSelector(zoneId: zoneId, settings: settings),
                const SizedBox(height: AppSpacing.s16),
                Center(
                  child: _IrrigationActionIconButton(
                    zone: zone,
                    settings: settings,
                    irrigationInProgress: irrigationInProgress,
                    hasActiveCommand: hasActiveCommand,
                  ),
                ),
                const SizedBox(height: AppSpacing.s16),
                SectionHeader(title: l10n.commands),
                commandsAsync.when(
                  loading: () =>
                      const SizedBox(height: 80, child: AppLoadingView()),
                  error: (error, _) => AppErrorView(
                    message: l10n.genericErrorTitle,
                    technicalDetails: '$error',
                    retryLabel: l10n.retry,
                    onRetry: () => ref.invalidate(recentCommandsProvider),
                  ),
                  data: (cmds) {
                    final list = cmds
                        .where((c) => c.zoneId == zoneId)
                        .take(10)
                        .toList();
                    if (list.isEmpty) {
                      return AppEmptyState(
                        compact: true,
                        icon: Icons.history_toggle_off,
                        title: l10n.noCommands,
                        description: l10n.noCommandsDesc,
                      );
                    }
                    return Column(
                      children: [
                        for (final c in list)
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.s8,
                            ),
                            child: SurfacePanel(
                              onTap: () => context.pushNamed(
                                RouteNames.commandDetail,
                                pathParameters: {'id': c.id},
                              ),
                              padding: const EdgeInsets.all(AppSpacing.s12),
                              child: Row(
                                children: [
                                  CommandTypeLabel(type: c.type),
                                  const Spacer(),
                                  CommandStatusBadge(
                                    status: c.status,
                                    dense: true,
                                  ),
                                  const SizedBox(width: AppSpacing.s8),
                                  Text(
                                    c.requestedAt == null
                                        ? l10n.notAvailable
                                        : context.relativeTime(c.requestedAt!),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _IrrigationHeader extends StatelessWidget {
  const _IrrigationHeader();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PageHeader(eyebrow: l10n.appName, title: l10n.irrigationTitle);
  }
}

class _ModeSelector extends ConsumerStatefulWidget {
  final String zoneId;
  final IrrigationSettings? settings;

  const _ModeSelector({required this.zoneId, required this.settings});

  @override
  ConsumerState<_ModeSelector> createState() => _ModeSelectorState();
}

class _ModeSelectorState extends ConsumerState<_ModeSelector> {
  bool saving = false;
  bool? _optimistic;

  Future<void> _setMode(bool auto) async {
    if (saving) return;
    final l10n = AppLocalizations.of(context)!;
    final settingsMap = ref.read(irrigationSettingsProvider).valueOrNull;
    final current =
        settingsMap?[widget.zoneId] ??
        widget.settings ??
        defaultSettingsFor(widget.zoneId);
    setState(() {
      saving = true;
      _optimistic = auto;
    });
    try {
      final repo = ref.read(irrigationSettingsRepositoryProvider);
      await repo.upsert(current.copyWith(autoEnabled: auto));
      await Future.delayed(const Duration(milliseconds: 200));
      ref.invalidate(irrigationSettingsProvider);
      try {
        await ref
            .read(irrigationSettingsProvider.future)
            .timeout(const Duration(seconds: 5));
      } catch (_) {}
      if (!mounted) return;
      setState(() {
        saving = false;
        _optimistic = null;
      });
      if (auto && mounted) {
        context.pushNamed(
          RouteNames.irrigationTiming,
          extra: {'zoneId': widget.zoneId},
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        saving = false;
        _optimistic = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsSaveFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settingsMap = ref.watch(irrigationSettingsProvider).valueOrNull;
    final settings = settingsMap?[widget.zoneId] ?? widget.settings;
    final auto = _optimistic ?? (settings?.autoEnabled ?? false);
    return SurfacePanel(
      padding: const EdgeInsets.all(AppSpacing.s8),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: saving ? null : () => _setMode(false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
                decoration: BoxDecoration(
                  color: !auto ? Theme.of(context).colorScheme.primaryContainer : null,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.handyman_outlined, color: !auto ? Theme.of(context).colorScheme.onPrimaryContainer : null),
                    const SizedBox(width: AppSpacing.s8),
                    Text(l10n.manualIrrigation, style: TextStyle(color: !auto ? Theme.of(context).colorScheme.onPrimaryContainer : null)),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: saving ? null : () => _setMode(true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
                decoration: BoxDecoration(
                  color: auto ? Theme.of(context).colorScheme.primaryContainer : null,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.auto_mode_outlined, color: auto ? Theme.of(context).colorScheme.onPrimaryContainer : null),
                    const SizedBox(width: AppSpacing.s8),
                    Text(l10n.automation, style: TextStyle(color: auto ? Theme.of(context).colorScheme.onPrimaryContainer : null)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IrrigationActionIconButton extends ConsumerWidget {
  final Zone zone;
  final IrrigationSettings? settings;
  final bool irrigationInProgress;
  final bool hasActiveCommand;

  const _IrrigationActionIconButton({
    required this.zone,
    required this.settings,
    required this.irrigationInProgress,
    required this.hasActiveCommand,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final settingsMap = ref.watch(irrigationSettingsProvider).valueOrNull;
    final currentSettings = settingsMap?[zone.id] ?? settings;
    final auto = currentSettings?.autoEnabled ?? false;
    final maxDur = currentSettings?.maxDurationSeconds;

    if (auto && !irrigationInProgress && !hasActiveCommand) {
      return Container(
        width: 112,
        height: 112,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.colorScheme.primaryContainer,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.18),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: IconButton(
          onPressed: () {
            context.pushNamed(
              RouteNames.irrigationTiming,
              extra: {'zoneId': zone.id},
            );
          },
          iconSize: 40,
          padding: EdgeInsets.zero,
          icon: Icon(
            Icons.auto_mode_outlined,
            color: theme.colorScheme.onPrimaryContainer,
          ),
          tooltip: l10n.automation,
        ),
      );
    }

    if (hasActiveCommand && !irrigationInProgress) {
      return Container(
        width: 112,
        height: 112,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.colorScheme.surfaceContainerHighest,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: IconButton(
          onPressed: null,
          iconSize: 40,
          padding: EdgeInsets.zero,
          icon: Icon(
            Icons.hourglass_top,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.38),
          ),
          tooltip: l10n.statusPending,
        ),
      );
    }

    if (irrigationInProgress) {
      return Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.error,
              theme.colorScheme.error.withValues(alpha: 0.85),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.error.withValues(alpha: 0.25),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: IconButton(
          onPressed: () => _confirmStop(context, ref),
          iconSize: 48,
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.stop_circle_outlined, color: Colors.white),
          tooltip: l10n.stopIrrigation,
        ),
      );
    }

    if (auto) {
      return Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.tertiary.withValues(alpha: 0.9),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.22),
              blurRadius: 22,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: IconButton(
          onPressed: () {
            ref.read(irrigationZoneProvider.notifier).state = zone.id;
            Navigator.of(context).pushNamed(
              RouteNames.irrigationTiming,
              arguments: {'zoneId': zone.id},
            );
          },
          iconSize: 48,
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.timer_outlined, color: Colors.white),
          tooltip: l10n.configureIrrigation,
        ),
      );
    }

    if (maxDur == null || maxDur <= 0) {
      return Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primary.withValues(alpha: 0.9),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.22),
              blurRadius: 22,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: IconButton(
          onPressed: () => _needManualMode(context, ref),
          iconSize: 48,
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.water_drop_outlined, color: Colors.white),
          tooltip: l10n.requestOpen,
        ),
      );
    }

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.88),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.24),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: IconButton(
        onPressed: () => _startManual(context, ref, maxDur),
        iconSize: 48,
        padding: EdgeInsets.zero,
        icon: const Icon(Icons.water_drop_outlined, color: Colors.white),
        tooltip: l10n.requestOpen,
      ),
    );
  }

  Future<void> _needManualMode(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        title: Text(l10n.modeManualRequired),
        content: Text(l10n.enableManualModeDesc),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(d, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(d, true),
            child: Text(l10n.switchToManual),
          ),
        ],
      ),
    );
    if (ok != true) return;
    final settingsMap = ref.read(irrigationSettingsProvider).valueOrNull;
    final base = settingsMap?[zone.id] ?? settings ?? defaultSettingsFor(zone.id);
    try {
      final repo = ref.read(irrigationSettingsRepositoryProvider);
      await repo.upsert(base.copyWith(autoEnabled: false));
      ref.invalidate(irrigationSettingsProvider);
    } catch (_) {}
  }

  Future<void> _startManual(
    BuildContext context,
    WidgetRef ref,
    int maxDurSec,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(
      text: (maxDurSec / 60).toStringAsFixed(0),
    );
    String? error;
    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.startIrrigation),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(zone.name),
              const SizedBox(height: AppSpacing.s12),
              TextFormField(
                controller: controller,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: l10n.durationMinutesLabel,
                  suffixText: 'min',
                  helperText:
                      '${l10n.maxDuration}: ${(maxDurSec / 60).toStringAsFixed(0)} min',
                ),
              ),
              if (error != null) ...[
                const SizedBox(height: AppSpacing.s8),
                Text(
                  error!,
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: AppSpacing.s8),
              Text(
                l10n.autoStopAtEnd,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(d, false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                final v = int.tryParse(controller.text.trim());
                if (v == null || v <= 0) {
                  setState(() => error = l10n.invalidDuration);
                  return;
                }
                final sec = v * 60;
                if (sec > maxDurSec) {
                  setState(() => error = l10n.durationExceedsMax);
                  return;
                }
                Navigator.pop(d, true);
              },
              child: Text(l10n.confirm),
            ),
          ],
        ),
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(irrigationActionsProvider).requestOpen(zone.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.commandCreated)));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${l10n.commandFailed} — $e')));
      }
    }
  }

  Future<void> _confirmStop(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        title: Text(l10n.stopIrrigation),
        content: Text(l10n.stopIrrigationConfirm(zone.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(d, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(d, true),
            child: Text(l10n.requestClose),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(irrigationActionsProvider).requestClose(zone.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.commandCreated)));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${l10n.commandFailed} — $e')));
      }
    }
  }
}

Zone _find(List<Zone> zones, String zoneId) {
  for (final z in zones) {
    if (z.id == zoneId) return z;
  }
  return zones.first;
}
