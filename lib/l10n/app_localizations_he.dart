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
  String get welcome => 'ברוכים הבאים';

  @override
  String get settings => 'הגדרות';

  @override
  String get profile => 'פרופיל';

  @override
  String get search => 'חיפוש';

  @override
  String get marketplace => 'שוק';

  @override
  String get portfolio => 'תיק השקעות';

  @override
  String get myInvestments => 'ההשקעות שלי';

  @override
  String get aiAdvisor => 'יועץ בינה מלאכותית';

  @override
  String get login => 'התחבר';

  @override
  String get logout => 'התנתק';

  @override
  String get register => 'הירשם';

  @override
  String get cancel => 'ביטול';

  @override
  String get save => 'שמור';

  @override
  String get apply => 'החל';

  @override
  String get reset => 'אפס';

  @override
  String get delete => 'מחק';

  @override
  String get edit => 'ערוך';

  @override
  String get back => 'חזור';

  @override
  String get next => 'הבא';

  @override
  String get finish => 'סיים';

  @override
  String get skip => 'דלג';

  @override
  String get retry => 'נסה שוב';

  @override
  String get loading => 'טוען...';

  @override
  String get error => 'שגיאה';

  @override
  String get success => 'הצלחה';

  @override
  String get confirm => 'אשר';

  @override
  String get yes => 'כן';

  @override
  String get no => 'לא';

  @override
  String get ok => 'אישור';

  @override
  String get online => 'מקוון';

  @override
  String get offline => 'לא מקוון';

  @override
  String get connected => 'מחובר';

  @override
  String get disconnected => 'מנותק';

  @override
  String get calibration => 'כיול';

  @override
  String get brightness => 'בהירות';

  @override
  String get rotation => 'סיבוב';

  @override
  String get volume => 'עוצמת קול';

  @override
  String get position => 'מיקום';

  @override
  String get playback => 'השמעה';

  @override
  String get play => 'הפעל';

  @override
  String get pause => 'השהה';

  @override
  String get stop => 'עצור';

  @override
  String get language => 'שפה';

  @override
  String get languageSettings => 'הגדרות שפה';

  @override
  String get theme => 'ערכת נושא';

  @override
  String get light => 'בהיר';

  @override
  String get dark => 'כהה';

  @override
  String get system => 'מערכת';

  @override
  String get lienSearch => 'חיפוש שעבוד מס';

  @override
  String get searching => 'מחפש...';

  @override
  String get nothingFound => 'לא נמצא דבר';

  @override
  String get tryChangingSearchQuery => 'נסה לשנות את שאילתת החיפוש';

  @override
  String get searchHistory => 'היסטוריית חיפוש';

  @override
  String get searchHistoryEmpty => 'היסטוריית החיפוש ריקה';

  @override
  String get searchQueriesWillAppearHere => 'שאילתות החיפוש שלך יופיעו כאן';

  @override
  String foundLiensCount(int count) {
    return 'נמצאו $count שעבודים';
  }

  @override
  String get availableForPurchase => 'זמין לרכישה';

  @override
  String get sold => 'נמכר';

  @override
  String get redeemed => 'נפדה';

  @override
  String get foreclosed => 'הוחרם';

  @override
  String get purchaseLien => 'רכוש שעבוד';

  @override
  String enterBidAmount(String amount) {
    return 'הזן סכום הצעה (מינימום $amount)';
  }

  @override
  String get lienPurchasedSuccessfully => 'השעבוד נרכש בהצלחה!';

  @override
  String get purchaseError => 'שגיאת רכישה';

  @override
  String get invalidBidAmount => 'סכום הצעה לא חוקי';

  @override
  String get purchase => 'רכוש';

  @override
  String daysAgo(int days) {
    return 'לפני $days ימים';
  }

  @override
  String hoursAgo(int hours) {
    return 'לפני $hours שעות';
  }

  @override
  String minutesAgo(int minutes) {
    return 'לפני $minutes דקות';
  }

  @override
  String get justNow => 'ממש עכשיו';

  @override
  String get notAuthorized => 'לא מורשה';

  @override
  String get loginForAccess => 'אנא התחבר כדי לגשת לתכונות';

  @override
  String get loginToAccount => 'התחבר לחשבון';

  @override
  String get password => 'סיסמה';

  @override
  String get loginSuccessful => 'התחברות הצליחה!';

  @override
  String get loginError => 'שגיאת התחברות';

  @override
  String get registration => 'הרשמה';

  @override
  String get firstName => 'שם פרטי';

  @override
  String get lastName => 'שם משפחה';

  @override
  String get registerAccount => 'הרשם לחשבון';

  @override
  String get registrationSuccessful => 'ההרשמה הצליחה!';

  @override
  String get registrationError => 'שגיאת הרשמה';

  @override
  String get logoutConfirmation => 'אישור התנתקות';

  @override
  String get logoutConfirmationMessage => 'האם אתה בטוח שברצונך להתנתק?';

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
  String get viewAllTransactions => 'הצג את כל העסקאות';

  @override
  String get favoriteLiens => 'שעבודים מועדפים';

  @override
  String get savedLiens => 'שעבודים שמורים';

  @override
  String get notifications => 'התראות';

  @override
  String get notificationSettings => 'הגדרות התראות';

  @override
  String get help => 'עזרה';

  @override
  String get appSettings => 'הגדרות אפליקציה';

  @override
  String get russian => 'רוסית';

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
  String get digitalFreedomGateway => 'שער החופש הדיגיטלי';

  @override
  String get systemStatus => 'מצב מערכת';

  @override
  String get stopped => 'עצור';

  @override
  String get file => 'קובץ';

  @override
  String get seconds => 'שניות';

  @override
  String get playbackControls => 'בקרות השמעה';

  @override
  String get projectionSettings => 'הגדרות הקרנה';

  @override
  String get connection => 'חיבור';

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
