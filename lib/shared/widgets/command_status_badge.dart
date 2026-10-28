import 'package:flutter/material.dart';

import '../../app/theme/app_motion.dart';
import '../../core/animations/reduced_motion.dart';
import '../../domain/models/valve_command.dart';
import '../../l10n/app_localizations.dart';
import 'status_badge.dart';

/// Badge de statut d'une commande de vanne.
class CommandStatusBadge extends StatelessWidget {
  final ValveCommandStatus status;
  final bool dense;

  const CommandStatusBadge({
    super.key,
    required this.status,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final (label, tone, icon) = switch (status) {
      ValveCommandStatus.pending => (
        l10n.statusPending,
        StatusTone.warning,
        Icons.schedule,
      ),
      ValveCommandStatus.executing => (
        l10n.statusExecuting,
        StatusTone.info,
        Icons.sync,
      ),
      ValveCommandStatus.executed => (
        l10n.statusExecuted,
        StatusTone.success,
        Icons.check_circle_outline,
      ),
      ValveCommandStatus.failed => (
        l10n.statusFailed,
        StatusTone.error,
        Icons.error_outline,
      ),
    };
    final duration = motionDuration(context, AppMotion.fast);
    final curve = motionCurve(context, AppMotion.enter);
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: curve,
      switchOutCurve: motionCurve(context, AppMotion.exit),
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          alignment: Alignment.centerLeft,
          children: [
            ...previousChildren,
            ?currentChild,
          ],
        );
      },
      child: StatusBadge(
        key: ValueKey('${status.name}_$label'),
        label: label,
        tone: tone,
        icon: icon,
        dense: dense,
      ),
    );
  }
}

/// Icône et libellé d'un type de commande.
class CommandTypeLabel extends StatelessWidget {
  final ValveCommandType type;

  const CommandTypeLabel({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isOpen = type == ValveCommandType.open;
    final label = isOpen ? l10n.openValve : l10n.closeValve;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isOpen ? Icons.water_drop_outlined : Icons.water_drop,
          size: 18,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.titleSmall),
      ],
    );
  }
}
