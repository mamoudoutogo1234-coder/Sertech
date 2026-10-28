import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_localizations.dart';
import 'fallback_localizations_delegate.dart';

const List<LocalizationsDelegate<dynamic>> appLocalizationsDelegates = [
  AppLocalizations.delegate,
  FallbackLocalizationsDelegate<MaterialLocalizations>(
    delegate: GlobalMaterialLocalizations.delegate,
    locale: 'bm',
    fallbackLocale: Locale('fr'),
  ),
  FallbackLocalizationsDelegate<CupertinoLocalizations>(
    delegate: GlobalCupertinoLocalizations.delegate,
    locale: 'bm',
    fallbackLocale: Locale('fr'),
  ),
  FallbackLocalizationsDelegate<WidgetsLocalizations>(
    delegate: GlobalWidgetsLocalizations.delegate,
    locale: 'bm',
    fallbackLocale: Locale('fr'),
  ),
];
