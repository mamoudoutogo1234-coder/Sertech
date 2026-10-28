import 'package:intl/intl.dart';

/// Formatage des dates.
///
/// Les formats absolus passent par `MaterialLocalizations` côté interface
/// (voir `lib/l10n/l10n_extensions.dart`). Cette classe ne fournit que les
/// formats techniques utilisés côté domaine / tests.
class DateFormatter {
  DateFormatter._();

  static final DateFormat _time = DateFormat('HH:mm');
  static final DateFormat _dateTime = DateFormat('dd/MM/yyyy HH:mm');
  static final DateFormat _date = DateFormat('dd/MM/yyyy');

  static String time(DateTime dateTime) => _time.format(dateTime);
  static String dateTimeLabel(DateTime dateTime) => _dateTime.format(dateTime);
  static String date(DateTime dateTime) => _date.format(dateTime);
}
