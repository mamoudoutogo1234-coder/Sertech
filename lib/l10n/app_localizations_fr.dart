// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Sertech';

  @override
  String get navAccueil => 'Accueil';

  @override
  String get navZones => 'Zones';

  @override
  String get navIrrigation => 'Irrigation';

  @override
  String get navCamera => 'Caméra';

  @override
  String get navActivity => 'Activité';

  @override
  String get dashboardTitle => 'Tableau de bord';

  @override
  String get settings => 'Paramètres';

  @override
  String get notifications => 'Notifications';

  @override
  String get back => 'Retour';

  @override
  String get retry => 'Réessayer';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get add => 'Ajouter';

  @override
  String get close => 'Fermer';

  @override
  String get confirm => 'Confirmer';

  @override
  String get refresh => 'Actualiser';

  @override
  String get search => 'Rechercher';

  @override
  String get viewAll => 'Voir tout';

  @override
  String get loading => 'Chargement…';

  @override
  String get error => 'Erreur';

  @override
  String get unknown => 'Inconnu';

  @override
  String get notAvailable => 'Non disponible';

  @override
  String get none => 'Aucun';

  @override
  String get all => 'Toutes';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get noData => '—';

  @override
  String get unknownState => 'État inconnu';

  @override
  String get offline => 'Hors ligne';

  @override
  String get online => 'En ligne';

  @override
  String get noInstallationConfigured => 'Aucune installation configurée';

  @override
  String get noInstallationConfiguredDesc =>
      'Les zones de culture apparaîtront ici dès qu\'elles seront enregistrées.';

  @override
  String get noRecentActivity => 'Aucune activité récente';

  @override
  String get noRecentActivityDesc =>
      'Les commandes d\'irrigation apparaîtront ici.';

  @override
  String get genericErrorTitle => 'Impossible de charger les données';

  @override
  String get supabaseErrorHint =>
      'Le mode Supabase ne bascule jamais sur des données fictives.';

  @override
  String get justNow => 'À l\'instant';

  @override
  String minutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Il y a $count min',
      one: 'Il y a 1 min',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Il y a $count h',
      one: 'Il y a 1 h',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Il y a $count jours',
      one: 'Il y a 1 jour',
    );
    return '$_temp0';
  }

  @override
  String updatedAt(String time) {
    return 'Mis à jour $time';
  }

  @override
  String recordedAt(String date) {
    return 'Mesuré le $date';
  }

  @override
  String requestedAt(String date) {
    return 'Demandé le $date';
  }

  @override
  String executedAt(String date) {
    return 'Exécuté le $date';
  }

  @override
  String get systemStatus => 'État du système';

  @override
  String get systemStatusDesc =>
      'Le Raspberry Pi reste l\'autorité d\'exécution. L\'application ne fait que demander des commandes.';

  @override
  String get soilMoisture => 'Humidité du sol';

  @override
  String get lastMeasurement => 'Dernière mesure';

  @override
  String get automation => 'Automatisation';

  @override
  String get irrigationState => 'État de l\'arrosage';

  @override
  String zonesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zones',
      one: '1 zone',
      zero: 'Aucune zone',
    );
    return '$_temp0';
  }

  @override
  String commandsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count commandes',
      one: '1 commande',
      zero: 'Aucune commande',
    );
    return '$_temp0';
  }

  @override
  String get moistureTrend => 'Évolution de l\'humidité';

  @override
  String get quickActions => 'Actions rapides';

  @override
  String get zones => 'Zones';

  @override
  String get zoneActive => 'Active';

  @override
  String get zoneInactive => 'Inactive';

  @override
  String get noMeasurementsYet => 'Aucune mesure enregistrée';

  @override
  String get selectZoneHint =>
      'Sélectionnez une zone pour voir son historique.';

  @override
  String get zonesTitle => 'Zones de culture';

  @override
  String get noZonesConfigured => 'Aucune zone configurée';

  @override
  String get noZonesConfiguredDesc =>
      'Créez une zone pour la rattacher à une culture et à son capteur.';

  @override
  String get createZone => 'Nouvelle zone';

  @override
  String get editZone => 'Modifier la zone';

  @override
  String get zoneName => 'Nom de la zone';

  @override
  String get zoneNameHint => 'Ex. Zone Nord — Maraîchage';

  @override
  String get zoneDescription => 'Description';

  @override
  String get zoneDescriptionHint => 'Culture, type de sol, vanne associée…';

  @override
  String get zoneIsActive => 'Zone active';

  @override
  String zoneCreated(String name) {
    return 'Zone « $name » créée';
  }

  @override
  String zoneUpdated(String name) {
    return 'Zone « $name » mise à jour';
  }

  @override
  String zoneDeleted(String name) {
    return 'Zone « $name » supprimée';
  }

  @override
  String get deleteZoneTitle => 'Supprimer cette zone ?';

  @override
  String deleteZoneMessage(String name) {
    return 'La zone « $name », ses mesures, ses réglages et ses commandes seront supprimés. Cette action est irréversible.';
  }

  @override
  String get searchZones => 'Rechercher une zone';

  @override
  String get noZoneMatches => 'Aucune zone ne correspond';

  @override
  String get zoneDetails => 'Détails de la zone';

  @override
  String get zoneNotFound => 'Zone introuvable';

  @override
  String get zoneIdentifier => 'Identifiant';

  @override
  String zoneCreatedOn(String date) {
    return 'Créée le $date';
  }

  @override
  String get measurements => 'Mesures';

  @override
  String get settingsTab => 'Réglages';

  @override
  String get commandsTab => 'Commandes';

  @override
  String get historyTitle => 'Mesures et historique';

  @override
  String get noMeasurements => 'Aucune mesure';

  @override
  String get noMeasurementsDesc =>
      'Aucun capteur n\'a encore écrit de mesure pour cette zone.';

  @override
  String get period24h => '24 h';

  @override
  String get period7d => '7 jours';

  @override
  String get period30d => '30 jours';

  @override
  String get rawValue => 'Valeur brute';

  @override
  String get percentValue => 'Pourcentage';

  @override
  String get calibrated => 'Calibré';

  @override
  String get notCalibrated => 'Non calibré';

  @override
  String get outOfRange => 'Valeur hors plage';

  @override
  String get source => 'Source';

  @override
  String get thresholdLegend => 'Seuil';

  @override
  String get chartEmptyLabel => 'Aucune donnée à afficher sur cette période';

  @override
  String measurementCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mesures',
      one: '1 mesure',
      zero: 'Aucune mesure',
    );
    return '$_temp0';
  }

  @override
  String get irrigationTitle => 'Irrigation et automatisation';

  @override
  String get automationEnabled => 'Automatisation activée';

  @override
  String get automationDisabled => 'Automatisation désactivée';

  @override
  String get automationUnknown => 'Automatisation non configurée';

  @override
  String get thresholds => 'Seuils d\'humidité';

  @override
  String get startThreshold => 'Seuil de démarrage';

  @override
  String get stopThreshold => 'Seuil d\'arrêt';

  @override
  String get maxDuration => 'Durée maximale';

  @override
  String get minInterval => 'Intervalle minimum';

  @override
  String get saveSettings => 'Enregistrer les réglages';

  @override
  String get settingsSaved => 'Réglages enregistrés';

  @override
  String get settingsSaveFailed => 'Échec de l\'enregistrement des réglages';

  @override
  String get manualIrrigation => 'Commande manuelle';

  @override
  String get requestOpen => 'Demander l\'ouverture';

  @override
  String get requestClose => 'Demander la fermeture';

  @override
  String confirmOpenTitle(String name) {
    return 'Demander l\'arrosage de « $name » ?';
  }

  @override
  String confirmOpenMessage(String zoneName) {
    return 'Demander l\'ouverture de la vanne pour $zoneName ?';
  }

  @override
  String get commandCreated => 'Demande enregistrée — en attente d\'exécution';

  @override
  String get commandFailed => 'La demande n\'a pas pu être enregistrée';

  @override
  String get executionUnavailable => 'Exécution matérielle non disponible';

  @override
  String get executionUnavailableDesc =>
      'L\'application enregistre vos demandes. Le Raspberry Pi les exécute ; sans contrôleur connecté, une commande reste « en attente ».';

  @override
  String get commands => 'Commandes';

  @override
  String get noCommands => 'Aucune commande';

  @override
  String get noCommandsDesc => 'Les demandes d\'arrosage apparaîtront ici.';

  @override
  String get autoModeOn => 'Mode automatique';

  @override
  String get autoModeOff => 'Mode manuel';

  @override
  String durationMinutes(String value) {
    return '$value min';
  }

  @override
  String intervalHours(String value) {
    return '$value h';
  }

  @override
  String get activityTitle => 'Activité';

  @override
  String get noActivity => 'Aucune activité';

  @override
  String get noActivityDesc => 'L\'historique des commandes est vide.';

  @override
  String get commandDetails => 'Détail de la commande';

  @override
  String get origin => 'Origine';

  @override
  String get reason => 'Motif';

  @override
  String get errorMessage => 'Message d\'erreur';

  @override
  String get statusPending => 'En attente';

  @override
  String get statusExecuting => 'En cours';

  @override
  String get statusExecuted => 'Exécutée';

  @override
  String get statusFailed => 'Échec';

  @override
  String get openValve => 'Ouverture';

  @override
  String get closeValve => 'Fermeture';

  @override
  String get originMobile => 'Application mobile';

  @override
  String get originAutomatic => 'Automatique (Raspberry Pi)';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get noNotifications => 'Aucune notification';

  @override
  String get noNotificationsDesc =>
      'Les événements réels (mesures périmées, commandes échouées) apparaîtront ici.';

  @override
  String eventStaleMeasurement(String zone) {
    return 'Mesure périmée — $zone';
  }

  @override
  String eventPendingCommand(String zone) {
    return 'Commande en attente — $zone';
  }

  @override
  String eventFailedCommand(String zone) {
    return 'Commande en échec — $zone';
  }

  @override
  String eventNoMeasurements(String zone) {
    return 'Aucune mesure — $zone';
  }

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get appearance => 'Apparence';

  @override
  String get theme => 'Thème';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeSystem => 'Système';

  @override
  String get language => 'Langue';

  @override
  String get languageFr => 'Français';

  @override
  String get languageEn => 'Anglais';

  @override
  String get languageBm => 'Bamanankan';

  @override
  String get dataSource => 'Source de données';

  @override
  String get dataMode => 'Mode de données';

  @override
  String get dataModeSupabase => 'Supabase (local)';

  @override
  String get dataModeInMemory => 'Démonstration (mémoire)';

  @override
  String get dataModeDesc =>
      'Choisissez la source des données. Le mode Supabase se connecte à votre instance (locale ou distante). Le mode Démonstration utilise des données fictives et ne modifie jamais Supabase.';

  @override
  String get demoScenarioSubtitle =>
      'Données fictives, jamais écrites dans Supabase.';

  @override
  String get supabaseStatus => 'Serveur Supabase';

  @override
  String get configured => 'Configuré';

  @override
  String get notConfigured => 'Non configuré';

  @override
  String get notConfiguredLocalOnly => 'Non configuré — mode local uniquement';

  @override
  String get networkStatus => 'Connectivité du téléphone';

  @override
  String get networkStatusDesc =>
      'L\'accès au Wi-Fi n\'indique ni la disponibilité de Supabase ni celle du Raspberry Pi.';

  @override
  String get rpiStatus => 'Raspberry Pi (contrôleur)';

  @override
  String get rpiUnknown => 'État inconnu';

  @override
  String get rpiUnknownDesc =>
      'Aucune source de heartbeat n\'existe encore : l\'état du contrôleur ne peut pas être affirmé.';

  @override
  String get version => 'Version';

  @override
  String get diagnostics => 'Diagnostics';

  @override
  String get about => 'À propos';

  @override
  String get sertechDesc => 'Supervision agricole — NextDev';

  @override
  String get profile => 'Profil';

  @override
  String get profileUnavailable => 'Aucun profil utilisateur connecté';

  @override
  String get demoMode => 'Mode démonstration';

  @override
  String get demoScenario => 'Scénario de démonstration';

  @override
  String get demoScenarioDesc =>
      'Le scénario n\'existe qu\'en mode démonstration : il permet de parcourir tous les états de l\'interface sans matériel.';

  @override
  String get demoModeEnabled => 'Données fictives actives';

  @override
  String get fieldRequired => 'Ce champ est obligatoire';

  @override
  String get nameTooLong => '80 caractères maximum';

  @override
  String get thresholdRange => 'Valeur entre 0 et 100';

  @override
  String get hysteresisInvalid =>
      'Le seuil de démarrage doit être inférieur ou égal au seuil d\'arrêt';

  @override
  String get durationRange => 'Durée entre 30 secondes et 6 heures';

  @override
  String get intervalRange => 'Intervalle entre 0 et 24 heures';

  @override
  String get invalidNumber => 'Nombre invalide';

  @override
  String get savedSuccess => 'Modifications enregistrées';

  @override
  String get deletedSuccess => 'Élément supprimé';

  @override
  String get actionFailed => 'L\'opération a échoué';

  @override
  String get signIn => 'Se connecter';

  @override
  String get signUp => 'Créer un compte';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get email => 'Adresse e-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get displayName => 'Nom affiché';

  @override
  String get sessionRequired => 'Session requise';

  @override
  String get sessionRequiredDesc =>
      'Les données Supabase sont isolées par utilisateur (RLS). Connectez-vous pour consulter vos zones.';

  @override
  String get invalidCredentials => 'Identifiants invalides';

  @override
  String get authError => 'Authentification impossible';

  @override
  String get noAccount => 'Pas encore de compte ?';

  @override
  String get haveAccount => 'Déjà un compte ?';

  @override
  String get emailInvalid => 'Adresse e-mail invalide';

  @override
  String get passwordTooShort => '6 caractères minimum';

  @override
  String signedInAs(String name) {
    return 'Connecté en tant que $name';
  }

  @override
  String get controllerUnknown => 'Contrôleur : état inconnu';

  @override
  String get dataFresh => 'Données récentes';

  @override
  String get dataStale => 'Données périmées';

  @override
  String get noDataReceived => 'Aucune donnée reçue';

  @override
  String get viewHistory => 'Voir l\'historique';

  @override
  String get openCamera => 'Ouvrir la caméra';

  @override
  String get configureIrrigation => 'Configurer l\'irrigation';

  @override
  String get latestCommand => 'Dernière commande';

  @override
  String get noCommand => 'Aucune commande';

  @override
  String get requestWatering => 'Demander l\'arrosage';

  @override
  String get measurementsTab => 'Mesures';

  @override
  String get scenarioNominal => 'Installation nominale';

  @override
  String get scenarioStaleSensor => 'Capteur silencieux';

  @override
  String get scenarioNoMeasurements => 'Sans mesures';

  @override
  String get scenarioPendingCommands => 'Commandes en attente';

  @override
  String get scenarioFailedCommand => 'Commande en échec';

  @override
  String get scenarioEmptyInstallation => 'Installation vide';

  @override
  String get currentScenario => 'Scénario actif';

  @override
  String get confirmCloseTitle => 'Arrêter l\'arrosage ?';

  @override
  String confirmCloseMessage(String zoneName) {
    return 'Demander la fermeture de la vanne pour $zoneName ?';
  }

  @override
  String get recentCommands => 'Commandes récentes';

  @override
  String get lastUpdate => 'Dernière mise à jour';

  @override
  String get average => 'Moyenne';

  @override
  String get minimum => 'Minimum';

  @override
  String get maximum => 'Maximum';

  @override
  String get readings => 'Relevés';

  @override
  String get cmdType => 'Type de commande';

  @override
  String get noReason => 'Aucun motif';

  @override
  String get noError => 'Aucune erreur';

  @override
  String get systemHint => 'Le Raspberry Pi est l\'autorité d\'exécution.';

  @override
  String get cameraTitle => 'Caméra';

  @override
  String get cameraDesc =>
      'Aperçu non disponible dans cette version. Aucun flux en direct n\'est chargé.';

  @override
  String get cameraOfflineDesc =>
      'L\'application ne se connecte pas directement à la caméra. Si un flux existe, il sera géré par le Raspberry Pi.';

  @override
  String get account => 'Compte';

  @override
  String get aboutApp => 'À propos de Sertech';

  @override
  String get notLoggedIn => 'Non connecté';

  @override
  String get tapToSignIn => 'Appuyer pour se connecter';

  @override
  String get localMode => 'Mode local';

  @override
  String get systemRealtimeHint =>
      'Données actualisées à chaque mesure reçue du Raspberry Pi.';

  @override
  String get modeManualRequired => 'Le mode manuel est nécessaire';

  @override
  String get enableManualModeDesc =>
      'Pour lancer un arrosage manuel, vous devez désactiver l\'automatisation.';

  @override
  String get switchToManual => 'Passer en mode manuel';

  @override
  String get startIrrigation => 'Démarrer un arrosage ?';

  @override
  String get durationMinutesLabel => 'Durée (minutes)';

  @override
  String get maxDurationLabel => 'Durée maximale autorisée';

  @override
  String get autoStopAtEnd =>
      'L\'arrosage s\'arrêtera automatiquement à la fin de la durée autorisée.';

  @override
  String get invalidDuration => 'Durée invalide';

  @override
  String get durationExceedsMax => 'Durée supérieure à la limite autorisée';

  @override
  String get stopIrrigation => 'Arrêter l\'arrosage';

  @override
  String stopIrrigationConfirm(Object zoneName) {
    return 'Arrêter l\'arrosage de $zoneName ?';
  }

  @override
  String get onboardingSkip => 'Passer';

  @override
  String get onboardingNext => 'Suivant';

  @override
  String get onboardingGetStarted => 'Commencer';

  @override
  String get onboardingTitle1 => 'Surveillez vos parcelles';

  @override
  String get onboardingDesc1 =>
      'Gardez un œil sur l\'humidité de vos zones et suivez l\'état de votre installation en un coup d\'œil.';

  @override
  String get onboardingTitle2 => 'Irriguez simplement';

  @override
  String get onboardingDesc2 =>
      'Suivez vos zones, lancez un arrosage manuel ou laissez-vous guider par l\'automatisation selon vos besoins.';

  @override
  String get registerSubtitle => 'REJOIGNEZ SERTECH';

  @override
  String get registerTitle => 'Cultivons mieux, ensemble.';

  @override
  String get registerDesc =>
      'Créez votre compte pour organiser vos zones et gérer votre système d\'irrigation intelligent.';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get createAccount => 'Créer mon compte';

  @override
  String get alreadyHaveAccount => 'Déjà inscrit ?';

  @override
  String get passwordMismatch => 'Les mots de passe ne correspondent pas';

  @override
  String get loginSubtitle => 'BIENVENUE SUR SERTECH';

  @override
  String get loginTitle => 'Heureux de vous revoir !';

  @override
  String get loginDesc =>
      'Connectez-vous pour retrouver vos zones, surveiller l\'humidité du sol et piloter votre irrigation.';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get noAccountText => 'Pas encore de compte ?';

  @override
  String get createAccountLink => 'Créer un compte';

  @override
  String get authSubtitle => 'BIENVENUE SUR SERTECH';

  @override
  String get onboardingTitle3 => 'Automatisez intelligemment';

  @override
  String get onboardingDesc3 =>
      'Définissez des seuils d\'humidité et laissez l\'irrigation se déclencher au bon moment.';

  @override
  String get alreadyHaveAccountText => 'Déjà un compte ?';

  @override
  String get signInLink => 'Se connecter';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';
}
