import 'package:flutter/material.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/page_header.dart';
import '../../../shared/widgets/sertech_scaffold.dart';
import '../../../shared/widgets/surface_panel.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
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
            title: l10n.cameraTitle,
            subtitle: l10n.cameraDesc,
          ),
          SurfacePanel(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s20,
              vertical: AppSpacing.s32,
            ),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.videocam_off_outlined,
                    size: 26,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.s16),
                Text(
                  l10n.cameraTitle,
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.s8),
                Text(
                  l10n.cameraOfflineDesc,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
