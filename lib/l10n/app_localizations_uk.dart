// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'TaxLien.online';

  @override
  String get systemStatus => 'Статус системи';

  @override
  String get playback => 'Відтворення';

  @override
  String get stopped => 'Зупинено';

  @override
  String get file => 'Файл';

  @override
  String get position => 'Позиція';

  @override
  String get seconds => 'сек';

  @override
  String get playbackControls => 'Управління відтворенням';

  @override
  String get play => 'Відтворити';

  @override
  String get pause => 'Пауза';

  @override
  String get stop => 'Стоп';

  @override
  String get volume => 'Гучність';

  @override
  String get projectionSettings => 'Налаштування проекції';

  @override
  String get brightness => 'Яскравість';

  @override
  String get rotation => 'Поворот';

  @override
  String get mediaFiles => 'Медіафайли';

  @override
  String get image => 'Зображення';

  @override
  String get calibration => 'Калібрування';

  @override
  String get calibrationTitle => 'Калібрування проекції';

  @override
  String get preview => 'Попередній перегляд';

  @override
  String get offset => 'Зміщення';

  @override
  String get xOffset => 'Зміщення по X';

  @override
  String get yOffset => 'Зміщення по Y';

  @override
  String get scaleRotation => 'Масштаб і поворот';

  @override
  String get scale => 'Масштаб';

  @override
  String get apply => 'Застосувати';

  @override
  String get reset => 'Скинути';

  @override
  String get calibrationApplied => 'Калібрування застосовано';

  @override
  String get online => 'ПІДКЛЮЧЕНО';

  @override
  String get offline => 'ВІДКЛЮЧЕНО';

  @override
  String get languageSettings => 'Налаштування мови';

  @override
  String get languageChanged => 'Мову змінено';

  @override
  String get onboardingWelcomeTitle => 'Ласкаво просимо до TaxLien.online';

  @override
  String get onboardingWelcomeDescription =>
      'Ваш шлях до цифрової свободи та духовного зв\'язку';

  @override
  String get onboardingConnectionTitle => 'Підключення до FreeDome';

  @override
  String get onboardingConnectionDescription =>
      'Встановіть безпечне підключення до вашої мережі FreeDome';

  @override
  String get onboardingDomeControlTitle => 'Управління куполом';

  @override
  String get onboardingDomeControlDescription =>
      'Управляйте налаштуваннями та конфігураціями вашого купола';

  @override
  String get onboardingCalibrationTitle => 'Калібрування';

  @override
  String get onboardingCalibrationDescription =>
      'Відкалібруйте ваш купол для оптимальної продуктивності';

  @override
  String get onboardingMediaTitle => 'Управління медіа';

  @override
  String get onboardingMediaDescription =>
      'Завантажуйте та управляйте вашими медіафайлами';

  @override
  String get onboardingReadyTitle => 'Ви готові!';

  @override
  String get onboardingReadyDescription =>
      'Почніть ваш шлях до цифрової свободи';

  @override
  String get next => 'Далі';

  @override
  String get back => 'Назад';

  @override
  String get skip => 'Пропустити';

  @override
  String get getStarted => 'Почати';

  @override
  String get skipConfirmationTitle => 'Пропустити онбординг?';

  @override
  String get skipConfirmationMessage =>
      'Ви впевнені, що хочете пропустити онбординг? Ви завжди можете отримати доступ до посібника пізніше з налаштувань.';

  @override
  String get cancel => 'Скасувати';

  @override
  String get connectingToFreedome => 'Підключення до FreeDome...';

  @override
  String get domeStatusActive => 'Статус купола: Активний';

  @override
  String get open => 'Відкрити';

  @override
  String get close => 'Закрити';

  @override
  String get calibrationProgress => 'Прогрес калібрування';

  @override
  String mediaFilesCount(int count) {
    return 'Медіафайли: $count елементів';
  }

  @override
  String get upload => 'Завантажити';

  @override
  String get manage => 'Керувати';

  @override
  String get serverSettings => 'Налаштування сервера';

  @override
  String get connectionStatus => 'Статус підключення';

  @override
  String get russian => 'Російська';

  @override
  String get ukrainian => 'Українська';

  @override
  String dataLoadError(String error) {
    return 'Помилка завантаження даних: $error';
  }

  @override
  String get taxLienMarketplace => 'Ринок податкових застав';

  @override
  String get filters => 'Фільтри';

  @override
  String get refresh => 'Оновити';

  @override
  String get searchHint => 'Пошук за адресою, власником або ID ділянки...';

  @override
  String get clear => 'Очистити';

  @override
  String foundLiens(int count) {
    return 'Знайдено: $count застав';
  }

  @override
  String sortBy(String sortLabel) {
    return 'Сортування: $sortLabel';
  }

  @override
  String get retry => 'Повторити';

  @override
  String get noLiensFound => 'Податкові застави не знайдено';

  @override
  String get tryChangingSearch =>
      'Спробуйте змінити параметри пошуку або фільтри';

  @override
  String stateFilter(String state) {
    return 'Штат: $state';
  }

  @override
  String countyFilter(String county) {
    return 'Округ: $county';
  }

  @override
  String amountFrom(String amount) {
    return 'Від: $amount';
  }

  @override
  String amountTo(String amount) {
    return 'До: $amount';
  }

  @override
  String interestRateFrom(String rate) {
    return 'Ставка від: $rate%';
  }

  @override
  String auctionDateSort(String direction) {
    return 'Дата аукціону $direction';
  }

  @override
  String taxAmountSort(String direction) {
    return 'Сума податку $direction';
  }

  @override
  String interestRateSort(String direction) {
    return 'Процентна ставка $direction';
  }

  @override
  String assessedValueSort(String direction) {
    return 'Оціночна вартість $direction';
  }

  @override
  String redemptionDeadlineSort(String direction) {
    return 'Строк погашення $direction';
  }

  @override
  String lienNumber(String parcelId) {
    return 'Заклад #$parcelId';
  }

  @override
  String owner(String owner) {
    return 'Власник: $owner';
  }

  @override
  String get taxAmount => 'Сума податку';

  @override
  String get interestRate => 'Процентна ставка';

  @override
  String get assessedValue => 'Оціночна вартість';

  @override
  String get auctionDate => 'Дата аукціону';

  @override
  String get additionalInfo => 'Додаткова інформація';

  @override
  String get county => 'Округ';

  @override
  String get state => 'Штат';

  @override
  String get redemptionDeadline => 'Строк погашення';

  @override
  String get status => 'Статус';

  @override
  String get buyLien => 'Купити заставу';

  @override
  String get availableForPurchase => 'Доступна для покупки';

  @override
  String get sold => 'Продана';

  @override
  String get redeemed => 'Погашена';

  @override
  String get foreclosed => 'Звернена у власність';

  @override
  String get purchaseLien => 'Покупка застави';

  @override
  String enterBidAmount(String amount) {
    return 'Введіть суму ставки (мінімум $amount):';
  }

  @override
  String get bidAmount => 'Сума ставки';

  @override
  String get lienPurchasedSuccessfully => 'Заставу успішно куплено!';

  @override
  String get purchaseError => 'Помилка при покупці';

  @override
  String get invalidBidAmount => 'Невірна сума ставки';

  @override
  String get buy => 'Купити';

  @override
  String get profile => 'Профіль';

  @override
  String get settings => 'Налаштування';

  @override
  String get notAuthorized => 'Не авторизовано';

  @override
  String get loginForAccess =>
      'Увійдіть в обліковий запис для доступу до функцій';

  @override
  String get login => 'Увійти';

  @override
  String get register => 'Реєстрація';

  @override
  String get edit => 'Редагувати';

  @override
  String get logout => 'Вийти';

  @override
  String get balance => 'Баланс';

  @override
  String get available => 'Доступно';

  @override
  String get topUp => 'Поповнити';

  @override
  String get quickActions => 'Швидкі дії';

  @override
  String get transactionHistory => 'Історія транзакцій';

  @override
  String get viewAllTransactions => 'Перегляд всіх операцій';

  @override
  String get favoriteLiens => 'Улюблені застави';

  @override
  String get savedLiens => 'Ваші збережені застави';

  @override
  String get notifications => 'Сповіщення';

  @override
  String get notificationSettings => 'Налаштування сповіщень';

  @override
  String get help => 'Допомога';

  @override
  String get appSettings => 'Налаштування додатку';

  @override
  String get language => 'Мова';

  @override
  String get theme => 'Тема';

  @override
  String get dark => 'Темна';

  @override
  String get light => 'Світла';

  @override
  String get security => 'Безпека';

  @override
  String get securitySettings => 'Налаштування безпеки';

  @override
  String get privacy => 'Конфіденційність';

  @override
  String get privacySettings => 'Налаштування приватності';

  @override
  String get aboutApp => 'Про додаток';

  @override
  String get version => 'Версія';

  @override
  String get license => 'Ліцензія';

  @override
  String get termsOfService => 'Умови використання';

  @override
  String get userAgreement => 'Користувацька угода';

  @override
  String get privacyPolicy => 'Політика конфіденційності';

  @override
  String get dataProcessing => 'Обробка персональних даних';

  @override
  String get loginToAccount => 'Вхід в обліковий запис';

  @override
  String get password => 'Пароль';

  @override
  String get loginSuccessful => 'Успішний вхід!';

  @override
  String get loginError => 'Помилка входу';

  @override
  String get registration => 'Реєстрація';

  @override
  String get firstName => 'Ім\'я';

  @override
  String get lastName => 'Прізвище';

  @override
  String get registrationSuccessful => 'Реєстрація успішна!';

  @override
  String get registrationError => 'Помилка реєстрації';

  @override
  String get registerAccount => 'Зареєструватися';

  @override
  String get logoutConfirmation => 'Вихід з облікового запису';

  @override
  String get logoutConfirmationMessage =>
      'Ви впевнені, що хочете вийти з облікового запису?';

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
