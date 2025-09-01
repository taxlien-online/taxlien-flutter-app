// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'TaxLien.online';

  @override
  String get systemStatus => 'Статус системы';

  @override
  String get playback => 'Воспроизведение';

  @override
  String get stopped => 'Остановлено';

  @override
  String get file => 'Файл';

  @override
  String get position => 'Позиция';

  @override
  String get seconds => 'сек';

  @override
  String get playbackControls => 'Управление воспроизведением';

  @override
  String get play => 'Воспроизвести';

  @override
  String get pause => 'Пауза';

  @override
  String get stop => 'Стоп';

  @override
  String get volume => 'Громкость';

  @override
  String get projectionSettings => 'Настройки проекции';

  @override
  String get brightness => 'Яркость';

  @override
  String get rotation => 'Поворот';

  @override
  String get mediaFiles => 'Медиафайлы';

  @override
  String get image => 'Изображение';

  @override
  String get calibration => 'Калибровка';

  @override
  String get calibrationTitle => 'Калибровка проекции';

  @override
  String get preview => 'Предварительный просмотр';

  @override
  String get offset => 'Смещение';

  @override
  String get xOffset => 'Смещение по X';

  @override
  String get yOffset => 'Смещение по Y';

  @override
  String get scaleRotation => 'Масштаб и поворот';

  @override
  String get scale => 'Масштаб';

  @override
  String get apply => 'Применить';

  @override
  String get reset => 'Сброс';

  @override
  String get calibrationApplied => 'Калибровка применена';

  @override
  String get online => 'ПОДКЛЮЧЕНО';

  @override
  String get offline => 'ОТКЛЮЧЕНО';

  @override
  String get languageSettings => 'Настройки языка';

  @override
  String get languageChanged => 'Язык изменен';

  @override
  String get onboardingWelcomeTitle => 'Добро пожаловать в TaxLien.online';

  @override
  String get onboardingWelcomeDescription =>
      'Ваш путь к цифровой свободе и духовной связи';

  @override
  String get onboardingConnectionTitle => 'Подключение к FreeDome';

  @override
  String get onboardingConnectionDescription =>
      'Установите безопасное подключение к вашей сети FreeDome';

  @override
  String get onboardingDomeControlTitle => 'Управление куполом';

  @override
  String get onboardingDomeControlDescription =>
      'Управляйте настройками и конфигурациями вашего купола';

  @override
  String get onboardingCalibrationTitle => 'Калибровка';

  @override
  String get onboardingCalibrationDescription =>
      'Откалибруйте ваш купол для оптимальной производительности';

  @override
  String get onboardingMediaTitle => 'Управление медиа';

  @override
  String get onboardingMediaDescription =>
      'Загружайте и управляйте вашими медиафайлами';

  @override
  String get onboardingReadyTitle => 'Вы готовы!';

  @override
  String get onboardingReadyDescription =>
      'Начните ваш путь к цифровой свободе';

  @override
  String get next => 'Далее';

  @override
  String get back => 'Назад';

  @override
  String get skip => 'Пропустить';

  @override
  String get getStarted => 'Начать';

  @override
  String get skipConfirmationTitle => 'Пропустить онбординг?';

  @override
  String get skipConfirmationMessage =>
      'Вы уверены, что хотите пропустить онбординг? Вы всегда можете получить доступ к руководству позже из настроек.';

  @override
  String get cancel => 'Отмена';

  @override
  String get connectingToFreedome => 'Подключение к FreeDome...';

  @override
  String get domeStatusActive => 'Статус купола: Активен';

  @override
  String get open => 'Открыть';

  @override
  String get close => 'Закрыть';

  @override
  String get calibrationProgress => 'Прогресс калибровки';

  @override
  String mediaFilesCount(int count) {
    return 'Медиафайлы: $count элементов';
  }

  @override
  String get upload => 'Загрузить';

  @override
  String get manage => 'Управлять';

  @override
  String get serverSettings => 'Настройки сервера';

  @override
  String get connectionStatus => 'Статус подключения';

  @override
  String get russian => 'Русский';

  @override
  String get ukrainian => 'Українська';

  @override
  String dataLoadError(String error) {
    return 'Ошибка загрузки данных: $error';
  }

  @override
  String get taxLienMarketplace => 'Рынок налоговых закладных';

  @override
  String get filters => 'Фильтры';

  @override
  String get refresh => 'Обновить';

  @override
  String get searchHint => 'Поиск по адресу, владельцу или ID участка...';

  @override
  String get clear => 'Очистить';

  @override
  String foundLiens(int count) {
    return 'Найдено: $count закладных';
  }

  @override
  String sortBy(String sortLabel) {
    return 'Сортировка: $sortLabel';
  }

  @override
  String get retry => 'Повторить';

  @override
  String get noLiensFound => 'Налоговые закладные не найдены';

  @override
  String get tryChangingSearch =>
      'Попробуйте изменить параметры поиска или фильтры';

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
    return 'От: $amount';
  }

  @override
  String amountTo(String amount) {
    return 'До: $amount';
  }

  @override
  String interestRateFrom(String rate) {
    return 'Ставка от: $rate%';
  }

  @override
  String auctionDateSort(String direction) {
    return 'Дата аукциона $direction';
  }

  @override
  String taxAmountSort(String direction) {
    return 'Сумма налога $direction';
  }

  @override
  String interestRateSort(String direction) {
    return 'Процентная ставка $direction';
  }

  @override
  String assessedValueSort(String direction) {
    return 'Оценочная стоимость $direction';
  }

  @override
  String redemptionDeadlineSort(String direction) {
    return 'Срок погашения $direction';
  }

  @override
  String lienNumber(String parcelId) {
    return 'Закладная #$parcelId';
  }

  @override
  String owner(String owner) {
    return 'Владелец: $owner';
  }

  @override
  String get taxAmount => 'Сумма налога';

  @override
  String get interestRate => 'Процентная ставка';

  @override
  String get assessedValue => 'Оценочная стоимость';

  @override
  String get auctionDate => 'Дата аукциона';

  @override
  String get additionalInfo => 'Дополнительная информация';

  @override
  String get county => 'Округ';

  @override
  String get state => 'Штат';

  @override
  String get redemptionDeadline => 'Срок погашения';

  @override
  String get status => 'Статус';

  @override
  String get buyLien => 'Купить закладную';

  @override
  String get availableForPurchase => 'Доступна для покупки';

  @override
  String get sold => 'Продана';

  @override
  String get redeemed => 'Погашена';

  @override
  String get foreclosed => 'Обращена в собственность';

  @override
  String get purchaseLien => 'Покупка закладной';

  @override
  String enterBidAmount(String amount) {
    return 'Введите сумму ставки (минимум $amount):';
  }

  @override
  String get bidAmount => 'Сумма ставки';

  @override
  String get lienPurchasedSuccessfully => 'Закладная успешно куплена!';

  @override
  String get purchaseError => 'Ошибка покупки';

  @override
  String get invalidBidAmount => 'Неверная сумма ставки';

  @override
  String get buy => 'Купить';

  @override
  String get profile => 'Профиль';

  @override
  String get settings => 'Настройки';

  @override
  String get notAuthorized => 'Не авторизован';

  @override
  String get loginForAccess => 'Войдите в аккаунт для доступа к функциям';

  @override
  String get login => 'Войти';

  @override
  String get register => 'Регистрация';

  @override
  String get edit => 'Редактировать';

  @override
  String get logout => 'Выйти';

  @override
  String get balance => 'Баланс';

  @override
  String get available => 'Доступно';

  @override
  String get topUp => 'Пополнить';

  @override
  String get quickActions => 'Быстрые действия';

  @override
  String get transactionHistory => 'История транзакций';

  @override
  String get viewAllTransactions => 'Просмотр всех операций';

  @override
  String get favoriteLiens => 'Избранные закладные';

  @override
  String get savedLiens => 'Ваши сохраненные закладные';

  @override
  String get notifications => 'Уведомления';

  @override
  String get notificationSettings => 'Настройка уведомлений';

  @override
  String get help => 'Помощь';

  @override
  String get appSettings => 'Настройки приложения';

  @override
  String get language => 'Язык';

  @override
  String get theme => 'Тема';

  @override
  String get dark => 'Темная';

  @override
  String get light => 'Светлая';

  @override
  String get security => 'Безопасность';

  @override
  String get securitySettings => 'Настройки безопасности';

  @override
  String get privacy => 'Конфиденциальность';

  @override
  String get privacySettings => 'Настройки приватности';

  @override
  String get aboutApp => 'О приложении';

  @override
  String get version => 'Версия';

  @override
  String get license => 'Лицензия';

  @override
  String get termsOfService => 'Условия использования';

  @override
  String get userAgreement => 'Пользовательское соглашение';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get dataProcessing => 'Обработка персональных данных';

  @override
  String get loginToAccount => 'Вход в аккаунт';

  @override
  String get password => 'Пароль';

  @override
  String get loginSuccessful => 'Успешный вход!';

  @override
  String get loginError => 'Ошибка входа';

  @override
  String get registration => 'Регистрация';

  @override
  String get firstName => 'Имя';

  @override
  String get lastName => 'Фамилия';

  @override
  String get registrationSuccessful => 'Регистрация успешна!';

  @override
  String get registrationError => 'Ошибка регистрации';

  @override
  String get registerAccount => 'Зарегистрироваться';

  @override
  String get logoutConfirmation => 'Выход из аккаунта';

  @override
  String get logoutConfirmationMessage =>
      'Вы уверены, что хотите выйти из аккаунта?';

  @override
  String get myInvestments => 'Мои инвестиции';

  @override
  String get myLiens => 'Мои закладные';

  @override
  String get favorites => 'Избранное';

  @override
  String get statistics => 'Статистика';

  @override
  String get noInvestmentsYet => 'У вас пока нет инвестиций';

  @override
  String get goToMarketplace =>
      'Перейдите на рынок, чтобы купить налоговые закладные';

  @override
  String get goToMarketplaceButton => 'Перейти на рынок';

  @override
  String get noFavoriteLiens => 'Нет избранных закладных';

  @override
  String get addToFavoritesHint =>
      'Добавляйте закладные в избранное для быстрого доступа';

  @override
  String get overallStatistics => 'Общая статистика';

  @override
  String get totalInvested => 'Всего инвестировано';

  @override
  String get currentValue => 'Текущая стоимость';

  @override
  String get profitLoss => 'Прибыль/убыток';

  @override
  String get roi => 'ROI';

  @override
  String get statusStatistics => 'Статистика по статусам';

  @override
  String get activeLiens => 'Активные закладные';

  @override
  String get redeemedLiens => 'Погашенные закладные';

  @override
  String get foreclosedLiens => 'Обращенные в собственность';

  @override
  String get totalLiens => 'Всего закладных';

  @override
  String get monthlyReturns => 'Доходность по месяцам';

  @override
  String get profitChartInDevelopment => 'График доходности\n(в разработке)';

  @override
  String get topPerformingLiens => 'Топ закладных по доходности';

  @override
  String get investmentInfo => 'Информация об инвестиции';

  @override
  String get purchaseDate => 'Дата покупки';

  @override
  String get purchaseAmount => 'Сумма покупки';

  @override
  String get daysInInvestment => 'Дней в инвестиции';

  @override
  String get interestEarned => 'Заработанные проценты';

  @override
  String get redemptionDate => 'Дата погашения';

  @override
  String get digitalFreedomGateway => 'Врата к цифровой свободе';

  @override
  String get connection => 'Подключение';

  @override
  String get calibrationScreenComingSoon => 'Экран калибровки скоро появится';

  @override
  String get mediaManagementComingSoon => 'Управление медиа скоро появится';

  @override
  String get lienSearch => 'Поиск закладных';

  @override
  String get searching => 'Поиск...';

  @override
  String get noSearchHistory => 'Нет истории поиска';

  @override
  String get clearSearchHistory => 'Очистить историю поиска';

  @override
  String get searchHistory => 'История поиска';

  @override
  String get recentSearches => 'Недавние поиски';

  @override
  String get purchase => 'Покупка';

  @override
  String get searchHistoryEmpty => 'История поиска пуста';

  @override
  String get searchQueriesWillAppearHere =>
      'Ваши поисковые запросы появятся здесь';

  @override
  String get nothingFound => 'Ничего не найдено';

  @override
  String get tryChangingSearchQuery => 'Попробуйте изменить поисковый запрос';

  @override
  String foundLiensCount(int count) {
    return 'Найдено: $count закладных';
  }

  @override
  String daysAgo(int days) {
    return '$days дней назад';
  }

  @override
  String hoursAgo(int hours) {
    return '$hours часов назад';
  }

  @override
  String minutesAgo(int minutes) {
    return '$minutes минут назад';
  }

  @override
  String get justNow => 'Только что';
}
