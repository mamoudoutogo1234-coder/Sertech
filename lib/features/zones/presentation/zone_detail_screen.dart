import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/utils/freshness_utils.dart';
import '../../../core/utils/number_formatter.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_error_view.dart';
import '../../../core/widgets/app_loading_view.dart';
import '../../../domain/models/automation_state.dart';
import '../../../domain/models/irrigation_settings.dart';
import '../../../domain/models/sensor_data.dart';
import '../../../domain/models/zone.dart';
import '../../../domain/repositories/sensor_data_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/l10n_extensions.dart';
import '../../../shared/widgets/brand_hero.dart';
import '../../../shared/widgets/command_status_badge.dart';
import '../../../shared/widgets/metric_tile.dart';
import '../../../shared/widgets/moisture_chart.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/sertech_scaffold.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/widgets/surface_panel.dart';
import '../../irrigation/application/irrigation_providers.dart';
import '../../measurements/application/measurements_providers.dart';
import '../application/zones_providers.dart';
import 'zone_form_sheet.dart';

class ZoneDetailScreen extends ConsumerWidget {
  final String zoneId;

  const ZoneDetailScreen({super.key, required this.zoneId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final zoneAsync = ref.watch(zoneByIdProvider(zoneId));

    return DefaultTabController(
      length: 3,
      child: SertechScaffold(
        body: zoneAsync.when(
          loading: () => Column(
            children: [
              _ZoneTopBar(title: l10n.zoneDetails),
              const Expanded(child: AppLoadingView()),
            ],
          ),
          error: (error, _) => Column(
            children: [
              _ZoneTopBar(title: l10n.zoneDetails),
              Expanded(
                child: AppErrorView(
                  message: l10n.genericErrorTitle,
                  technicalDetails: '$error',
                  retryLabel: l10n.retry,
                  onRetry: () => ref.invalidate(zonesProvider),
                ),
              ),
            ],
          ),
          data: (zone) {
            if (zone == null) {
              return Column(
                children: [
                  _ZoneTopBar(title: l10n.zoneDetails),
                  Expanded(
                    child: AppEmptyState(
                      icon: Icons.search_off,
                      title: l10n.zoneNotFound,
                      action: FilledButton(
                        onPressed: () => context.goNamed(RouteNames.zones),
                        child: Text(l10n.back),
                      ),
                    ),
                  ),
                ],
              );
            }
            return Column(
              children: [
                _ZoneHeader(
                  zone: zone,
                  onEdit: () => _edit(context, ref, zone),
                  onDelete: () => _delete(context, ref, zone),
                ),
                const _ZoneTabs(),
                Expanded(
                  child: TabBarView(
                    children: [
                      _MeasurementsTab(zoneId: zone.id),
                      _SettingsTab(zoneId: zone.id),
                      _CommandsTab(zoneId: zone.id),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _edit(BuildContext context, WidgetRef ref, Zone zone) async {
    final saved = await showZoneFormSheet(context, zone: zone);
    if (saved != null && context.mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.zoneUpdated(saved.name))));
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, Zone zone) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteZoneTitle),
        content: Text(l10n.deleteZoneMessage(zone.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(zoneActionsProvider).delete(zone.id);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.zoneDeleted(zone.name))));
      context.goNamed(RouteNames.zones);
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${l10n.actionFailed} — $error')));
    }
  }
}

/// Barre minimale pour les états sans zone : retour + titre.
class _ZoneTopBar extends StatelessWidget {
  final String title;

  const _ZoneTopBar({required this.title});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s8,
        AppSpacing.s4,
        AppSpacing.screenPadding,
        AppSpacing.s8,
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: l10n.back,
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.goNamed(RouteNames.zones),
          ),
          const SizedBox(width: AppSpacing.s4),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _ZoneHeader extends StatelessWidget {
  final Zone zone;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ZoneHeader({
    required this.zone,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.s4,
        AppSpacing.screenPadding,
        AppSpacing.s12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                tooltip: l10n.back,
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.goNamed(RouteNames.zones),
              ),
              const Spacer(),
              IconButton(
                tooltip: l10n.editZone,
                icon: const Icon(Icons.edit_outlined),
                onPressed: onEdit,
              ),
              IconButton(
                tooltip: l10n.delete,
                icon: const Icon(Icons.delete_outline),
                onPressed: onDelete,
              ),
            ],
          ),
          Text(
            l10n.zonesTitle.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
              letterSpacing: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.s8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  zone.name,
                  style: theme.textTheme.headlineLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.s12),
              StatusBadge(
                label: zone.isActive ? l10n.zoneActive : l10n.zoneInactive,
                tone: zone.isActive ? StatusTone.success : StatusTone.neutral,
              ),
            ],
          ),
          if ((zone.description ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s8),
            Text(
              zone.description!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: AppSpacing.s12),
          Wrap(
            spacing: AppSpacing.s16,
            runSpacing: AppSpacing.s4,
            children: [
              _MetaChip(
                icon: Icons.tag,
                label: '${l10n.zoneIdentifier} · ${zone.id}',
              ),
              if (zone.createdAt != null)
                _MetaChip(
                  icon: Icons.event_outlined,
                  label: l10n.zoneCreatedOn(context.shortDate(zone.createdAt!)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// Onglets en capsule : une seule pastille active, pas de filet lourd.
class _ZoneTabs extends StatelessWidget {
  const _ZoneTabs();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        0,
        AppSpacing.screenPadding,
        AppSpacing.s8,
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s4),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: TabBar(
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          ),
          labelColor: theme.colorScheme.onPrimary,
          unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
          labelStyle: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: theme.textTheme.labelMedium,
          labelPadding: EdgeInsets.zero,
          tabs: [
            Tab(height: 38, text: l10n.measurementsTab),
            Tab(height: 38, text: l10n.settingsTab),
            Tab(height: 38, text: l10n.commandsTab),
          ],
        ),
      ),
    );
  }
}

class _MeasurementsTab extends ConsumerWidget {
  final String zoneId;

  const _MeasurementsTab({required this.zoneId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final latest = ref.watch(zoneLatestMeasurementProvider(zoneId));
    final history = ref.watch(
      historyProvider((zoneId: zoneId, period: HistoryPeriod.day24h)),
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.s12,
        AppSpacing.screenPadding,
        AppSpacing.s32,
      ),
      children: [
        latest.when(
          loading: () => const SizedBox(height: 140, child: AppLoadingView()),
          error: (error, _) => AppErrorView(
            message: l10n.genericErrorTitle,
            technicalDetails: '$error',
            retryLabel: l10n.retry,
            onRetry: () =>
                ref.invalidate(zoneLatestMeasurementProvider(zoneId)),
          ),
          data: (measurement) =>
              _LatestMeasurementCard(measurement: measurement),
        ),
        SectionHeader(
          title: l10n.historyTitle,
          actionLabel: l10n.viewAll,
          onAction: () {
            ref.read(historyZoneProvider.notifier).state = zoneId;
            context.goNamed(RouteNames.measurements);
          },
        ),
        SurfacePanel(
          padding: const EdgeInsets.all(AppSpacing.s16),
          child: history.when(
            loading: () => const SizedBox(height: 180, child: AppLoadingView()),
            error: (error, _) => AppErrorView(
              message: l10n.genericErrorTitle,
              technicalDetails: '$error',
              retryLabel: l10n.retry,
              onRetry: () => ref.invalidate(historyProvider),
            ),
            data: (readings) => MoistureChart(
              points: _points(readings),
              minY: 0,
              maxY: 100,
              unitLabel: '%',
              emptyLabel: l10n.chartEmptyLabel,
            ),
          ),
        ),
      ],
    );
  }
}

class _LatestMeasurementCard extends StatelessWidget {
  final SensorData? measurement;

  const _LatestMeasurementCard({required this.measurement});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final freshness = FreshnessUtils.of(measurement);

    final data = measurement;
    if (data == null) {
      return AppEmptyState(
        compact: true,
        icon: Icons.sensors_off,
        title: l10n.noMeasurements,
        description: l10n.noMeasurementsDesc,
      );
    }

    final (tone, label) = switch (freshness) {
      ReadingFreshness.fresh => (StatusTone.success, l10n.dataFresh),
      ReadingFreshness.expired => (StatusTone.warning, l10n.dataStale),
      ReadingFreshness.unavailable => (StatusTone.neutral, l10n.noMeasurements),
    };

    final extension = theme.extension<AppThemeExtension>();
    final heroAccent = extension?.heroAccent ?? Colors.white;
    final toneColor = switch (tone) {
      StatusTone.success => heroAccent,
      StatusTone.warning => const Color(0xFFFFD48A),
      _ => Colors.white,
    };

    return BrandHero(
      padding: const EdgeInsets.all(AppSpacing.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.soilMoisture.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white70,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              _HeroPill(label: label, color: toneColor),
            ],
          ),
          const SizedBox(height: AppSpacing.s8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                data.moisturePercent == null
                    ? '—'
                    : NumberFormatter.percentValue(data.moisturePercent!),
                style: theme.textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                ),
              ),
              if (data.moisturePercent != null) ...[
                const SizedBox(width: AppSpacing.s4),
                Text(
                  '%',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.s16),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.16)),
          const SizedBox(height: AppSpacing.s12),
          Wrap(
            spacing: AppSpacing.s24,
            runSpacing: AppSpacing.s12,
            children: [
              _HeroDatum(
                label: l10n.lastMeasurement,
                value: context.relativeTime(data.recordedAt),
              ),
              _HeroDatum(
                label: l10n.rawValue,
                value: data.moistureRaw == null
                    ? l10n.notAvailable
                    : NumberFormatter.oneDecimal(data.moistureRaw!),
              ),
              _HeroDatum(
                label: l10n.source,
                value: data.source ?? l10n.notAvailable,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s12),
          Wrap(
            spacing: AppSpacing.s8,
            runSpacing: AppSpacing.s8,
            children: [
              _HeroPill(
                label: data.isCalibrated ? l10n.calibrated : l10n.notCalibrated,
                color: data.isCalibrated ? heroAccent : const Color(0xFFFFD48A),
              ),
              if (data.isOutOfRange)
                _HeroPill(
                  label: l10n.outOfRange,
                  color: const Color(0xFFFFD48A),
                  icon: Icons.warning_amber_outlined,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroDatum extends StatelessWidget {
  final String label;
  final String value;

  const _HeroDatum({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: Colors.white70,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _HeroPill extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const _HeroPill({required this.label, required this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Icon(icon, size: 12, color: color)
          else
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _SettingsTab extends ConsumerWidget {
  final String zoneId;

  const _SettingsTab({required this.zoneId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settingsAsync = ref.watch(zoneSettingsProvider(zoneId));

    return settingsAsync.when(
      loading: () => const AppLoadingView(),
      error: (error, _) => AppErrorView(
        message: l10n.genericErrorTitle,
        technicalDetails: '$error',
        retryLabel: l10n.retry,
        onRetry: () => ref.invalidate(zoneSettingsProvider(zoneId)),
      ),
      data: (settings) {
        if (settings == null) {
          return Center(
            child: AppEmptyState(
              icon: Icons.tune,
              title: l10n.automationUnknown,
              action: FilledButton(
                onPressed: () => _openIrrigation(context, ref),
                child: Text(l10n.configureIrrigation),
              ),
            ),
          );
        }
        return ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.s12,
            AppSpacing.screenPadding,
            AppSpacing.s32,
          ),
          children: [
            SurfacePanel(
              padding: const EdgeInsets.all(AppSpacing.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.automation,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      StatusBadge(
                        label: _automationLabel(l10n, settings),
                        tone:
                            automationStateFor(settings) ==
                                AutomationState.enabled
                            ? StatusTone.success
                            : StatusTone.neutral,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  InfoRow(
                    icon: Icons.trending_down,
                    label: l10n.startThreshold,
                    value: NumberFormatter.percent(settings.startThreshold),
                  ),
                  InfoRow(
                    icon: Icons.trending_up,
                    label: l10n.stopThreshold,
                    value: NumberFormatter.percent(settings.stopThreshold),
                  ),
                  InfoRow(
                    icon: Icons.timer_outlined,
                    label: l10n.maxDuration,
                    value: l10n.durationMinutes(
                      NumberFormatter.decimal(settings.maxDurationSeconds / 60),
                    ),
                  ),
                  InfoRow(
                    icon: Icons.repeat,
                    label: l10n.minInterval,
                    value: l10n.intervalHours(
                      NumberFormatter.decimal(
                        settings.minIntervalSeconds / 3600,
                      ),
                    ),
                  ),
                  if (settings.updatedAt != null)
                    InfoRow(
                      icon: Icons.update,
                      label: l10n.lastUpdate,
                      value: context.dateTimeLabel(settings.updatedAt!),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            FilledButton.icon(
              onPressed: () => _openIrrigation(context, ref),
              icon: const Icon(Icons.tune),
              label: Text(l10n.configureIrrigation),
            ),
          ],
        );
      },
    );
  }

  void _openIrrigation(BuildContext context, WidgetRef ref) {
    ref.read(irrigationZoneProvider.notifier).state = zoneId;
    context.goNamed(RouteNames.irrigation);
  }
}

class _CommandsTab extends ConsumerWidget {
  final String zoneId;

  const _CommandsTab({required this.zoneId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final commandsAsync = ref.watch(zoneCommandsProvider(zoneId));

    return commandsAsync.when(
      loading: () => const AppLoadingView(),
      error: (error, _) => AppErrorView(
        message: l10n.genericErrorTitle,
        technicalDetails: '$error',
        retryLabel: l10n.retry,
        onRetry: () => ref.invalidate(zoneCommandsProvider(zoneId)),
      ),
      data: (commands) {
        if (commands.isEmpty) {
          return Center(
            child: AppEmptyState(
              icon: Icons.history_toggle_off,
              title: l10n.noCommands,
              description: l10n.noCommandsDesc,
              action: FilledButton.icon(
                onPressed: () {
                  ref.read(irrigationZoneProvider.notifier).state = zoneId;
                  context.goNamed(RouteNames.irrigation);
                },
                icon: const Icon(Icons.water_drop_outlined),
                label: Text(l10n.requestWatering),
              ),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.s12,
            AppSpacing.screenPadding,
            AppSpacing.s32,
          ),
          itemCount: commands.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.s8),
          itemBuilder: (context, index) {
            final command = commands[index];
            return SurfacePanel(
              onTap: () => context.pushNamed(
                RouteNames.commandDetail,
                pathParameters: {'id': command.id},
              ),
              padding: const EdgeInsets.all(AppSpacing.s12),
              child: Row(
                children: [
                  CommandTypeLabel(type: command.type),
                  const Spacer(),
                  CommandStatusBadge(status: command.status, dense: true),
                  const SizedBox(width: AppSpacing.s8),
                  Text(
                    command.requestedAt == null
                        ? l10n.notAvailable
                        : context.relativeTime(command.requestedAt!),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

String _automationLabel(AppLocalizations l10n, IrrigationSettings settings) {
  return settings.autoEnabled ? l10n.autoModeOn : l10n.autoModeOff;
}

List<MoistureChartPoint> _points(List<SensorData> readings) {
  final points = <MoistureChartPoint>[];
  for (final reading in readings) {
    final value = reading.moisturePercent;
    if (value != null) {
      points.add(MoistureChartPoint(time: reading.recordedAt, value: value));
    }
  }
  points.sort((a, b) => a.time.compareTo(b.time));
  return points;
}
