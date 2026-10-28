import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';
import '../../shared/widgets/status_badge.dart';

/// Pastille d'état de la connectivité.
///
/// Réflexe important : l'accès au réseau Wi-Fi n'est PAS l'équivalent de la
/// disponibilité du serveur Supabase ni de celle du Raspberry Pi. Cet
/// indicateur ne porte donc que sur la connectivité réseau du téléphone.
class ConnectionStatusBadge extends StatelessWidget {
  final bool isOnline;
  final String? label;

  const ConnectionStatusBadge({super.key, required this.isOnline, this.label});

  @override
  Widget build(BuildContext context) {
    return StatusBadge(
      label: label ?? (isOnline ? 'Connecté' : 'Hors ligne'),
      tone: isOnline ? StatusTone.success : StatusTone.neutral,
      icon: isOnline ? Icons.wifi : Icons.wifi_off,
      dense: true,
    );
  }
}

/// Variante dense pour les listes (sans icône de réseau).
class InlineStateChip extends StatelessWidget {
  final String label;
  final StatusTone tone;
  final IconData? icon;

  const InlineStateChip({
    super.key,
    required this.label,
    required this.tone,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.s8),
      child: StatusBadge(label: label, tone: tone, icon: icon, dense: true),
    );
  }
}
