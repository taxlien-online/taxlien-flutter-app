// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'TaxLien.online';

  @override
  String get systemStatus => 'حالة النظام';

  @override
  String get playback => 'التشغيل';

  @override
  String get stopped => 'متوقف';

  @override
  String get file => 'الملف';

  @override
  String get position => 'الموضع';

  @override
  String get seconds => 'ثانية';

  @override
  String get playbackControls => 'أدوات التحكم في التشغيل';

  @override
  String get play => 'تشغيل';

  @override
  String get pause => 'إيقاف مؤقت';

  @override
  String get stop => 'إيقاف';

  @override
  String get volume => 'مستوى الصوت';

  @override
  String get projectionSettings => 'إعدادات الإسقاط';

  @override
  String get brightness => 'السطوع';

  @override
  String get rotation => 'الدوران';

  @override
  String get mediaFiles => 'ملفات الوسائط';

  @override
  String get image => 'الصورة';

  @override
  String get calibration => 'المعايرة';

  @override
  String get calibrationTitle => 'معايرة الإسقاط';

  @override
  String get preview => 'المعاينة';

  @override
  String get offset => 'الإزاحة';

  @override
  String get xOffset => 'إزاحة X';

  @override
  String get yOffset => 'إزاحة Y';

  @override
  String get scaleRotation => 'المقياس والدوران';

  @override
  String get scale => 'المقياس';

  @override
  String get apply => 'تطبيق';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get calibrationApplied => 'تم تطبيق المعايرة';

  @override
  String get online => 'متصل';

  @override
  String get offline => 'غير متصل';

  @override
  String get languageSettings => 'إعدادات اللغة';

  @override
  String get languageChanged => 'تم تغيير اللغة';

  @override
  String get onboardingWelcomeTitle => 'مرحباً بك في TaxLien.online';

  @override
  String get onboardingWelcomeDescription =>
      'بوابتك إلى الحرية الرقمية والاتصال الروحي';

  @override
  String get onboardingConnectionTitle => 'الاتصال بـ FreeDome';

  @override
  String get onboardingConnectionDescription =>
      'إنشاء اتصال آمن بشبكة FreeDome الخاصة بك';

  @override
  String get onboardingDomeControlTitle => 'تحكم القبة';

  @override
  String get onboardingDomeControlDescription =>
      'تحكم في إعدادات وتكوينات قبتك';

  @override
  String get onboardingCalibrationTitle => 'المعايرة';

  @override
  String get onboardingCalibrationDescription =>
      'عاير قبتك للحصول على أداء مثالي';

  @override
  String get onboardingMediaTitle => 'إدارة الوسائط';

  @override
  String get onboardingMediaDescription => 'رفع وإدارة ملفات الوسائط الخاصة بك';

  @override
  String get onboardingReadyTitle => 'أنت جاهز!';

  @override
  String get onboardingReadyDescription => 'ابدأ رحلتك إلى الحرية الرقمية';

  @override
  String get next => 'التالي';

  @override
  String get back => 'رجوع';

  @override
  String get skip => 'تخطي';

  @override
  String get getStarted => 'ابدأ';

  @override
  String get skipConfirmationTitle => 'تخطي التمهيد؟';

  @override
  String get skipConfirmationMessage =>
      'هل أنت متأكد من أنك تريد تخطي التمهيد؟ يمكنك دائماً الوصول إلى الدليل لاحقاً من الإعدادات.';

  @override
  String get cancel => 'إلغاء';

  @override
  String get connectingToFreedome => 'الاتصال بـ FreeDome...';

  @override
  String get domeStatusActive => 'حالة القبة: نشط';

  @override
  String get open => 'فتح';

  @override
  String get close => 'إغلاق';

  @override
  String get calibrationProgress => 'تقدم المعايرة';

  @override
  String mediaFilesCount(int count) {
    return 'ملفات الوسائط: $count عنصر';
  }

  @override
  String get upload => 'رفع';

  @override
  String get manage => 'إدارة';

  @override
  String get serverSettings => 'إعدادات الخادم';

  @override
  String get connectionStatus => 'حالة الاتصال';

  @override
  String get russian => 'الروسية';

  @override
  String get ukrainian => 'الأوكرانية';

  @override
  String dataLoadError(String error) {
    return 'خطأ في تحميل البيانات: $error';
  }

  @override
  String get taxLienMarketplace => 'سوق الرهن الضريبي';

  @override
  String get filters => 'المرشحات';

  @override
  String get refresh => 'تحديث';

  @override
  String get searchHint => 'البحث بالعنوان أو المالك أو معرف القطعة...';

  @override
  String get clear => 'مسح';

  @override
  String foundLiens(int count) {
    return 'تم العثور على: $count رهن';
  }

  @override
  String sortBy(String sortLabel) {
    return 'ترتيب حسب: $sortLabel';
  }

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get noLiensFound => 'لم يتم العثور على رهونات ضريبية';

  @override
  String get tryChangingSearch => 'حاول تغيير معاملات البحث أو المرشحات';

  @override
  String stateFilter(String state) {
    return 'الولاية: $state';
  }

  @override
  String countyFilter(String county) {
    return 'المقاطعة: $county';
  }

  @override
  String amountFrom(String amount) {
    return 'من: $amount';
  }

  @override
  String amountTo(String amount) {
    return 'إلى: $amount';
  }

  @override
  String interestRateFrom(String rate) {
    return 'معدل الفائدة من: $rate%';
  }

  @override
  String auctionDateSort(String direction) {
    return 'تاريخ المزاد $direction';
  }

  @override
  String taxAmountSort(String direction) {
    return 'مبلغ الضريبة $direction';
  }

  @override
  String interestRateSort(String direction) {
    return 'معدل الفائدة $direction';
  }

  @override
  String assessedValueSort(String direction) {
    return 'القيمة المقدرة $direction';
  }

  @override
  String redemptionDeadlineSort(String direction) {
    return 'موعد الاسترداد $direction';
  }

  @override
  String lienNumber(String parcelId) {
    return 'الرهن #$parcelId';
  }

  @override
  String owner(String owner) {
    return 'المالك: $owner';
  }

  @override
  String get taxAmount => 'مبلغ الضريبة';

  @override
  String get interestRate => 'معدل الفائدة';

  @override
  String get assessedValue => 'القيمة المقدرة';

  @override
  String get auctionDate => 'تاريخ المزاد';

  @override
  String get additionalInfo => 'معلومات إضافية';

  @override
  String get county => 'المقاطعة';

  @override
  String get state => 'الولاية';

  @override
  String get redemptionDeadline => 'موعد الاسترداد';

  @override
  String get status => 'الحالة';

  @override
  String get buyLien => 'شراء الرهن';

  @override
  String get availableForPurchase => 'متاح للشراء';

  @override
  String get sold => 'مباع';

  @override
  String get redeemed => 'مسترد';

  @override
  String get foreclosed => 'مصادر';

  @override
  String get purchaseLien => 'شراء الرهن';

  @override
  String enterBidAmount(String amount) {
    return 'أدخل مبلغ المزايدة (الحد الأدنى $amount):';
  }

  @override
  String get bidAmount => 'مبلغ المزايدة';

  @override
  String get lienPurchasedSuccessfully => 'تم شراء الرهن بنجاح!';

  @override
  String get purchaseError => 'خطأ في الشراء';

  @override
  String get invalidBidAmount => 'مبلغ مزايدة غير صحيح';

  @override
  String get buy => 'شراء';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get settings => 'الإعدادات';

  @override
  String get notAuthorized => 'غير مصرح';

  @override
  String get loginForAccess => 'سجل الدخول للوصول إلى الميزات';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get register => 'التسجيل';

  @override
  String get edit => 'تعديل';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get balance => 'الرصيد';

  @override
  String get available => 'متاح';

  @override
  String get topUp => 'شحن';

  @override
  String get quickActions => 'الإجراءات السريعة';

  @override
  String get transactionHistory => 'سجل المعاملات';

  @override
  String get viewAllTransactions => 'عرض جميع المعاملات';

  @override
  String get favoriteLiens => 'الرهونات المفضلة';

  @override
  String get savedLiens => 'رهوناتك المحفوظة';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get notificationSettings => 'إعدادات الإشعارات';

  @override
  String get help => 'المساعدة';

  @override
  String get appSettings => 'إعدادات التطبيق';

  @override
  String get language => 'اللغة';

  @override
  String get theme => 'المظهر';

  @override
  String get dark => 'داكن';

  @override
  String get light => 'فاتح';

  @override
  String get security => 'الأمان';

  @override
  String get securitySettings => 'إعدادات الأمان';

  @override
  String get privacy => 'الخصوصية';

  @override
  String get privacySettings => 'إعدادات الخصوصية';

  @override
  String get aboutApp => 'حول التطبيق';

  @override
  String get version => 'الإصدار';

  @override
  String get license => 'الترخيص';

  @override
  String get termsOfService => 'شروط الخدمة';

  @override
  String get userAgreement => 'اتفاقية المستخدم';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get dataProcessing => 'معالجة البيانات الشخصية';

  @override
  String get loginToAccount => 'تسجيل الدخول إلى الحساب';

  @override
  String get password => 'كلمة المرور';

  @override
  String get loginSuccessful => 'تم تسجيل الدخول بنجاح!';

  @override
  String get loginError => 'خطأ في تسجيل الدخول';

  @override
  String get registration => 'التسجيل';

  @override
  String get firstName => 'الاسم الأول';

  @override
  String get lastName => 'اسم العائلة';

  @override
  String get registrationSuccessful => 'تم التسجيل بنجاح!';

  @override
  String get registrationError => 'خطأ في التسجيل';

  @override
  String get registerAccount => 'تسجيل';

  @override
  String get logoutConfirmation => 'تأكيد تسجيل الخروج';

  @override
  String get logoutConfirmationMessage =>
      'هل أنت متأكد من أنك تريد تسجيل الخروج؟';

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
