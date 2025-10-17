// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'TaxLien.online';

  @override
  String get welcome => 'स्वागत है';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get search => 'खोजें';

  @override
  String get marketplace => 'बाज़ार';

  @override
  String get portfolio => 'पोर्टफोलियो';

  @override
  String get myInvestments => 'मेरे निवेश';

  @override
  String get aiAdvisor => 'AI सलाहकार';

  @override
  String get login => 'लॉग इन करें';

  @override
  String get logout => 'लॉग आउट करें';

  @override
  String get register => 'पंजीकरण करें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get save => 'सहेजें';

  @override
  String get apply => 'लागू करें';

  @override
  String get reset => 'रीसेट करें';

  @override
  String get delete => 'हटाएं';

  @override
  String get edit => 'संपादित करें';

  @override
  String get back => 'वापस';

  @override
  String get next => 'आगे';

  @override
  String get finish => 'समाप्त करें';

  @override
  String get skip => 'छोड़ें';

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String get loading => 'लोड हो रहा है...';

  @override
  String get error => 'त्रुटि';

  @override
  String get success => 'सफलता';

  @override
  String get confirm => 'पुष्टि करें';

  @override
  String get yes => 'हां';

  @override
  String get no => 'नहीं';

  @override
  String get ok => 'ठीक है';

  @override
  String get online => 'ऑनलाइन';

  @override
  String get offline => 'ऑफ़लाइन';

  @override
  String get connected => 'कनेक्ट किया गया';

  @override
  String get disconnected => 'डिस्कनेक्ट किया गया';

  @override
  String get calibration => 'अंशांकन';

  @override
  String get brightness => 'चमक';

  @override
  String get rotation => 'घूर्णन';

  @override
  String get volume => 'वॉल्यूम';

  @override
  String get position => 'स्थिति';

  @override
  String get playback => 'प्लेबैक';

  @override
  String get play => 'चलाएं';

  @override
  String get pause => 'रोकें';

  @override
  String get stop => 'बंद करें';

  @override
  String get language => 'भाषा';

  @override
  String get languageSettings => 'भाषा सेटिंग्स';

  @override
  String get theme => 'थीम';

  @override
  String get light => 'हल्का';

  @override
  String get dark => 'गहरा';

  @override
  String get system => 'सिस्टम';

  @override
  String get lienSearch => 'टैक्स लियन खोज';

  @override
  String get searching => 'खोज रहा है...';

  @override
  String get nothingFound => 'कुछ नहीं मिला';

  @override
  String get tryChangingSearchQuery => 'खोज क्वेरी बदलने का प्रयास करें';

  @override
  String get searchHistory => 'खोज इतिहास';

  @override
  String get searchHistoryEmpty => 'खोज इतिहास खाली है';

  @override
  String get searchQueriesWillAppearHere => 'आपकी खोज क्वेरी यहाँ दिखाई देंगी';

  @override
  String foundLiensCount(int count) {
    return '$count लियन मिले';
  }

  @override
  String get availableForPurchase => 'खरीदने के लिए उपलब्ध';

  @override
  String get sold => 'बिक गया';

  @override
  String get redeemed => 'छुड़ाया गया';

  @override
  String get foreclosed => 'जब्त किया गया';

  @override
  String get purchaseLien => 'लियन खरीदें';

  @override
  String enterBidAmount(String amount) {
    return 'बोली राशि दर्ज करें (न्यूनतम $amount)';
  }

  @override
  String get lienPurchasedSuccessfully => 'लियन सफलतापूर्वक खरीदा गया!';

  @override
  String get purchaseError => 'खरीद में त्रुटि';

  @override
  String get invalidBidAmount => 'अवैध बोली राशि';

  @override
  String get purchase => 'खरीदें';

  @override
  String daysAgo(int days) {
    return '$days दिन पहले';
  }

  @override
  String hoursAgo(int hours) {
    return '$hours घंटे पहले';
  }

  @override
  String minutesAgo(int minutes) {
    return '$minutes मिनट पहले';
  }

  @override
  String get justNow => 'अभी';

  @override
  String get notAuthorized => 'अधिकृत नहीं';

  @override
  String get loginForAccess => 'सुविधाओं तक पहुंच के लिए कृपया लॉग इन करें';

  @override
  String get loginToAccount => 'खाते में लॉग इन करें';

  @override
  String get password => 'पासवर्ड';

  @override
  String get loginSuccessful => 'लॉग इन सफल!';

  @override
  String get loginError => 'लॉग इन में त्रुटि';

  @override
  String get registration => 'पंजीकरण';

  @override
  String get firstName => 'पहला नाम';

  @override
  String get lastName => 'उपनाम';

  @override
  String get registerAccount => 'खाता पंजीकृत करें';

  @override
  String get registrationSuccessful => 'पंजीकरण सफल!';

  @override
  String get registrationError => 'पंजीकरण में त्रुटि';

  @override
  String get logoutConfirmation => 'लॉगआउट की पुष्टि';

  @override
  String get logoutConfirmationMessage =>
      'क्या आप सुनिश्चित हैं कि आप लॉग आउट करना चाहते हैं?';

  @override
  String get balance => 'शेष';

  @override
  String get available => 'उपलब्ध';

  @override
  String get topUp => 'टॉप अप करें';

  @override
  String get quickActions => 'त्वरित कार्रवाई';

  @override
  String get transactionHistory => 'लेन-देन इतिहास';

  @override
  String get viewAllTransactions => 'सभी लेन-देन देखें';

  @override
  String get favoriteLiens => 'पसंदीदा लियन';

  @override
  String get savedLiens => 'सहेजे गए लियन';

  @override
  String get notifications => 'सूचनाएं';

  @override
  String get notificationSettings => 'सूचना सेटिंग्स';

  @override
  String get help => 'सहायता';

  @override
  String get appSettings => 'ऐप सेटिंग्स';

  @override
  String get russian => 'रूसी';

  @override
  String get security => 'सुरक्षा';

  @override
  String get securitySettings => 'सुरक्षा सेटिंग्स';

  @override
  String get privacy => 'गोपनीयता';

  @override
  String get privacySettings => 'गोपनीयता सेटिंग्स';

  @override
  String get aboutApp => 'ऐप के बारे में';

  @override
  String get version => 'संस्करण';

  @override
  String get license => 'लाइसेंस';

  @override
  String get termsOfService => 'सेवा की शर्तें';

  @override
  String get userAgreement => 'उपयोगकर्ता समझौता';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get dataProcessing => 'व्यक्तिगत डेटा प्रोसेसिंग';

  @override
  String get digitalFreedomGateway => 'डिजिटल स्वतंत्रता द्वार';

  @override
  String get systemStatus => 'सिस्टम स्थिति';

  @override
  String get stopped => 'रुका हुआ';

  @override
  String get file => 'फ़ाइल';

  @override
  String get seconds => 'सेकंड';

  @override
  String get playbackControls => 'प्लेबैक नियंत्रण';

  @override
  String get projectionSettings => 'प्रोजेक्शन सेटिंग्स';

  @override
  String get connection => 'कनेक्शन';
}
