import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/l10n/locale_notifier.dart';
import '../../../app/providers.dart';
import '../../../data/demo/demo_scenario.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/theme_mode_notifier.dart';
import '../../../app/theme/theme_preferences.dart' as tp;
import '../../../domain/models/profile.dart';
import '../../../features/auth/application/auth_providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/page_header.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/sertech_scaffold.dart';
import '../../../shared/widgets/status_badge.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final dataMode = ref.watch(effectiveDataModeProvider);
    final supabaseReady = ref.watch(supabaseReadyProvider);
    final supabaseOk = ref.watch(supabaseConfiguredProvider);
    final scenario = ref.watch(demoScenarioProvider);
    final profileAsync = ref.watch(currentProfileProvider);
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);

    return SertechScaffold(
      body: ListView(
        padding: kPagePaddingWithHeader,
        children: [
          PageHeader(
            leading: IconButton(
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            eyebrow: l10n.appName,
            title: l10n.settingsTitle,
            subtitle: l10n.sertechDesc,
          ),
          SectionHeader(title: l10n.appearance),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.brightness_6_outlined),
                  title: Text(l10n.theme),
                  subtitle: Text(_themeLabel(themeMode, l10n)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showThemePicker(context, ref, l10n, themeMode),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.translate),
                  title: Text(l10n.language),
                  subtitle: Text(_languageLabel(locale, l10n)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showLanguagePicker(context, ref, l10n, locale),
                ),
              ],
            ),
          ),
          SectionHeader(title: l10n.dataSource),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.s16,
                    AppSpacing.s12,
                    AppSpacing.s16,
                    AppSpacing.s8,
                  ),
                  child: Text(
                    l10n.dataModeDesc,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                RadioGroup<DataMode>(
                  groupValue: dataMode,
                  onChanged: (v) {
                    if (v == null) return;
                    if (v == DataMode.supabase && !supabaseReady) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.notConfiguredLocalOnly)),
                      );
                      return;
                    }
                    ref.read(dataModeProvider.notifier).state = v;
                  },
                  child: Column(
                    children: [
                      RadioListTile<DataMode>(
                        value: DataMode.supabase,
                        enabled: supabaseReady,
                        title: Text(l10n.dataModeSupabase),
                        subtitle: Text(
                          supabaseReady
                              ? l10n.configured
                              : l10n.notConfiguredLocalOnly,
                        ),
                      ),
                      RadioListTile<DataMode>(
                        value: DataMode.inMemory,
                        title: Text(l10n.dataModeInMemory),
                        subtitle: Text(l10n.demoScenarioSubtitle),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (dataMode == DataMode.inMemory) ...[
            SectionHeader(title: l10n.demoScenario),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.currentScenario,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    Wrap(
                      spacing: AppSpacing.s8,
                      runSpacing: AppSpacing.s8,
                      children: [
                        _Chip(
                          label: l10n.scenarioNominal,
                          selected: scenario == DemoScenario.nominal,
                          onTap: () =>
                              ref.read(demoScenarioProvider.notifier).state =
                                  DemoScenario.nominal,
                        ),
                        _Chip(
                          label: l10n.scenarioStaleSensor,
                          selected: scenario == DemoScenario.staleSensor,
                          onTap: () =>
                              ref.read(demoScenarioProvider.notifier).state =
                                  DemoScenario.staleSensor,
                        ),
                        _Chip(
                          label: l10n.scenarioNoMeasurements,
                          selected: scenario == DemoScenario.noMeasurements,
                          onTap: () =>
                              ref.read(demoScenarioProvider.notifier).state =
                                  DemoScenario.noMeasurements,
                        ),
                        _Chip(
                          label: l10n.scenarioPendingCommands,
                          selected: scenario == DemoScenario.pendingCommands,
                          onTap: () =>
                              ref.read(demoScenarioProvider.notifier).state =
                                  DemoScenario.pendingCommands,
                        ),
                        _Chip(
                          label: l10n.scenarioFailedCommand,
                          selected: scenario == DemoScenario.failedCommand,
                          onTap: () =>
                              ref.read(demoScenarioProvider.notifier).state =
                                  DemoScenario.failedCommand,
                        ),
                        _Chip(
                          label: l10n.scenarioEmptyInstallation,
                          selected: scenario == DemoScenario.emptyInstallation,
                          onTap: () =>
                              ref.read(demoScenarioProvider.notifier).state =
                                  DemoScenario.emptyInstallation,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    Text(
                      l10n.demoScenarioDesc,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          SectionHeader(title: l10n.account),
          Card(
            child: profileAsync.when(
              loading: () => const ListTile(
                leading: Icon(Icons.person_outline),
                title: Text('...'),
              ),
              error: (_, _) => ListTile(
                leading: const Icon(Icons.person_outline),
                title: Text(l10n.profileUnavailable),
              ),
              data: (Profile? p) {
                if (p == null) {
                  return ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: Text(l10n.notLoggedIn),
                    subtitle: Text(
                      dataMode == DataMode.supabase
                          ? l10n.tapToSignIn
                          : l10n.localMode,
                    ),
                  );
                }
                return Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(p.displayName ?? p.id),
                      subtitle: Text(
                        dataMode == DataMode.supabase
                            ? l10n.signedInAs(p.displayName ?? p.id)
                            : l10n.localMode,
                      ),
                    ),
                    if (dataMode == DataMode.supabase) ...[
                      const Divider(height: 1),
                      ListTile(
                        leading: Icon(
                          Icons.logout,
                          color: theme.colorScheme.error,
                        ),
                        title: Text(l10n.signOut),
                        onTap: () => ref.read(authControllerProvider).signOut(),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
          SectionHeader(title: l10n.systemStatus),
          Card(
            child: Column(
              children: [
                Consumer(
                  builder: (context, ref, _) {
                    final isOn =
                        ref.watch(isOnlineProvider).valueOrNull == true;
                    return ListTile(
                      leading: Icon(
                        isOn ? Icons.wifi : Icons.wifi_off,
                        color: isOn
                            ? context.statusPalette.success
                            : context.statusPalette.warning,
                      ),
                      title: Text(l10n.networkStatus),
                      subtitle: Text(isOn ? l10n.online : l10n.offline),
                      trailing: StatusBadge(
                        label: isOn ? l10n.online : l10n.offline,
                        tone: isOn ? StatusTone.success : StatusTone.warning,
                        dense: true,
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.memory_outlined),
                  title: Text(l10n.rpiStatus),
                  subtitle: Text(l10n.rpiUnknownDesc),
                  trailing: StatusBadge(
                    label: l10n.rpiUnknown,
                    tone: StatusTone.neutral,
                    dense: true,
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.cloud_outlined),
                  title: Text(l10n.supabaseStatus),
                  subtitle: Text(
                    supabaseOk ? l10n.configured : l10n.notConfiguredLocalOnly,
                  ),
                  trailing: StatusBadge(
                    label: supabaseOk ? l10n.configured : l10n.notConfigured,
                    tone: supabaseOk ? StatusTone.success : StatusTone.neutral,
                    dense: true,
                  ),
                ),
              ],
            ),
          ),
          SectionHeader(title: l10n.aboutApp),
          Card(
            child: ListTile(
              leading: const Icon(Icons.eco_outlined),
              title: Text(l10n.appName),
              subtitle: Text(l10n.sertechDesc),
            ),
          ),
        ],
      ),
    );
  }
}

String _languageLabel(Locale locale, AppLocalizations l10n) {
  return switch (locale.languageCode) {
    'en' => l10n.languageEn,
    'bm' => l10n.languageBm,
    _ => l10n.languageFr,
  };
}

String _themeLabel(tp.ThemeMode mode, AppLocalizations l10n) {
  return switch (mode) {
    tp.ThemeMode.light => l10n.themeLight,
    tp.ThemeMode.dark => l10n.themeDark,
    tp.ThemeMode.system => l10n.themeSystem,
  };
}

Future<void> _showLanguagePicker(
  BuildContext context,
  WidgetRef ref,
  AppLocalizations l10n,
  Locale current,
) async {
  final selected = await showModalBottomSheet<Locale>(
    context: context,
    builder: (sheetContext) {
      return SafeArea(
        child: RadioGroup<Locale>(
          groupValue: current,
          onChanged: (value) {
            if (value != null) Navigator.of(sheetContext).pop(value);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  l10n.language,
                  style: Theme.of(sheetContext).textTheme.titleMedium,
                ),
              ),
              RadioListTile<Locale>(
                value: const Locale('fr'),
                title: Text(l10n.languageFr),
              ),
              RadioListTile<Locale>(
                value: const Locale('en'),
                title: Text(l10n.languageEn),
              ),
              RadioListTile<Locale>(
                value: const Locale('bm'),
                title: Text(l10n.languageBm),
              ),
              const SizedBox(height: AppSpacing.s8),
            ],
          ),
        ),
      );
    },
  );
  if (selected == null) return;
  await ref.read(localeProvider.notifier).setLocale(selected);
}

Future<void> _showThemePicker(
  BuildContext context,
  WidgetRef ref,
  AppLocalizations l10n,
  tp.ThemeMode current,
) async {
  final selected = await showModalBottomSheet<tp.ThemeMode>(
    context: context,
    builder: (sheetContext) {
      return SafeArea(
        child: RadioGroup<tp.ThemeMode>(
          groupValue: current,
          onChanged: (value) {
            if (value != null) Navigator.of(sheetContext).pop(value);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  l10n.theme,
                  style: Theme.of(sheetContext).textTheme.titleMedium,
                ),
              ),
              RadioListTile<tp.ThemeMode>(
                value: tp.ThemeMode.system,
                title: Text(l10n.themeSystem),
              ),
              RadioListTile<tp.ThemeMode>(
                value: tp.ThemeMode.light,
                title: Text(l10n.themeLight),
              ),
              RadioListTile<tp.ThemeMode>(
                value: tp.ThemeMode.dark,
                title: Text(l10n.themeDark),
              ),
              const SizedBox(height: AppSpacing.s8),
            ],
          ),
        ),
      );
    },
  );
  if (selected == null) return;
  await ref.read(themeModeProvider.notifier).setThemeMode(selected);
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: theme.colorScheme.primary.withValues(alpha: 0.14),
      labelStyle: TextStyle(
        color: selected
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurface,
      ),
    );
  }
}
