import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_error_view.dart';
import '../../../core/widgets/app_loading_view.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/l10n_extensions.dart';
import '../../../shared/widgets/page_header.dart';
import '../../../shared/widgets/sertech_scaffold.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/widgets/surface_panel.dart';
import '../../notifications/application/notifications_providers.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final events = ref.watch(systemEventsProvider);

    final header = PageHeader(
      leading: IconButton(
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      eyebrow: l10n.appName,
      title: l10n.notificationsTitle,
    );

    return SertechScaffold(
      body: events.when(
        loading: () => ListView(
          padding: kPagePaddingWithHeader,
          children: [
            header,
            const SizedBox(height: 120, child: AppLoadingView()),
          ],
        ),
        error: (error, _) => ListView(
          padding: kPagePaddingWithHeader,
          children: [
            header,
            AppErrorView(
              message: l10n.genericErrorTitle,
              technicalDetails: '$error',
              retryLabel: l10n.retry,
              onRetry: () => ref.invalidate(systemEventsProvider),
            ),
          ],
        ),
        data: (items) {
          if (items.isEmpty) {
            return ListView(
              padding: kPagePaddingWithHeader,
              children: [
                header,
                const SizedBox(height: AppSpacing.s24),
                AppEmptyState(
                  icon: Icons.notifications_none,
                  title: l10n.noNotifications,
                  description: l10n.noNotificationsDesc,
                ),
              ],
            );
          }
          return ListView(
            padding: kPagePaddingWithHeader,
            children: [
              header,
              for (final event in items)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.s8),
                  child: _EventTile(event: event),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  final SystemEvent event;

  const _EventTile({required this.event});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final palette = context.statusPalette;

    final (icon, tone, title) = switch (event.type) {
      SystemEventType.staleMeasurement => (
        Icons.sensors_off,
        StatusTone.warning,
        l10n.eventStaleMeasurement(event.zoneName),
      ),
      SystemEventType.noMeasurement => (
        Icons.cloud_off_outlined,
        StatusTone.neutral,
        l10n.eventNoMeasurements(event.zoneName),
      ),
      SystemEventType.pendingCommand => (
        Icons.schedule,
        StatusTone.warning,
        l10n.eventPendingCommand(event.zoneName),
      ),
      SystemEventType.failedCommand => (
        Icons.error_outline,
        StatusTone.error,
        l10n.eventFailedCommand(event.zoneName),
      ),
    };

    final color = switch (tone) {
      StatusTone.success => palette.success,
      StatusTone.warning => palette.warning,
      StatusTone.error => palette.error,
      StatusTone.info => palette.info,
      StatusTone.accent => palette.accent,
      StatusTone.demo => palette.demo,
      StatusTone.neutral => palette.neutral,
    };

    return SurfacePanel(
      padding: const EdgeInsets.all(AppSpacing.s12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        event.zoneName,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (event.at != null) ...[
                      Text(
                        ' · ',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        context.relativeTime(event.at!),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s8),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ],
      ),
    );
  }
}
