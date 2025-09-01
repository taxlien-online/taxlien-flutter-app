// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'TaxLien.online';

  @override
  String get systemStatus => 'Systemstatus';

  @override
  String get playback => 'Wiedergabe';

  @override
  String get stopped => 'Gestoppt';

  @override
  String get file => 'Datei';

  @override
  String get position => 'Position';

  @override
  String get seconds => 'Sek';

  @override
  String get playbackControls => 'Wiedergabesteuerung';

  @override
  String get play => 'Play';

  @override
  String get pause => 'Pause';

  @override
  String get stop => 'Stop';

  @override
  String get volume => 'Lautstärke';

  @override
  String get projectionSettings => 'Projektionseinstellungen';

  @override
  String get brightness => 'Helligkeit';

  @override
  String get rotation => 'Rotation';

  @override
  String get mediaFiles => 'Mediendateien';

  @override
  String get image => 'Bild';

  @override
  String get calibration => 'Kalibrierung';

  @override
  String get calibrationTitle => 'Projektionskalibrierung';

  @override
  String get preview => 'Vorschau';

  @override
  String get offset => 'Versatz';

  @override
  String get xOffset => 'X-Versatz';

  @override
  String get yOffset => 'Y-Versatz';

  @override
  String get scaleRotation => 'Skalierung und Rotation';

  @override
  String get scale => 'Skalierung';

  @override
  String get apply => 'Anwenden';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get calibrationApplied => 'Kalibrierung angewendet';

  @override
  String get online => 'ONLINE';

  @override
  String get offline => 'OFFLINE';

  @override
  String get languageSettings => 'Spracheinstellungen';

  @override
  String get languageChanged => 'Sprache geändert';

  @override
  String get onboardingWelcomeTitle => 'Willkommen bei TaxLien.online';

  @override
  String get onboardingWelcomeDescription =>
      'Ihr Tor zur digitalen Freiheit und spirituellen Verbindung';

  @override
  String get onboardingConnectionTitle => 'Verbinden mit FreeDome';

  @override
  String get onboardingConnectionDescription =>
      'Stellen Sie eine sichere Verbindung zu Ihrem FreeDome-Netzwerk her';

  @override
  String get onboardingDomeControlTitle => 'Kuppelsteuerung';

  @override
  String get onboardingDomeControlDescription =>
      'Steuern Sie Ihre Kuppeleinstellungen und -konfigurationen';

  @override
  String get onboardingCalibrationTitle => 'Kalibrierung';

  @override
  String get onboardingCalibrationDescription =>
      'Kalibrieren Sie Ihre Kuppel für optimale Leistung';

  @override
  String get onboardingMediaTitle => 'Medienverwaltung';

  @override
  String get onboardingMediaDescription =>
      'Laden Sie Ihre Mediendateien hoch und verwalten Sie sie';

  @override
  String get onboardingReadyTitle => 'Sie sind bereit!';

  @override
  String get onboardingReadyDescription =>
      'Starten Sie Ihre Reise zur digitalen Freiheit';

  @override
  String get next => 'Weiter';

  @override
  String get back => 'Zurück';

  @override
  String get skip => 'Überspringen';

  @override
  String get getStarted => 'Loslegen';

  @override
  String get skipConfirmationTitle => 'Onboarding überspringen?';

  @override
  String get skipConfirmationMessage =>
      'Sind Sie sicher, dass Sie das Onboarding überspringen möchten? Sie können das Tutorial später immer über die Einstellungen aufrufen.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get connectingToFreedome => 'Verbinde mit FreeDome...';

  @override
  String get domeStatusActive => 'Kuppelstatus: Aktiv';

  @override
  String get open => 'Öffnen';

  @override
  String get close => 'Schließen';

  @override
  String get calibrationProgress => 'Kalibrierungsfortschritt';

  @override
  String mediaFilesCount(int count) {
    return 'Mediendateien: $count Elemente';
  }

  @override
  String get upload => 'Hochladen';

  @override
  String get manage => 'Verwalten';

  @override
  String get serverSettings => 'Servereinstellungen';

  @override
  String get connectionStatus => 'Verbindungsstatus';

  @override
  String get russian => 'Russisch';

  @override
  String get ukrainian => 'Ukrainisch';

  @override
  String dataLoadError(String error) {
    return 'Datenladefehler: $error';
  }

  @override
  String get taxLienMarketplace => 'Steuerpfandrecht-Marktplatz';

  @override
  String get filters => 'Filter';

  @override
  String get refresh => 'Aktualisieren';

  @override
  String get searchHint =>
      'Suche nach Adresse, Eigentümer oder Grundstücks-ID...';

  @override
  String get clear => 'Löschen';

  @override
  String foundLiens(int count) {
    return 'Gefunden: $count Pfandrechte';
  }

  @override
  String sortBy(String sortLabel) {
    return 'Sortieren nach: $sortLabel';
  }

  @override
  String get retry => 'Wiederholen';

  @override
  String get noLiensFound => 'Keine Steuerpfandrechte gefunden';

  @override
  String get tryChangingSearch =>
      'Versuchen Sie, Suchparameter oder Filter zu ändern';

  @override
  String stateFilter(String state) {
    return 'Bundesstaat: $state';
  }

  @override
  String countyFilter(String county) {
    return 'Bezirk: $county';
  }

  @override
  String amountFrom(String amount) {
    return 'Von: $amount';
  }

  @override
  String amountTo(String amount) {
    return 'Bis: $amount';
  }

  @override
  String interestRateFrom(String rate) {
    return 'Zinssatz von: $rate%';
  }

  @override
  String auctionDateSort(String direction) {
    return 'Auktionsdatum $direction';
  }

  @override
  String taxAmountSort(String direction) {
    return 'Steuerbetrag $direction';
  }

  @override
  String interestRateSort(String direction) {
    return 'Zinssatz $direction';
  }

  @override
  String assessedValueSort(String direction) {
    return 'Bewerteter Wert $direction';
  }

  @override
  String redemptionDeadlineSort(String direction) {
    return 'Einlösungsfrist $direction';
  }

  @override
  String lienNumber(String parcelId) {
    return 'Pfandrecht #$parcelId';
  }

  @override
  String owner(String owner) {
    return 'Eigentümer: $owner';
  }

  @override
  String get taxAmount => 'Steuerbetrag';

  @override
  String get interestRate => 'Zinssatz';

  @override
  String get assessedValue => 'Bewerteter Wert';

  @override
  String get auctionDate => 'Auktionsdatum';

  @override
  String get additionalInfo => 'Zusätzliche Informationen';

  @override
  String get county => 'Bezirk';

  @override
  String get state => 'Bundesstaat';

  @override
  String get redemptionDeadline => 'Einlösungsfrist';

  @override
  String get status => 'Status';

  @override
  String get buyLien => 'Pfandrecht kaufen';

  @override
  String get availableForPurchase => 'Zum Kauf verfügbar';

  @override
  String get sold => 'Verkauft';

  @override
  String get redeemed => 'Eingelöst';

  @override
  String get foreclosed => 'Zwangsversteigert';

  @override
  String get purchaseLien => 'Pfandrecht kaufen';

  @override
  String enterBidAmount(String amount) {
    return 'Gebotsbetrag eingeben (Minimum $amount):';
  }

  @override
  String get bidAmount => 'Gebotsbetrag';

  @override
  String get lienPurchasedSuccessfully => 'Pfandrecht erfolgreich gekauft!';

  @override
  String get purchaseError => 'Kauf Fehler';

  @override
  String get invalidBidAmount => 'Ungültiger Gebotsbetrag';

  @override
  String get buy => 'Kaufen';

  @override
  String get profile => 'Profil';

  @override
  String get settings => 'Einstellungen';

  @override
  String get notAuthorized => 'Nicht autorisiert';

  @override
  String get loginForAccess =>
      'Melden Sie sich an, um auf Funktionen zuzugreifen';

  @override
  String get login => 'Anmelden';

  @override
  String get register => 'Registrieren';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get logout => 'Abmelden';

  @override
  String get balance => 'Kontostand';

  @override
  String get available => 'Verfügbar';

  @override
  String get topUp => 'Aufladen';

  @override
  String get quickActions => 'Schnellaktionen';

  @override
  String get transactionHistory => 'Transaktionsverlauf';

  @override
  String get viewAllTransactions => 'Alle Transaktionen anzeigen';

  @override
  String get favoriteLiens => 'Favorisierte Pfandrechte';

  @override
  String get savedLiens => 'Ihre gespeicherten Pfandrechte';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get notificationSettings => 'Benachrichtigungseinstellungen';

  @override
  String get help => 'Hilfe';

  @override
  String get appSettings => 'App-Einstellungen';

  @override
  String get language => 'Sprache';

  @override
  String get theme => 'Design';

  @override
  String get dark => 'Dunkel';

  @override
  String get light => 'Hell';

  @override
  String get security => 'Sicherheit';

  @override
  String get securitySettings => 'Sicherheitseinstellungen';

  @override
  String get privacy => 'Datenschutz';

  @override
  String get privacySettings => 'Datenschutzeinstellungen';

  @override
  String get aboutApp => 'Über die App';

  @override
  String get version => 'Version';

  @override
  String get license => 'Lizenz';

  @override
  String get termsOfService => 'Nutzungsbedingungen';

  @override
  String get userAgreement => 'Benutzervereinbarung';

  @override
  String get privacyPolicy => 'Datenschutzrichtlinie';

  @override
  String get dataProcessing => 'Verarbeitung personenbezogener Daten';

  @override
  String get loginToAccount => 'In Konto anmelden';

  @override
  String get password => 'Passwort';

  @override
  String get loginSuccessful => 'Anmeldung erfolgreich!';

  @override
  String get loginError => 'Anmeldefehler';

  @override
  String get registration => 'Registrierung';

  @override
  String get firstName => 'Vorname';

  @override
  String get lastName => 'Nachname';

  @override
  String get registrationSuccessful => 'Registrierung erfolgreich!';

  @override
  String get registrationError => 'Registrierungsfehler';

  @override
  String get registerAccount => 'Registrieren';

  @override
  String get logoutConfirmation => 'Abmeldung bestätigen';

  @override
  String get logoutConfirmationMessage =>
      'Sind Sie sicher, dass Sie sich abmelden möchten?';

  @override
  String get myInvestments => 'Meine Investitionen';

  @override
  String get myLiens => 'Meine Pfandrechte';

  @override
  String get favorites => 'Favoriten';

  @override
  String get statistics => 'Statistiken';

  @override
  String get noInvestmentsYet => 'Sie haben noch keine Investitionen';

  @override
  String get goToMarketplace =>
      'Gehen Sie zum Marktplatz, um Steuerpfandrechte zu kaufen';

  @override
  String get goToMarketplaceButton => 'Zum Marktplatz';

  @override
  String get noFavoriteLiens => 'Keine Lieblingspfandrechte';

  @override
  String get addToFavoritesHint =>
      'Fügen Sie Pfandrechte zu Favoriten für schnellen Zugriff hinzu';

  @override
  String get overallStatistics => 'Gesamtstatistiken';

  @override
  String get totalInvested => 'Gesamt investiert';

  @override
  String get currentValue => 'Aktueller Wert';

  @override
  String get profitLoss => 'Gewinn/Verlust';

  @override
  String get roi => 'ROI';

  @override
  String get statusStatistics => 'Statusstatistiken';

  @override
  String get activeLiens => 'Aktive Pfandrechte';

  @override
  String get redeemedLiens => 'Eingelöste Pfandrechte';

  @override
  String get foreclosedLiens => 'Zwangsversteigerte Pfandrechte';

  @override
  String get totalLiens => 'Gesamte Pfandrechte';

  @override
  String get monthlyReturns => 'Monatliche Renditen';

  @override
  String get profitChartInDevelopment => 'Gewinndiagramm\n(in Entwicklung)';

  @override
  String get topPerformingLiens => 'Beste Pfandrechte';

  @override
  String get investmentInfo => 'Investitionsinformationen';

  @override
  String get purchaseDate => 'Kaufdatum';

  @override
  String get purchaseAmount => 'Kaufbetrag';

  @override
  String get daysInInvestment => 'Tage in der Investition';

  @override
  String get interestEarned => 'Verdiente Zinsen';

  @override
  String get redemptionDate => 'Einlösungsdatum';

  @override
  String get digitalFreedomGateway => 'Tor zur digitalen Freiheit';

  @override
  String get connection => 'Verbindung';

  @override
  String get calibrationScreenComingSoon =>
      'Kalibrierungsbildschirm kommt bald';

  @override
  String get mediaManagementComingSoon => 'Medienverwaltung kommt bald';

  @override
  String get lienSearch => 'Pfandrechtssuche';

  @override
  String get searching => 'Suche...';

  @override
  String get noSearchHistory => 'Keine Suchhistorie';

  @override
  String get clearSearchHistory => 'Suchhistorie löschen';

  @override
  String get searchHistory => 'Suchhistorie';

  @override
  String get recentSearches => 'Letzte Suchen';

  @override
  String get purchase => 'Kaufen';

  @override
  String get searchHistoryEmpty => 'Suchhistorie ist leer';

  @override
  String get searchQueriesWillAppearHere =>
      'Ihre Suchanfragen werden hier angezeigt';

  @override
  String get nothingFound => 'Nichts gefunden';

  @override
  String get tryChangingSearchQuery =>
      'Versuchen Sie, Ihre Suchanfrage zu ändern';

  @override
  String foundLiensCount(int count) {
    return 'Gefunden: $count Pfandrechte';
  }

  @override
  String daysAgo(int days) {
    return 'vor $days Tagen';
  }

  @override
  String hoursAgo(int hours) {
    return 'vor $hours Stunden';
  }

  @override
  String minutesAgo(int minutes) {
    return 'vor $minutes Minuten';
  }

  @override
  String get justNow => 'Gerade eben';
}
