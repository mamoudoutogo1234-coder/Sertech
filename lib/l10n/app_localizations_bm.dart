// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bambara (`bm`).
class AppLocalizationsBm extends AppLocalizations {
  AppLocalizationsBm([String locale = 'bm']) : super(locale);

  @override
  String get appName => 'Sertech';

  @override
  String get navAccueil => 'So';

  @override
  String get navZones => 'Yɔrɔw';

  @override
  String get navIrrigation => 'Ji bɔli';

  @override
  String get navCamera => 'Kamera';

  @override
  String get navActivity => 'Kɛwalew';

  @override
  String get dashboardTitle => 'Ɲɛnɛkɛnɛ';

  @override
  String get settings => 'Suguya';

  @override
  String get notifications => 'Kibaruya';

  @override
  String get back => 'Segin';

  @override
  String get retry => 'Segin';

  @override
  String get cancel => 'Abolɔ';

  @override
  String get save => 'Sɛbɛn';

  @override
  String get delete => 'Jɔsi';

  @override
  String get edit => 'Jaabi';

  @override
  String get add => 'Fara';

  @override
  String get close => 'Datugu';

  @override
  String get confirm => 'Sɛmɛ';

  @override
  String get refresh => 'Yɛlɛma';

  @override
  String get search => 'Ɲɛn';

  @override
  String get viewAll => 'Bɛɛ ye';

  @override
  String get loading => 'Bɛ don…';

  @override
  String get error => 'Fili';

  @override
  String get unknown => 'Dɔ ma lɔn';

  @override
  String get notAvailable => 'Tɛ sɔrɔ';

  @override
  String get none => 'Foyi';

  @override
  String get all => 'Bɛɛ';

  @override
  String get yes => 'Ɲa';

  @override
  String get no => 'ƆƆ';

  @override
  String get noData => '—';

  @override
  String get unknownState => 'Cogoya ma lɔn';

  @override
  String get offline => 'Ofrɛli';

  @override
  String get online => 'Jɛnsɛnnen';

  @override
  String get noInstallationConfigured => 'Sɛnɛyɔrɔ ma labɛn';

  @override
  String get noInstallationConfiguredDesc =>
      'Ji bɔli yɔrɔw bɛna jira yan ni u labɛnnen don.';

  @override
  String get noRecentActivity => 'Kɛwale sisan tɛ yen';

  @override
  String get noRecentActivityDesc => 'Ji bɔli bole bɛna jira yan.';

  @override
  String get genericErrorTitle => 'A bɛ fana ladata sɛbɛn';

  @override
  String get supabaseErrorHint =>
      'Supabase modu ye fana te ye bɛ na data mɔgɔ sɛbɛn.';

  @override
  String get justNow => 'Dɔ bɛ la';

  @override
  String minutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A minɛnsɛn $count min',
      one: 'A minɛnsɛn 1 min',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A lɔrɔnsɛn $count kɔnɔ',
      one: 'A lɔrɔnsɛn 1 kɔnɔ',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A lɔrɔnsɛn $count don',
      one: 'A lɔrɔnsɛn 1 don',
    );
    return '$_temp0';
  }

  @override
  String updatedAt(String time) {
    return 'Ladilennen $time';
  }

  @override
  String recordedAt(String date) {
    return 'Karannin $date';
  }

  @override
  String requestedAt(String date) {
    return 'Sɔnnin $date';
  }

  @override
  String executedAt(String date) {
    return 'Jɛkɔnnen $date';
  }

  @override
  String get systemStatus => 'Sisitɛmu cogoya';

  @override
  String get systemStatusDesc =>
      'Raspberry Pi ye jɛnsɛn na ye. App bɛna sɔnnin kɛ dɔrɔn ye.';

  @override
  String get soilMoisture => 'Binkɛnɛ ji hakɛ';

  @override
  String get lastMeasurement => 'Suman dakɛ';

  @override
  String get automation => 'Yɛrɛma';

  @override
  String get irrigationState => 'Ji bɔli cogoya';

  @override
  String zonesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Yɔrɔw $count',
      one: 'Yɔrɔ 1',
      zero: 'Yɔrɔ si tɛ yen',
    );
    return '$_temp0';
  }

  @override
  String commandsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bolew $count',
      one: 'Bole 1',
      zero: 'Bole si tɛ yen',
    );
    return '$_temp0';
  }

  @override
  String get moistureTrend => 'Binkɛnɛ ji hakɛ yɛlɛma';

  @override
  String get quickActions => 'Bɛɛn nafle dɔwɛ';

  @override
  String get zones => 'Yɔrɔw';

  @override
  String get zoneActive => 'Bɛ baara la';

  @override
  String get zoneInactive => 'Dabila';

  @override
  String get noMeasurementsYet => 'Suman ma sɔrɔ foyi';

  @override
  String get selectZoneHint => 'Yɔrɔ dɔ，选 ka ben yen ni kɛwalew dɔwɛ.';

  @override
  String get zonesTitle => 'Ji bɔli yɔrɔw';

  @override
  String get noZonesConfigured => 'Yɔrɔ si ma labɛn';

  @override
  String get noZonesConfiguredDesc =>
      'Yɔrɔ dɔ labɛn ka jɛnɛ ni binkɛnɛ n\'aw ye.';

  @override
  String get createZone => 'Yɔrɔ dɔ';

  @override
  String get editZone => 'Yɔrɔ jaabi';

  @override
  String get zoneName => 'Yɔrɔw yɔrɔma';

  @override
  String get zoneNameHint => 'Misali: Yɔrɔ Bau — Ji bɔli';

  @override
  String get zoneDescription => 'Jigali';

  @override
  String get zoneDescriptionHint => 'Bɛnbɛn, hakɛ bɛn, vanne…';

  @override
  String get zoneIsActive => 'Yɔrɔ bɛ baara la';

  @override
  String zoneCreated(String name) {
    return 'Yɔrɔ « $name » dɔnɛ';
  }

  @override
  String zoneUpdated(String name) {
    return 'Yɔrɔ « $name » lajɛ';
  }

  @override
  String zoneDeleted(String name) {
    return 'Yɔrɔ « $name » jɔsi';
  }

  @override
  String get deleteZoneTitle => 'Yɔrɔ nin jɔsi wa?';

  @override
  String deleteZoneMessage(String name) {
    return 'Yɔrɔ « $name », sumanw, suguyaw ni bolew bɛna jɔsi. A ma fana segin.';
  }

  @override
  String get searchZones => 'Yɔrɔ dɔ ɲɛn';

  @override
  String get noZoneMatches => 'Yɔrɔ dɔ ma bɛn';

  @override
  String get zoneDetails => 'Yɔrɔ cɛsiriw';

  @override
  String get zoneNotFound => 'Yɔrɔ ma bɛn';

  @override
  String get zoneIdentifier => 'Tɔgɔ/kode';

  @override
  String zoneCreatedOn(String date) {
    return 'Dɔnɛnen $date';
  }

  @override
  String get measurements => 'Sumanw';

  @override
  String get settingsTab => 'Suguyaw';

  @override
  String get commandsTab => 'Bolew';

  @override
  String get historyTitle => 'Sumanw ni kɛwalew';

  @override
  String get noMeasurements => 'Suman si tɛ yen';

  @override
  String get noMeasurementsDesc =>
      'Binkɛnɛ ma sɔrɔ sumanw ka fara yɔrɔ nin ye fɔlɔ.';

  @override
  String get period24h => '24 kɔnɔ';

  @override
  String get period7d => '7 don';

  @override
  String get period30d => '30 don';

  @override
  String get rawValue => 'Jɔyɔrɔ kɔnɔ';

  @override
  String get percentValue => 'YɔrɔPercentage';

  @override
  String get calibrated => 'Kalibiri';

  @override
  String get notCalibrated => 'Kalibiri sɔrɔma';

  @override
  String get outOfRange => 'Jɔyɔrɔ bɛnna';

  @override
  String get source => 'Yuubin';

  @override
  String get thresholdLegend => 'Sɛnsɛn';

  @override
  String get chartEmptyLabel => 'A kɔnɔ dɔ wɛn ko data tɛ yen';

  @override
  String measurementCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sumanw $count',
      one: 'Suman 1',
      zero: 'Suman si tɛ yen',
    );
    return '$_temp0';
  }

  @override
  String get irrigationTitle => 'Ji bɔli ni yɛrɛma';

  @override
  String get automationEnabled => 'Yɛrɛma bɛ baara la';

  @override
  String get automationDisabled => 'Yɛrɛma dabila';

  @override
  String get automationUnknown => 'Yɛrɛma ma labɛn';

  @override
  String get thresholds => 'Binkɛnɛ ji hakɛ sɛnsɛnw';

  @override
  String get startThreshold => 'Sɛnsɛn dɛmɛn';

  @override
  String get stopThreshold => 'Sɛnsɛn dabilɛ';

  @override
  String get maxDuration => 'Wakati makɛn';

  @override
  String get minInterval => 'Wakati kɔnɔnw';

  @override
  String get saveSettings => 'Sɛbɛn suguyaw';

  @override
  String get settingsSaved => 'Suguyaw labɛnnen';

  @override
  String get settingsSaveFailed => 'Suguyaw ma fana seebɛn';

  @override
  String get manualIrrigation => 'Bololabaarakɛ';

  @override
  String get requestOpen => 'Sɔnnin bɔgɔma';

  @override
  String get requestClose => 'Tugu wajibi';

  @override
  String confirmOpenTitle(String name) {
    return 'Sɔnnin ji bɔli « $name » wa?';
  }

  @override
  String confirmOpenMessage(String zoneName) {
    return 'Wajibi ka buteli da $zoneName kosɔn?';
  }

  @override
  String get commandCreated => 'Sɔnnin labɛnnen — bɛ bɔta kɛ';

  @override
  String get commandFailed => 'Sɔnnin ma fana seebɛn';

  @override
  String get executionUnavailable => 'Jɔrɔnw bɛɛnna ma sɔrɔ';

  @override
  String get executionUnavailableDesc =>
      'App bɛna sɛbɛn sɔnniw. Raspberry Pi bɛna kɛ a wa; nɛ ma sɔrɔ kontilolo la, bole bɛna tɛ « bɔta kɛ » la.';

  @override
  String get commands => 'Bolew';

  @override
  String get noCommands => 'Bole si tɛ yen';

  @override
  String get noCommandsDesc => 'Ji bɔli sɔnniw bɛna jira yan.';

  @override
  String get autoModeOn => 'Modu otomatiki';

  @override
  String get autoModeOff => 'Modu bololabaara';

  @override
  String durationMinutes(String value) {
    return '$value min';
  }

  @override
  String intervalHours(String value) {
    return '$value h';
  }

  @override
  String get activityTitle => 'Kɛwalew';

  @override
  String get noActivity => 'Kɛwale tɛ yen';

  @override
  String get noActivityDesc => 'Bolew kɛwalew ye tɛ ye kɔnɔ.';

  @override
  String get commandDetails => 'Bole cɛsiriw';

  @override
  String get origin => 'Yuubin';

  @override
  String get reason => 'Sabu';

  @override
  String get errorMessage => 'Fili hakɛ';

  @override
  String get statusPending => 'Bɛ bɔta kɛ';

  @override
  String get statusExecuting => 'Bɛ sen na';

  @override
  String get statusExecuted => 'A jɛkɔn';

  @override
  String get statusFailed => 'A bila';

  @override
  String get openValve => 'Bɔgɔma';

  @override
  String get closeValve => 'Datugu';

  @override
  String get originMobile => 'App telefɔni';

  @override
  String get originAutomatic => 'Otomatiki (Raspberry Pi)';

  @override
  String get notificationsTitle => 'Kibaruya';

  @override
  String get noNotifications => 'Kibaruya si tɛ yen';

  @override
  String get noNotificationsDesc =>
      'Taamalenw (suman tɛmɛnen, bole bila) bɛna jira yan.';

  @override
  String eventStaleMeasurement(String zone) {
    return 'Suman tɛmɛnen — $zone';
  }

  @override
  String eventPendingCommand(String zone) {
    return 'Bole bɛ bɔta kɛ — $zone';
  }

  @override
  String eventFailedCommand(String zone) {
    return 'Bole a bila — $zone';
  }

  @override
  String eventNoMeasurements(String zone) {
    return 'Suman tɛ yen — $zone';
  }

  @override
  String get settingsTitle => 'Suguya';

  @override
  String get appearance => 'Jɛnɛmɛnɛ';

  @override
  String get theme => 'Kuluya';

  @override
  String get themeLight => 'Yeelen';

  @override
  String get themeDark => 'Dibi';

  @override
  String get themeSystem => 'Sisitɛmu';

  @override
  String get language => 'Kan';

  @override
  String get languageFr => 'Fransi';

  @override
  String get languageEn => 'Angɛlɛsi';

  @override
  String get languageBm => 'Bamanankan';

  @override
  String get dataSource => 'Ladata yuubin';

  @override
  String get dataMode => 'Ladata modu';

  @override
  String get dataModeSupabase => 'Supabase (yanɲɛni)';

  @override
  String get dataModeInMemory => 'Fɛnɲɛna (memwiri)';

  @override
  String get dataModeDesc =>
      'I ka kan ka sugandi data bɔyɔrɔ. Supabase modu bɛ siri i ka instance ma (sigida walima yɔrɔ wɛrɛ). Demo modu bɛ na ni data fɛnw ye minnu ma deli ka sɛbɛn Supabase kɔnɔ.';

  @override
  String get demoScenarioSubtitle => 'Data fɛnnu ma sɛbɛn Supabase kɔnɔ.';

  @override
  String get supabaseStatus => 'Supabase sèrwɛri';

  @override
  String get configured => 'Labɛnnen';

  @override
  String get notConfigured => 'Ma labɛn';

  @override
  String get notConfiguredLocalOnly => 'Ma labɛn — yanɲɛni dɔrɔn';

  @override
  String get networkStatus => 'Telefɔni jɛnsɛnni';

  @override
  String get networkStatusDesc =>
      'Wi-Fi jɛnsɛnni ye Supabase walima Raspberry Pi dɔrɔn te foyi.';

  @override
  String get rpiStatus => 'Raspberry Pi (kontilolo)';

  @override
  String get rpiUnknown => 'Cogoya ma lɔn';

  @override
  String get rpiUnknownDesc =>
      'Heartbeat yuubin tɛ yen fɔlɔ: kontilolo cogoya ma bɛ na kɛ.';

  @override
  String get version => 'Wɛrisɔn';

  @override
  String get diagnostics => 'Jɛnɛmɛnɛ lajɛli';

  @override
  String get about => 'Koow kan';

  @override
  String get sertechDesc => 'Sɛnɛ jateminɛ — NextDev';

  @override
  String get profile => 'Ɲɔgɔ';

  @override
  String get profileUnavailable => 'Ɲɔgɔ tɛ yen';

  @override
  String get demoMode => 'Fɛnɲɛna modu';

  @override
  String get demoScenario => 'Fɛnɲɛna senario';

  @override
  String get demoScenarioDesc =>
      'Senario bɛ dɔrɔn fɛnɲɛna modu la: bɛna kɛ cɛsiri bɛɛn bɛɛn na fana jɔrɔnw makɛn.';

  @override
  String get demoModeEnabled => 'Data mɔgɔ bɛ baara la';

  @override
  String get fieldRequired => 'A bɛna sɔrɔ';

  @override
  String get nameTooLong => '80 kaara a maxima';

  @override
  String get thresholdRange => 'Jɔyɔrɔ ka dɔ fɛn 0 ni 100 ye';

  @override
  String get hysteresisInvalid =>
      'Sɛnsɛn dɛmɛn ka dɔ ka ye kɛ a sɛnsɛn dabilɛ ka fɛn ye';

  @override
  String get durationRange => 'Wakati ka dɔ fɛn 30 sɔgɔma ni 6 lɔrɔ ye';

  @override
  String get intervalRange => 'Wakati kɔnɔnw ka dɔ fɛn 0 ni 24 lɔrɔ ye';

  @override
  String get invalidNumber => 'Jɔyɔrɔ ma foyi';

  @override
  String get savedSuccess => 'Ɲɛnɛkɛn labɛnnen';

  @override
  String get deletedSuccess => 'A jɔsi';

  @override
  String get actionFailed => 'A fana tɛ lajɛ';

  @override
  String get signIn => 'Don';

  @override
  String get signUp => 'Kontu dɔ';

  @override
  String get signOut => 'Bɔ';

  @override
  String get email => 'Imɛli adrɛsi';

  @override
  String get password => 'Kunnafoni';

  @override
  String get displayName => 'Tɔgɔ';

  @override
  String get sessionRequired => 'Session bɛna sɔrɔ';

  @override
  String get sessionRequiredDesc =>
      'Supabase data bɛ ka ɲɔgɔn ye (RLS). Don ka i yɔrɔw ye.';

  @override
  String get invalidCredentials => 'Dɔnni ma bɛn';

  @override
  String get authError => 'Dɔnni ma fana kɛ';

  @override
  String get noAccount => 'Kontu tɛ yen fɔlɔ?';

  @override
  String get haveAccount => 'Kontu bɛ yen?';

  @override
  String get emailInvalid => 'Imɛli adrɛsi ma bɛn';

  @override
  String get passwordTooShort => 'Karafɛ 6 ka dɔ';

  @override
  String signedInAs(String name) {
    return 'Donnen $name ye';
  }

  @override
  String get controllerUnknown => 'Kontilolo: cogoya ma lɔn';

  @override
  String get dataFresh => 'Data kuraw';

  @override
  String get dataStale => 'Data tɛmɛnenw';

  @override
  String get noDataReceived => 'Data si ma sɔrɔ';

  @override
  String get viewHistory => 'Kɛwalew ye';

  @override
  String get openCamera => 'Kamera da';

  @override
  String get configureIrrigation => 'Ji bɔli labɛn';

  @override
  String get latestCommand => 'Bole laban';

  @override
  String get noCommand => 'Bole si tɛ yen';

  @override
  String get requestWatering => 'Sɔnnin ji bɔli';

  @override
  String get measurementsTab => 'Sumanw';

  @override
  String get scenarioNominal => 'Sɛnɛyɔrɔ bɛnnen';

  @override
  String get scenarioStaleSensor => 'Kɔnɔma bɛ dabila';

  @override
  String get scenarioNoMeasurements => 'Suman tɛ yen';

  @override
  String get scenarioPendingCommands => 'Bolew bɛ bɔta kɛ';

  @override
  String get scenarioFailedCommand => 'Bole bila';

  @override
  String get scenarioEmptyInstallation => 'Sɛnɛyɔrɔ tɛ yen';

  @override
  String get currentScenario => 'Senario bɛ baara la';

  @override
  String get confirmCloseTitle => 'Ji bɔli dabila?';

  @override
  String confirmCloseMessage(String zoneName) {
    return 'Wajibi ka buteli tugu $zoneName kosɔn?';
  }

  @override
  String get recentCommands => 'Bole kuraw';

  @override
  String get lastUpdate => 'Labɛn laban';

  @override
  String get average => 'Cɛmancɛ';

  @override
  String get minimum => 'Dɔgɔman';

  @override
  String get maximum => 'Camancɛ';

  @override
  String get readings => 'Sumanw';

  @override
  String get cmdType => 'Bole suguya';

  @override
  String get noReason => 'Sabu si tɛ yen';

  @override
  String get noError => 'Fili si tɛ yen';

  @override
  String get systemHint => 'Raspberry Pi ye baara kɛyɔrɔ ye.';

  @override
  String get cameraTitle => 'Kamera';

  @override
  String get cameraDesc => 'Jira ma sɔrɔ. Fɛn si ma don.';

  @override
  String get cameraOfflineDesc =>
      'App ma bɛn kamera ma. Ni fɛn bɛ yen, Raspberry Pi bɛna a jira.';

  @override
  String get account => 'Kontu';

  @override
  String get aboutApp => 'Sertech ko la';

  @override
  String get notLoggedIn => 'Ma don';

  @override
  String get tapToSignIn => 'Don kɛ ka don';

  @override
  String get localMode => 'Yɔrɔ kɔnɔ';

  @override
  String get systemRealtimeHint =>
      'Data bɛ kuraw bɔ tuma o tuma Raspberry Pi fɛ.';

  @override
  String get modeManualRequired => 'Mode manuwal wajib';

  @override
  String get enableManualModeDesc =>
      'Ka fana manuwal daminɛ, i ka wajibiya ka otomatiki dabila.';

  @override
  String get switchToManual => 'Tɛmɛ manuwal ma';

  @override
  String get startIrrigation => 'Daminɛ fana wa?';

  @override
  String get durationMinutesLabel => 'Waati (miniti)';

  @override
  String get maxDurationLabel => 'Waati max bɔlen';

  @override
  String get autoStopAtEnd => 'Fana bɛ jɔ a yɛrɛma waati ban na.';

  @override
  String get invalidDuration => 'Waati ma ɲɛ';

  @override
  String get durationExceedsMax => 'Waati tɛmɛna dan kan';

  @override
  String get stopIrrigation => 'Dabila fana';

  @override
  String stopIrrigationConfirm(Object zoneName) {
    return 'Dabila fana $zoneName la?';
  }

  @override
  String get onboardingSkip => 'Tɛmɛ';

  @override
  String get onboardingNext => 'Nata';

  @override
  String get onboardingGetStarted => 'Daminɛ';

  @override
  String get onboardingTitle1 => 'Aw kɛ yɔrɔw lajɛ';

  @override
  String get onboardingDesc1 =>
      'Aw bɛ se ka dugukolo ji hakɛ lajɛ ani aw ka masin ka cogoya ye kelen kan.';

  @override
  String get onboardingTitle2 => 'Ji bɔli nɔgɔya la';

  @override
  String get onboardingDesc2 =>
      'Aw bɛ se ka yɔrɔw ɲɛnabɔ, ji bɔli daminɛ bololabaarakɛ la walima ka otomatik kɛ.';

  @override
  String get registerSubtitle => 'KA DON SERTECH';

  @override
  String get registerTitle => 'Aw bɛ sɛnɛ ka ɲɛ, ɲɔgɔn fɛ.';

  @override
  String get registerDesc =>
      'Aw ye jatebɔsɛbɛn da ka aw ka yɔrɔw labɛn ani aw ka ji bɔli masin ɲɛnabɔ.';

  @override
  String get confirmPassword => 'Daɲɛ dogo caman';

  @override
  String get createAccount => 'Jatebɔsɛbɛn da';

  @override
  String get alreadyHaveAccount => 'Aw already have account?';

  @override
  String get passwordMismatch => 'Daɲɛ dogo tɛ kelen ye';

  @override
  String get loginSubtitle => 'BIENVENUE SERTECH';

  @override
  String get loginTitle => 'Aw bisimila!';

  @override
  String get loginDesc =>
      'Aw ye don ka aw ka yɔrɔw ye, dugukolo ji lajɛ ani ji bɔli kɛ.';

  @override
  String get forgotPassword => 'Aw ye daɲɛ dogo tunu wa?';

  @override
  String get noAccountText => 'Jatebɔsɛbɛn tɛ aw bolo wa?';

  @override
  String get createAccountLink => 'Jatebɔsɛbɛn da';

  @override
  String get authSubtitle => 'BIENVENUE SERTECH';

  @override
  String get onboardingTitle3 => 'Otomatize kaɲan';

  @override
  String get onboardingDesc3 =>
      'Dabɔ ji hakɛ sigiyɔrɔw ani kɛ ji bɔli ye waati ɲuman na.';

  @override
  String get alreadyHaveAccountText => 'I ye jatebɔla sisan wa?';

  @override
  String get signInLink => 'Don tɛmɛ';

  @override
  String get passwordsDoNotMatch => 'Daɲɛ tɛ kelen ye';
}
