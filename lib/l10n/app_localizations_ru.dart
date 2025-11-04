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
  String get welcome => 'Добро пожаловать';

  @override
  String get settings => 'Настройки';

  @override
  String get profile => 'Профиль';

  @override
  String get search => 'Поиск';

  @override
  String get marketplace => 'Магазин';

  @override
  String get portfolio => 'Портфель';

  @override
  String get myInvestments => 'Мои инвестиции';

  @override
  String get aiAdvisor => 'AI Советник';

  @override
  String get login => 'Войти';

  @override
  String get logout => 'Выйти';

  @override
  String get register => 'Регистрация';

  @override
  String get cancel => 'Отмена';

  @override
  String get save => 'Сохранить';

  @override
  String get apply => 'Применить';

  @override
  String get reset => 'Сбросить';

  @override
  String get delete => 'Удалить';

  @override
  String get edit => 'Редактировать';

  @override
  String get back => 'Назад';

  @override
  String get next => 'Далее';

  @override
  String get finish => 'Завершить';

  @override
  String get skip => 'Пропустить';

  @override
  String get retry => 'Повторить';

  @override
  String get loading => 'Загрузка...';

  @override
  String get error => 'Ошибка';

  @override
  String get success => 'Успешно';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';

  @override
  String get ok => 'ОК';

  @override
  String get online => 'Онлайн';

  @override
  String get offline => 'Оффлайн';

  @override
  String get connected => 'Подключено';

  @override
  String get disconnected => 'Отключено';

  @override
  String get calibration => 'Калибровка';

  @override
  String get brightness => 'Яркость';

  @override
  String get rotation => 'Поворот';

  @override
  String get volume => 'Громкость';

  @override
  String get position => 'Позиция';

  @override
  String get playback => 'Воспроизведение';

  @override
  String get play => 'Играть';

  @override
  String get pause => 'Пауза';

  @override
  String get stop => 'Стоп';

  @override
  String get language => 'Язык';

  @override
  String get languageSettings => 'Настройки языка';

  @override
  String get theme => 'Тема';

  @override
  String get light => 'Светлая';

  @override
  String get dark => 'Темная';

  @override
  String get system => 'Системная';

  @override
  String get lienSearch => 'Поиск закладных';

  @override
  String get searching => 'Поиск...';

  @override
  String get nothingFound => 'Ничего не найдено';

  @override
  String get tryChangingSearchQuery => 'Попробуйте изменить параметры поиска';

  @override
  String get searchHistory => 'История поиска';

  @override
  String get searchHistoryEmpty => 'История поиска пуста';

  @override
  String get searchQueriesWillAppearHere =>
      'Ваши запросы будут отображаться здесь';

  @override
  String foundLiensCount(int count) {
    return 'Найдено закладных: $count';
  }

  @override
  String get availableForPurchase => 'Доступна для покупки';

  @override
  String get sold => 'Продано';

  @override
  String get redeemed => 'Выкуплено';

  @override
  String get foreclosed => 'Конфисковано';

  @override
  String get purchaseLien => 'Купить закладную';

  @override
  String enterBidAmount(String amount) {
    return 'Введите сумму ставки (минимум $amount)';
  }

  @override
  String get lienPurchasedSuccessfully => 'Закладная успешно куплена!';

  @override
  String get purchaseError => 'Ошибка покупки';

  @override
  String get invalidBidAmount => 'Неверная сумма ставки';

  @override
  String get purchase => 'Купить';

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

  @override
  String get notAuthorized => 'Не авторизован';

  @override
  String get loginForAccess => 'Войдите для доступа к функциям';

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
  String get registerAccount => 'Зарегистрироваться';

  @override
  String get registrationSuccessful => 'Регистрация успешна!';

  @override
  String get registrationError => 'Ошибка регистрации';

  @override
  String get logoutConfirmation => 'Подтверждение выхода';

  @override
  String get logoutConfirmationMessage => 'Вы уверены, что хотите выйти?';

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
  String get viewAllTransactions => 'Просмотреть все транзакции';

  @override
  String get favoriteLiens => 'Избранные закладные';

  @override
  String get savedLiens => 'Сохраненные закладные';

  @override
  String get notifications => 'Уведомления';

  @override
  String get notificationSettings => 'Настройки уведомлений';

  @override
  String get help => 'Помощь';

  @override
  String get appSettings => 'Настройки приложения';

  @override
  String get russian => 'Русский';

  @override
  String get security => 'Безопасность';

  @override
  String get securitySettings => 'Настройки безопасности';

  @override
  String get privacy => 'Приватность';

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
  String get digitalFreedomGateway => 'Цифровой шлюз свободы';

  @override
  String get systemStatus => 'Статус системы';

  @override
  String get stopped => 'Остановлено';

  @override
  String get file => 'Файл';

  @override
  String get seconds => 'Секунды';

  @override
  String get playbackControls => 'Управление воспроизведением';

  @override
  String get projectionSettings => 'Настройки проекции';

  @override
  String get connection => 'Соединение';

  @override
  String get trial => 'Пробная версия';

  @override
  String get trialActive => 'Пробная версия активна';

  @override
  String get trialExpired => 'Пробная версия истекла';

  @override
  String daysRemaining(int days) {
    return 'Осталось дней: $days';
  }

  @override
  String get startFreeTrial => 'Начать бесплатную пробную версию';

  @override
  String get startTrial => 'Начать пробный период';

  @override
  String get trialStarted => 'Пробный период начат';

  @override
  String get trialWelcome =>
      'Добро пожаловать! Ваш 365-дневный пробный период начался';

  @override
  String get trialAlreadyUsed => 'Пробная версия уже использована';

  @override
  String get subscription => 'Подписка';

  @override
  String get subscriptions => 'Подписки';

  @override
  String get subscribe => 'Подписаться';

  @override
  String get subscribed => 'Подписан';

  @override
  String get premium => 'Премиум';

  @override
  String get premiumFeatures => 'Премиум функции';

  @override
  String get unlockPremium => 'Разблокировать премиум функции';

  @override
  String get choosePlan => 'Выберите ваш план';

  @override
  String get freePlan => 'Бесплатный план';

  @override
  String get trialPlan => 'Пробный план';

  @override
  String get premiumPlan => 'Премиум план';

  @override
  String get enterprisePlan => 'Корпоративный план';

  @override
  String get monthly => 'Ежемесячно';

  @override
  String get yearly => 'Ежегодно';

  @override
  String get perMonth => 'в месяц';

  @override
  String get perYear => 'в год';

  @override
  String get bestValue => 'Лучшее предложение';

  @override
  String savePercent(int percent) {
    return 'Сэкономьте $percent%';
  }

  @override
  String get restorePurchases => 'Восстановить покупки';

  @override
  String get purchaseSuccessful => 'Покупка успешна';

  @override
  String get subscriptionActive => 'Подписка активна';

  @override
  String get subscriptionExpired => 'Подписка истекла';

  @override
  String get upgradeToAccessFeature =>
      'Обновите подписку для доступа к этой функции';

  @override
  String get featuresIncluded => 'Включенные функции';

  @override
  String get noPaymentRequired => 'Оплата не требуется';

  @override
  String get cancelAnytime => 'Отмена в любое время';

  @override
  String get autoRenews => 'Автоматическое продление';

  @override
  String get termsAndConditions => 'Условия и положения';

  @override
  String get bySubscribing =>
      'Подписываясь, вы соглашаетесь с нашими Условиями использования и Политикой конфиденциальности';

  @override
  String get subscriptionInfo =>
      'Подписки автоматически продлеваются, если автопродление не отключено как минимум за 24 часа до окончания текущего периода';
}
