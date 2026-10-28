import 'package:flutter/material.dart';

/// Retourne true si l'utilisateur a désactivé les animations dans les
/// paramètres d'accessibilité.
bool shouldReduceMotion(BuildContext context) {
  try {
    final mediaQuery = MediaQuery.maybeOf(context);
    if (mediaQuery == null) return false;
    return mediaQuery.disableAnimations;
  } catch (_) {
    return false;
  }
}

/// Durée à utiliser selon le paramètre [disableAnimations].
Duration motionDuration(BuildContext context, Duration base) {
  if (shouldReduceMotion(context)) {
    return Duration.zero;
  }
  return base;
}

/// Courbe à utiliser selon le paramètre [disableAnimations].
Curve motionCurve(BuildContext context, Curve base) {
  if (shouldReduceMotion(context)) {
    return Curves.linear;
  }
  return base;
}
