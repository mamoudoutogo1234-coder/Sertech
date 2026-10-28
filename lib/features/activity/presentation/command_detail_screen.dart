import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_error_view.dart';
import '../../../core/widgets/app_loading_view.dart';
import '../../../domain/models/valve_command.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/l10n_extensions.dart';
import '../../../shared/widgets/brand_hero.dart';
import '../../../shared/widgets/page_header.dart';
import '../../../shared/widgets/sertech_scaffold.dart';
import '../../../shared/widgets/surface_panel.dart';
import '../../zones/application/zones_providers.dart';
import '../application/activity_providers.dart';

class CommandDetailScreen extends ConsumerWidget {
  final String commandId;
  const CommandDetailScreen({super.key, required this.commandId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final cmdAsync = ref.watch(commandByIdProvider(commandId));

    return SertechScaffold(
      body: cmdAsync.when(
        loading: () => ListView(
          padding: kPagePaddingWithHeader,
          children: [
            _header(context, l10n),
            const SizedBox(height: 160, child: AppLoadingView()),
          ],
        ),
        error: (error, _) => ListView(
          padding: kPagePaddingWithHeader,
          children: [
            _header(context, l10n),
            AppErrorView(
              message: l10n.genericErrorTitle,
              technicalDetails: '$error',
              retryLabel: l10n.retry,
              onRetry: () => ref.invalidate(commandByIdProvider(commandId)),
            ),
          ],
        ),
        data: (cmd) {
          if (cmd == null) {
            return ListView(
              padding: kPagePaddingWithHeader,
              children: [
                _header(context, l10n),
                const SizedBox(height: AppSpacing.s24),
                AppEmptyState(icon: Icons.search_off, title: l10n.noData),
              ],
            );
          }
          final zoneAsync = ref.watch(zoneByIdProvider(cmd.zoneId));
          final zoneName = zoneAsync.valueOrNull?.name ?? cmd.zoneId;
          final extension = Theme.of(context).extension<AppThemeExtension>();
          final statusLabel = switch (cmd.status) {
            ValveCommandStatus.pending => l10n.statusPending,
            ValveCommandStatus.executing => l10n.statusExecuting,
            ValveCommandStatus.executed => l10n.statusExecuted,
            ValveCommandStatus.failed => l10n.statusFailed,
          };
          final statusColor = switch (cmd.status) {
            ValveCommandStatus.pending => const Color(0xFFFFD48A),
            ValveCommandStatus.executing => Colors.white,
            ValveCommandStatus.executed =>
              extension?.heroAccent ?? Colors.white,
            ValveCommandStatus.failed => const Color(0xFFFFB4AB),
          };

          return ListView(
            padding: kPagePaddingWithHeader,
            children: [
              _header(context, l10n, subtitle: zoneName),
              BrandHero(
                padding: const EdgeInsets.all(AppSpacing.s20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.commandDetails.toUpperCase(),
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: Colors.white70,
                                  letterSpacing: 1.2,
                                ),
                          ),
                        ),
                        Text(
                          zoneName,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: Colors.white70),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    Text(
                      statusLabel,
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(color: statusColor),
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    Row(
                      children: [
                        Icon(
                          cmd.type == ValveCommandType.open
                              ? Icons.water_drop_outlined
                              : Icons.water_drop,
                          size: 16,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          cmd.type == ValveCommandType.open
                              ? l10n.openValve
                              : l10n.closeValve,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.white70),
                        ),
                        const Spacer(),
                        Text(
                          cmd.requestedAt == null
                              ? l10n.notAvailable
                              : context.relativeTime(cmd.requestedAt!),
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              SurfacePanel(
                padding: const EdgeInsets.all(AppSpacing.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _row(context, l10n.zoneName, zoneName),
                    _row(context, l10n.origin, _origin(l10n, cmd.origin)),
                    _row(context, l10n.reason, cmd.reason ?? l10n.noReason),
                    _kv(
                      context,
                      label: l10n.requestedAt(_fmt(cmd.requestedAt)),
                      value: '',
                    ),
                    _kv(
                      context,
                      label: l10n.executedAt(_fmt(cmd.executedAt)),
                      value: '',
                    ),
                    _kv(
                      context,
                      label: l10n.errorMessage,
                      value: cmd.errorMessage ?? l10n.noError,
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.s12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary
                            .withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusMd,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: AppSpacing.s8),
                          Expanded(
                            child: Text(
                              l10n.executionUnavailableDesc,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _header(
    BuildContext context,
    AppLocalizations l10n, {
    String? subtitle,
  }) {
    return PageHeader(
      leading: IconButton(
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      eyebrow: l10n.appName,
      title: l10n.commandDetails,
      subtitle: subtitle,
    );
  }

  String _origin(AppLocalizations l10n, String? o) {
    if (o == 'mobile_app') return l10n.originMobile;
    if (o == 'automatic') return l10n.originAutomatic;
    if (o == null || o.isEmpty) return l10n.notAvailable;
    return o;
  }

  String _fmt(DateTime? dt) {
    if (dt == null) return '-';
    final l = dt.toLocal();
    return '${l.year}-${l.month.toString().padLeft(2, '0')}-${l.day.toString().padLeft(2, '0')} ${l.hour.toString().padLeft(2, '0')}:${l.minute.toString().padLeft(2, '0')}';
  }

  Widget _row(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 2),
          Text(value, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }

  Widget _kv(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    if (value.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
        child: Text(label, style: theme.textTheme.bodyLarge),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.split(' ').first.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 2),
          Text(value, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}
