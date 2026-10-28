import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/animations/staggered_entrance.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_error_view.dart';
import '../../../core/widgets/app_loading_view.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/page_header.dart';
import '../../../shared/widgets/sertech_scaffold.dart';
import '../../../shared/widgets/surface_panel.dart';
import '../application/zones_providers.dart';
import 'zone_form_sheet.dart';

class ZonesScreen extends ConsumerWidget {
  const ZonesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final zonesAsync = ref.watch(zonesProvider);

    return SertechScaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => showZoneFormSheet(context),
        tooltip: l10n.createZone,
        child: const Icon(Icons.add),
      ),
      body: zonesAsync.when(
        loading: () => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: kPagePaddingWithHeader,
          children: const [
            _ZonesHeader(),
            SizedBox(height: AppSpacing.s48),
            SizedBox(height: 120, child: AppLoadingView()),
          ],
        ),
        error: (error, _) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: kPagePaddingWithHeader,
          children: [
            const _ZonesHeader(),
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
              physics: const AlwaysScrollableScrollPhysics(),
              padding: kPagePaddingWithHeader,
              children: [
                const _ZonesHeader(),
                const SizedBox(height: AppSpacing.s24),
                AppEmptyState(
                  icon: Icons.grid_view_outlined,
                  title: l10n.noZonesConfigured,
                  description: l10n.noZonesConfiguredDesc,
                  action: FilledButton.icon(
                    onPressed: () => showZoneFormSheet(context),
                    icon: const Icon(Icons.add),
                    label: Text(l10n.createZone),
                  ),
                ),
              ],
            );
          }

          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: kPagePaddingWithHeader,
            children: [
              const _ZonesHeader(),
              const SizedBox(height: AppSpacing.s16),
              for (var i = 0; i < zones.length; i++)
                StaggeredEntrance(
                  index: i,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.s10),
                    child: SurfacePanel(
                      onTap: () => context.goNamed(
                        RouteNames.zoneDetail,
                        pathParameters: {'id': zones[i].id},
                      ),
                      padding: const EdgeInsets.all(AppSpacing.s16),
                      child: Row(
                        children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.primarySoft,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.grass_outlined,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                zones[i].name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                zones[i].isActive ? 'Actif' : 'Inactif',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ZonesHeader extends StatelessWidget {
  const _ZonesHeader();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PageHeader(
      eyebrow: l10n.appName,
      title: l10n.zonesTitle,
    );
  }
}
