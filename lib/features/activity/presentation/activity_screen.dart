import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/animations/staggered_entrance.dart';
import '../../../core/utils/number_formatter.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_error_view.dart';
import '../../../core/widgets/app_loading_view.dart';
import '../../../domain/models/valve_command.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/l10n_extensions.dart';
import '../../../shared/widgets/command_status_badge.dart';
import '../../../shared/widgets/page_header.dart';
import '../../../shared/widgets/sertech_scaffold.dart';
import '../../../shared/widgets/surface_panel.dart';
import '../../irrigation/application/irrigation_providers.dart';
import '../../zones/application/zones_providers.dart';

class ActivityScreen extends ConsumerWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final commandsAsync = ref.watch(recentCommandsProvider);
    final zonesAsync = ref.watch(zonesProvider);

    return SertechScaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(recentCommandsProvider);
          ref.invalidate(zonesProvider);
        },
        child: commandsAsync.when(
          loading: () => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: kPagePaddingWithHeader,
            children: const [
              _ActivityHeader(),
              SizedBox(height: AppSpacing.s48),
              SizedBox(height: 120, child: AppLoadingView()),
            ],
          ),
          error: (error, _) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: kPagePaddingWithHeader,
            children: [
              const _ActivityHeader(),
              const SizedBox(height: AppSpacing.s24),
              AppErrorView(
                message: l10n.genericErrorTitle,
                technicalDetails: '$error',
                retryLabel: l10n.retry,
                onRetry: () => ref.invalidate(recentCommandsProvider),
              ),
            ],
          ),
          data: (commands) {
            if (commands.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: kPagePaddingWithHeader,
                children: [
                  _ActivityHeader(count: 0),
                  const SizedBox(height: AppSpacing.s24),
                  AppEmptyState(
                    icon: Icons.history_toggle_off,
                    title: l10n.noActivity,
                    description: l10n.noActivityDesc,
                  ),
                ],
              );
            }
            final zones = zonesAsync.valueOrNull ?? const [];
            String name(String id) {
              for (final z in zones) {
                if (z.id == id) return z.name;
              }
              return id;
            }

            final executed = commands
                .where((c) => c.status == ValveCommandStatus.executed)
                .length;
            final failed = commands
                .where((c) => c.status == ValveCommandStatus.failed)
                .length;

            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: kPagePaddingWithHeader,
              children: [
                _ActivityHeader(count: commands.length),
                _ActivityOverview(
                  total: commands.length,
                  executed: executed,
                  failed: failed,
                ),
                const SizedBox(height: AppSpacing.s24),
                ..._buildTimeline(context, commands, name),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ActivityHeader extends StatelessWidget {
  final int? count;

  const _ActivityHeader({this.count});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PageHeader(
      eyebrow: l10n.appName,
      title: l10n.activityTitle,
      subtitle: count == null ? null : l10n.measurementCount(count!),
    );
  }
}

class _ActivityOverview extends StatelessWidget {
  final int total;
  final int executed;
  final int failed;

  const _ActivityOverview({
    required this.total,
    required this.executed,
    required this.failed,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SurfacePanel(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s8,
        vertical: AppSpacing.s16,
      ),
      child: Row(
        children: [
          Expanded(
            child: _OverviewStat(
              label: l10n.commands,
              value: NumberFormatter.integer(total),
            ),
          ),
          const _OverviewDivider(),
          Expanded(
            child: _OverviewStat(
              label: l10n.statusExecuted,
              value: NumberFormatter.integer(executed),
              color: context.statusPalette.success,
            ),
          ),
          const _OverviewDivider(),
          Expanded(
            child: _OverviewStat(
              label: l10n.statusFailed,
              value: NumberFormatter.integer(failed),
              color: failed == 0 ? null : context.statusPalette.error,
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewStat extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _OverviewStat({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineMedium?.copyWith(
            letterSpacing: -0.6,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            letterSpacing: 0.6,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _OverviewDivider extends StatelessWidget {
  const _OverviewDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }
}

List<Widget> _buildTimeline(
  BuildContext context,
  List<ValveCommand> commands,
  String Function(String) zoneName,
) {
  final widgets = <Widget>[];
  final localizations = MaterialLocalizations.of(context);
  String? currentDay;

  for (var i = 0; i < commands.length; i++) {
    final command = commands[i];
    final date = command.requestedAt;
    if (date != null) {
      final day = localizations.formatMediumDate(date);
      if (day != currentDay) {
        currentDay = day;
        widgets.add(
          Padding(
            padding: EdgeInsets.only(
              top: widgets.isEmpty ? 0 : AppSpacing.s16,
              bottom: AppSpacing.s8,
            ),
            child: Text(
              day.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                letterSpacing: 1.2,
              ),
            ),
          ),
        );
      }
    }
    widgets.add(
      StaggeredEntrance(
        index: i,
        child: Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.s8),
          child: _TimelineEntry(
            command: command,
            zoneName: zoneName(command.zoneId),
            isLast: i == commands.length - 1,
          ),
        ),
      ),
    );
  }
  return widgets;
}

class _TimelineEntry extends StatelessWidget {
  final ValveCommand command;
  final String zoneName;
  final bool isLast;

  const _TimelineEntry({
    required this.command,
    required this.zoneName,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.statusPalette;
    final color = switch (command.status) {
      ValveCommandStatus.pending => palette.warning,
      ValveCommandStatus.executing => palette.info,
      ValveCommandStatus.executed => palette.success,
      ValveCommandStatus.failed => palette.error,
    };

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.s16),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.35),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.5,
                      margin: const EdgeInsets.only(top: AppSpacing.s4),
                      color: theme.colorScheme.outlineVariant,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s8),
          Expanded(
            child: SurfacePanel(
              onTap: () => context.pushNamed(
                RouteNames.commandDetail,
                pathParameters: {'id': command.id},
              ),
              padding: const EdgeInsets.all(AppSpacing.s12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommandTypeLabel(type: command.type),
                        const SizedBox(height: 2),
                        Text(
                          command.requestedAt == null
                              ? zoneName
                              : '$zoneName · ${context.relativeTime(command.requestedAt!)}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s8),
                  CommandStatusBadge(status: command.status, dense: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
