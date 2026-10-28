import 'package:flutter/widgets.dart';

class FallbackLocalizationsDelegate<T> extends LocalizationsDelegate<T> {
  const FallbackLocalizationsDelegate({
    required this.delegate,
    required this.locale,
    required this.fallbackLocale,
  });

  final LocalizationsDelegate<T> delegate;
  final String locale;
  final Locale fallbackLocale;

  @override
  bool isSupported(Locale locale) =>
      delegate.isSupported(locale) || locale.languageCode == this.locale;

  @override
  Future<T> load(Locale locale) =>
      delegate.load(delegate.isSupported(locale) ? locale : fallbackLocale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<T> oldDelegate) =>
      oldDelegate is! FallbackLocalizationsDelegate<T> ||
      delegate.shouldReload(oldDelegate.delegate);
}
