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
import '../../../shared/widgets/surface_panel.dart';

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
          ),
          const SizedBox(height: AppSpacing.s16),
          Text(
            l10n.appearance,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.s10),
          SurfacePanel(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.brightness_6_outlined,
                  title: l10n.theme,
                  subtitle: _themeLabel(themeMode, l10n),
                  onTap: () => _showThemePicker(context, ref, l10n, themeMode),
                ),
                Divider(
                  height: 1,
                  indent: 56,
                  color: theme.colorScheme.outlineVariant,
                ),
                _SettingsTile(
                  icon: Icons.translate,
                  title: l10n.language,
                  subtitle: _languageLabel(locale, l10n),
                  onTap: () => _showLanguagePicker(context, ref, l10n, locale),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s20),
          Text(
            l10n.dataSource,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.s10),
          SurfacePanel(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.s16,
                    AppSpacing.s14,
                    AppSpacing.s16,
                    AppSpacing.s10,
                  ),
                  child: Text(
                    l10n.dataModeDesc,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.s16,
                        ),
                      ),
                      RadioListTile<DataMode>(
                        value: DataMode.inMemory,
                        title: Text(l10n.dataModeInMemory),
                        subtitle: Text(l10n.demoScenarioSubtitle),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.s16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (dataMode == DataMode.inMemory) ...[
            const SizedBox(height: AppSpacing.s20),
            Text(
              l10n.demoScenario,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.s10),
            SurfacePanel(
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
          ],
          const SizedBox(height: AppSpacing.s20),
          Text(
            l10n.account,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.s10),
          SurfacePanel(
            padding: EdgeInsets.zero,
            child: profileAsync.when(
              loading: () => const _SettingsTile(
                icon: Icons.person_outline,
                title: '...',
              ),
              error: (_, _) => _SettingsTile(
                icon: Icons.person_outline,
                title: l10n.profileUnavailable,
              ),
              data: (Profile? p) {
                if (p == null) {
                  return _SettingsTile(
                    icon: Icons.person_outline,
                    title: l10n.notLoggedIn,
                    subtitle: dataMode == DataMode.supabase
                        ? l10n.tapToSignIn
                        : l10n.localMode,
                  );
                }
                return Column(
                  children: [
                    _SettingsTile(
                      icon: Icons.person,
                      title: p.displayName ?? p.id,
                      subtitle: dataMode == DataMode.supabase
                          ? l10n.signedInAs(p.displayName ?? p.id)
                          : l10n.localMode,
                    ),
                    if (dataMode == DataMode.supabase) ...[
                      Divider(
                        height: 1,
                        indent: 56,
                        color: theme.colorScheme.outlineVariant,
                      ),
                      _SettingsTile(
                        icon: Icons.logout,
                        iconColor: theme.colorScheme.error,
                        title: l10n.signOut,
                        onTap: () => ref.read(authControllerProvider).signOut(),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.s20),
          Text(
            l10n.systemStatus,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.s10),
          SurfacePanel(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Consumer(
                  builder: (context, ref, _) {
                    final isOn =
                        ref.watch(isOnlineProvider).valueOrNull == true;
                    return _SettingsTile(
                      icon: isOn ? Icons.wifi : Icons.wifi_off,
                      iconColor: isOn
                          ? context.statusPalette.success
                          : context.statusPalette.warning,
                      title: l10n.networkStatus,
                      subtitle: isOn ? l10n.online : l10n.offline,
                      trailing: StatusBadge(
                        label: isOn ? l10n.online : l10n.offline,
                        tone: isOn ? StatusTone.success : StatusTone.warning,
                        dense: true,
                      ),
                    );
                  },
                ),
                Divider(
                  height: 1,
                  indent: 56,
                  color: theme.colorScheme.outlineVariant,
                ),
                _SettingsTile(
                  icon: Icons.memory_outlined,
                  title: l10n.rpiStatus,
                  subtitle: l10n.rpiUnknownDesc,
                  trailing: StatusBadge(
                    label: l10n.rpiUnknown,
                    tone: StatusTone.neutral,
                    dense: true,
                  ),
                ),
                Divider(
                  height: 1,
                  indent: 56,
                  color: theme.colorScheme.outlineVariant,
                ),
                _SettingsTile(
                  icon: Icons.cloud_outlined,
                  title: l10n.supabaseStatus,
                  subtitle: supabaseOk ? l10n.configured : l10n.notConfiguredLocalOnly,
                  trailing: StatusBadge(
                    label: supabaseOk ? l10n.configured : l10n.notConfigured,
                    tone: supabaseOk ? StatusTone.success : StatusTone.neutral,
                    dense: true,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s20),
          Text(
            l10n.aboutApp,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.s10),
          SurfacePanel(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.eco_outlined,
                  title: l10n.appName,
                  subtitle: l10n.sertechDesc,
                ),
                Divider(
                  height: 1,
                  indent: 56,
                  color: theme.colorScheme.outlineVariant,
                ),
                _SettingsTile(
                  icon: Icons.help_outline,
                  title: 'FAQ',
                  subtitle: 'Questions fréquentes',
                  onTap: () => _showFaq(context, l10n),
                ),
                Divider(
                  height: 1,
                  indent: 56,
                  color: theme.colorScheme.outlineVariant,
                ),
                _SettingsTile(
                  icon: Icons.description_outlined,
                  title: "Conditions d'utilisation",
                  subtitle: "Mentions et conditions",
                  onTap: () => _showTerms(context, l10n),
                ),
              ],
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

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = iconColor ?? theme.colorScheme.onSurfaceVariant;
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
      trailing: trailing ??
          (onTap == null ? null : const Icon(Icons.chevron_right)),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s4,
      ),
    );
  }
}

Future<void> _showFaq(BuildContext context, AppLocalizations l10n) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) {
      final theme = Theme.of(sheetContext);
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'FAQ',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(sheetContext),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s12),
              const _FaqItem(
                question: "Comment fonctionne le mode démo ?",
                answer:
                    "Le mode démo utilise des données locales pour tester l'application sans connexion Supabase.",
              ),
              const _FaqItem(
                question: "Comment basculer entre Manuel et Automatique ?",
                answer:
                    "Sur l'écran Irrigation, utilisez le sélecteur pour choisir le mode souhaité pour chaque zone.",
              ),
              const _FaqItem(
                question: "Pourquoi certaines mesures sont périmées ?",
                answer:
                    "Si aucune nouvelle mesure n'est reçue depuis plus de 30 minutes, l'état devient périmé.",
              ),
              const SizedBox(height: AppSpacing.s12),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> _showTerms(BuildContext context, AppLocalizations l10n) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) {
      final theme = Theme.of(sheetContext);
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Conditions d'utilisation",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(sheetContext),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s12),
              Text(
                "Sertech est une application de supervision et de pilotage de l'irrigation agricole. L'utilisation de l'application se fait sous votre propre responsabilité.",
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.s12),
              Text(
                "Les commandes de vanne sont envoyées via le système configuré et doivent toujours être vérifiées sur le terrain.",
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.s16),
            ],
          ),
        ),
      );
    },
  );
}

class _FaqItem extends StatelessWidget {
  final String question;
  final String answer;
  const _FaqItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            answer,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
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
