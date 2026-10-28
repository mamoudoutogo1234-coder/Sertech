import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/animations/staggered_entrance.dart';
import '../../../core/utils/freshness_utils.dart';
import '../../../core/utils/number_formatter.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_error_view.dart';
import '../../../core/widgets/app_loading_view.dart';
import '../../../domain/models/valve_command.dart';
import '../../../domain/models/zone.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/l10n_extensions.dart';
import '../../../shared/widgets/command_status_badge.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/sertech_scaffold.dart';
import '../../../shared/widgets/surface_panel.dart';
import '../../measurements/application/measurements_providers.dart';
import '../../notifications/application/notifications_providers.dart';
import '../application/dashboard_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final snapshot = ref.watch(dashboardSnapshotProvider);

    return SertechScaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(dashboardSnapshotProvider);
          ref.invalidate(historyProvider);
          await ref.read(dashboardSnapshotProvider.future);
        },
        child: snapshot.when(
          loading: () => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: kPagePaddingWithHeader,
            children: const [
              _DashboardHeader(),
              SizedBox(height: 100),
              SizedBox(height: 120, child: AppLoadingView()),
            ],
          ),
          error: (error, stackTrace) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: kPagePaddingWithHeader,
            children: [
              const _DashboardHeader(),
              const SizedBox(height: 24),
              AppErrorView(
                message: l10n.genericErrorTitle,
                technicalDetails: '$error',
                retryLabel: l10n.retry,
                onRetry: () => ref.invalidate(dashboardSnapshotProvider),
              ),
            ],
          ),
          data: (data) => _DashboardBody(snapshot: data),
        ),
      ),
    );
  }
}

class _DashboardHeader extends ConsumerWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final notificationCount = ref.watch(systemEventCountProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.appName,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.dashboardTitle,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.8,
                  ),
                ),
              ],
            ),
          ),
          _HeaderAction(
            tooltip: l10n.notifications,
            onPressed: () => context.pushNamed(RouteNames.notifications),
            icon: Badge.count(
              count: notificationCount,
              isLabelVisible: notificationCount > 0,
              child: const Icon(Icons.notifications_none_rounded),
            ),
          ),
          const SizedBox(width: 8),
          _HeaderAction(
            tooltip: l10n.settings,
            onPressed: () => context.pushNamed(RouteNames.settings),
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({
    required this.tooltip,
    required this.onPressed,
    required this.icon,
  });

  final String tooltip;
  final VoidCallback onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: theme.colorScheme.surfaceContainerLow,
        foregroundColor: theme.colorScheme.onSurface,
        side: BorderSide(color: theme.colorScheme.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      icon: icon,
    );
  }
}

class _DashboardBody extends ConsumerWidget {
  const _DashboardBody({required this.snapshot});

  final dynamic snapshot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final zones = snapshot.zones as List<Zone>;

    if (zones.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: kPagePaddingWithHeader,
        children: [
          const _DashboardHeader(),
          const SizedBox(height: 32),
          AppEmptyState(
            icon: Icons.grass_rounded,
            title: l10n.noInstallationConfigured,
            description: l10n.noInstallationConfiguredDesc,
            action: FilledButton.icon(
              onPressed: () => context.goNamed(RouteNames.zones),
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.createZone),
            ),
          ),
        ],
      );
    }

    final selectedZoneId = ref.watch(historyZoneProvider);
    Zone selectedZone =
        zones.cast<Zone?>().firstWhere(
          (zone) => zone?.id == selectedZoneId,
          orElse: () => snapshot.freshestZone as Zone? ?? zones.first,
        ) ??
        zones.first;
    if (zones.isNotEmpty &&
        !zones.any((zone) => zone.id == selectedZone.id)) {
      selectedZone = zones.first;
    }

    final executingCommands = snapshot.recentCommands
        .where((command) => command.status == ValveCommandStatus.executing)
        .length;

    final activeZones = zones.where((zone) => zone.isActive).length;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: kPagePaddingWithHeader,
      children: [
        const _DashboardHeader(),
        const SizedBox(height: 24),

        // Primary information: soil moisture and measurement freshness.
        SizedBox(
          height: 210,
          child: PageView.builder(
            itemCount: zones.length,
            onPageChanged: (index) {
              ref.read(historyZoneProvider.notifier).state = zones[index].id;
            },
            itemBuilder: (context, index) {
              final zone = zones[index];
              final measurement = snapshot.measurementFor(zone.id);
              final freshness = FreshnessUtils.of(measurement);
              final moisture = measurement?.moisturePercent;
              return Padding(
                padding: EdgeInsets.only(
                  right: index == zones.length - 1 ? 0 : 12,
                ),
                child: SizedBox(
                  height: 210,
                  child: _MoistureOverview(
                    zoneName: zone.name,
                    moisture: moisture,
                    freshnessLabel: freshness == ReadingFreshness.fresh
                        ? l10n.dataFresh
                        : freshness == ReadingFreshness.expired
                        ? l10n.dataStale
                        : l10n.noMeasurementsYet,
                    isFresh: freshness == ReadingFreshness.fresh,
                    recordedAt: measurement?.recordedAt == null
                        ? null
                        : context.relativeTime(measurement!.recordedAt),
                    onIrrigationTap: () => context.goNamed(RouteNames.irrigation),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 20),

        // Compact operational summary instead of three redundant cards.
        Row(
          children: [
            Expanded(
              child: _SummaryTile(
                icon: Icons.grid_view_rounded,
                label: l10n.zones,
                value: '${zones.length}',
                detail: '$activeZones actives',
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryTile(
                icon: Icons.water_drop_outlined,
                label: l10n.irrigationTitle,
                value: '$executingCommands',
                detail: 'Commandes en cours',
                color: AppColors.water,
              ),
            ),
          ],
        ),

        const SizedBox(height: 28),

        SectionHeader(
          title: l10n.zones,
          actionLabel: l10n.viewAll,
          onAction: () => context.goNamed(RouteNames.zones),
        ),
        const SizedBox(height: 12),

        for (var i = 0; i < zones.take(3).length; i++)
          StaggeredEntrance(
            index: i,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ZoneTile(
                zone: zones.take(3).elementAt(i),
                moisture: snapshot
                    .measurementFor(zones.take(3).elementAt(i).id)
                    ?.moisturePercent,
                onTap: () => context.goNamed(
                  RouteNames.zoneDetail,
                  pathParameters: {'id': zones.take(3).elementAt(i).id},
                ),
              ),
            ),
          ),

        const SizedBox(height: 20),

        SectionHeader(
          title: l10n.recentCommands,
          actionLabel: l10n.viewAll,
          onAction: () => context.goNamed(RouteNames.activity),
        ),
        const SizedBox(height: 12),

        if (snapshot.recentCommands.isEmpty)
          SurfacePanel(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  Icons.history_rounded,
                  size: 28,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    l10n.noRecentActivity,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          for (var i = 0; i < snapshot.recentCommands.take(3).length; i++)
            StaggeredEntrance(
              index: i,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _CommandTile(
                  command: snapshot.recentCommands.take(3).elementAt(i),
                  zoneName: _zoneName(
                    zones,
                    snapshot.recentCommands.take(3).elementAt(i).zoneId,
                  ),
                  onTap: () => context.pushNamed(
                    RouteNames.commandDetail,
                    pathParameters: {
                      'id': snapshot.recentCommands.take(3).elementAt(i).id
                    },
                  ),
                ),
              ),
            ),

        const SizedBox(height: 20),
      ],
    );
  }
}

class _MoistureOverview extends StatelessWidget {
  const _MoistureOverview({
    required this.zoneName,
    required this.moisture,
    required this.freshnessLabel,
    required this.isFresh,
    required this.recordedAt,
    required this.onIrrigationTap,
  });

  final String zoneName;
  final double? moisture;
  final String freshnessLabel;
  final bool isFresh;
  final String? recordedAt;
  final VoidCallback onIrrigationTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final hasValue = moisture != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: colors.primary.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: colors.onPrimaryContainer.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.grass_rounded,
                  color: colors.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      zoneName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Humidité du sol',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onPrimaryContainer.withValues(
                          alpha: 0.72,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colors.onPrimaryContainer.withValues(alpha: 0.18),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: onIrrigationTap,
                  icon: Icon(
                    Icons.water_drop_outlined,
                    color: colors.onPrimaryContainer,
                  ),
                  tooltip: 'Irrigation',
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  hasValue ? NumberFormatter.percentValue(moisture!) : '—',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.2,
                    height: 1,
                    color: colors.onPrimaryContainer,
                  ),
                ),
              ),
              if (hasValue)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    '%',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: colors.onPrimaryContainer.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          if (hasValue)
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: LinearProgressIndicator(
                value: moisture!.clamp(0, 100) / 100,
                minHeight: 6,
                backgroundColor: colors.onPrimaryContainer.withValues(
                  alpha: 0.12,
                ),
                valueColor: AlwaysStoppedAnimation<Color>(
                  colors.onPrimaryContainer,
                ),
              ),
            ),

          const SizedBox(height: 12),

          Row(
            children: [
              Icon(
                isFresh ? Icons.check_circle_outline : Icons.info_outline,
                size: 16,
                color: colors.onPrimaryContainer.withValues(alpha: 0.85),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  freshnessLabel,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colors.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          if (recordedAt != null) ...[
            const SizedBox(height: 4),
            Text(
              'Dernière mesure : $recordedAt',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.onPrimaryContainer.withValues(alpha: 0.72),
              ),
            ),
          ],

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.detail,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final String detail;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SurfacePanel(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 23),
          const SizedBox(height: 15),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            detail,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ZoneTile extends StatelessWidget {
  const _ZoneTile({
    required this.zone,
    required this.moisture,
    required this.onTap,
  });

  final Zone zone;
  final double? moisture;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SurfacePanel(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(Icons.grass_rounded, color: colors.onPrimaryContainer),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  zone.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(
                      zone.isActive
                          ? Icons.check_circle_outline
                          : Icons.pause_circle_outline,
                      size: 15,
                      color: zone.isActive
                          ? colors.primary
                          : colors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        zone.isActive ? 'Zone active' : 'Zone inactive',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (moisture != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  NumberFormatter.percentValue(moisture!),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Humidité',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            )
          else
            Icon(Icons.chevron_right_rounded, color: colors.onSurfaceVariant),
        ],
      ),
    );
  }
}

class _CommandTile extends StatelessWidget {
  const _CommandTile({
    required this.command,
    required this.zoneName,
    required this.onTap,
  });

  final ValveCommand command;
  final String zoneName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isOpenCommand = command.type == ValveCommandType.open;

    final timeLabel = command.requestedAt == null
        ? zoneName
        : '$zoneName · ${context.relativeTime(command.requestedAt!)}';

    return SurfacePanel(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isOpenCommand
                  ? colors.primaryContainer
                  : colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              isOpenCommand
                  ? Icons.water_drop_outlined
                  : Icons.water_drop_rounded,
              color: isOpenCommand
                  ? colors.onPrimaryContainer
                  : colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isOpenCommand
                      ? 'Ouverture de la vanne'
                      : 'Fermeture de la vanne',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  timeLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: CommandStatusBadge(
                    status: command.status,
                    dense: true,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Icon(Icons.chevron_right_rounded, color: colors.onSurfaceVariant),
        ],
      ),
    );
  }
}

String _zoneName(List<Zone> zones, String zoneId) {
  for (final zone in zones) {
    if (zone.id == zoneId) return zone.name;
  }
  return zoneId;
}
