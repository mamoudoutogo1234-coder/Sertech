#!/usr/bin/env python3
"""Génère les fichiers ARB fr / en / bm à partir d'une source unique.

Une seule table de traductions garantit que les trois locales exposent
exactement le même jeu de clés.
"""
import json
import os
from collections import OrderedDict

# key: (fr, en, bm, placeholders)
# placeholders: dict nom -> (type fr/en/bm, description)
T = OrderedDict()


def add(key, fr, en, bm, placeholders=None):
    T[key] = (fr, en, bm, placeholders or {})


# --- Marque & navigation ----------------------------------------------------
add("appName", "Sertech", "Sertech", "Sertech")
add("navAccueil", "Accueil", "Home", "So")
add("navZones", "Zones", "Zones", "Yɔrɔw")
add("navIrrigation", "Irrigation", "Irrigation", "Ji bɔli")
add("navCamera", "Caméra", "Camera", "Kamera")
add("navActivity", "Activité", "Activity", "Kɛwalew")
add("dashboardTitle", "Tableau de bord", "Dashboard", "Ɲɛnɛkɛnɛ")
add("settings", "Paramètres", "Settings", "Suguya")
add("notifications", "Notifications", "Notifications", "Kibaruya")
add("back", "Retour", "Back", "Segin")

# --- Actions ----------------------------------------------------------------
add("retry", "Réessayer", "Retry", "Segin")
add("cancel", "Annuler", "Cancel", "Abolɔ")
add("save", "Enregistrer", "Save", "Sɛbɛn")
add("delete", "Supprimer", "Delete", "Jɔsi")
add("edit", "Modifier", "Edit", "Jaabi")
add("add", "Ajouter", "Add", "Fara")
add("close", "Fermer", "Close", "Datugu")
add("confirm", "Confirmer", "Confirm", "Minen")
add("refresh", "Actualiser", "Refresh", "Yɛlɛma")
add("search", "Rechercher", "Search", "Ɲɛn")
add("viewAll", "Voir tout", "View all", "Bɛɛ ye")
add("loading", "Chargement…", "Loading…", "Bɛ don…")
add("error", "Erreur", "Error", "Fili")
add("unknown", "Inconnu", "Unknown", "Dɔ ma lɔn")
add("notAvailable", "Non disponible", "Not available", "Tɛ sɔrɔ")
add("none", "Aucun", "None", "Foyi")
add("all", "Toutes", "All", "Bɛɛ")
add("yes", "Oui", "Yes", "Ɲa")
add("no", "Non", "No", "ƆƆ")

# --- États vides / erreurs ---------------------------------------------------
add("noData", "—", "—", "—")
add("unknownState", "État inconnu", "Unknown state", "Cogoya ma lɔn")
add("offline", "Hors ligne", "Offline", "Ofrɛli")
add("online", "En ligne", "Online", "Jɛnsɛnnen")
add("noInstallationConfigured", "Aucune installation configurée",
    "No installation configured", "Sɛnɛyɔrɔ ma labɛn")
add("noInstallationConfiguredDesc",
    "Les zones de culture apparaîtront ici dès qu'elles seront enregistrées.",
    "Growing zones will appear here once they are registered.",
    "Ji bɔli yɔrɔw bɛna jira yan ni u labɛnnen don.")
add("noRecentActivity", "Aucune activité récente", "No recent activity",
    "Kɛwale sisan tɛ yen")
add("noRecentActivityDesc",
    "Les commandes d'irrigation apparaîtront ici.",
    "Irrigation commands will appear here.",
    "Ji bɔli bole bɛna jira yan.")
add("genericErrorTitle", "Impossible de charger les données",
    "Could not load the data", "A bɛ fana ladata sɛbɛn")
add("supabaseErrorHint",
    "Le mode Supabase ne bascule jamais sur des données fictives.",
    "Supabase mode never falls back to fictional data.",
    "Supabase modu ye fana te ye bɛ na data mɔgɔ sɛbɛn.")

# --- Fraîcheur & temps ------------------------------------------------------
add("justNow", "À l'instant", "Just now", "Dɔ bɛ la")
add("minutesAgo", "{count, plural, =1{Il y a 1 min} other{Il y a {count} min}}",
    "{count, plural, =1{1 min ago} other{{count} min ago}}",
    "{count, plural, =1{A minɛnsɛn 1 min} other{A minɛnsɛn {count} min}}",
    {"count": ("int", "int", "int")})
add("hoursAgo", "{count, plural, =1{Il y a 1 h} other{Il y a {count} h}}",
    "{count, plural, =1{1 h ago} other{{count} h ago}}",
    "{count, plural, =1{A lɔrɔnsɛn 1 kɔnɔ} other{A lɔrɔnsɛn {count} kɔnɔ}}",
    {"count": ("int", "int", "int")})
add("daysAgo", "{count, plural, =1{Il y a 1 jour} other{Il y a {count} jours}}",
    "{count, plural, =1{1 day ago} other{{count} days ago}}",
    "{count, plural, =1{A lɔrɔnsɛn 1 don} other{A lɔrɔnsɛn {count} don}}",
    {"count": ("int", "int", "int")})
add("updatedAt", "Mis à jour {time}", "Updated {time}", "Ladilennen {time}",
    {"time": ("String", "String", "String")})
add("recordedAt", "Mesuré le {date}", "Measured on {date}",
    "Karannin {date}", {"date": ("String", "String", "String")})
add("requestedAt", "Demandé le {date}", "Requested on {date}",
    "Sɔnnin {date}", {"date": ("String", "String", "String")})
add("executedAt", "Exécuté le {date}", "Executed on {date}",
    "Jɛkɔnnen {date}", {"date": ("String", "String", "String")})

# --- Tableau de bord --------------------------------------------------------
add("systemStatus", "État du système", "System status", "Sisitɛmu cogoya")
add("systemStatusDesc",
    "Le Raspberry Pi reste l'autorité d'exécution. L'application ne fait que "
    "demander des commandes.",
    "The Raspberry Pi remains the execution authority. The app only requests "
    "commands.",
    "Raspberry Pi ye jɛnsɛn na ye. App bɛna sɔnnin kɛ dɔrɔn ye.")
add("soilMoisture", "Humidité du sol", "Soil moisture", "Binkɛnɛ ji hakɛ")
add("lastMeasurement", "Dernière mesure", "Last measurement",
    "Suman dakɛ")
add("automation", "Automatisation", "Automation", "Yɛrɛma")
add("irrigationState", "État de l'arrosage", "Irrigation state",
    "Ji bɔli cogoya")
add("zonesCount", "{count, plural, =0{Aucune zone} =1{1 zone} other{{count} zones}}",
    "{count, plural, =0{No zone} =1{1 zone} other{{count} zones}}",
    "{count, plural, =0{Yɔrɔ si tɛ yen} =1{Yɔrɔ 1} other{Yɔrɔw {count}}}",
    {"count": ("int", "int", "int")})
add("commandsCount",
    "{count, plural, =0{Aucune commande} =1{1 commande} other{{count} commandes}}",
    "{count, plural, =0{No command} =1{1 command} other{{count} commands}}",
    "{count, plural, =0{Bole si tɛ yen} =1{Bole 1} other{Bolew {count}}}",
    {"count": ("int", "int", "int")})
add("moistureTrend", "Évolution de l'humidité", "Moisture trend",
    "Binkɛnɛ ji hakɛ yɛlɛma")
add("quickActions", "Actions rapides", "Quick actions", "Bɛɛn nafle dɔwɛ")
add("zones", "Zones", "Zones", "Yɔrɔw")
add("zoneActive", "Active", "Active", "Bɛ baara la")
add("zoneInactive", "Inactive", "Inactive", "Dabila")
add("noMeasurementsYet", "Aucune mesure enregistrée",
    "No measurement recorded yet", "Suman ma sɔrɔ foyi")
add("selectZoneHint", "Sélectionnez une zone pour voir son historique.",
    "Select a zone to view its history.",
    "Yɔrɔ dɔ，选 ka ben yen ni kɛwalew dɔwɛ.")

# --- Zones ------------------------------------------------------------------
add("zonesTitle", "Zones de culture", "Growing zones", "Ji bɔli yɔrɔw")
add("noZonesConfigured", "Aucune zone configurée", "No zones configured",
    "Yɔrɔ si ma labɛn")
add("noZonesConfiguredDesc",
    "Créez une zone pour la rattacher à une culture et à son capteur.",
    "Create a zone to attach a crop and its sensor to it.",
    "Yɔrɔ dɔ labɛn ka jɛnɛ ni binkɛnɛ n'aw ye.")
add("createZone", "Nouvelle zone", "New zone", "Yɔrɔ dɔ")
add("editZone", "Modifier la zone", "Edit zone", "Yɔrɔ jaabi")
add("zoneName", "Nom de la zone", "Zone name", "Yɔrɔw yɔrɔma")
add("zoneNameHint", "Ex. Zone Nord — Maraîchage", "e.g. North zone — Vegetables",
    "Misali: Yɔrɔ Bau — Ji bɔli")
add("zoneDescription", "Description", "Description", "Jigali")
add("zoneDescriptionHint", "Culture, type de sol, vanne associée…",
    "Crop, soil type, linked valve…", "Bɛnbɛn, hakɛ bɛn, vanne…")
add("zoneIsActive", "Zone active", "Zone active", "Yɔrɔ bɛ baara la")
add("zoneCreated", "Zone « {name} » créée", "Zone “{name}” created",
    "Yɔrɔ « {name} » dɔnɛ", {"name": ("String", "String", "String")})
add("zoneUpdated", "Zone « {name} » mise à jour", "Zone “{name}” updated",
    "Yɔrɔ « {name} » lajɛ", {"name": ("String", "String", "String")})
add("zoneDeleted", "Zone « {name} » supprimée", "Zone “{name}” deleted",
    "Yɔrɔ « {name} » jɔsi", {"name": ("String", "String", "String")})
add("deleteZoneTitle", "Supprimer cette zone ?",
    "Delete this zone?", "Yɔrɔ nin jɔsi wa?")
add("deleteZoneMessage",
    "La zone « {name} », ses mesures, ses réglages et ses commandes seront "
    "supprimés. Cette action est irréversible.",
    "Zone “{name}”, its measurements, settings and commands will be deleted. "
    "This action cannot be undone.",
    "Yɔrɔ « {name} », sumanw, suguyaw ni bolew bɛna jɔsi. A ma fana segin.",
    {"name": ("String", "String", "String")})
add("searchZones", "Rechercher une zone", "Search a zone",
    "Yɔrɔ dɔ ɲɛn")
add("noZoneMatches", "Aucune zone ne correspond", "No matching zone",
    "Yɔrɔ dɔ ma bɛn")
add("zoneDetails", "Détails de la zone", "Zone details", "Yɔrɔ cɛsiriw")
add("zoneNotFound", "Zone introuvable", "Zone not found", "Yɔrɔ ma bɛn")
add("zoneIdentifier", "Identifiant", "Identifier", "Tɔgɔ/kode")
add("zoneCreatedOn", "Créée le {date}", "Created on {date}",
    "Dɔnɛnen {date}", {"date": ("String", "String", "String")})
add("measurements", "Mesures", "Measurements", "Sumanw")
add("settingsTab", "Réglages", "Settings", "Suguyaw")
add("commandsTab", "Commandes", "Commands", "Bolew")

# --- Mesures / historique ---------------------------------------------------
add("historyTitle", "Mesures et historique", "Measurements & history",
    "Sumanw ni kɛwalew")
add("noMeasurements", "Aucune mesure", "No measurements", "Suman si tɛ yen")
add("noMeasurementsDesc",
    "Aucun capteur n'a encore écrit de mesure pour cette zone.",
    "No sensor has written a measurement for this zone yet.",
    "Binkɛnɛ ma sɔrɔ sumanw ka fara yɔrɔ nin ye fɔlɔ.")
add("period24h", "24 h", "24 h", "24 kɔnɔ")
add("period7d", "7 jours", "7 days", "7 don")
add("period30d", "30 jours", "30 days", "30 don")
add("rawValue", "Valeur brute", "Raw value", "Jɔyɔrɔ kɔnɔ")
add("percentValue", "Pourcentage", "Percentage", "YɔrɔPercentage")
add("calibrated", "Calibré", "Calibrated", "Kalibiri")
add("notCalibrated", "Non calibré", "Not calibrated", "Kalibiri sɔrɔma")
add("outOfRange", "Valeur hors plage", "Value out of range", "Jɔyɔrɔ bɛnna")
add("source", "Source", "Source", "Yuubin")
add("thresholdLegend", "Seuil", "Threshold", "Sɛnsɛn")
add("chartEmptyLabel", "Aucune donnée à afficher sur cette période",
    "No data to display for this period", "A kɔnɔ dɔ wɛn ko data tɛ yen")
add("measurementCount",
    "{count, plural, =0{Aucune mesure} =1{1 mesure} other{{count} mesures}}",
    "{count, plural, =0{No measurement} =1{1 measurement} other{{count} measurements}}",
    "{count, plural, =0{Suman si tɛ yen} =1{Suman 1} other{Sumanw {count}}}",
    {"count": ("int", "int", "int")})

# --- Irrigation -------------------------------------------------------------
add("irrigationTitle", "Irrigation et automatisation",
    "Irrigation & automation", "Ji bɔli ni yɛrɛma")
add("automationEnabled", "Automatisation activée", "Automation enabled",
    "Yɛrɛma bɛ baara la")
add("automationDisabled", "Automatisation désactivée",
    "Automation disabled", "Yɛrɛma dabila")
add("automationUnknown", "Automatisation non configurée",
    "Automation not configured", "Yɛrɛma ma labɛn")
add("thresholds", "Seuils d'humidité", "Moisture thresholds",
    "Binkɛnɛ ji hakɛ sɛnsɛnw")
add("startThreshold", "Seuil de démarrage", "Start threshold",
    "Sɛnsɛn dɛmɛn")
add("stopThreshold", "Seuil d'arrêt", "Stop threshold", "Sɛnsɛn dabilɛ")
add("maxDuration", "Durée maximale", "Maximum duration", "Wakati makɛn")
add("minInterval", "Intervalle minimum", "Minimum interval",
    "Wakati kɔnɔnw")
add("saveSettings", "Enregistrer les réglages", "Save settings",
    "Sɛbɛn suguyaw")
add("settingsSaved", "Réglages enregistrés", "Settings saved",
    "Suguyaw labɛnnen")
add("settingsSaveFailed", "Échec de l'enregistrement des réglages",
    "Could not save the settings", "Suguyaw ma fana seebɛn")
add("manualIrrigation", "Commande manuelle", "Manual control",
    "Bololabaarakɛ")
add("requestOpen", "Demander l'ouverture", "Request opening",
    "Sɔnnin bɔgɔma")
add("requestClose", "Demander la fermeture", "Request closing",
    "Sɔnnin datugu")
add("confirmOpenTitle", "Demander l'arrosage de « {name} » ?",
    "Request watering for “{name}”?",
    "Sɔnnin ji bɔli « {name} » wa?",
    {"name": ("String", "String", "String")})
add("confirmOpenMessage",
    "Une demande sera enregistrée pour le Raspberry Pi. L'ouverture effective "
    "de la vanne dépend de la disponibilité du contrôleur.",
    "A request will be recorded for the Raspberry Pi. The valve will only open "
    "if the controller is available.",
    "Bɛna jira sɔnnin la Raspbeeri Pi ye. Vanne bɛna bɔ ye nɛ ma sɔrɔ "
    "kontilolo la.")
add("commandCreated", "Demande enregistrée — en attente d'exécution",
    "Request recorded — awaiting execution",
    "Sɔnnin labɛnnen — bɛ bɔta kɛ")
add("commandFailed", "La demande n'a pas pu être enregistrée",
    "The request could not be recorded", "Sɔnnin ma fana seebɛn")
add("executionUnavailable", "Exécution matérielle non disponible",
    "Hardware execution unavailable", "Jɔrɔnw bɛɛnna ma sɔrɔ")
add("executionUnavailableDesc",
    "L'application enregistre vos demandes. Le Raspberry Pi les exécute ; sans "
    "contrôleur connecté, une commande reste « en attente ».",
    "The app records your requests. The Raspberry Pi executes them; without a "
    "connected controller a command stays “pending”.",
    "App bɛna sɛbɛn sɔnniw. Raspberry Pi bɛna kɛ a wa; nɛ ma sɔrɔ "
    "kontilolo la, bole bɛna tɛ « bɔta kɛ » la.")
add("commands", "Commandes", "Commands", "Bolew")
add("noCommands", "Aucune commande", "No commands", "Bole si tɛ yen")
add("noCommandsDesc", "Les demandes d'arrosage apparaîtront ici.",
    "Watering requests will appear here.",
    "Ji bɔli sɔnniw bɛna jira yan.")
add("autoModeOn", "Mode automatique", "Automatic mode", "Modu otomatiki")
add("autoModeOff", "Mode manuel", "Manual mode", "Modu bololabaara")
add("durationMinutes", "{value} min", "{value} min", "{value} min",
    {"value": ("String", "String", "String")})
add("intervalHours", "{value} h", "{value} h", "{value} h",
    {"value": ("String", "String", "String")})

# --- Activité & commandes ----------------------------------------------------
add("activityTitle", "Activité", "Activity", "Kɛwalew")
add("noActivity", "Aucune activité", "No activity", "Kɛwale tɛ yen")
add("noActivityDesc", "L'historique des commandes est vide.",
    "The command history is empty.", "Bolew kɛwalew ye tɛ ye kɔnɔ.")
add("commandDetails", "Détail de la commande", "Command details",
    "Bole cɛsiriw")
add("origin", "Origine", "Origin", "Yuubin")
add("reason", "Motif", "Reason", "Sabu")
add("errorMessage", "Message d'erreur", "Error message", "Fili hakɛ")
add("statusPending", "En attente", "Pending", "Bɛ bɔta kɛ")
add("statusExecuting", "En cours", "Running", "Bɛ sen na")
add("statusExecuted", "Exécutée", "Executed", "A jɛkɔn")
add("statusFailed", "Échec", "Failed", "A bila")
add("openValve", "Ouverture", "Opening", "Bɔgɔma")
add("closeValve", "Fermeture", "Closing", "Datugu")
add("originMobile", "Application mobile", "Mobile app", "App telefɔni")
add("originAutomatic", "Automatique (Raspberry Pi)",
    "Automatic (Raspberry Pi)", "Otomatiki (Raspberry Pi)")

# --- Notifications -----------------------------------------------------------
add("notificationsTitle", "Notifications", "Notifications", "Kibaruya")
add("noNotifications", "Aucune notification", "No notification",
    "Kibaruya si tɛ yen")
add("noNotificationsDesc",
    "Les événements réels (mesures périmées, commandes échouées) apparaîtront "
    "ici.",
    "Real events (stale measurements, failed commands) will appear here.",
    "Taamalenw (suman tɛmɛnen, bole bila) bɛna jira yan.")
add("eventStaleMeasurement", "Mesure périmée — {zone}",
    "Stale measurement — {zone}", "Suman tɛmɛnen — {zone}",
    {"zone": ("String", "String", "String")})
add("eventPendingCommand", "Commande en attente — {zone}",
    "Pending command — {zone}", "Bole bɛ bɔta kɛ — {zone}",
    {"zone": ("String", "String", "String")})
add("eventFailedCommand", "Commande en échec — {zone}",
    "Failed command — {zone}", "Bole a bila — {zone}",
    {"zone": ("String", "String", "String")})
add("eventNoMeasurements", "Aucune mesure — {zone}",
    "No measurement — {zone}", "Suman tɛ yen — {zone}",
    {"zone": ("String", "String", "String")})

# --- Paramètres & diagnostic -------------------------------------------------
add("settingsTitle", "Paramètres", "Settings", "Suguya")
add("appearance", "Apparence", "Appearance", "Jɛnɛmɛnɛ")
add("theme", "Thème", "Theme", "Kuluya")
add("themeLight", "Clair", "Light", "Yeelen")
add("themeDark", "Sombre", "Dark", "Dibi")
add("themeSystem", "Système", "System", "Sisitɛmu")
add("language", "Langue", "Language", "Kan")
add("languageFr", "Français", "French", "Fransi")
add("languageEn", "Anglais", "English", "Angɛlɛsi")
add("languageBm", "Bamanankan", "Bamanankan", "Bamanankan")
add("dataSource", "Source de données", "Data source", "Ladata yuubin")
add("dataMode", "Mode de données", "Data mode", "Ladata modu")
add("dataModeSupabase", "Supabase (local)", "Supabase (local)",
    "Supabase (yanɲɛni)")
add("dataModeInMemory", "Démonstration (mémoire)", "Demo (in-memory)",
    "Fɛnɲɛna (memwiri)")
add("dataModeDesc",
    "Le mode démonstration utilise des données fictives et n'écrit jamais "
    "dans Supabase.",
    "Demo mode uses fictional data and never writes to Supabase.",
    "Fɛnɲɛna modu bɛ na data mɔgɔ bɛɛn e ka fara Supabase ma fana.")
add("supabaseStatus", "Serveur Supabase", "Supabase server",
    "Supabase sèrwɛri")
add("configured", "Configuré", "Configured", "Labɛnnen")
add("notConfigured", "Non configuré", "Not configured", "Ma labɛn")
add("notConfiguredLocalOnly", "Non configuré — mode local uniquement",
    "Not configured — local mode only", "Ma labɛn — yanɲɛni dɔrɔn")
add("networkStatus", "Connectivité du téléphone", "Phone connectivity",
    "Telefɔni jɛnsɛnni")
add("networkStatusDesc",
    "L'accès au Wi-Fi n'indique ni la disponibilité de Supabase ni celle du "
    "Raspberry Pi.",
    "Wi-Fi access says nothing about Supabase or Raspberry Pi availability.",
    "Wi-Fi jɛnsɛnni ye Supabase walima Raspberry Pi dɔrɔn te foyi.")
add("rpiStatus", "Raspberry Pi (contrôleur)", "Raspberry Pi (controller)",
    "Raspberry Pi (kontilolo)")
add("rpiUnknown", "État inconnu", "Unknown state", "Cogoya ma lɔn")
add("rpiUnknownDesc",
    "Aucune source de heartbeat n'existe encore : l'état du contrôleur ne peut "
    "pas être affirmé.",
    "No heartbeat source exists yet: the controller state cannot be asserted.",
    "Heartbeat yuubin tɛ yen fɔlɔ: kontilolo cogoya ma bɛ na kɛ.")
add("version", "Version", "Version", "Wɛrisɔn")
add("diagnostics", "Diagnostics", "Diagnostics", "Jɛnɛmɛnɛ lajɛli")
add("about", "À propos", "About", "Koow kan")
add("sertechDesc", "Supervision agricole — NextDev",
    "Agricultural supervision — NextDev", "Sɛnɛ jateminɛ — NextDev")
add("profile", "Profil", "Profile", "Ɲɔgɔ")
add("profileUnavailable", "Aucun profil utilisateur connecté",
    "No signed-in user profile", "Ɲɔgɔ tɛ yen")
add("demoMode", "Mode démonstration", "Demo mode", "Fɛnɲɛna modu")
add("demoScenario", "Scénario de démonstration", "Demo scenario",
    "Fɛnɲɛna senario")
add("demoScenarioDesc",
    "Le scénario n'existe qu'en mode démonstration : il permet de parcourir "
    "tous les états de l'interface sans matériel.",
    "The scenario only exists in demo mode: it lets you walk through every UI "
    "state without hardware.",
    "Senario bɛ dɔrɔn fɛnɲɛna modu la: bɛna kɛ cɛsiri bɛɛn bɛɛn na fana "
    "jɔrɔnw makɛn.")
add("demoModeEnabled", "Données fictives actives",
    "Fictional data active", "Data mɔgɔ bɛ baara la")

# --- Validation -------------------------------------------------------------
add("fieldRequired", "Ce champ est obligatoire", "This field is required",
    "A bɛna sɔrɔ")
add("nameTooLong", "80 caractères maximum", "80 characters maximum",
    "80 kaara a maxima")
add("thresholdRange", "Valeur entre 0 et 100", "Value between 0 and 100",
    "Jɔyɔrɔ ka dɔ fɛn 0 ni 100 ye")
add("hysteresisInvalid",
    "Le seuil de démarrage doit être inférieur ou égal au seuil d'arrêt",
    "The start threshold must be lower than or equal to the stop threshold",
    "Sɛnsɛn dɛmɛn ka dɔ ka ye kɛ a sɛnsɛn dabilɛ ka fɛn ye")
add("durationRange", "Durée entre 30 secondes et 6 heures",
    "Duration between 30 seconds and 6 hours",
    "Wakati ka dɔ fɛn 30 sɔgɔma ni 6 lɔrɔ ye")
add("intervalRange", "Intervalle entre 0 et 24 heures",
    "Interval between 0 and 24 hours", "Wakati kɔnɔnw ka dɔ fɛn 0 ni 24 lɔrɔ ye")
add("invalidNumber", "Nombre invalide", "Invalid number", "Jɔyɔrɔ ma foyi")

# --- Notifications (messages système) ---------------------------------------
add("savedSuccess", "Modifications enregistrées", "Changes saved",
    "Ɲɛnɛkɛn labɛnnen")
add("deletedSuccess", "Élément supprimé", "Item deleted", "A jɔsi")
add("actionFailed", "L'opération a échoué", "The operation failed",
    "A fana tɛ lajɛ")


# --- Authentification -------------------------------------------------------
add("signIn", "Se connecter", "Sign in", "Don")
add("signUp", "Créer un compte", "Create account", "Kontu dɔ")
add("signOut", "Se déconnecter", "Sign out", "Bɔ")
add("email", "Adresse e-mail", "Email address", "Imɛli adrɛsi")
add("password", "Mot de passe", "Password", "Kunnafoni")
add("displayName", "Nom affiché", "Display name", "Tɔgɔ")
add("sessionRequired", "Session requise", "Session required",
    "Session bɛna sɔrɔ")
add("sessionRequiredDesc",
    "Les données Supabase sont isolées par utilisateur (RLS). Connectez-vous "
    "pour consulter vos zones.",
    "Supabase data is isolated per user (RLS). Sign in to view your zones.",
    "Supabase data bɛ ka ɲɔgɔn ye (RLS). Don ka i yɔrɔw ye.")
add("invalidCredentials", "Identifiants invalides",
    "Invalid credentials", "Dɔnni ma bɛn")
add("authError", "Authentification impossible",
    "Could not authenticate", "Dɔnni ma fana kɛ")
add("noAccount", "Pas encore de compte ?", "No account yet?",
    "Kontu tɛ yen fɔlɔ?")
add("haveAccount", "Déjà un compte ?", "Already have an account?",
    "Kontu bɛ yen?")
add("emailInvalid", "Adresse e-mail invalide", "Invalid email address",
    "Imɛli adrɛsi ma bɛn")
add("passwordTooShort", "6 caractères minimum", "At least 6 characters",
    "Karafɛ 6 ka dɔ")
add("signedInAs", "Connecté en tant que {name}", "Signed in as {name}",
    "Donnen {name} ye", {"name": ("String", "String", "String")})

# --- Tableau de bord : compléments -----------------------------------------
add("controllerUnknown", "Contrôleur : état inconnu",
    "Controller: unknown state", "Kontilolo: cogoya ma lɔn")
add("dataFresh", "Données récentes", "Recent data", "Data kuraw")
add("dataStale", "Données périmées", "Stale data", "Data tɛmɛnenw")
add("noDataReceived", "Aucune donnée reçue", "No data received",
    "Data si ma sɔrɔ")
add("viewHistory", "Voir l'historique", "View history", "Kɛwalew ye")
add("openCamera", "Ouvrir la caméra", "Open camera", "Kamera da")
add("configureIrrigation", "Configurer l'irrigation",
    "Configure irrigation", "Ji bɔli labɛn")
add("latestCommand", "Dernière commande", "Latest command", "Bole laban")
add("noCommand", "Aucune commande", "No command", "Bole si tɛ yen")
add("requestWatering", "Demander l'arrosage", "Request watering",
    "Sɔnnin ji bɔli")
add("measurementsTab", "Mesures", "Measurements", "Sumanw")

# --- Scénarios de démonstration -------------------------------------------
add("scenarioNominal", "Installation nominale", "Nominal installation",
    "Sɛnɛyɔrɔ bɛnnen")
add("scenarioStaleSensor", "Capteur silencieux", "Silent sensor",
    "Kɔnɔma bɛ dabila")
add("scenarioNoMeasurements", "Sans mesures", "No measurements",
    "Suman tɛ yen")
add("scenarioPendingCommands", "Commandes en attente", "Pending commands",
    "Bolew bɛ bɔta kɛ")
add("scenarioFailedCommand", "Commande en échec", "Failed command",
    "Bole bila")
add("scenarioEmptyInstallation", "Installation vide", "Empty installation",
    "Sɛnɛyɔrɔ tɛ yen")
add("currentScenario", "Scénario actif", "Active scenario",
    "Senario bɛ baara la")
add("confirmOpenMessage",
    "Demander l'ouverture de la vanne pour {zoneName} ?",
    "Request to open the valve for {zoneName}?",
    "Wajibi ka buteli da {zoneName} kosɔn?",
    {"zoneName": ("String", "String", "String")})
add("confirmCloseTitle", "Arrêter l'arrosage ?", "Stop irrigation?",
    "Ji bɔli dabila?")
add("confirmCloseMessage",
    "Demander la fermeture de la vanne pour {zoneName} ?",
    "Request to close the valve for {zoneName}?",
    "Wajibi ka buteli tugu {zoneName} kosɔn?",
    {"zoneName": ("String", "String", "String")})
add("requestClose", "Demander la fermeture", "Request close",
    "Tugu wajibi")
add("recentCommands", "Commandes récentes", "Recent commands",
    "Bole kuraw")
add("lastUpdate", "Dernière mise à jour", "Last update",
    "Labɛn laban")
add("average", "Moyenne", "Average", "Cɛmancɛ")
add("minimum", "Minimum", "Minimum", "Dɔgɔman")
add("maximum", "Maximum", "Maximum", "Camancɛ")
add("readings", "Relevés", "Readings", "Sumanw")
add("cmdType", "Type de commande", "Command type", "Bole suguya")
add("noReason", "Aucun motif", "No reason", "Sabu si tɛ yen")
add("noError", "Aucune erreur", "No error", "Fili si tɛ yen")
add("systemHint", "Le Raspberry Pi est l'autorité d'exécution.",
    "The Raspberry Pi is the execution authority.",
    "Raspberry Pi ye baara kɛyɔrɔ ye.")
add("cameraTitle", "Caméra", "Camera", "Kamera")
add("cameraDesc",
    "Aperçu non disponible dans cette version. Aucun flux en direct n'est chargé.",
    "Preview unavailable in this version. No live stream is loaded.",
    "Jira ma sɔrɔ. Fɛn si ma don.")
add("cameraOfflineDesc",
    "L'application ne se connecte pas directement à la caméra. Si un flux existe, il sera géré par le Raspberry Pi.",
    "The app does not connect directly to the camera. If a stream exists, the Raspberry Pi will expose it.",
    "App ma bɛn kamera ma. Ni fɛn bɛ yen, Raspberry Pi bɛna a jira.")
add("account", "Compte", "Account", "Kontu")
add("aboutApp", "À propos de Sertech", "About Sertech", "Sertech ko la")
add("notLoggedIn", "Non connecté", "Not signed in", "Ma don")
add("tapToSignIn", "Appuyer pour se connecter", "Tap to sign in",
    "Don kɛ ka don")
add("localMode", "Mode local", "Local mode", "Yɔrɔ kɔnɔ")
add("systemRealtimeHint",
    "Données actualisées à chaque mesure reçue du Raspberry Pi.",
    "Data refreshes with every measurement received from the Raspberry Pi.",
    "Data bɛ kuraw bɔ tuma o tuma Raspberry Pi fɛ.")

LOCALES = ["fr", "en", "bm"]
OUT_DIR = os.path.join(os.path.dirname(__file__), "..", "lib", "l10n")


def build(index):
    arb = OrderedDict()
    arb["@@locale"] = LOCALES[index]
    metadata = OrderedDict()
    for key, values in T.items():
        fr, en, bm, placeholders = values
        value = (fr, en, bm)[index]
        arb[key] = value
        if placeholders:
            meta = OrderedDict()
            meta["description"] = f"Placeholder(s) for '{key}'."
            ph = OrderedDict()
            for name, types in placeholders.items():
                ph[name] = OrderedDict()
                ph[name]["type"] = types[index]
            meta["placeholders"] = ph
            metadata["@" + key] = meta
    for key, meta in metadata.items():
        arb[key] = meta
    return arb


for index, locale in enumerate(LOCALES):
    path = os.path.join(OUT_DIR, f"app_{locale}.arb")
    with open(path, "w", encoding="utf-8") as handle:
        json.dump(build(index), handle, ensure_ascii=False, indent=2)
        handle.write("\n")
    print(f"{path}: {len(T)} clés")
