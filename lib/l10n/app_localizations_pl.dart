// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'TaxLien.online';

  @override
  String get systemStatus => 'Status systemu';

  @override
  String get playback => 'Odtwarzanie';

  @override
  String get stopped => 'Zatrzymane';

  @override
  String get file => 'Plik';

  @override
  String get position => 'Pozycja';

  @override
  String get seconds => 'sek';

  @override
  String get playbackControls => 'Sterowanie odtwarzaniem';

  @override
  String get play => 'Play';

  @override
  String get pause => 'Pause';

  @override
  String get stop => 'Stop';

  @override
  String get volume => 'Głośność';

  @override
  String get projectionSettings => 'Ustawienia projekcji';

  @override
  String get brightness => 'Jasność';

  @override
  String get rotation => 'Obrót';

  @override
  String get mediaFiles => 'Pliki multimedialne';

  @override
  String get image => 'Obraz';

  @override
  String get calibration => 'Kalibracja';

  @override
  String get calibrationTitle => 'Kalibracja projekcji';

  @override
  String get preview => 'Podgląd';

  @override
  String get offset => 'Przesunięcie';

  @override
  String get xOffset => 'Przesunięcie X';

  @override
  String get yOffset => 'Przesunięcie Y';

  @override
  String get scaleRotation => 'Skala i obrót';

  @override
  String get scale => 'Skala';

  @override
  String get apply => 'Zastosuj';

  @override
  String get reset => 'Resetuj';

  @override
  String get calibrationApplied => 'Kalibracja zastosowana';

  @override
  String get online => 'ONLINE';

  @override
  String get offline => 'OFFLINE';

  @override
  String get languageSettings => 'Ustawienia języka';

  @override
  String get languageChanged => 'Język zmieniony';

  @override
  String get onboardingWelcomeTitle => 'Witamy w TaxLien.online';

  @override
  String get onboardingWelcomeDescription =>
      'Twoja brama do cyfrowej wolności i duchowego połączenia';

  @override
  String get onboardingConnectionTitle => 'Połącz z FreeDome';

  @override
  String get onboardingConnectionDescription =>
      'Nawiąż bezpieczne połączenie z siecią FreeDome';

  @override
  String get onboardingDomeControlTitle => 'Sterowanie kopułą';

  @override
  String get onboardingDomeControlDescription =>
      'Steruj ustawieniami i konfiguracjami swojej kopuły';

  @override
  String get onboardingCalibrationTitle => 'Kalibracja';

  @override
  String get onboardingCalibrationDescription =>
      'Skalibruj swoją kopułę dla optymalnej wydajności';

  @override
  String get onboardingMediaTitle => 'Zarządzanie mediami';

  @override
  String get onboardingMediaDescription =>
      'Prześlij i zarządzaj plikami multimedialnymi';

  @override
  String get onboardingReadyTitle => 'Jesteś gotowy!';

  @override
  String get onboardingReadyDescription =>
      'Rozpocznij swoją podróż do cyfrowej wolności';

  @override
  String get next => 'Dalej';

  @override
  String get back => 'Wstecz';

  @override
  String get skip => 'Pomiń';

  @override
  String get getStarted => 'Rozpocznij';

  @override
  String get skipConfirmationTitle => 'Pomiń onboarding?';

  @override
  String get skipConfirmationMessage =>
      'Czy na pewno chcesz pominąć onboarding? Zawsze możesz uzyskać dostęp do samouczka później z ustawień.';

  @override
  String get cancel => 'Anuluj';

  @override
  String get connectingToFreedome => 'Łączenie z FreeDome...';

  @override
  String get domeStatusActive => 'Status kopuły: Aktywna';

  @override
  String get open => 'Otwórz';

  @override
  String get close => 'Zamknij';

  @override
  String get calibrationProgress => 'Postęp kalibracji';

  @override
  String mediaFilesCount(int count) {
    return 'Pliki multimedialne: $count elementów';
  }

  @override
  String get upload => 'Prześlij';

  @override
  String get manage => 'Zarządzaj';

  @override
  String get serverSettings => 'Ustawienia serwera';

  @override
  String get connectionStatus => 'Status połączenia';

  @override
  String get russian => 'Rosyjski';

  @override
  String get ukrainian => 'Ukraiński';

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
    return 'Błąd ładowania danych: $error';
  }

  @override
  String get taxLienMarketplace => 'Rynek zastawów podatkowych';

  @override
  String get filters => 'Filtry';

  @override
  String get refresh => 'Odśwież';

  @override
  String get searchHint =>
      'Szukaj według adresu, właściciela lub ID działki...';

  @override
  String get clear => 'Wyczyść';

  @override
  String foundLiens(int count) {
    return 'Znaleziono: $count zastawów';
  }

  @override
  String sortBy(String sortLabel) {
    return 'Sortuj według: $sortLabel';
  }

  @override
  String get retry => 'Ponów';

  @override
  String get noLiensFound => 'Nie znaleziono zastawów podatkowych';

  @override
  String get tryChangingSearch =>
      'Spróbuj zmienić parametry wyszukiwania lub filtry';

  @override
  String stateFilter(String state) {
    return 'Stan: $state';
  }

  @override
  String countyFilter(String county) {
    return 'Hrabstwo: $county';
  }

  @override
  String amountFrom(String amount) {
    return 'Od: $amount';
  }

  @override
  String amountTo(String amount) {
    return 'Do: $amount';
  }

  @override
  String interestRateFrom(String rate) {
    return 'Stawka od: $rate%';
  }

  @override
  String auctionDateSort(String direction) {
    return 'Data aukcji $direction';
  }

  @override
  String taxAmountSort(String direction) {
    return 'Kwota podatku $direction';
  }

  @override
  String interestRateSort(String direction) {
    return 'Stawka procentowa $direction';
  }

  @override
  String assessedValueSort(String direction) {
    return 'Wartość szacunkowa $direction';
  }

  @override
  String redemptionDeadlineSort(String direction) {
    return 'Termin wykupu $direction';
  }

  @override
  String lienNumber(String parcelId) {
    return 'Zastaw #$parcelId';
  }

  @override
  String owner(String owner) {
    return 'Właściciel: $owner';
  }

  @override
  String get taxAmount => 'Kwota podatku';

  @override
  String get interestRate => 'Stawka procentowa';

  @override
  String get assessedValue => 'Wartość szacunkowa';

  @override
  String get auctionDate => 'Data aukcji';

  @override
  String get additionalInfo => 'Dodatkowe informacje';

  @override
  String get county => 'Hrabstwo';

  @override
  String get state => 'Stan';

  @override
  String get redemptionDeadline => 'Termin wykupu';

  @override
  String get status => 'Status';

  @override
  String get buyLien => 'Kup zastaw';

  @override
  String get availableForPurchase => 'Dostępny do zakupu';

  @override
  String get sold => 'Sprzedany';

  @override
  String get redeemed => 'Wykupiony';

  @override
  String get foreclosed => 'Przejęty';

  @override
  String get purchaseLien => 'Kup zastaw';

  @override
  String enterBidAmount(String amount) {
    return 'Wprowadź kwotę oferty (minimum $amount):';
  }

  @override
  String get bidAmount => 'Kwota oferty';

  @override
  String get lienPurchasedSuccessfully => 'Zastaw kupiony pomyślnie!';

  @override
  String get purchaseError => 'Błąd zakupu';

  @override
  String get invalidBidAmount => 'Nieprawidłowa kwota oferty';

  @override
  String get buy => 'Kup';

  @override
  String get profile => 'Profil';

  @override
  String get settings => 'Ustawienia';

  @override
  String get notAuthorized => 'Nieautoryzowany';

  @override
  String get loginForAccess => 'Zaloguj się, aby uzyskać dostęp do funkcji';

  @override
  String get login => 'Zaloguj';

  @override
  String get register => 'Zarejestruj';

  @override
  String get edit => 'Edytuj';

  @override
  String get logout => 'Wyloguj';

  @override
  String get balance => 'Saldo';

  @override
  String get available => 'Dostępne';

  @override
  String get topUp => 'Doładuj';

  @override
  String get quickActions => 'Szybkie akcje';

  @override
  String get transactionHistory => 'Historia transakcji';

  @override
  String get viewAllTransactions => 'Zobacz wszystkie transakcje';

  @override
  String get favoriteLiens => 'Ulubione zastawy';

  @override
  String get savedLiens => 'Twoje zapisane zastawy';

  @override
  String get notifications => 'Powiadomienia';

  @override
  String get notificationSettings => 'Ustawienia powiadomień';

  @override
  String get help => 'Pomoc';

  @override
  String get appSettings => 'Ustawienia aplikacji';

  @override
  String get language => 'Język';

  @override
  String get theme => 'Motyw';

  @override
  String get dark => 'Ciemny';

  @override
  String get light => 'Jasny';

  @override
  String get security => 'Bezpieczeństwo';

  @override
  String get securitySettings => 'Ustawienia bezpieczeństwa';

  @override
  String get privacy => 'Prywatność';

  @override
  String get privacySettings => 'Ustawienia prywatności';

  @override
  String get aboutApp => 'O aplikacji';

  @override
  String get version => 'Wersja';

  @override
  String get license => 'Licencja';

  @override
  String get termsOfService => 'Warunki korzystania';

  @override
  String get userAgreement => 'Umowa użytkownika';

  @override
  String get privacyPolicy => 'Polityka prywatności';

  @override
  String get dataProcessing => 'Przetwarzanie danych osobowych';

  @override
  String get loginToAccount => 'Zaloguj do konta';

  @override
  String get password => 'Hasło';

  @override
  String get loginSuccessful => 'Logowanie pomyślne!';

  @override
  String get loginError => 'Błąd logowania';

  @override
  String get registration => 'Rejestracja';

  @override
  String get firstName => 'Imię';

  @override
  String get lastName => 'Nazwisko';

  @override
  String get registrationSuccessful => 'Rejestracja pomyślna!';

  @override
  String get registrationError => 'Błąd rejestracji';

  @override
  String get registerAccount => 'Zarejestruj';

  @override
  String get logoutConfirmation => 'Potwierdzenie wylogowania';

  @override
  String get logoutConfirmationMessage => 'Czy na pewno chcesz się wylogować?';

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
