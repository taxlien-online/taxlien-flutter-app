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
  String get systemStatus => 'सिस्टम स्थिति';

  @override
  String get playback => 'प्लेबैक';

  @override
  String get stopped => 'रुका हुआ';

  @override
  String get file => 'फ़ाइल';

  @override
  String get position => 'स्थिति';

  @override
  String get seconds => 'सेकंड';

  @override
  String get playbackControls => 'प्लेबैक नियंत्रण';

  @override
  String get play => 'Play';

  @override
  String get pause => 'Pause';

  @override
  String get stop => 'Stop';

  @override
  String get volume => 'आवाज़';

  @override
  String get projectionSettings => 'प्रोजेक्शन सेटिंग्स';

  @override
  String get brightness => 'चमक';

  @override
  String get rotation => 'घूर्णन';

  @override
  String get mediaFiles => 'मीडिया फ़ाइलें';

  @override
  String get image => 'छवि';

  @override
  String get calibration => 'कैलिब्रेशन';

  @override
  String get calibrationTitle => 'प्रोजेक्शन कैलिब्रेशन';

  @override
  String get preview => 'पूर्वावलोकन';

  @override
  String get offset => 'ऑफ़सेट';

  @override
  String get xOffset => 'X ऑफ़सेट';

  @override
  String get yOffset => 'Y ऑफ़सेट';

  @override
  String get scaleRotation => 'स्केल और घूर्णन';

  @override
  String get scale => 'स्केल';

  @override
  String get apply => 'लागू करें';

  @override
  String get reset => 'रीसेट';

  @override
  String get calibrationApplied => 'कैलिब्रेशन लागू किया गया';

  @override
  String get online => 'ONLINE';

  @override
  String get offline => 'OFFLINE';

  @override
  String get languageSettings => 'भाषा सेटिंग्स';

  @override
  String get languageChanged => 'भाषा बदली गई';

  @override
  String get onboardingWelcomeTitle => 'TaxLien.online में आपका स्वागत है';

  @override
  String get onboardingWelcomeDescription =>
      'डिजिटल स्वतंत्रता और आध्यात्मिक संबंध के लिए आपका प्रवेश द्वार';

  @override
  String get onboardingConnectionTitle => 'FreeDome से कनेक्ट करें';

  @override
  String get onboardingConnectionDescription =>
      'अपने FreeDome नेटवर्क से सुरक्षित कनेक्शन स्थापित करें';

  @override
  String get onboardingDomeControlTitle => 'डोम नियंत्रण';

  @override
  String get onboardingDomeControlDescription =>
      'अपनी डोम की सेटिंग्स और कॉन्फ़िगरेशन को नियंत्रित करें';

  @override
  String get onboardingCalibrationTitle => 'कैलिब्रेशन';

  @override
  String get onboardingCalibrationDescription =>
      'इष्टतम प्रदर्शन के लिए अपनी डोम को कैलिब्रेट करें';

  @override
  String get onboardingMediaTitle => 'मीडिया प्रबंधन';

  @override
  String get onboardingMediaDescription =>
      'अपनी मीडिया फ़ाइलें अपलोड और प्रबंधित करें';

  @override
  String get onboardingReadyTitle => 'आप तैयार हैं!';

  @override
  String get onboardingReadyDescription =>
      'डिजिटल स्वतंत्रता की अपनी यात्रा शुरू करें';

  @override
  String get next => 'अगला';

  @override
  String get back => 'वापस';

  @override
  String get skip => 'छोड़ें';

  @override
  String get getStarted => 'शुरू करें';

  @override
  String get skipConfirmationTitle => 'ऑनबोर्डिंग छोड़ें?';

  @override
  String get skipConfirmationMessage =>
      'क्या आप वाकई ऑनबोर्डिंग छोड़ना चाहते हैं? आप बाद में सेटिंग्स से ट्यूटोरियल तक पहुंच सकते हैं।';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get connectingToFreedome => 'FreeDome से कनेक्ट हो रहा है...';

  @override
  String get domeStatusActive => 'डोम स्थिति: सक्रिय';

  @override
  String get open => 'खोलें';

  @override
  String get close => 'बंद करें';

  @override
  String get calibrationProgress => 'कैलिब्रेशन प्रगति';

  @override
  String mediaFilesCount(int count) {
    return 'मीडिया फ़ाइलें: $count आइटम';
  }

  @override
  String get upload => 'अपलोड';

  @override
  String get manage => 'प्रबंधित करें';

  @override
  String get serverSettings => 'सर्वर सेटिंग्स';

  @override
  String get connectionStatus => 'कनेक्शन स्थिति';

  @override
  String get russian => 'रूसी';

  @override
  String get ukrainian => 'यूक्रेनी';

  @override
  String dataLoadError(String error) {
    return 'डेटा लोडिंग त्रुटि: $error';
  }

  @override
  String get taxLienMarketplace => 'कर लीयन मार्केटप्लेस';

  @override
  String get filters => 'फ़िल्टर';

  @override
  String get refresh => 'रिफ्रेश';

  @override
  String get searchHint => 'पता, मालिक या पार्सल ID द्वारा खोजें...';

  @override
  String get clear => 'साफ़ करें';

  @override
  String foundLiens(int count) {
    return 'मिला: $count लीयन';
  }

  @override
  String sortBy(String sortLabel) {
    return 'इसके अनुसार क्रमबद्ध करें: $sortLabel';
  }

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String get noLiensFound => 'कोई कर लीयन नहीं मिला';

  @override
  String get tryChangingSearch =>
      'खोज पैरामीटर या फ़िल्टर बदलने का प्रयास करें';

  @override
  String stateFilter(String state) {
    return 'राज्य: $state';
  }

  @override
  String countyFilter(String county) {
    return 'काउंटी: $county';
  }

  @override
  String amountFrom(String amount) {
    return 'से: $amount';
  }

  @override
  String amountTo(String amount) {
    return 'तक: $amount';
  }

  @override
  String interestRateFrom(String rate) {
    return 'दर से: $rate%';
  }

  @override
  String auctionDateSort(String direction) {
    return 'नीलामी तिथि $direction';
  }

  @override
  String taxAmountSort(String direction) {
    return 'कर राशि $direction';
  }

  @override
  String interestRateSort(String direction) {
    return 'ब्याज दर $direction';
  }

  @override
  String assessedValueSort(String direction) {
    return 'मूल्यांकित मूल्य $direction';
  }

  @override
  String redemptionDeadlineSort(String direction) {
    return 'मोचन समय सीमा $direction';
  }

  @override
  String lienNumber(String parcelId) {
    return 'लीयन #$parcelId';
  }

  @override
  String owner(String owner) {
    return 'मालिक: $owner';
  }

  @override
  String get taxAmount => 'कर राशि';

  @override
  String get interestRate => 'ब्याज दर';

  @override
  String get assessedValue => 'मूल्यांकित मूल्य';

  @override
  String get auctionDate => 'नीलामी तिथि';

  @override
  String get additionalInfo => 'अतिरिक्त जानकारी';

  @override
  String get county => 'काउंटी';

  @override
  String get state => 'राज्य';

  @override
  String get redemptionDeadline => 'मोचन समय सीमा';

  @override
  String get status => 'स्थिति';

  @override
  String get buyLien => 'लीयन खरीदें';

  @override
  String get availableForPurchase => 'खरीदने के लिए उपलब्ध';

  @override
  String get sold => 'बिक गया';

  @override
  String get redeemed => 'मोचित';

  @override
  String get foreclosed => 'जब्त';

  @override
  String get purchaseLien => 'लीयन खरीदें';

  @override
  String enterBidAmount(String amount) {
    return 'बोली राशि दर्ज करें (न्यूनतम $amount):';
  }

  @override
  String get bidAmount => 'बोली राशि';

  @override
  String get lienPurchasedSuccessfully => 'लीयन सफलतापूर्वक खरीदा गया!';

  @override
  String get purchaseError => 'खरीद त्रुटि';

  @override
  String get invalidBidAmount => 'अमान्य बोली राशि';

  @override
  String get buy => 'खरीदें';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get notAuthorized => 'अनधिकृत';

  @override
  String get loginForAccess => 'सुविधाओं तक पहुंचने के लिए लॉगिन करें';

  @override
  String get login => 'लॉगिन';

  @override
  String get register => 'पंजीकरण';

  @override
  String get edit => 'संपादित करें';

  @override
  String get logout => 'लॉगआउट';

  @override
  String get balance => 'शेष राशि';

  @override
  String get available => 'उपलब्ध';

  @override
  String get topUp => 'टॉप अप';

  @override
  String get quickActions => 'त्वरित कार्य';

  @override
  String get transactionHistory => 'लेन-देन इतिहास';

  @override
  String get viewAllTransactions => 'सभी लेन-देन देखें';

  @override
  String get favoriteLiens => 'पसंदीदा लीयन';

  @override
  String get savedLiens => 'आपके सहेजे गए लीयन';

  @override
  String get notifications => 'सूचनाएं';

  @override
  String get notificationSettings => 'सूचना सेटिंग्स';

  @override
  String get help => 'सहायता';

  @override
  String get appSettings => 'ऐप सेटिंग्स';

  @override
  String get language => 'भाषा';

  @override
  String get theme => 'थीम';

  @override
  String get dark => 'डार्क';

  @override
  String get light => 'लाइट';

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
  String get dataProcessing => 'व्यक्तिगत डेटा प्रसंस्करण';

  @override
  String get loginToAccount => 'खाते में लॉगिन करें';

  @override
  String get password => 'पासवर्ड';

  @override
  String get loginSuccessful => 'लॉगिन सफल!';

  @override
  String get loginError => 'लॉगिन त्रुटि';

  @override
  String get registration => 'पंजीकरण';

  @override
  String get firstName => 'पहला नाम';

  @override
  String get lastName => 'अंतिम नाम';

  @override
  String get registrationSuccessful => 'पंजीकरण सफल!';

  @override
  String get registrationError => 'पंजीकरण त्रुटि';

  @override
  String get registerAccount => 'पंजीकरण करें';

  @override
  String get logoutConfirmation => 'लॉगआउट पुष्टि';

  @override
  String get logoutConfirmationMessage => 'क्या आप वाकई लॉगआउट करना चाहते हैं?';

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
