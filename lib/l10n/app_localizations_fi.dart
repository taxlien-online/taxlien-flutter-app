// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get appTitle => 'TaxLien.online';

  @override
  String get systemStatus => 'Järjestelmän Tila';

  @override
  String get playback => 'Toisto';

  @override
  String get stopped => 'Pysähtynyt';

  @override
  String get file => 'Tiedosto';

  @override
  String get position => 'Sijainti';

  @override
  String get seconds => 'sek';

  @override
  String get playbackControls => 'Toistokontrollit';

  @override
  String get play => 'Toista';

  @override
  String get pause => 'Tauko';

  @override
  String get stop => 'Pysäytä';

  @override
  String get volume => 'Äänenvoimakkuus';

  @override
  String get projectionSettings => 'Projektioasetukset';

  @override
  String get brightness => 'Kirkkaus';

  @override
  String get rotation => 'Kierto';

  @override
  String get mediaFiles => 'Mediatiedostot';

  @override
  String get image => 'Kuva';

  @override
  String get calibration => 'Kalibrointi';

  @override
  String get calibrationTitle => 'Projektion Kalibrointi';

  @override
  String get preview => 'Esikatselu';

  @override
  String get offset => 'Siirtymä';

  @override
  String get xOffset => 'X Siirtymä';

  @override
  String get yOffset => 'Y Siirtymä';

  @override
  String get scaleRotation => 'Skaala ja Kierto';

  @override
  String get scale => 'Skaala';

  @override
  String get apply => 'Käytä';

  @override
  String get reset => 'Nollaa';

  @override
  String get calibrationApplied => 'Kalibrointi käytetty';

  @override
  String get online => 'ONLINE';

  @override
  String get offline => 'OFFLINE';

  @override
  String get languageSettings => 'Kieliasetukset';

  @override
  String get languageChanged => 'Kieli vaihdettu';

  @override
  String get onboardingWelcomeTitle => 'Tervetuloa TaxLien.online';

  @override
  String get onboardingWelcomeDescription =>
      'Porttisi digitaaliseen vapauteen ja henkiseen yhteyteen';

  @override
  String get onboardingConnectionTitle => 'Yhdistä FreeDomeen';

  @override
  String get onboardingConnectionDescription =>
      'Muodosta turvallinen yhteys FreeDome-verkkoosi';

  @override
  String get onboardingDomeControlTitle => 'Kupolin Ohjaus';

  @override
  String get onboardingDomeControlDescription =>
      'Hallitse kupolin asetuksia ja konfiguraatioita';

  @override
  String get onboardingCalibrationTitle => 'Kalibrointi';

  @override
  String get onboardingCalibrationDescription =>
      'Kalibroi kupolisi optimaalista suorituskykyä varten';

  @override
  String get onboardingMediaTitle => 'Median Hallinta';

  @override
  String get onboardingMediaDescription =>
      'Lataa ja hallitse mediatiedostojasi';

  @override
  String get onboardingReadyTitle => 'Olet Valmis!';

  @override
  String get onboardingReadyDescription =>
      'Aloita matkasi digitaaliseen vapauteen';

  @override
  String get next => 'Seuraava';

  @override
  String get back => 'Takaisin';

  @override
  String get skip => 'Ohita';

  @override
  String get getStarted => 'Aloita';

  @override
  String get skipConfirmationTitle => 'Ohita Onboarding?';

  @override
  String get skipConfirmationMessage =>
      'Oletko varma, että haluat ohittaa onboardingin? Voit aina käyttää opastusta myöhemmin asetuksista.';

  @override
  String get cancel => 'Peruuta';

  @override
  String get connectingToFreedome => 'Yhdistetään FreeDomeen...';

  @override
  String get domeStatusActive => 'Kupolin Tila: Aktiivinen';

  @override
  String get open => 'Avaa';

  @override
  String get close => 'Sulje';

  @override
  String get calibrationProgress => 'Kalibroinnin Edistyminen';

  @override
  String mediaFilesCount(int count) {
    return 'Mediatiedostot: $count kohdetta';
  }

  @override
  String get upload => 'Lataa';

  @override
  String get manage => 'Hallitse';

  @override
  String get serverSettings => 'Palvelinasetukset';

  @override
  String get connectionStatus => 'Yhteystila';

  @override
  String get russian => 'Venäjä';

  @override
  String get ukrainian => 'Ukraina';

  @override
  String get english => 'English';

  @override
  String get chinese => 'Chinese';

  @override
  String get hindi => 'Hindi';

  @override
  String get thai => 'Thai';

  @override
  String dataLoadError(String error) {
    return 'Tietojen latausvirhe: $error';
  }

  @override
  String get taxLienMarketplace => 'Veropanttien Markkinapaikka';

  @override
  String get filters => 'Suodattimet';

  @override
  String get refresh => 'Päivitä';

  @override
  String get searchHint =>
      'Etsi osoitteen, omistajan tai tontin ID:n perusteella...';

  @override
  String get clear => 'Tyhjennä';

  @override
  String foundLiens(int count) {
    return 'Löydetty: $count panttia';
  }

  @override
  String sortBy(String sortLabel) {
    return 'Järjestä: $sortLabel';
  }

  @override
  String get retry => 'Yritä uudelleen';

  @override
  String get noLiensFound => 'Veropantteja ei löytynyt';

  @override
  String get tryChangingSearch =>
      'Kokeile muuttaa haun parametreja tai suodattimia';

  @override
  String stateFilter(String state) {
    return 'Osavaltio: $state';
  }

  @override
  String countyFilter(String county) {
    return 'Piirikunta: $county';
  }

  @override
  String amountFrom(String amount) {
    return 'Alkaen: $amount';
  }

  @override
  String amountTo(String amount) {
    return 'Asti: $amount';
  }

  @override
  String interestRateFrom(String rate) {
    return 'Korko alkaen: $rate%';
  }

  @override
  String auctionDateSort(String direction) {
    return 'Huutokauppapäivä $direction';
  }

  @override
  String taxAmountSort(String direction) {
    return 'Verosumma $direction';
  }

  @override
  String interestRateSort(String direction) {
    return 'Korko $direction';
  }

  @override
  String assessedValueSort(String direction) {
    return 'Arvioitu arvo $direction';
  }

  @override
  String redemptionDeadlineSort(String direction) {
    return 'Lunastusmääräaika $direction';
  }

  @override
  String lienNumber(String parcelId) {
    return 'Pantti #$parcelId';
  }

  @override
  String owner(String owner) {
    return 'Omistaja: $owner';
  }

  @override
  String get taxAmount => 'Verosumma';

  @override
  String get interestRate => 'Korko';

  @override
  String get assessedValue => 'Arvioitu arvo';

  @override
  String get auctionDate => 'Huutokauppapäivä';

  @override
  String get additionalInfo => 'Lisätiedot';

  @override
  String get county => 'Piirikunta';

  @override
  String get state => 'Osavaltio';

  @override
  String get redemptionDeadline => 'Lunastusmääräaika';

  @override
  String get status => 'Tila';

  @override
  String get buyLien => 'Osta Pantti';

  @override
  String get availableForPurchase => 'Ostettavissa';

  @override
  String get sold => 'Myyty';

  @override
  String get redeemed => 'Lunastettu';

  @override
  String get foreclosed => 'Ulosmitattu';

  @override
  String get purchaseLien => 'Pantin ostaminen';

  @override
  String enterBidAmount(String amount) {
    return 'Syötä tarjoussumma (vähintään $amount):';
  }

  @override
  String get bidAmount => 'Tarjoussumma';

  @override
  String get lienPurchasedSuccessfully => 'Pantti ostettu onnistuneesti!';

  @override
  String get purchaseError => 'Ostovirhe';

  @override
  String get invalidBidAmount => 'Virheellinen tarjoussumma';

  @override
  String get buy => 'Osta';

  @override
  String get profile => 'Profiili';

  @override
  String get settings => 'Asetukset';

  @override
  String get notAuthorized => 'Ei valtuutettu';

  @override
  String get loginForAccess => 'Kirjaudu sisään saadaksesi pääsy toimintoihin';

  @override
  String get login => 'Kirjaudu sisään';

  @override
  String get register => 'Rekisteröidy';

  @override
  String get edit => 'Muokkaa';

  @override
  String get logout => 'Kirjaudu ulos';

  @override
  String get balance => 'Saldo';

  @override
  String get available => 'Saatavilla';

  @override
  String get topUp => 'Täytä';

  @override
  String get quickActions => 'Pikatoiminnot';

  @override
  String get transactionHistory => 'Tapahtumahistoria';

  @override
  String get viewAllTransactions => 'Katso kaikki tapahtumat';

  @override
  String get favoriteLiens => 'Suosikki Pantit';

  @override
  String get savedLiens => 'Tallennetut panttisi';

  @override
  String get notifications => 'Ilmoitukset';

  @override
  String get notificationSettings => 'Ilmoitusasetukset';

  @override
  String get help => 'Ohje';

  @override
  String get appSettings => 'Sovelluksen asetukset';

  @override
  String get language => 'Kieli';

  @override
  String get theme => 'Teema';

  @override
  String get dark => 'Tumma';

  @override
  String get light => 'Vaalea';

  @override
  String get security => 'Turvallisuus';

  @override
  String get securitySettings => 'Turvallisuusasetukset';

  @override
  String get privacy => 'Yksityisyys';

  @override
  String get privacySettings => 'Yksityisyysasetukset';

  @override
  String get aboutApp => 'Sovelluksesta';

  @override
  String get version => 'Versio';

  @override
  String get license => 'Lisenssi';

  @override
  String get termsOfService => 'Käyttöehdot';

  @override
  String get userAgreement => 'Käyttäjäsopimus';

  @override
  String get privacyPolicy => 'Tietosuojakäytäntö';

  @override
  String get dataProcessing => 'Henkilötietojen käsittely';

  @override
  String get loginToAccount => 'Kirjaudu tilille';

  @override
  String get password => 'Salasana';

  @override
  String get loginSuccessful => 'Sisäänkirjautuminen onnistui!';

  @override
  String get loginError => 'Sisäänkirjautumisvirhe';

  @override
  String get registration => 'Rekisteröityminen';

  @override
  String get firstName => 'Etunimi';

  @override
  String get lastName => 'Sukunimi';

  @override
  String get registrationSuccessful => 'Rekisteröityminen onnistui!';

  @override
  String get registrationError => 'Rekisteröitymisvirhe';

  @override
  String get registerAccount => 'Rekisteröidy';

  @override
  String get logoutConfirmation => 'Uloskirjautumisen vahvistus';

  @override
  String get logoutConfirmationMessage =>
      'Oletko varma, että haluat kirjautua ulos?';

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
