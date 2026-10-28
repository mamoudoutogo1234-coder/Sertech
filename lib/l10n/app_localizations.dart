import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bm.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bm'),
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Sertech'**
  String get appName;

  /// No description provided for @navAccueil.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navAccueil;

  /// No description provided for @navZones.
  ///
  /// In en, this message translates to:
  /// **'Zones'**
  String get navZones;

  /// No description provided for @navIrrigation.
  ///
  /// In en, this message translates to:
  /// **'Irrigation'**
  String get navIrrigation;

  /// No description provided for @navCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get navCamera;

  /// No description provided for @navActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get navActivity;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get notAvailable;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get noData;

  /// No description provided for @unknownState.
  ///
  /// In en, this message translates to:
  /// **'Unknown state'**
  String get unknownState;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @noInstallationConfigured.
  ///
  /// In en, this message translates to:
  /// **'No installation configured'**
  String get noInstallationConfigured;

  /// No description provided for @noInstallationConfiguredDesc.
  ///
  /// In en, this message translates to:
  /// **'Growing zones will appear here once they are registered.'**
  String get noInstallationConfiguredDesc;

  /// No description provided for @noRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'No recent activity'**
  String get noRecentActivity;

  /// No description provided for @noRecentActivityDesc.
  ///
  /// In en, this message translates to:
  /// **'Irrigation commands will appear here.'**
  String get noRecentActivityDesc;

  /// No description provided for @genericErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not load the data'**
  String get genericErrorTitle;

  /// No description provided for @supabaseErrorHint.
  ///
  /// In en, this message translates to:
  /// **'Supabase mode never falls back to fictional data.'**
  String get supabaseErrorHint;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// Placeholder(s) for 'minutesAgo'.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 min ago} other{{count} min ago}}'**
  String minutesAgo(int count);

  /// Placeholder(s) for 'hoursAgo'.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 h ago} other{{count} h ago}}'**
  String hoursAgo(int count);

  /// Placeholder(s) for 'daysAgo'.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day ago} other{{count} days ago}}'**
  String daysAgo(int count);

  /// Placeholder(s) for 'updatedAt'.
  ///
  /// In en, this message translates to:
  /// **'Updated {time}'**
  String updatedAt(String time);

  /// Placeholder(s) for 'recordedAt'.
  ///
  /// In en, this message translates to:
  /// **'Measured on {date}'**
  String recordedAt(String date);

  /// Placeholder(s) for 'requestedAt'.
  ///
  /// In en, this message translates to:
  /// **'Requested on {date}'**
  String requestedAt(String date);

  /// Placeholder(s) for 'executedAt'.
  ///
  /// In en, this message translates to:
  /// **'Executed on {date}'**
  String executedAt(String date);

  /// No description provided for @systemStatus.
  ///
  /// In en, this message translates to:
  /// **'System status'**
  String get systemStatus;

  /// No description provided for @systemStatusDesc.
  ///
  /// In en, this message translates to:
  /// **'The Raspberry Pi remains the execution authority. The app only requests commands.'**
  String get systemStatusDesc;

  /// No description provided for @soilMoisture.
  ///
  /// In en, this message translates to:
  /// **'Soil moisture'**
  String get soilMoisture;

  /// No description provided for @lastMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Last measurement'**
  String get lastMeasurement;

  /// No description provided for @automation.
  ///
  /// In en, this message translates to:
  /// **'Automation'**
  String get automation;

  /// No description provided for @irrigationState.
  ///
  /// In en, this message translates to:
  /// **'Irrigation state'**
  String get irrigationState;

  /// Placeholder(s) for 'zonesCount'.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No zone} =1{1 zone} other{{count} zones}}'**
  String zonesCount(int count);

  /// Placeholder(s) for 'commandsCount'.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No command} =1{1 command} other{{count} commands}}'**
  String commandsCount(int count);

  /// No description provided for @moistureTrend.
  ///
  /// In en, this message translates to:
  /// **'Moisture trend'**
  String get moistureTrend;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get quickActions;

  /// No description provided for @zones.
  ///
  /// In en, this message translates to:
  /// **'Zones'**
  String get zones;

  /// No description provided for @zoneActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get zoneActive;

  /// No description provided for @zoneInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get zoneInactive;

  /// No description provided for @noMeasurementsYet.
  ///
  /// In en, this message translates to:
  /// **'No measurement recorded yet'**
  String get noMeasurementsYet;

  /// No description provided for @selectZoneHint.
  ///
  /// In en, this message translates to:
  /// **'Select a zone to view its history.'**
  String get selectZoneHint;

  /// No description provided for @zonesTitle.
  ///
  /// In en, this message translates to:
  /// **'Growing zones'**
  String get zonesTitle;

  /// No description provided for @noZonesConfigured.
  ///
  /// In en, this message translates to:
  /// **'No zones configured'**
  String get noZonesConfigured;

  /// No description provided for @noZonesConfiguredDesc.
  ///
  /// In en, this message translates to:
  /// **'Create a zone to attach a crop and its sensor to it.'**
  String get noZonesConfiguredDesc;

  /// No description provided for @createZone.
  ///
  /// In en, this message translates to:
  /// **'New zone'**
  String get createZone;

  /// No description provided for @editZone.
  ///
  /// In en, this message translates to:
  /// **'Edit zone'**
  String get editZone;

  /// No description provided for @zoneName.
  ///
  /// In en, this message translates to:
  /// **'Zone name'**
  String get zoneName;

  /// No description provided for @zoneNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. North zone — Vegetables'**
  String get zoneNameHint;

  /// No description provided for @zoneDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get zoneDescription;

  /// No description provided for @zoneDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Crop, soil type, linked valve…'**
  String get zoneDescriptionHint;

  /// No description provided for @zoneIsActive.
  ///
  /// In en, this message translates to:
  /// **'Zone active'**
  String get zoneIsActive;

  /// Placeholder(s) for 'zoneCreated'.
  ///
  /// In en, this message translates to:
  /// **'Zone “{name}” created'**
  String zoneCreated(String name);

  /// Placeholder(s) for 'zoneUpdated'.
  ///
  /// In en, this message translates to:
  /// **'Zone “{name}” updated'**
  String zoneUpdated(String name);

  /// Placeholder(s) for 'zoneDeleted'.
  ///
  /// In en, this message translates to:
  /// **'Zone “{name}” deleted'**
  String zoneDeleted(String name);

  /// No description provided for @deleteZoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this zone?'**
  String get deleteZoneTitle;

  /// Placeholder(s) for 'deleteZoneMessage'.
  ///
  /// In en, this message translates to:
  /// **'Zone “{name}”, its measurements, settings and commands will be deleted. This action cannot be undone.'**
  String deleteZoneMessage(String name);

  /// No description provided for @searchZones.
  ///
  /// In en, this message translates to:
  /// **'Search a zone'**
  String get searchZones;

  /// No description provided for @noZoneMatches.
  ///
  /// In en, this message translates to:
  /// **'No matching zone'**
  String get noZoneMatches;

  /// No description provided for @zoneDetails.
  ///
  /// In en, this message translates to:
  /// **'Zone details'**
  String get zoneDetails;

  /// No description provided for @zoneNotFound.
  ///
  /// In en, this message translates to:
  /// **'Zone not found'**
  String get zoneNotFound;

  /// No description provided for @zoneIdentifier.
  ///
  /// In en, this message translates to:
  /// **'Identifier'**
  String get zoneIdentifier;

  /// Placeholder(s) for 'zoneCreatedOn'.
  ///
  /// In en, this message translates to:
  /// **'Created on {date}'**
  String zoneCreatedOn(String date);

  /// No description provided for @measurements.
  ///
  /// In en, this message translates to:
  /// **'Measurements'**
  String get measurements;

  /// No description provided for @settingsTab.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTab;

  /// No description provided for @commandsTab.
  ///
  /// In en, this message translates to:
  /// **'Commands'**
  String get commandsTab;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'Measurements & history'**
  String get historyTitle;

  /// No description provided for @noMeasurements.
  ///
  /// In en, this message translates to:
  /// **'No measurements'**
  String get noMeasurements;

  /// No description provided for @noMeasurementsDesc.
  ///
  /// In en, this message translates to:
  /// **'No sensor has written a measurement for this zone yet.'**
  String get noMeasurementsDesc;

  /// No description provided for @period24h.
  ///
  /// In en, this message translates to:
  /// **'24 h'**
  String get period24h;

  /// No description provided for @period7d.
  ///
  /// In en, this message translates to:
  /// **'7 days'**
  String get period7d;

  /// No description provided for @period30d.
  ///
  /// In en, this message translates to:
  /// **'30 days'**
  String get period30d;

  /// No description provided for @rawValue.
  ///
  /// In en, this message translates to:
  /// **'Raw value'**
  String get rawValue;

  /// No description provided for @percentValue.
  ///
  /// In en, this message translates to:
  /// **'Percentage'**
  String get percentValue;

  /// No description provided for @calibrated.
  ///
  /// In en, this message translates to:
  /// **'Calibrated'**
  String get calibrated;

  /// No description provided for @notCalibrated.
  ///
  /// In en, this message translates to:
  /// **'Not calibrated'**
  String get notCalibrated;

  /// No description provided for @outOfRange.
  ///
  /// In en, this message translates to:
  /// **'Value out of range'**
  String get outOfRange;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get source;

  /// No description provided for @thresholdLegend.
  ///
  /// In en, this message translates to:
  /// **'Threshold'**
  String get thresholdLegend;

  /// No description provided for @chartEmptyLabel.
  ///
  /// In en, this message translates to:
  /// **'No data to display for this period'**
  String get chartEmptyLabel;

  /// Placeholder(s) for 'measurementCount'.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No measurement} =1{1 measurement} other{{count} measurements}}'**
  String measurementCount(int count);

  /// No description provided for @irrigationTitle.
  ///
  /// In en, this message translates to:
  /// **'Irrigation & automation'**
  String get irrigationTitle;

  /// No description provided for @automationEnabled.
  ///
  /// In en, this message translates to:
  /// **'Automation enabled'**
  String get automationEnabled;

  /// No description provided for @automationDisabled.
  ///
  /// In en, this message translates to:
  /// **'Automation disabled'**
  String get automationDisabled;

  /// No description provided for @automationUnknown.
  ///
  /// In en, this message translates to:
  /// **'Automation not configured'**
  String get automationUnknown;

  /// No description provided for @thresholds.
  ///
  /// In en, this message translates to:
  /// **'Moisture thresholds'**
  String get thresholds;

  /// No description provided for @startThreshold.
  ///
  /// In en, this message translates to:
  /// **'Start threshold'**
  String get startThreshold;

  /// No description provided for @stopThreshold.
  ///
  /// In en, this message translates to:
  /// **'Stop threshold'**
  String get stopThreshold;

  /// No description provided for @maxDuration.
  ///
  /// In en, this message translates to:
  /// **'Maximum duration'**
  String get maxDuration;

  /// No description provided for @minInterval.
  ///
  /// In en, this message translates to:
  /// **'Minimum interval'**
  String get minInterval;

  /// No description provided for @saveSettings.
  ///
  /// In en, this message translates to:
  /// **'Save settings'**
  String get saveSettings;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved'**
  String get settingsSaved;

  /// No description provided for @settingsSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save the settings'**
  String get settingsSaveFailed;

  /// No description provided for @manualIrrigation.
  ///
  /// In en, this message translates to:
  /// **'Manual control'**
  String get manualIrrigation;

  /// No description provided for @requestOpen.
  ///
  /// In en, this message translates to:
  /// **'Request opening'**
  String get requestOpen;

  /// No description provided for @requestClose.
  ///
  /// In en, this message translates to:
  /// **'Request close'**
  String get requestClose;

  /// Placeholder(s) for 'confirmOpenTitle'.
  ///
  /// In en, this message translates to:
  /// **'Request watering for “{name}”?'**
  String confirmOpenTitle(String name);

  /// Placeholder(s) for 'confirmOpenMessage'.
  ///
  /// In en, this message translates to:
  /// **'Request to open the valve for {zoneName}?'**
  String confirmOpenMessage(String zoneName);

  /// No description provided for @commandCreated.
  ///
  /// In en, this message translates to:
  /// **'Request recorded — awaiting execution'**
  String get commandCreated;

  /// No description provided for @commandFailed.
  ///
  /// In en, this message translates to:
  /// **'The request could not be recorded'**
  String get commandFailed;

  /// No description provided for @executionUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Hardware execution unavailable'**
  String get executionUnavailable;

  /// No description provided for @executionUnavailableDesc.
  ///
  /// In en, this message translates to:
  /// **'The app records your requests. The Raspberry Pi executes them; without a connected controller a command stays “pending”.'**
  String get executionUnavailableDesc;

  /// No description provided for @commands.
  ///
  /// In en, this message translates to:
  /// **'Commands'**
  String get commands;

  /// No description provided for @noCommands.
  ///
  /// In en, this message translates to:
  /// **'No commands'**
  String get noCommands;

  /// No description provided for @noCommandsDesc.
  ///
  /// In en, this message translates to:
  /// **'Watering requests will appear here.'**
  String get noCommandsDesc;

  /// No description provided for @autoModeOn.
  ///
  /// In en, this message translates to:
  /// **'Automatic mode'**
  String get autoModeOn;

  /// No description provided for @autoModeOff.
  ///
  /// In en, this message translates to:
  /// **'Manual mode'**
  String get autoModeOff;

  /// Placeholder(s) for 'durationMinutes'.
  ///
  /// In en, this message translates to:
  /// **'{value} min'**
  String durationMinutes(String value);

  /// Placeholder(s) for 'intervalHours'.
  ///
  /// In en, this message translates to:
  /// **'{value} h'**
  String intervalHours(String value);

  /// No description provided for @activityTitle.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activityTitle;

  /// No description provided for @noActivity.
  ///
  /// In en, this message translates to:
  /// **'No activity'**
  String get noActivity;

  /// No description provided for @noActivityDesc.
  ///
  /// In en, this message translates to:
  /// **'The command history is empty.'**
  String get noActivityDesc;

  /// No description provided for @commandDetails.
  ///
  /// In en, this message translates to:
  /// **'Command details'**
  String get commandDetails;

  /// No description provided for @origin.
  ///
  /// In en, this message translates to:
  /// **'Origin'**
  String get origin;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// No description provided for @errorMessage.
  ///
  /// In en, this message translates to:
  /// **'Error message'**
  String get errorMessage;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusExecuting.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get statusExecuting;

  /// No description provided for @statusExecuted.
  ///
  /// In en, this message translates to:
  /// **'Executed'**
  String get statusExecuted;

  /// No description provided for @statusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get statusFailed;

  /// No description provided for @openValve.
  ///
  /// In en, this message translates to:
  /// **'Opening'**
  String get openValve;

  /// No description provided for @closeValve.
  ///
  /// In en, this message translates to:
  /// **'Closing'**
  String get closeValve;

  /// No description provided for @originMobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile app'**
  String get originMobile;

  /// No description provided for @originAutomatic.
  ///
  /// In en, this message translates to:
  /// **'Automatic (Raspberry Pi)'**
  String get originAutomatic;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notification'**
  String get noNotifications;

  /// No description provided for @noNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Real events (stale measurements, failed commands) will appear here.'**
  String get noNotificationsDesc;

  /// Placeholder(s) for 'eventStaleMeasurement'.
  ///
  /// In en, this message translates to:
  /// **'Stale measurement — {zone}'**
  String eventStaleMeasurement(String zone);

  /// Placeholder(s) for 'eventPendingCommand'.
  ///
  /// In en, this message translates to:
  /// **'Pending command — {zone}'**
  String eventPendingCommand(String zone);

  /// Placeholder(s) for 'eventFailedCommand'.
  ///
  /// In en, this message translates to:
  /// **'Failed command — {zone}'**
  String eventFailedCommand(String zone);

  /// Placeholder(s) for 'eventNoMeasurements'.
  ///
  /// In en, this message translates to:
  /// **'No measurement — {zone}'**
  String eventNoMeasurements(String zone);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageFr.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get languageFr;

  /// No description provided for @languageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEn;

  /// No description provided for @languageBm.
  ///
  /// In en, this message translates to:
  /// **'Bamanankan'**
  String get languageBm;

  /// No description provided for @dataSource.
  ///
  /// In en, this message translates to:
  /// **'Data source'**
  String get dataSource;

  /// No description provided for @dataMode.
  ///
  /// In en, this message translates to:
  /// **'Data mode'**
  String get dataMode;

  /// No description provided for @dataModeSupabase.
  ///
  /// In en, this message translates to:
  /// **'Supabase (local)'**
  String get dataModeSupabase;

  /// No description provided for @dataModeInMemory.
  ///
  /// In en, this message translates to:
  /// **'Demo (in-memory)'**
  String get dataModeInMemory;

  /// No description provided for @dataModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose the data source. Supabase mode connects to your instance (local or remote). Demo mode uses fictional data and never writes to Supabase.'**
  String get dataModeDesc;

  /// No description provided for @demoScenarioSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fictional data, never written to Supabase.'**
  String get demoScenarioSubtitle;

  /// No description provided for @supabaseStatus.
  ///
  /// In en, this message translates to:
  /// **'Supabase server'**
  String get supabaseStatus;

  /// No description provided for @configured.
  ///
  /// In en, this message translates to:
  /// **'Configured'**
  String get configured;

  /// No description provided for @notConfigured.
  ///
  /// In en, this message translates to:
  /// **'Not configured'**
  String get notConfigured;

  /// No description provided for @notConfiguredLocalOnly.
  ///
  /// In en, this message translates to:
  /// **'Not configured — local mode only'**
  String get notConfiguredLocalOnly;

  /// No description provided for @networkStatus.
  ///
  /// In en, this message translates to:
  /// **'Phone connectivity'**
  String get networkStatus;

  /// No description provided for @networkStatusDesc.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi access says nothing about Supabase or Raspberry Pi availability.'**
  String get networkStatusDesc;

  /// No description provided for @rpiStatus.
  ///
  /// In en, this message translates to:
  /// **'Raspberry Pi (controller)'**
  String get rpiStatus;

  /// No description provided for @rpiUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown state'**
  String get rpiUnknown;

  /// No description provided for @rpiUnknownDesc.
  ///
  /// In en, this message translates to:
  /// **'No heartbeat source exists yet: the controller state cannot be asserted.'**
  String get rpiUnknownDesc;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @diagnostics.
  ///
  /// In en, this message translates to:
  /// **'Diagnostics'**
  String get diagnostics;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @sertechDesc.
  ///
  /// In en, this message translates to:
  /// **'Agricultural supervision — NextDev'**
  String get sertechDesc;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @profileUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No signed-in user profile'**
  String get profileUnavailable;

  /// No description provided for @demoMode.
  ///
  /// In en, this message translates to:
  /// **'Demo mode'**
  String get demoMode;

  /// No description provided for @demoScenario.
  ///
  /// In en, this message translates to:
  /// **'Demo scenario'**
  String get demoScenario;

  /// No description provided for @demoScenarioDesc.
  ///
  /// In en, this message translates to:
  /// **'The scenario only exists in demo mode: it lets you walk through every UI state without hardware.'**
  String get demoScenarioDesc;

  /// No description provided for @demoModeEnabled.
  ///
  /// In en, this message translates to:
  /// **'Fictional data active'**
  String get demoModeEnabled;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @nameTooLong.
  ///
  /// In en, this message translates to:
  /// **'80 characters maximum'**
  String get nameTooLong;

  /// No description provided for @thresholdRange.
  ///
  /// In en, this message translates to:
  /// **'Value between 0 and 100'**
  String get thresholdRange;

  /// No description provided for @hysteresisInvalid.
  ///
  /// In en, this message translates to:
  /// **'The start threshold must be lower than or equal to the stop threshold'**
  String get hysteresisInvalid;

  /// No description provided for @durationRange.
  ///
  /// In en, this message translates to:
  /// **'Duration between 30 seconds and 6 hours'**
  String get durationRange;

  /// No description provided for @intervalRange.
  ///
  /// In en, this message translates to:
  /// **'Interval between 0 and 24 hours'**
  String get intervalRange;

  /// No description provided for @invalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid number'**
  String get invalidNumber;

  /// No description provided for @savedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Changes saved'**
  String get savedSuccess;

  /// No description provided for @deletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Item deleted'**
  String get deletedSuccess;

  /// No description provided for @actionFailed.
  ///
  /// In en, this message translates to:
  /// **'The operation failed'**
  String get actionFailed;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get signUp;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @displayName.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get displayName;

  /// No description provided for @sessionRequired.
  ///
  /// In en, this message translates to:
  /// **'Session required'**
  String get sessionRequired;

  /// No description provided for @sessionRequiredDesc.
  ///
  /// In en, this message translates to:
  /// **'Supabase data is isolated per user (RLS). Sign in to view your zones.'**
  String get sessionRequiredDesc;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials'**
  String get invalidCredentials;

  /// No description provided for @authError.
  ///
  /// In en, this message translates to:
  /// **'Could not authenticate'**
  String get authError;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'No account yet?'**
  String get noAccount;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get haveAccount;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get emailInvalid;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters'**
  String get passwordTooShort;

  /// Placeholder(s) for 'signedInAs'.
  ///
  /// In en, this message translates to:
  /// **'Signed in as {name}'**
  String signedInAs(String name);

  /// No description provided for @controllerUnknown.
  ///
  /// In en, this message translates to:
  /// **'Controller: unknown state'**
  String get controllerUnknown;

  /// No description provided for @dataFresh.
  ///
  /// In en, this message translates to:
  /// **'Recent data'**
  String get dataFresh;

  /// No description provided for @dataStale.
  ///
  /// In en, this message translates to:
  /// **'Stale data'**
  String get dataStale;

  /// No description provided for @noDataReceived.
  ///
  /// In en, this message translates to:
  /// **'No data received'**
  String get noDataReceived;

  /// No description provided for @viewHistory.
  ///
  /// In en, this message translates to:
  /// **'View history'**
  String get viewHistory;

  /// No description provided for @openCamera.
  ///
  /// In en, this message translates to:
  /// **'Open camera'**
  String get openCamera;

  /// No description provided for @configureIrrigation.
  ///
  /// In en, this message translates to:
  /// **'Configure irrigation'**
  String get configureIrrigation;

  /// No description provided for @latestCommand.
  ///
  /// In en, this message translates to:
  /// **'Latest command'**
  String get latestCommand;

  /// No description provided for @noCommand.
  ///
  /// In en, this message translates to:
  /// **'No command'**
  String get noCommand;

  /// No description provided for @requestWatering.
  ///
  /// In en, this message translates to:
  /// **'Request watering'**
  String get requestWatering;

  /// No description provided for @measurementsTab.
  ///
  /// In en, this message translates to:
  /// **'Measurements'**
  String get measurementsTab;

  /// No description provided for @scenarioNominal.
  ///
  /// In en, this message translates to:
  /// **'Nominal installation'**
  String get scenarioNominal;

  /// No description provided for @scenarioStaleSensor.
  ///
  /// In en, this message translates to:
  /// **'Silent sensor'**
  String get scenarioStaleSensor;

  /// No description provided for @scenarioNoMeasurements.
  ///
  /// In en, this message translates to:
  /// **'No measurements'**
  String get scenarioNoMeasurements;

  /// No description provided for @scenarioPendingCommands.
  ///
  /// In en, this message translates to:
  /// **'Pending commands'**
  String get scenarioPendingCommands;

  /// No description provided for @scenarioFailedCommand.
  ///
  /// In en, this message translates to:
  /// **'Failed command'**
  String get scenarioFailedCommand;

  /// No description provided for @scenarioEmptyInstallation.
  ///
  /// In en, this message translates to:
  /// **'Empty installation'**
  String get scenarioEmptyInstallation;

  /// No description provided for @currentScenario.
  ///
  /// In en, this message translates to:
  /// **'Active scenario'**
  String get currentScenario;

  /// No description provided for @confirmCloseTitle.
  ///
  /// In en, this message translates to:
  /// **'Stop irrigation?'**
  String get confirmCloseTitle;

  /// Placeholder(s) for 'confirmCloseMessage'.
  ///
  /// In en, this message translates to:
  /// **'Request to close the valve for {zoneName}?'**
  String confirmCloseMessage(String zoneName);

  /// No description provided for @recentCommands.
  ///
  /// In en, this message translates to:
  /// **'Recent commands'**
  String get recentCommands;

  /// No description provided for @lastUpdate.
  ///
  /// In en, this message translates to:
  /// **'Last update'**
  String get lastUpdate;

  /// No description provided for @average.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get average;

  /// No description provided for @minimum.
  ///
  /// In en, this message translates to:
  /// **'Minimum'**
  String get minimum;

  /// No description provided for @maximum.
  ///
  /// In en, this message translates to:
  /// **'Maximum'**
  String get maximum;

  /// No description provided for @readings.
  ///
  /// In en, this message translates to:
  /// **'Readings'**
  String get readings;

  /// No description provided for @cmdType.
  ///
  /// In en, this message translates to:
  /// **'Command type'**
  String get cmdType;

  /// No description provided for @noReason.
  ///
  /// In en, this message translates to:
  /// **'No reason'**
  String get noReason;

  /// No description provided for @noError.
  ///
  /// In en, this message translates to:
  /// **'No error'**
  String get noError;

  /// No description provided for @systemHint.
  ///
  /// In en, this message translates to:
  /// **'The Raspberry Pi is the execution authority.'**
  String get systemHint;

  /// No description provided for @cameraTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get cameraTitle;

  /// No description provided for @cameraDesc.
  ///
  /// In en, this message translates to:
  /// **'Preview unavailable in this version. No live stream is loaded.'**
  String get cameraDesc;

  /// No description provided for @cameraOfflineDesc.
  ///
  /// In en, this message translates to:
  /// **'The app does not connect directly to the camera. If a stream exists, the Raspberry Pi will expose it.'**
  String get cameraOfflineDesc;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About Sertech'**
  String get aboutApp;

  /// No description provided for @notLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Not signed in'**
  String get notLoggedIn;

  /// No description provided for @tapToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Tap to sign in'**
  String get tapToSignIn;

  /// No description provided for @localMode.
  ///
  /// In en, this message translates to:
  /// **'Local mode'**
  String get localMode;

  /// No description provided for @systemRealtimeHint.
  ///
  /// In en, this message translates to:
  /// **'Data refreshes with every measurement received from the Raspberry Pi.'**
  String get systemRealtimeHint;

  /// No description provided for @modeManualRequired.
  ///
  /// In en, this message translates to:
  /// **'Manual mode required'**
  String get modeManualRequired;

  /// No description provided for @enableManualModeDesc.
  ///
  /// In en, this message translates to:
  /// **'To start manual irrigation, you must disable automation.'**
  String get enableManualModeDesc;

  /// No description provided for @switchToManual.
  ///
  /// In en, this message translates to:
  /// **'Switch to manual'**
  String get switchToManual;

  /// No description provided for @startIrrigation.
  ///
  /// In en, this message translates to:
  /// **'Start irrigation?'**
  String get startIrrigation;

  /// No description provided for @durationMinutesLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration (minutes)'**
  String get durationMinutesLabel;

  /// No description provided for @maxDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Maximum allowed duration'**
  String get maxDurationLabel;

  /// No description provided for @autoStopAtEnd.
  ///
  /// In en, this message translates to:
  /// **'Irrigation will stop automatically at the end of the allowed duration.'**
  String get autoStopAtEnd;

  /// No description provided for @invalidDuration.
  ///
  /// In en, this message translates to:
  /// **'Invalid duration'**
  String get invalidDuration;

  /// No description provided for @durationExceedsMax.
  ///
  /// In en, this message translates to:
  /// **'Duration exceeds allowed limit'**
  String get durationExceedsMax;

  /// No description provided for @stopIrrigation.
  ///
  /// In en, this message translates to:
  /// **'Stop irrigation'**
  String get stopIrrigation;

  /// No description provided for @stopIrrigationConfirm.
  ///
  /// In en, this message translates to:
  /// **'Stop irrigation for {zoneName}?'**
  String stopIrrigationConfirm(Object zoneName);

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Monitor your plots'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Keep an eye on soil moisture and track your system at a glance.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Irrigate with ease'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'Manage zones, start manual watering or rely on automation as needed.'**
  String get onboardingDesc2;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'JOIN SERTECH'**
  String get registerSubtitle;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Grow smarter, together.'**
  String get registerTitle;

  /// No description provided for @registerDesc.
  ///
  /// In en, this message translates to:
  /// **'Create your account to organize your zones and manage your smart irrigation system.'**
  String get registerDesc;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'WELCOME TO SERTECH'**
  String get loginSubtitle;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get loginTitle;

  /// No description provided for @loginDesc.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access your zones, monitor soil moisture and control irrigation.'**
  String get loginDesc;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @noAccountText.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccountText;

  /// No description provided for @createAccountLink.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get createAccountLink;

  /// No description provided for @authSubtitle.
  ///
  /// In en, this message translates to:
  /// **'WELCOME TO SERTECH'**
  String get authSubtitle;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Automate intelligently'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Set moisture thresholds and let irrigation trigger at the right time.'**
  String get onboardingDesc3;

  /// No description provided for @alreadyHaveAccountText.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccountText;

  /// No description provided for @signInLink.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInLink;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bm', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bm':
      return AppLocalizationsBm();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
