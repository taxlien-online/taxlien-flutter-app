// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'TaxLien.online';

  @override
  String get systemStatus => 'Stato del Sistema';

  @override
  String get playback => 'Riproduzione';

  @override
  String get stopped => 'Fermato';

  @override
  String get file => 'File';

  @override
  String get position => 'Posizione';

  @override
  String get seconds => 'sec';

  @override
  String get playbackControls => 'Controlli di Riproduzione';

  @override
  String get play => 'Riproduci';

  @override
  String get pause => 'Pausa';

  @override
  String get stop => 'Ferma';

  @override
  String get volume => 'Volume';

  @override
  String get projectionSettings => 'Impostazioni di Proiezione';

  @override
  String get brightness => 'Luminosità';

  @override
  String get rotation => 'Rotazione';

  @override
  String get mediaFiles => 'File Multimediali';

  @override
  String get image => 'Immagine';

  @override
  String get calibration => 'Calibrazione';

  @override
  String get calibrationTitle => 'Calibrazione di Proiezione';

  @override
  String get preview => 'Anteprima';

  @override
  String get offset => 'Offset';

  @override
  String get xOffset => 'Offset X';

  @override
  String get yOffset => 'Offset Y';

  @override
  String get scaleRotation => 'Scala e Rotazione';

  @override
  String get scale => 'Scala';

  @override
  String get apply => 'Applica';

  @override
  String get reset => 'Ripristina';

  @override
  String get calibrationApplied => 'Calibrazione applicata';

  @override
  String get online => 'CONNESSO';

  @override
  String get offline => 'DISCONNESSO';

  @override
  String get languageSettings => 'Impostazioni Lingua';

  @override
  String get languageChanged => 'Lingua modificata';

  @override
  String get onboardingWelcomeTitle => 'Benvenuto in TaxLien.online';

  @override
  String get onboardingWelcomeDescription =>
      'La tua porta verso la libertà digitale e la connessione spirituale';

  @override
  String get onboardingConnectionTitle => 'Connetti a FreeDome';

  @override
  String get onboardingConnectionDescription =>
      'Stabilisci una connessione sicura alla tua rete FreeDome';

  @override
  String get onboardingDomeControlTitle => 'Controllo Cupola';

  @override
  String get onboardingDomeControlDescription =>
      'Controlla le impostazioni e configurazioni della tua cupola';

  @override
  String get onboardingCalibrationTitle => 'Calibrazione';

  @override
  String get onboardingCalibrationDescription =>
      'Calibra la tua cupola per prestazioni ottimali';

  @override
  String get onboardingMediaTitle => 'Gestione Media';

  @override
  String get onboardingMediaDescription =>
      'Carica e gestisci i tuoi file multimediali';

  @override
  String get onboardingReadyTitle => 'Sei Pronto!';

  @override
  String get onboardingReadyDescription =>
      'Inizia il tuo viaggio verso la libertà digitale';

  @override
  String get next => 'Avanti';

  @override
  String get back => 'Indietro';

  @override
  String get skip => 'Salta';

  @override
  String get getStarted => 'Inizia';

  @override
  String get skipConfirmationTitle => 'Saltare l\'Onboarding?';

  @override
  String get skipConfirmationMessage =>
      'Sei sicuro di voler saltare l\'onboarding? Puoi sempre accedere al tutorial più tardi dalle impostazioni.';

  @override
  String get cancel => 'Annulla';

  @override
  String get connectingToFreedome => 'Connessione a FreeDome...';

  @override
  String get domeStatusActive => 'Stato Cupola: Attivo';

  @override
  String get open => 'Apri';

  @override
  String get close => 'Chiudi';

  @override
  String get calibrationProgress => 'Progresso Calibrazione';

  @override
  String mediaFilesCount(int count) {
    return 'File Multimediali: $count elementi';
  }

  @override
  String get upload => 'Carica';

  @override
  String get manage => 'Gestisci';

  @override
  String get serverSettings => 'Impostazioni Server';

  @override
  String get connectionStatus => 'Stato Connessione';

  @override
  String get russian => 'Russo';

  @override
  String get ukrainian => 'Ucraino';

  @override
  String dataLoadError(String error) {
    return 'Errore caricamento dati: $error';
  }

  @override
  String get taxLienMarketplace => 'Mercato Privilegi Fiscali';

  @override
  String get filters => 'Filtri';

  @override
  String get refresh => 'Aggiorna';

  @override
  String get searchHint => 'Cerca per indirizzo, proprietario o ID lotto...';

  @override
  String get clear => 'Cancella';

  @override
  String foundLiens(int count) {
    return 'Trovati: $count privilegi';
  }

  @override
  String sortBy(String sortLabel) {
    return 'Ordina per: $sortLabel';
  }

  @override
  String get retry => 'Riprova';

  @override
  String get noLiensFound => 'Nessun privilegio fiscale trovato';

  @override
  String get tryChangingSearch =>
      'Prova a modificare i parametri di ricerca o i filtri';

  @override
  String stateFilter(String state) {
    return 'Stato: $state';
  }

  @override
  String countyFilter(String county) {
    return 'Contea: $county';
  }

  @override
  String amountFrom(String amount) {
    return 'Da: $amount';
  }

  @override
  String amountTo(String amount) {
    return 'A: $amount';
  }

  @override
  String interestRateFrom(String rate) {
    return 'Tasso da: $rate%';
  }

  @override
  String auctionDateSort(String direction) {
    return 'Data Asta $direction';
  }

  @override
  String taxAmountSort(String direction) {
    return 'Importo Tassa $direction';
  }

  @override
  String interestRateSort(String direction) {
    return 'Tasso di Interesse $direction';
  }

  @override
  String assessedValueSort(String direction) {
    return 'Valore Stimato $direction';
  }

  @override
  String redemptionDeadlineSort(String direction) {
    return 'Scadenza Riscatto $direction';
  }

  @override
  String lienNumber(String parcelId) {
    return 'Privilegio #$parcelId';
  }

  @override
  String owner(String owner) {
    return 'Proprietario: $owner';
  }

  @override
  String get taxAmount => 'Importo Tassa';

  @override
  String get interestRate => 'Tasso di Interesse';

  @override
  String get assessedValue => 'Valore Stimato';

  @override
  String get auctionDate => 'Data Asta';

  @override
  String get additionalInfo => 'Informazioni Aggiuntive';

  @override
  String get county => 'Contea';

  @override
  String get state => 'Stato';

  @override
  String get redemptionDeadline => 'Scadenza Riscatto';

  @override
  String get status => 'Stato';

  @override
  String get buyLien => 'Acquista Privilegio';

  @override
  String get availableForPurchase => 'Disponibile per l\'acquisto';

  @override
  String get sold => 'Venduto';

  @override
  String get redeemed => 'Riscattato';

  @override
  String get foreclosed => 'Pignorato';

  @override
  String get purchaseLien => 'Acquista Privilegio';

  @override
  String enterBidAmount(String amount) {
    return 'Inserisci l\'importo dell\'offerta (minimo $amount):';
  }

  @override
  String get bidAmount => 'Importo Offerta';

  @override
  String get lienPurchasedSuccessfully => 'Privilegio acquistato con successo!';

  @override
  String get purchaseError => 'Errore acquisto';

  @override
  String get invalidBidAmount => 'Importo offerta non valido';

  @override
  String get buy => 'Acquista';

  @override
  String get profile => 'Profilo';

  @override
  String get settings => 'Impostazioni';

  @override
  String get notAuthorized => 'Non autorizzato';

  @override
  String get loginForAccess => 'Accedi per utilizzare le funzionalità';

  @override
  String get login => 'Accedi';

  @override
  String get register => 'Registrati';

  @override
  String get edit => 'Modifica';

  @override
  String get logout => 'Esci';

  @override
  String get balance => 'Saldo';

  @override
  String get available => 'Disponibile';

  @override
  String get topUp => 'Ricarica';

  @override
  String get quickActions => 'Azioni Rapide';

  @override
  String get transactionHistory => 'Cronologia Transazioni';

  @override
  String get viewAllTransactions => 'Visualizza tutte le transazioni';

  @override
  String get favoriteLiens => 'Privilegi Preferiti';

  @override
  String get savedLiens => 'I tuoi privilegi salvati';

  @override
  String get notifications => 'Notifiche';

  @override
  String get notificationSettings => 'Impostazioni notifiche';

  @override
  String get help => 'Aiuto';

  @override
  String get appSettings => 'Impostazioni App';

  @override
  String get language => 'Lingua';

  @override
  String get theme => 'Tema';

  @override
  String get dark => 'Scuro';

  @override
  String get light => 'Chiaro';

  @override
  String get security => 'Sicurezza';

  @override
  String get securitySettings => 'Impostazioni sicurezza';

  @override
  String get privacy => 'Privacy';

  @override
  String get privacySettings => 'Impostazioni privacy';

  @override
  String get aboutApp => 'Informazioni App';

  @override
  String get version => 'Versione';

  @override
  String get license => 'Licenza';

  @override
  String get termsOfService => 'Termini di Servizio';

  @override
  String get userAgreement => 'Accordo Utente';

  @override
  String get privacyPolicy => 'Informativa Privacy';

  @override
  String get dataProcessing => 'Trattamento dati personali';

  @override
  String get loginToAccount => 'Accedi all\'Account';

  @override
  String get password => 'Password';

  @override
  String get loginSuccessful => 'Accesso riuscito!';

  @override
  String get loginError => 'Errore accesso';

  @override
  String get registration => 'Registrazione';

  @override
  String get firstName => 'Nome';

  @override
  String get lastName => 'Cognome';

  @override
  String get registrationSuccessful => 'Registrazione riuscita!';

  @override
  String get registrationError => 'Errore registrazione';

  @override
  String get registerAccount => 'Registrati';

  @override
  String get logoutConfirmation => 'Conferma Uscita';

  @override
  String get logoutConfirmationMessage => 'Sei sicuro di voler uscire?';

  @override
  String get myInvestments => 'My Investments';

  @override
  String get myLiens => 'My Liens';

  @override
  String get favorites => 'Favorites';

  @override
  String get statistics => 'Statistics';

  @override
  String get noInvestmentsYet => 'You don\'t have any investments yet';

  @override
  String get goToMarketplace => 'Go to marketplace to buy tax liens';

  @override
  String get goToMarketplaceButton => 'Go to Marketplace';

  @override
  String get noFavoriteLiens => 'No favorite liens';

  @override
  String get addToFavoritesHint => 'Add liens to favorites for quick access';

  @override
  String get overallStatistics => 'Overall Statistics';

  @override
  String get totalInvested => 'Total Invested';

  @override
  String get currentValue => 'Current Value';

  @override
  String get profitLoss => 'Profit/Loss';

  @override
  String get roi => 'ROI';

  @override
  String get statusStatistics => 'Status Statistics';

  @override
  String get activeLiens => 'Active Liens';

  @override
  String get redeemedLiens => 'Redeemed Liens';

  @override
  String get foreclosedLiens => 'Foreclosed Liens';

  @override
  String get totalLiens => 'Total Liens';

  @override
  String get monthlyReturns => 'Monthly Returns';

  @override
  String get profitChartInDevelopment => 'Profit Chart\n(in development)';

  @override
  String get topPerformingLiens => 'Top Performing Liens';

  @override
  String get investmentInfo => 'Investment Information';

  @override
  String get purchaseDate => 'Purchase Date';

  @override
  String get purchaseAmount => 'Purchase Amount';

  @override
  String get daysInInvestment => 'Days in Investment';

  @override
  String get interestEarned => 'Interest Earned';

  @override
  String get redemptionDate => 'Redemption Date';

  @override
  String get digitalFreedomGateway => 'Digital Freedom Gateway';

  @override
  String get connection => 'Connection';

  @override
  String get calibrationScreenComingSoon => 'Calibration screen coming soon';

  @override
  String get mediaManagementComingSoon => 'Media management coming soon';

  @override
  String get lienSearch => 'Lien Search';

  @override
  String get searching => 'Searching...';

  @override
  String get noSearchHistory => 'No search history';

  @override
  String get clearSearchHistory => 'Clear search history';

  @override
  String get searchHistory => 'Search History';

  @override
  String get recentSearches => 'Recent Searches';

  @override
  String get purchase => 'Purchase';

  @override
  String get searchHistoryEmpty => 'Search history is empty';

  @override
  String get searchQueriesWillAppearHere =>
      'Your search queries will appear here';

  @override
  String get nothingFound => 'Nothing found';

  @override
  String get tryChangingSearchQuery => 'Try changing your search query';

  @override
  String foundLiensCount(int count) {
    return 'Found: $count liens';
  }

  @override
  String daysAgo(int days) {
    return '$days days ago';
  }

  @override
  String hoursAgo(int hours) {
    return '$hours hours ago';
  }

  @override
  String minutesAgo(int minutes) {
    return '$minutes minutes ago';
  }

  @override
  String get justNow => 'Just now';
}
