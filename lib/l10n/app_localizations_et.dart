// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Estonian (`et`).
class AppLocalizationsEt extends AppLocalizations {
  AppLocalizationsEt([String locale = 'et']) : super(locale);

  @override
  String get appTitle => 'TaxLien.online';

  @override
  String get systemStatus => 'Süsteemi Olek';

  @override
  String get playback => 'Taasesitus';

  @override
  String get stopped => 'Peatatud';

  @override
  String get file => 'Fail';

  @override
  String get position => 'Positsioon';

  @override
  String get seconds => 'sek';

  @override
  String get playbackControls => 'Taasesituse Juhtimine';

  @override
  String get play => 'Mängi';

  @override
  String get pause => 'Paus';

  @override
  String get stop => 'Peata';

  @override
  String get volume => 'Helitugevus';

  @override
  String get projectionSettings => 'Projektsiooni Seaded';

  @override
  String get brightness => 'Heledus';

  @override
  String get rotation => 'Pööramine';

  @override
  String get mediaFiles => 'Meediafailid';

  @override
  String get image => 'Pilt';

  @override
  String get calibration => 'Kalibreerimine';

  @override
  String get calibrationTitle => 'Projektsiooni Kalibreerimine';

  @override
  String get preview => 'Eelvaade';

  @override
  String get offset => 'Nihe';

  @override
  String get xOffset => 'X Nihe';

  @override
  String get yOffset => 'Y Nihe';

  @override
  String get scaleRotation => 'Skaala ja Pööramine';

  @override
  String get scale => 'Skaala';

  @override
  String get apply => 'Rakenda';

  @override
  String get reset => 'Lähtesta';

  @override
  String get calibrationApplied => 'Kalibreerimine rakendatud';

  @override
  String get online => 'ONLINE';

  @override
  String get offline => 'OFFLINE';

  @override
  String get languageSettings => 'Keele Seaded';

  @override
  String get languageChanged => 'Keel muudetud';

  @override
  String get onboardingWelcomeTitle => 'Tere tulemast TaxLien.online';

  @override
  String get onboardingWelcomeDescription =>
      'Teie värav digitaalsesse vabadusse ja vaimsesse ühendusse';

  @override
  String get onboardingConnectionTitle => 'Ühenda FreeDomega';

  @override
  String get onboardingConnectionDescription =>
      'Loo turvaline ühendus oma FreeDome võrku';

  @override
  String get onboardingDomeControlTitle => 'Kupoli Juhtimine';

  @override
  String get onboardingDomeControlDescription =>
      'Juhtige oma kupoli seadeid ja konfiguratsioone';

  @override
  String get onboardingCalibrationTitle => 'Kalibreerimine';

  @override
  String get onboardingCalibrationDescription =>
      'Kalibreerige oma kupol optimaalse jõudluse jaoks';

  @override
  String get onboardingMediaTitle => 'Meedia Haldamine';

  @override
  String get onboardingMediaDescription =>
      'Laadige üles ja hallake oma meediafaile';

  @override
  String get onboardingReadyTitle => 'Oled Valmis!';

  @override
  String get onboardingReadyDescription =>
      'Alustage oma teekonda digitaalsesse vabadusse';

  @override
  String get next => 'Järgmine';

  @override
  String get back => 'Tagasi';

  @override
  String get skip => 'Vahele jäta';

  @override
  String get getStarted => 'Alusta';

  @override
  String get skipConfirmationTitle => 'Vahele jäta Onboarding?';

  @override
  String get skipConfirmationMessage =>
      'Oled kindel, et soovid onboardingi vahele jätta? Saad alati hiljem juhendile ligi pääseda seadetest.';

  @override
  String get cancel => 'Tühista';

  @override
  String get connectingToFreedome => 'Ühendatakse FreeDomega...';

  @override
  String get domeStatusActive => 'Kupoli Olek: Aktiivne';

  @override
  String get open => 'Ava';

  @override
  String get close => 'Sulge';

  @override
  String get calibrationProgress => 'Kalibreerimise Edenemine';

  @override
  String mediaFilesCount(int count) {
    return 'Meediafailid: $count elementi';
  }

  @override
  String get upload => 'Laadi üles';

  @override
  String get manage => 'Halda';

  @override
  String get serverSettings => 'Serveri Seaded';

  @override
  String get connectionStatus => 'Ühenduse Olek';

  @override
  String get russian => 'Vene';

  @override
  String get ukrainian => 'Ukraina';

  @override
  String dataLoadError(String error) {
    return 'Andmete laadimise viga: $error';
  }

  @override
  String get taxLienMarketplace => 'Maksu Lienside Turg';

  @override
  String get filters => 'Filtrid';

  @override
  String get refresh => 'Värskenda';

  @override
  String get searchHint => 'Otsi aadressi, omaniku või krundi ID järgi...';

  @override
  String get clear => 'Tühjenda';

  @override
  String foundLiens(int count) {
    return 'Leitud: $count liensi';
  }

  @override
  String sortBy(String sortLabel) {
    return 'Sorteeri: $sortLabel';
  }

  @override
  String get retry => 'Proovi uuesti';

  @override
  String get noLiensFound => 'Maksu liensi ei leitud';

  @override
  String get tryChangingSearch =>
      'Proovi muuta otsingu parameetreid või filtreid';

  @override
  String stateFilter(String state) {
    return 'Osariik: $state';
  }

  @override
  String countyFilter(String county) {
    return 'Maakond: $county';
  }

  @override
  String amountFrom(String amount) {
    return 'Alates: $amount';
  }

  @override
  String amountTo(String amount) {
    return 'Kuni: $amount';
  }

  @override
  String interestRateFrom(String rate) {
    return 'Intressimäär alates: $rate%';
  }

  @override
  String auctionDateSort(String direction) {
    return 'Oksjoni kuupäev $direction';
  }

  @override
  String taxAmountSort(String direction) {
    return 'Maksu summa $direction';
  }

  @override
  String interestRateSort(String direction) {
    return 'Intressimäär $direction';
  }

  @override
  String assessedValueSort(String direction) {
    return 'Hinnatud väärtus $direction';
  }

  @override
  String redemptionDeadlineSort(String direction) {
    return 'Lunastamise tähtaeg $direction';
  }

  @override
  String lienNumber(String parcelId) {
    return 'Liens #$parcelId';
  }

  @override
  String owner(String owner) {
    return 'Omanik: $owner';
  }

  @override
  String get taxAmount => 'Maksu summa';

  @override
  String get interestRate => 'Intressimäär';

  @override
  String get assessedValue => 'Hinnatud väärtus';

  @override
  String get auctionDate => 'Oksjoni kuupäev';

  @override
  String get additionalInfo => 'Lisaandmed';

  @override
  String get county => 'Maakond';

  @override
  String get state => 'Osariik';

  @override
  String get redemptionDeadline => 'Lunastamise tähtaeg';

  @override
  String get status => 'Olek';

  @override
  String get buyLien => 'Osta Liens';

  @override
  String get availableForPurchase => 'Ostmiseks saadaval';

  @override
  String get sold => 'Müüdud';

  @override
  String get redeemed => 'Lunastatud';

  @override
  String get foreclosed => 'Konfiskeeritud';

  @override
  String get purchaseLien => 'Liensi ostmine';

  @override
  String enterBidAmount(String amount) {
    return 'Sisesta pakkumise summa (miinimum $amount):';
  }

  @override
  String get bidAmount => 'Pakkumise summa';

  @override
  String get lienPurchasedSuccessfully => 'Liens ostetud edukalt!';

  @override
  String get purchaseError => 'Ostmise viga';

  @override
  String get invalidBidAmount => 'Vigane pakkumise summa';

  @override
  String get buy => 'Osta';

  @override
  String get profile => 'Profiil';

  @override
  String get settings => 'Seaded';

  @override
  String get notAuthorized => 'Pole autoriseeritud';

  @override
  String get loginForAccess => 'Logi sisse funktsioonidele ligipääsu saamiseks';

  @override
  String get login => 'Logi sisse';

  @override
  String get register => 'Registreeri';

  @override
  String get edit => 'Redigeeri';

  @override
  String get logout => 'Logi välja';

  @override
  String get balance => 'Saldo';

  @override
  String get available => 'Saadaval';

  @override
  String get topUp => 'Täienda';

  @override
  String get quickActions => 'Kiirtegevused';

  @override
  String get transactionHistory => 'Tehingute ajalugu';

  @override
  String get viewAllTransactions => 'Vaata kõiki tehinguid';

  @override
  String get favoriteLiens => 'Lemmik Liensid';

  @override
  String get savedLiens => 'Teie salvestatud liensid';

  @override
  String get notifications => 'Teated';

  @override
  String get notificationSettings => 'Teatete seaded';

  @override
  String get help => 'Abi';

  @override
  String get appSettings => 'Rakenduse seaded';

  @override
  String get language => 'Keel';

  @override
  String get theme => 'Teema';

  @override
  String get dark => 'Tume';

  @override
  String get light => 'Hele';

  @override
  String get security => 'Turvalisus';

  @override
  String get securitySettings => 'Turvalisuse seaded';

  @override
  String get privacy => 'Privaatsus';

  @override
  String get privacySettings => 'Privaatsuse seaded';

  @override
  String get aboutApp => 'Rakenduse kohta';

  @override
  String get version => 'Versioon';

  @override
  String get license => 'Litsents';

  @override
  String get termsOfService => 'Kasutustingimused';

  @override
  String get userAgreement => 'Kasutajaleping';

  @override
  String get privacyPolicy => 'Privaatsuspoliitika';

  @override
  String get dataProcessing => 'Isiklike andmete töötlemine';

  @override
  String get loginToAccount => 'Logi kontole sisse';

  @override
  String get password => 'Parool';

  @override
  String get loginSuccessful => 'Sisselogimine õnnestus!';

  @override
  String get loginError => 'Sisselogimise viga';

  @override
  String get registration => 'Registreerimine';

  @override
  String get firstName => 'Eesnimi';

  @override
  String get lastName => 'Perekonnanimi';

  @override
  String get registrationSuccessful => 'Registreerimine õnnestus!';

  @override
  String get registrationError => 'Registreerimise viga';

  @override
  String get registerAccount => 'Registreeri';

  @override
  String get logoutConfirmation => 'Väljalogimise kinnitamine';

  @override
  String get logoutConfirmationMessage =>
      'Oled kindel, et soovid välja logida?';

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
