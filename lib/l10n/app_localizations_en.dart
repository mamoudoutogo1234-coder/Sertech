// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Sertech';

  @override
  String get navAccueil => 'Home';

  @override
  String get navZones => 'Zones';

  @override
  String get navIrrigation => 'Irrigation';

  @override
  String get navCamera => 'Camera';

  @override
  String get navActivity => 'Activity';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get settings => 'Settings';

  @override
  String get notifications => 'Notifications';

  @override
  String get back => 'Back';

  @override
  String get retry => 'Retry';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get close => 'Close';

  @override
  String get confirm => 'Confirm';

  @override
  String get refresh => 'Refresh';

  @override
  String get search => 'Search';

  @override
  String get viewAll => 'View all';

  @override
  String get loading => 'Loading…';

  @override
  String get error => 'Error';

  @override
  String get unknown => 'Unknown';

  @override
  String get notAvailable => 'Not available';

  @override
  String get none => 'None';

  @override
  String get all => 'All';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get noData => '—';

  @override
  String get unknownState => 'Unknown state';

  @override
  String get offline => 'Offline';

  @override
  String get online => 'Online';

  @override
  String get noInstallationConfigured => 'No installation configured';

  @override
  String get noInstallationConfiguredDesc =>
      'Growing zones will appear here once they are registered.';

  @override
  String get noRecentActivity => 'No recent activity';

  @override
  String get noRecentActivityDesc => 'Irrigation commands will appear here.';

  @override
  String get genericErrorTitle => 'Could not load the data';

  @override
  String get supabaseErrorHint =>
      'Supabase mode never falls back to fictional data.';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count min ago',
      one: '1 min ago',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count h ago',
      one: '1 h ago',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String updatedAt(String time) {
    return 'Updated $time';
  }

  @override
  String recordedAt(String date) {
    return 'Measured on $date';
  }

  @override
  String requestedAt(String date) {
    return 'Requested on $date';
  }

  @override
  String executedAt(String date) {
    return 'Executed on $date';
  }

  @override
  String get systemStatus => 'System status';

  @override
  String get systemStatusDesc =>
      'The Raspberry Pi remains the execution authority. The app only requests commands.';

  @override
  String get soilMoisture => 'Soil moisture';

  @override
  String get lastMeasurement => 'Last measurement';

  @override
  String get automation => 'Automation';

  @override
  String get irrigationState => 'Irrigation state';

  @override
  String zonesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zones',
      one: '1 zone',
      zero: 'No zone',
    );
    return '$_temp0';
  }

  @override
  String commandsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count commands',
      one: '1 command',
      zero: 'No command',
    );
    return '$_temp0';
  }

  @override
  String get moistureTrend => 'Moisture trend';

  @override
  String get quickActions => 'Quick actions';

  @override
  String get zones => 'Zones';

  @override
  String get zoneActive => 'Active';

  @override
  String get zoneInactive => 'Inactive';

  @override
  String get noMeasurementsYet => 'No measurement recorded yet';

  @override
  String get selectZoneHint => 'Select a zone to view its history.';

  @override
  String get zonesTitle => 'Growing zones';

  @override
  String get noZonesConfigured => 'No zones configured';

  @override
  String get noZonesConfiguredDesc =>
      'Create a zone to attach a crop and its sensor to it.';

  @override
  String get createZone => 'New zone';

  @override
  String get editZone => 'Edit zone';

  @override
  String get zoneName => 'Zone name';

  @override
  String get zoneNameHint => 'e.g. North zone — Vegetables';

  @override
  String get zoneDescription => 'Description';

  @override
  String get zoneDescriptionHint => 'Crop, soil type, linked valve…';

  @override
  String get zoneIsActive => 'Zone active';

  @override
  String zoneCreated(String name) {
    return 'Zone “$name” created';
  }

  @override
  String zoneUpdated(String name) {
    return 'Zone “$name” updated';
  }

  @override
  String zoneDeleted(String name) {
    return 'Zone “$name” deleted';
  }

  @override
  String get deleteZoneTitle => 'Delete this zone?';

  @override
  String deleteZoneMessage(String name) {
    return 'Zone “$name”, its measurements, settings and commands will be deleted. This action cannot be undone.';
  }

  @override
  String get searchZones => 'Search a zone';

  @override
  String get noZoneMatches => 'No matching zone';

  @override
  String get zoneDetails => 'Zone details';

  @override
  String get zoneNotFound => 'Zone not found';

  @override
  String get zoneIdentifier => 'Identifier';

  @override
  String zoneCreatedOn(String date) {
    return 'Created on $date';
  }

  @override
  String get measurements => 'Measurements';

  @override
  String get settingsTab => 'Settings';

  @override
  String get commandsTab => 'Commands';

  @override
  String get historyTitle => 'Measurements & history';

  @override
  String get noMeasurements => 'No measurements';

  @override
  String get noMeasurementsDesc =>
      'No sensor has written a measurement for this zone yet.';

  @override
  String get period24h => '24 h';

  @override
  String get period7d => '7 days';

  @override
  String get period30d => '30 days';

  @override
  String get rawValue => 'Raw value';

  @override
  String get percentValue => 'Percentage';

  @override
  String get calibrated => 'Calibrated';

  @override
  String get notCalibrated => 'Not calibrated';

  @override
  String get outOfRange => 'Value out of range';

  @override
  String get source => 'Source';

  @override
  String get thresholdLegend => 'Threshold';

  @override
  String get chartEmptyLabel => 'No data to display for this period';

  @override
  String measurementCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count measurements',
      one: '1 measurement',
      zero: 'No measurement',
    );
    return '$_temp0';
  }

  @override
  String get irrigationTitle => 'Irrigation & automation';

  @override
  String get automationEnabled => 'Automation enabled';

  @override
  String get automationDisabled => 'Automation disabled';

  @override
  String get automationUnknown => 'Automation not configured';

  @override
  String get thresholds => 'Moisture thresholds';

  @override
  String get startThreshold => 'Start threshold';

  @override
  String get stopThreshold => 'Stop threshold';

  @override
  String get maxDuration => 'Maximum duration';

  @override
  String get minInterval => 'Minimum interval';

  @override
  String get saveSettings => 'Save settings';

  @override
  String get settingsSaved => 'Settings saved';

  @override
  String get settingsSaveFailed => 'Could not save the settings';

  @override
  String get manualIrrigation => 'Manual control';

  @override
  String get requestOpen => 'Request opening';

  @override
  String get requestClose => 'Request close';

  @override
  String confirmOpenTitle(String name) {
    return 'Request watering for “$name”?';
  }

  @override
  String confirmOpenMessage(String zoneName) {
    return 'Request to open the valve for $zoneName?';
  }

  @override
  String get commandCreated => 'Request recorded — awaiting execution';

  @override
  String get commandFailed => 'The request could not be recorded';

  @override
  String get executionUnavailable => 'Hardware execution unavailable';

  @override
  String get executionUnavailableDesc =>
      'The app records your requests. The Raspberry Pi executes them; without a connected controller a command stays “pending”.';

  @override
  String get commands => 'Commands';

  @override
  String get noCommands => 'No commands';

  @override
  String get noCommandsDesc => 'Watering requests will appear here.';

  @override
  String get autoModeOn => 'Automatic mode';

  @override
  String get autoModeOff => 'Manual mode';

  @override
  String durationMinutes(String value) {
    return '$value min';
  }

  @override
  String intervalHours(String value) {
    return '$value h';
  }

  @override
  String get activityTitle => 'Activity';

  @override
  String get noActivity => 'No activity';

  @override
  String get noActivityDesc => 'The command history is empty.';

  @override
  String get commandDetails => 'Command details';

  @override
  String get origin => 'Origin';

  @override
  String get reason => 'Reason';

  @override
  String get errorMessage => 'Error message';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusExecuting => 'Running';

  @override
  String get statusExecuted => 'Executed';

  @override
  String get statusFailed => 'Failed';

  @override
  String get openValve => 'Opening';

  @override
  String get closeValve => 'Closing';

  @override
  String get originMobile => 'Mobile app';

  @override
  String get originAutomatic => 'Automatic (Raspberry Pi)';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get noNotifications => 'No notification';

  @override
  String get noNotificationsDesc =>
      'Real events (stale measurements, failed commands) will appear here.';

  @override
  String eventStaleMeasurement(String zone) {
    return 'Stale measurement — $zone';
  }

  @override
  String eventPendingCommand(String zone) {
    return 'Pending command — $zone';
  }

  @override
  String eventFailedCommand(String zone) {
    return 'Failed command — $zone';
  }

  @override
  String eventNoMeasurements(String zone) {
    return 'No measurement — $zone';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get theme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get language => 'Language';

  @override
  String get languageFr => 'French';

  @override
  String get languageEn => 'English';

  @override
  String get languageBm => 'Bamanankan';

  @override
  String get dataSource => 'Data source';

  @override
  String get dataMode => 'Data mode';

  @override
  String get dataModeSupabase => 'Supabase (local)';

  @override
  String get dataModeInMemory => 'Demo (in-memory)';

  @override
  String get dataModeDesc =>
      'Choose the data source. Supabase mode connects to your instance (local or remote). Demo mode uses fictional data and never writes to Supabase.';

  @override
  String get demoScenarioSubtitle =>
      'Fictional data, never written to Supabase.';

  @override
  String get supabaseStatus => 'Supabase server';

  @override
  String get configured => 'Configured';

  @override
  String get notConfigured => 'Not configured';

  @override
  String get notConfiguredLocalOnly => 'Not configured — local mode only';

  @override
  String get networkStatus => 'Phone connectivity';

  @override
  String get networkStatusDesc =>
      'Wi-Fi access says nothing about Supabase or Raspberry Pi availability.';

  @override
  String get rpiStatus => 'Raspberry Pi (controller)';

  @override
  String get rpiUnknown => 'Unknown state';

  @override
  String get rpiUnknownDesc =>
      'No heartbeat source exists yet: the controller state cannot be asserted.';

  @override
  String get version => 'Version';

  @override
  String get diagnostics => 'Diagnostics';

  @override
  String get about => 'About';

  @override
  String get sertechDesc => 'Agricultural supervision — NextDev';

  @override
  String get profile => 'Profile';

  @override
  String get profileUnavailable => 'No signed-in user profile';

  @override
  String get demoMode => 'Demo mode';

  @override
  String get demoScenario => 'Demo scenario';

  @override
  String get demoScenarioDesc =>
      'The scenario only exists in demo mode: it lets you walk through every UI state without hardware.';

  @override
  String get demoModeEnabled => 'Fictional data active';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get nameTooLong => '80 characters maximum';

  @override
  String get thresholdRange => 'Value between 0 and 100';

  @override
  String get hysteresisInvalid =>
      'The start threshold must be lower than or equal to the stop threshold';

  @override
  String get durationRange => 'Duration between 30 seconds and 6 hours';

  @override
  String get intervalRange => 'Interval between 0 and 24 hours';

  @override
  String get invalidNumber => 'Invalid number';

  @override
  String get savedSuccess => 'Changes saved';

  @override
  String get deletedSuccess => 'Item deleted';

  @override
  String get actionFailed => 'The operation failed';

  @override
  String get signIn => 'Sign in';

  @override
  String get signUp => 'Create account';

  @override
  String get signOut => 'Sign out';

  @override
  String get email => 'Email address';

  @override
  String get password => 'Password';

  @override
  String get displayName => 'Display name';

  @override
  String get sessionRequired => 'Session required';

  @override
  String get sessionRequiredDesc =>
      'Supabase data is isolated per user (RLS). Sign in to view your zones.';

  @override
  String get invalidCredentials => 'Invalid credentials';

  @override
  String get authError => 'Could not authenticate';

  @override
  String get noAccount => 'No account yet?';

  @override
  String get haveAccount => 'Already have an account?';

  @override
  String get emailInvalid => 'Invalid email address';

  @override
  String get passwordTooShort => 'At least 6 characters';

  @override
  String signedInAs(String name) {
    return 'Signed in as $name';
  }

  @override
  String get controllerUnknown => 'Controller: unknown state';

  @override
  String get dataFresh => 'Recent data';

  @override
  String get dataStale => 'Stale data';

  @override
  String get noDataReceived => 'No data received';

  @override
  String get viewHistory => 'View history';

  @override
  String get openCamera => 'Open camera';

  @override
  String get configureIrrigation => 'Configure irrigation';

  @override
  String get latestCommand => 'Latest command';

  @override
  String get noCommand => 'No command';

  @override
  String get requestWatering => 'Request watering';

  @override
  String get measurementsTab => 'Measurements';

  @override
  String get scenarioNominal => 'Nominal installation';

  @override
  String get scenarioStaleSensor => 'Silent sensor';

  @override
  String get scenarioNoMeasurements => 'No measurements';

  @override
  String get scenarioPendingCommands => 'Pending commands';

  @override
  String get scenarioFailedCommand => 'Failed command';

  @override
  String get scenarioEmptyInstallation => 'Empty installation';

  @override
  String get currentScenario => 'Active scenario';

  @override
  String get confirmCloseTitle => 'Stop irrigation?';

  @override
  String confirmCloseMessage(String zoneName) {
    return 'Request to close the valve for $zoneName?';
  }

  @override
  String get recentCommands => 'Recent commands';

  @override
  String get lastUpdate => 'Last update';

  @override
  String get average => 'Average';

  @override
  String get minimum => 'Minimum';

  @override
  String get maximum => 'Maximum';

  @override
  String get readings => 'Readings';

  @override
  String get cmdType => 'Command type';

  @override
  String get noReason => 'No reason';

  @override
  String get noError => 'No error';

  @override
  String get systemHint => 'The Raspberry Pi is the execution authority.';

  @override
  String get cameraTitle => 'Camera';

  @override
  String get cameraDesc =>
      'Preview unavailable in this version. No live stream is loaded.';

  @override
  String get cameraOfflineDesc =>
      'The app does not connect directly to the camera. If a stream exists, the Raspberry Pi will expose it.';

  @override
  String get account => 'Account';

  @override
  String get aboutApp => 'About Sertech';

  @override
  String get notLoggedIn => 'Not signed in';

  @override
  String get tapToSignIn => 'Tap to sign in';

  @override
  String get localMode => 'Local mode';

  @override
  String get systemRealtimeHint =>
      'Data refreshes with every measurement received from the Raspberry Pi.';

  @override
  String get modeManualRequired => 'Manual mode required';

  @override
  String get enableManualModeDesc =>
      'To start manual irrigation, you must disable automation.';

  @override
  String get switchToManual => 'Switch to manual';

  @override
  String get startIrrigation => 'Start irrigation?';

  @override
  String get durationMinutesLabel => 'Duration (minutes)';

  @override
  String get maxDurationLabel => 'Maximum allowed duration';

  @override
  String get autoStopAtEnd =>
      'Irrigation will stop automatically at the end of the allowed duration.';

  @override
  String get invalidDuration => 'Invalid duration';

  @override
  String get durationExceedsMax => 'Duration exceeds allowed limit';

  @override
  String get stopIrrigation => 'Stop irrigation';

  @override
  String stopIrrigationConfirm(Object zoneName) {
    return 'Stop irrigation for $zoneName?';
  }

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingGetStarted => 'Get started';

  @override
  String get onboardingTitle1 => 'Monitor your plots';

  @override
  String get onboardingDesc1 =>
      'Keep an eye on soil moisture and track your system at a glance.';

  @override
  String get onboardingTitle2 => 'Irrigate with ease';

  @override
  String get onboardingDesc2 =>
      'Manage zones, start manual watering or rely on automation as needed.';

  @override
  String get registerSubtitle => 'JOIN SERTECH';

  @override
  String get registerTitle => 'Grow smarter, together.';

  @override
  String get registerDesc =>
      'Create your account to organize your zones and manage your smart irrigation system.';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get createAccount => 'Create account';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get passwordMismatch => 'Passwords do not match';

  @override
  String get loginSubtitle => 'WELCOME TO SERTECH';

  @override
  String get loginTitle => 'Welcome back!';

  @override
  String get loginDesc =>
      'Sign in to access your zones, monitor soil moisture and control irrigation.';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get noAccountText => 'Don\'t have an account?';

  @override
  String get createAccountLink => 'Create an account';

  @override
  String get authSubtitle => 'WELCOME TO SERTECH';

  @override
  String get onboardingTitle3 => 'Automate intelligently';

  @override
  String get onboardingDesc3 =>
      'Set moisture thresholds and let irrigation trigger at the right time.';

  @override
  String get alreadyHaveAccountText => 'Already have an account?';

  @override
  String get signInLink => 'Sign in';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';
}
