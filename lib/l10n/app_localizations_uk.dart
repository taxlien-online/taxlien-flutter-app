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
  String get welcome => 'Ласкаво просимо';

  @override
  String get settings => 'Налаштування';

  @override
  String get profile => 'Профіль';

  @override
  String get search => 'Пошук';

  @override
  String get marketplace => 'Магазин';

  @override
  String get portfolio => 'Портфель';

  @override
  String get myInvestments => 'Мої інвестиції';

  @override
  String get aiAdvisor => 'AI Радник';

  @override
  String get login => 'Увійти';

  @override
  String get logout => 'Вийти';

  @override
  String get register => 'Реєстрація';

  @override
  String get cancel => 'Скасувати';

  @override
  String get save => 'Зберегти';

  @override
  String get apply => 'Застосувати';

  @override
  String get reset => 'Скинути';

  @override
  String get delete => 'Видалити';

  @override
  String get edit => 'Редагувати';

  @override
  String get back => 'Назад';

  @override
  String get next => 'Далі';

  @override
  String get finish => 'Завершити';

  @override
  String get skip => 'Пропустити';

  @override
  String get retry => 'Повторити';

  @override
  String get loading => 'Завантаження...';

  @override
  String get error => 'Помилка';

  @override
  String get success => 'Успішно';

  @override
  String get confirm => 'Підтвердити';

  @override
  String get yes => 'Так';

  @override
  String get no => 'Ні';

  @override
  String get ok => 'ОК';

  @override
  String get online => 'Онлайн';

  @override
  String get offline => 'Офлайн';

  @override
  String get connected => 'Підключено';

  @override
  String get disconnected => 'Відключено';

  @override
  String get calibration => 'Калібрування';

  @override
  String get brightness => 'Яскравість';

  @override
  String get rotation => 'Поворот';

  @override
  String get volume => 'Гучність';

  @override
  String get position => 'Позиція';

  @override
  String get playback => 'Відтворення';

  @override
  String get play => 'Грати';

  @override
  String get pause => 'Пауза';

  @override
  String get stop => 'Стоп';

  @override
  String get language => 'Мова';

  @override
  String get languageSettings => 'Налаштування мови';

  @override
  String get theme => 'Тема';

  @override
  String get light => 'Світла';

  @override
  String get dark => 'Темна';

  @override
  String get system => 'Системна';

  @override
  String get lienSearch => 'Пошук податкових застав';

  @override
  String get searching => 'Пошук...';

  @override
  String get nothingFound => 'Нічого не знайдено';

  @override
  String get tryChangingSearchQuery => 'Спробуйте змінити параметри пошуку';

  @override
  String get searchHistory => 'Історія пошуку';

  @override
  String get searchHistoryEmpty => 'Історія пошуку порожня';

  @override
  String get searchQueriesWillAppearHere => 'Ваші запити відображатимуться тут';

  @override
  String foundLiensCount(int count) {
    return 'Знайдено застав: $count';
  }

  @override
  String get availableForPurchase => 'Доступна для покупки';

  @override
  String get sold => 'Продано';

  @override
  String get redeemed => 'Викуплено';

  @override
  String get foreclosed => 'Конфісковано';

  @override
  String get purchaseLien => 'Купити заставу';

  @override
  String enterBidAmount(String amount) {
    return 'Введіть суму ставки (мінімум $amount)';
  }

  @override
  String get lienPurchasedSuccessfully => 'Заставу успішно куплено!';

  @override
  String get purchaseError => 'Помилка покупки';

  @override
  String get invalidBidAmount => 'Невірна сума ставки';

  @override
  String get purchase => 'Купити';

  @override
  String daysAgo(int days) {
    return '$days днів тому';
  }

  @override
  String hoursAgo(int hours) {
    return '$hours годин тому';
  }

  @override
  String minutesAgo(int minutes) {
    return '$minutes хвилин тому';
  }

  @override
  String get justNow => 'Щойно';

  @override
  String get notAuthorized => 'Не авторизовано';

  @override
  String get loginForAccess => 'Увійдіть для доступу до функцій';

  @override
  String get loginToAccount => 'Вхід в акаунт';

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
  String get registerAccount => 'Зареєструватися';

  @override
  String get registrationSuccessful => 'Реєстрація успішна!';

  @override
  String get registrationError => 'Помилка реєстрації';

  @override
  String get logoutConfirmation => 'Підтвердження виходу';

  @override
  String get logoutConfirmationMessage => 'Ви впевнені, що хочете вийти?';

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
  String get viewAllTransactions => 'Переглянути всі транзакції';

  @override
  String get favoriteLiens => 'Улюблені застави';

  @override
  String get savedLiens => 'Збережені застави';

  @override
  String get notifications => 'Сповіщення';

  @override
  String get notificationSettings => 'Налаштування сповіщень';

  @override
  String get help => 'Допомога';

  @override
  String get appSettings => 'Налаштування застосунку';

  @override
  String get russian => 'Російська';

  @override
  String get security => 'Безпека';

  @override
  String get securitySettings => 'Налаштування безпеки';

  @override
  String get privacy => 'Приватність';

  @override
  String get privacySettings => 'Налаштування приватності';

  @override
  String get aboutApp => 'Про застосунок';

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
  String get digitalFreedomGateway => 'Цифрова брама свободи';

  @override
  String get systemStatus => 'Статус системи';

  @override
  String get stopped => 'Зупинено';

  @override
  String get file => 'Файл';

  @override
  String get seconds => 'Секунди';

  @override
  String get playbackControls => 'Керування відтворенням';

  @override
  String get projectionSettings => 'Налаштування проекції';

  @override
  String get connection => 'З\'єднання';

  @override
  String get trial => 'Trial';

  @override
  String get trialActive => 'Trial Active';

  @override
  String get trialExpired => 'Trial Expired';

  @override
  String daysRemaining(int days) {
    return '$days days remaining';
  }

  @override
  String get startFreeTrial => 'Start Free Trial';

  @override
  String get startTrial => 'Start Trial';

  @override
  String get trialStarted => 'Trial Started';

  @override
  String get trialWelcome => 'Welcome! Your 365-day trial has started';

  @override
  String get trialAlreadyUsed => 'Trial already used';

  @override
  String get subscription => 'Subscription';

  @override
  String get subscriptions => 'Subscriptions';

  @override
  String get subscribe => 'Subscribe';

  @override
  String get subscribed => 'Subscribed';

  @override
  String get premium => 'Premium';

  @override
  String get premiumFeatures => 'Premium Features';

  @override
  String get unlockPremium => 'Unlock Premium Features';

  @override
  String get choosePlan => 'Choose Your Plan';

  @override
  String get freePlan => 'Free Plan';

  @override
  String get trialPlan => 'Trial Plan';

  @override
  String get premiumPlan => 'Premium Plan';

  @override
  String get enterprisePlan => 'Enterprise Plan';

  @override
  String get monthly => 'Monthly';

  @override
  String get yearly => 'Yearly';

  @override
  String get perMonth => 'per month';

  @override
  String get perYear => 'per year';

  @override
  String get bestValue => 'Best Value';

  @override
  String savePercent(int percent) {
    return 'Save $percent%';
  }

  @override
  String get restorePurchases => 'Restore Purchases';

  @override
  String get purchaseSuccessful => 'Purchase Successful';

  @override
  String get subscriptionActive => 'Subscription Active';

  @override
  String get subscriptionExpired => 'Subscription Expired';

  @override
  String get upgradeToAccessFeature => 'Upgrade to access this feature';

  @override
  String get featuresIncluded => 'Features Included';

  @override
  String get noPaymentRequired => 'No payment required';

  @override
  String get cancelAnytime => 'Cancel anytime';

  @override
  String get autoRenews => 'Automatically renews';

  @override
  String get termsAndConditions => 'Terms and Conditions';

  @override
  String get bySubscribing =>
      'By subscribing, you agree to our Terms of Service and Privacy Policy';

  @override
  String get subscriptionInfo =>
      'Subscriptions automatically renew unless auto-renew is turned off at least 24 hours before the end of the current period';
}
