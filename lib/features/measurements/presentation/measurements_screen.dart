import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/utils/number_formatter.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_error_view.dart';
import '../../../core/widgets/app_loading_view.dart';
import '../../../domain/models/sensor_data.dart';
import '../../../domain/models/zone.dart';
import '../../../domain/repositories/sensor_data_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/metric_tile.dart';
import '../../../shared/widgets/moisture_chart.dart';
import '../../../shared/widgets/page_header.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/sertech_scaffold.dart';
import '../../../shared/widgets/surface_panel.dart';
import '../../irrigation/application/irrigation_providers.dart';
import '../application/measurements_providers.dart';
import '../../zones/application/zones_providers.dart';

class MeasurementsScreen extends ConsumerWidget {
  const MeasurementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final zonesAsync = ref.watch(zonesProvider);
    final selectedZoneId = ref.watch(historyZoneProvider);
    final period = ref.watch(historyPeriodProvider);

    return SertechScaffold(
      body: zonesAsync.when(
        loading: () => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: kPagePaddingWithHeader,
          children: const [
            _MeasurementsHeader(),
            SizedBox(height: AppSpacing.s48),
            SizedBox(height: 120, child: AppLoadingView()),
          ],
        ),
        error: (error, _) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: kPagePaddingWithHeader,
          children: [
            const _MeasurementsHeader(),
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
                const _MeasurementsHeader(),
                const SizedBox(height: AppSpacing.s24),
                AppEmptyState(
                  icon: Icons.show_chart,
                  title: l10n.noZonesConfigured,
                  description: l10n.noZonesConfiguredDesc,
                  action: FilledButton.icon(
                    onPressed: () => context.goNamed(RouteNames.zones),
                    icon: const Icon(Icons.add),
                    label: Text(l10n.createZone),
                  ),
                ),
              ],
            );
          }

          final zoneId =
              selectedZoneId ??
              zones
                  .firstWhere(
                    (zone) => zone.isActive,
                    orElse: () => zones.first,
                  )
                  .id;
          final historyAsync = ref.watch(
            historyProvider((zoneId: zoneId, period: period)),
          );

          return ListView(
            padding: kPagePaddingWithHeader,
            children: [
              const _MeasurementsHeader(),
              _ZoneSelector(
                zones: zones,
                selectedZoneId: zoneId,
                onChanged: (value) {
                  ref.read(historyZoneProvider.notifier).state = value;
                },
              ),
              const SizedBox(height: AppSpacing.s12),
              _PeriodSelector(period: period),
              const SizedBox(height: AppSpacing.s12),
              historyAsync.when(
                loading: () => const SurfacePanel(
                  child: SizedBox(height: 200, child: AppLoadingView()),
                ),
                error: (error, _) => SurfacePanel(
                  child: AppErrorView(
                    message: l10n.genericErrorTitle,
                    technicalDetails: '$error',
                    retryLabel: l10n.retry,
                    onRetry: () => ref.invalidate(historyProvider),
                  ),
                ),
                data: (readings) {
                  final points = _chartPoints(readings);
                  final values = points.map((p) => p.value).toList();
                  final stats = _Stats.fromValues(values);
                  final count = readings.length;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SurfacePanel(
                        padding: const EdgeInsets.all(AppSpacing.s16),
                        child: MoistureChart(
                          points: points,
                          minY: 0,
                          maxY: 100,
                          unitLabel: '%',
                          emptyLabel: l10n.chartEmptyLabel,
                        ),
                      ),
                      SectionHeader(title: l10n.systemStatus),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: MetricTile(
                              label: l10n.readings,
                              value: NumberFormatter.integer(count),
                              icon: Icons.timeline,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.s12),
                          Expanded(
                            child: MetricTile(
                              label: l10n.average,
                              value: stats.average == null
                                  ? l10n.noData
                                  : NumberFormatter.percent(stats.average!),
                              icon: Icons.show_chart,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.s12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: MetricTile(
                              label: l10n.minimum,
                              value: stats.min == null
                                  ? l10n.noData
                                  : NumberFormatter.percent(stats.min!),
                              icon: Icons.south,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.s12),
                          Expanded(
                            child: MetricTile(
                              label: l10n.maximum,
                              value: stats.max == null
                                  ? l10n.noData
                                  : NumberFormatter.percent(stats.max!),
                              icon: Icons.north,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.s20),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                ref
                                        .read(irrigationZoneProvider.notifier)
                                        .state =
                                    zoneId;
                                context.goNamed(RouteNames.irrigation);
                              },
                              icon: const Icon(Icons.tune),
                              label: Text(l10n.configureIrrigation),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.s12),
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () => context.goNamed(
                                RouteNames.zoneDetail,
                                pathParameters: {'id': zoneId},
                              ),
                              icon: const Icon(Icons.grid_view_outlined),
                              label: Text(l10n.zoneDetails),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MeasurementsHeader extends StatelessWidget {
  const _MeasurementsHeader();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PageHeader(
      eyebrow: l10n.appName,
      title: l10n.historyTitle,
      subtitle: l10n.selectZoneHint,
    );
  }
}

class _ZoneSelector extends StatelessWidget {
  final List<Zone> zones;
  final String selectedZoneId;
  final ValueChanged<String> onChanged;

  const _ZoneSelector({
    required this.zones,
    required this.selectedZoneId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SurfacePanel(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s12,
      ),
      child: Row(
        children: [
          const Icon(Icons.grass_outlined),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.zoneName,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedZoneId,
                    isDense: true,
                    isExpanded: true,
                    items: [
                      for (final zone in zones)
                        DropdownMenuItem(
                          value: zone.id,
                          child: Text(zone.name),
                        ),
                    ],
                    onChanged: (value) {
                      if (value != null) onChanged(value);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodSelector extends ConsumerWidget {
  final HistoryPeriod period;

  const _PeriodSelector({required this.period});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return SegmentedButton<HistoryPeriod>(
      segments: [
        ButtonSegment(value: HistoryPeriod.day24h, label: Text(l10n.period24h)),
        ButtonSegment(value: HistoryPeriod.days7, label: Text(l10n.period7d)),
        ButtonSegment(value: HistoryPeriod.days30, label: Text(l10n.period30d)),
      ],
      selected: {period},
      onSelectionChanged: (selection) {
        ref.read(historyPeriodProvider.notifier).state = selection.first;
      },
    );
  }
}

class _Stats {
  final double? min;
  final double? max;
  final double? average;

  const _Stats({this.min, this.max, this.average});

  factory _Stats.fromValues(List<double> values) {
    if (values.isEmpty) return const _Stats();
    var min = values.first;
    var max = values.first;
    var sum = 0.0;
    for (final value in values) {
      if (value < min) min = value;
      if (value > max) max = value;
      sum += value;
    }
    return _Stats(min: min, max: max, average: sum / values.length);
  }
}

List<MoistureChartPoint> _chartPoints(List<SensorData> readings) {
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
