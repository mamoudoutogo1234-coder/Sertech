import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// Formatage localisé accessible depuis n'importe quel widget.
///
/// Les dates passent par `MaterialLocalizations` (format de la langue active)
/// et les durées relatives par les pluriels de l'ARB : aucune chaîne en dur
/// et aucune date affichée dans une langue figée.
extension LocalizedFormatting on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  /// « il y a 3 min », « à l'instant »…
  String relativeTime(DateTime dateTime, {DateTime? now}) {
    final reference = now ?? DateTime.now();
    final diff = reference.difference(dateTime);

    if (diff.isNegative) return l10n.justNow;
    if (diff.inSeconds < 60) return l10n.justNow;
    if (diff.inMinutes < 60) return l10n.minutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return l10n.hoursAgo(diff.inHours);
    if (diff.inDays < 30) return l10n.daysAgo(diff.inDays);
    return shortDate(dateTime);
  }

  /// Date courte formatée selon la langue.
  String shortDate(DateTime dateTime) {
    return MaterialLocalizations.of(this).formatShortDate(dateTime);
  }

  /// Date et heure formatées selon la langue.
  String dateTimeLabel(DateTime dateTime) {
    final localizations = MaterialLocalizations.of(this);
    final time = localizations.formatTimeOfDay(
      TimeOfDay.fromDateTime(dateTime),
    );
    return '${localizations.formatShortDate(dateTime)} · $time';
  }

  /// Heure seule, formatée selon la langue.
  String timeLabel(DateTime dateTime) {
    return MaterialLocalizations.of(this)
        .formatTimeOfDay(TimeOfDay.fromDateTime(dateTime));
  }
}
