// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get appTitle => 'TaxLien.online';

  @override
  String get systemStatus => 'סטטוס המערכת';

  @override
  String get playback => 'השמעה';

  @override
  String get stopped => 'עצור';

  @override
  String get file => 'קובץ';

  @override
  String get position => 'מיקום';

  @override
  String get seconds => 'שניות';

  @override
  String get playbackControls => 'בקרת השמעה';

  @override
  String get play => 'נגן';

  @override
  String get pause => 'השהה';

  @override
  String get stop => 'עצור';

  @override
  String get volume => 'עוצמה';

  @override
  String get projectionSettings => 'הגדרות הקרנה';

  @override
  String get brightness => 'בהירות';

  @override
  String get rotation => 'סיבוב';

  @override
  String get mediaFiles => 'קבצי מדיה';

  @override
  String get image => 'תמונה';

  @override
  String get calibration => 'כיול';

  @override
  String get calibrationTitle => 'כיול הקרנה';

  @override
  String get preview => 'תצוגה מקדימה';

  @override
  String get offset => 'היסט';

  @override
  String get xOffset => 'היסט X';

  @override
  String get yOffset => 'היסט Y';

  @override
  String get scaleRotation => 'קנה מידה וסיבוב';

  @override
  String get scale => 'קנה מידה';

  @override
  String get apply => 'החל';

  @override
  String get reset => 'איפוס';

  @override
  String get calibrationApplied => 'הכיול הוחל';

  @override
  String get online => 'מחובר';

  @override
  String get offline => 'מנותק';

  @override
  String get languageSettings => 'הגדרות שפה';

  @override
  String get languageChanged => 'השפה השתנתה';

  @override
  String get onboardingWelcomeTitle => 'ברוכים הבאים ל-TaxLien.online';

  @override
  String get onboardingWelcomeDescription =>
      'השער שלך לחופש דיגיטלי וחיבור רוחני';

  @override
  String get onboardingConnectionTitle => 'התחבר ל-FreeDome';

  @override
  String get onboardingConnectionDescription =>
      'צור חיבור מאובטח לרשת FreeDome שלך';

  @override
  String get onboardingDomeControlTitle => 'בקרת כיפה';

  @override
  String get onboardingDomeControlDescription =>
      'נהל את הגדרות ותצורות הכיפה שלך';

  @override
  String get onboardingCalibrationTitle => 'כיול';

  @override
  String get onboardingCalibrationDescription =>
      'כייל את הכיפה שלך לביצועים מיטביים';

  @override
  String get onboardingMediaTitle => 'ניהול מדיה';

  @override
  String get onboardingMediaDescription => 'העלה ונהל את קבצי המדיה שלך';

  @override
  String get onboardingReadyTitle => 'אתה מוכן!';

  @override
  String get onboardingReadyDescription => 'התחל את המסע שלך לחופש דיגיטלי';

  @override
  String get next => 'הבא';

  @override
  String get back => 'חזור';

  @override
  String get skip => 'דלג';

  @override
  String get getStarted => 'התחל';

  @override
  String get skipConfirmationTitle => 'דלג על ההדרכה?';

  @override
  String get skipConfirmationMessage =>
      'האם אתה בטוח שברצונך לדלג על ההדרכה? תוכל תמיד לגשת למדריך מאוחר יותר מההגדרות.';

  @override
  String get cancel => 'ביטול';

  @override
  String get connectingToFreedome => 'מתחבר ל-FreeDome...';

  @override
  String get domeStatusActive => 'סטטוס כיפה: פעיל';

  @override
  String get open => 'פתח';

  @override
  String get close => 'סגור';

  @override
  String get calibrationProgress => 'התקדמות כיול';

  @override
  String mediaFilesCount(int count) {
    return 'קבצי מדיה: $count פריטים';
  }

  @override
  String get upload => 'העלה';

  @override
  String get manage => 'נהל';

  @override
  String get serverSettings => 'הגדרות שרת';

  @override
  String get connectionStatus => 'סטטוס חיבור';

  @override
  String get russian => 'רוסית';

  @override
  String get ukrainian => 'אוקראינית';

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
    return 'שגיאה בטעינת נתונים: $error';
  }

  @override
  String get taxLienMarketplace => 'שוק שעבוד מס';

  @override
  String get filters => 'מסננים';

  @override
  String get refresh => 'רענן';

  @override
  String get searchHint => 'חפש לפי כתובת, בעלים או מזהה חלקה...';

  @override
  String get clear => 'נקה';

  @override
  String foundLiens(int count) {
    return 'נמצאו: $count שעבודים';
  }

  @override
  String sortBy(String sortLabel) {
    return 'מיין לפי: $sortLabel';
  }

  @override
  String get retry => 'נסה שוב';

  @override
  String get noLiensFound => 'לא נמצאו שעבודי מס';

  @override
  String get tryChangingSearch => 'נסה לשנות פרמטרי חיפוש או מסננים';

  @override
  String stateFilter(String state) {
    return 'מדינה: $state';
  }

  @override
  String countyFilter(String county) {
    return 'מחוז: $county';
  }

  @override
  String amountFrom(String amount) {
    return 'מ: $amount';
  }

  @override
  String amountTo(String amount) {
    return 'עד: $amount';
  }

  @override
  String interestRateFrom(String rate) {
    return 'ריבית מ: $rate%';
  }

  @override
  String auctionDateSort(String direction) {
    return 'תאריך מכירה פומבית $direction';
  }

  @override
  String taxAmountSort(String direction) {
    return 'סכום מס $direction';
  }

  @override
  String interestRateSort(String direction) {
    return 'ריבית $direction';
  }

  @override
  String assessedValueSort(String direction) {
    return 'ערך מוערך $direction';
  }

  @override
  String redemptionDeadlineSort(String direction) {
    return 'תאריך יעד לפדיון $direction';
  }

  @override
  String lienNumber(String parcelId) {
    return 'שעבוד #$parcelId';
  }

  @override
  String owner(String owner) {
    return 'בעלים: $owner';
  }

  @override
  String get taxAmount => 'סכום מס';

  @override
  String get interestRate => 'ריבית';

  @override
  String get assessedValue => 'ערך מוערך';

  @override
  String get auctionDate => 'תאריך מכירה פומבית';

  @override
  String get additionalInfo => 'מידע נוסף';

  @override
  String get county => 'מחוז';

  @override
  String get state => 'מדינה';

  @override
  String get redemptionDeadline => 'תאריך יעד לפדיון';

  @override
  String get status => 'סטטוס';

  @override
  String get buyLien => 'קנה שעבוד';

  @override
  String get availableForPurchase => 'זמין לרכישה';

  @override
  String get sold => 'נמכר';

  @override
  String get redeemed => 'נפדה';

  @override
  String get foreclosed => 'הוחרם';

  @override
  String get purchaseLien => 'רכישת שעבוד';

  @override
  String enterBidAmount(String amount) {
    return 'הזן סכום הצעה (מינימום $amount):';
  }

  @override
  String get bidAmount => 'סכום הצעה';

  @override
  String get lienPurchasedSuccessfully => 'השעבוד נרכש בהצלחה!';

  @override
  String get purchaseError => 'שגיאה ברכישה';

  @override
  String get invalidBidAmount => 'סכום הצעה לא חוקי';

  @override
  String get buy => 'קנה';

  @override
  String get profile => 'פרופיל';

  @override
  String get settings => 'הגדרות';

  @override
  String get notAuthorized => 'לא מורשה';

  @override
  String get loginForAccess => 'התחבר כדי לגשת לתכונות';

  @override
  String get login => 'התחבר';

  @override
  String get register => 'הרשמה';

  @override
  String get edit => 'ערוך';

  @override
  String get logout => 'התנתק';

  @override
  String get balance => 'יתרה';

  @override
  String get available => 'זמין';

  @override
  String get topUp => 'טען';

  @override
  String get quickActions => 'פעולות מהירות';

  @override
  String get transactionHistory => 'היסטוריית עסקאות';

  @override
  String get viewAllTransactions => 'צפה בכל העסקאות';

  @override
  String get favoriteLiens => 'שעבודים מועדפים';

  @override
  String get savedLiens => 'השעבודים השמורים שלך';

  @override
  String get notifications => 'התראות';

  @override
  String get notificationSettings => 'הגדרות התראות';

  @override
  String get help => 'עזרה';

  @override
  String get appSettings => 'הגדרות אפליקציה';

  @override
  String get language => 'שפה';

  @override
  String get theme => 'ערכת נושא';

  @override
  String get dark => 'כהה';

  @override
  String get light => 'בהיר';

  @override
  String get security => 'אבטחה';

  @override
  String get securitySettings => 'הגדרות אבטחה';

  @override
  String get privacy => 'פרטיות';

  @override
  String get privacySettings => 'הגדרות פרטיות';

  @override
  String get aboutApp => 'אודות האפליקציה';

  @override
  String get version => 'גרסה';

  @override
  String get license => 'רישיון';

  @override
  String get termsOfService => 'תנאי שירות';

  @override
  String get userAgreement => 'הסכם משתמש';

  @override
  String get privacyPolicy => 'מדיניות פרטיות';

  @override
  String get dataProcessing => 'עיבוד נתונים אישיים';

  @override
  String get loginToAccount => 'התחבר לחשבון';

  @override
  String get password => 'סיסמה';

  @override
  String get loginSuccessful => 'ההתחברות הצליחה!';

  @override
  String get loginError => 'שגיאת התחברות';

  @override
  String get registration => 'הרשמה';

  @override
  String get firstName => 'שם פרטי';

  @override
  String get lastName => 'שם משפחה';

  @override
  String get registrationSuccessful => 'ההרשמה הצליחה!';

  @override
  String get registrationError => 'שגיאת הרשמה';

  @override
  String get registerAccount => 'הרשם';

  @override
  String get logoutConfirmation => 'אישור התנתקות';

  @override
  String get logoutConfirmationMessage => 'האם אתה בטוח שברצונך להתנתק?';

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
