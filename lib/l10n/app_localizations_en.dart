// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'TaxLien.online';

  @override
  String get systemStatus => 'System Status';

  @override
  String get playback => 'Playback';

  @override
  String get stopped => 'Stopped';

  @override
  String get file => 'File';

  @override
  String get position => 'Position';

  @override
  String get seconds => 'sec';

  @override
  String get playbackControls => 'Playback Controls';

  @override
  String get play => 'Play';

  @override
  String get pause => 'Pause';

  @override
  String get stop => 'Stop';

  @override
  String get volume => 'Volume';

  @override
  String get projectionSettings => 'Projection Settings';

  @override
  String get brightness => 'Brightness';

  @override
  String get rotation => 'Rotation';

  @override
  String get mediaFiles => 'Media Files';

  @override
  String get image => 'Image';

  @override
  String get calibration => 'Calibration';

  @override
  String get calibrationTitle => 'Projection Calibration';

  @override
  String get preview => 'Preview';

  @override
  String get offset => 'Offset';

  @override
  String get xOffset => 'X Offset';

  @override
  String get yOffset => 'Y Offset';

  @override
  String get scaleRotation => 'Scale and Rotation';

  @override
  String get scale => 'Scale';

  @override
  String get apply => 'Apply';

  @override
  String get reset => 'Reset';

  @override
  String get calibrationApplied => 'Calibration applied';

  @override
  String get online => 'ONLINE';

  @override
  String get offline => 'OFFLINE';

  @override
  String get languageSettings => 'Language Settings';

  @override
  String get languageChanged => 'Language changed';

  @override
  String get onboardingWelcomeTitle => 'Welcome to TaxLien.online';

  @override
  String get onboardingWelcomeDescription =>
      'Your gateway to digital freedom and spiritual connection';

  @override
  String get onboardingConnectionTitle => 'Connect to FreeDome';

  @override
  String get onboardingConnectionDescription =>
      'Establish a secure connection to your FreeDome network';

  @override
  String get onboardingDomeControlTitle => 'Dome Control';

  @override
  String get onboardingDomeControlDescription =>
      'Control your dome settings and configurations';

  @override
  String get onboardingCalibrationTitle => 'Calibration';

  @override
  String get onboardingCalibrationDescription =>
      'Calibrate your dome for optimal performance';

  @override
  String get onboardingMediaTitle => 'Media Management';

  @override
  String get onboardingMediaDescription => 'Upload and manage your media files';

  @override
  String get onboardingReadyTitle => 'You\'re Ready!';

  @override
  String get onboardingReadyDescription =>
      'Start your journey to digital freedom';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get skip => 'Skip';

  @override
  String get getStarted => 'Get Started';

  @override
  String get skipConfirmationTitle => 'Skip Onboarding?';

  @override
  String get skipConfirmationMessage =>
      'Are you sure you want to skip the onboarding? You can always access the tutorial later from settings.';

  @override
  String get cancel => 'Cancel';

  @override
  String get connectingToFreedome => 'Connecting to FreeDome...';

  @override
  String get domeStatusActive => 'Dome Status: Active';

  @override
  String get open => 'Open';

  @override
  String get close => 'Close';

  @override
  String get calibrationProgress => 'Calibration Progress';

  @override
  String mediaFilesCount(int count) {
    return 'Media Files: $count items';
  }

  @override
  String get upload => 'Upload';

  @override
  String get manage => 'Manage';

  @override
  String get serverSettings => 'Server Settings';

  @override
  String get connectionStatus => 'Connection Status';

  @override
  String get russian => 'Russian';

  @override
  String get ukrainian => 'Ukrainian';

  @override
  String dataLoadError(String error) {
    return 'Data loading error: $error';
  }

  @override
  String get taxLienMarketplace => 'Tax Lien Marketplace';

  @override
  String get filters => 'Filters';

  @override
  String get refresh => 'Refresh';

  @override
  String get searchHint => 'Search by address, owner or parcel ID...';

  @override
  String get clear => 'Clear';

  @override
  String foundLiens(int count) {
    return 'Found: $count liens';
  }

  @override
  String sortBy(String sortLabel) {
    return 'Sort by: $sortLabel';
  }

  @override
  String get retry => 'Retry';

  @override
  String get noLiensFound => 'No tax liens found';

  @override
  String get tryChangingSearch => 'Try changing search parameters or filters';

  @override
  String stateFilter(String state) {
    return 'State: $state';
  }

  @override
  String countyFilter(String county) {
    return 'County: $county';
  }

  @override
  String amountFrom(String amount) {
    return 'From: $amount';
  }

  @override
  String amountTo(String amount) {
    return 'To: $amount';
  }

  @override
  String interestRateFrom(String rate) {
    return 'Rate from: $rate%';
  }

  @override
  String auctionDateSort(String direction) {
    return 'Auction Date $direction';
  }

  @override
  String taxAmountSort(String direction) {
    return 'Tax Amount $direction';
  }

  @override
  String interestRateSort(String direction) {
    return 'Interest Rate $direction';
  }

  @override
  String assessedValueSort(String direction) {
    return 'Assessed Value $direction';
  }

  @override
  String redemptionDeadlineSort(String direction) {
    return 'Redemption Deadline $direction';
  }

  @override
  String lienNumber(String parcelId) {
    return 'Lien #$parcelId';
  }

  @override
  String owner(String owner) {
    return 'Owner: $owner';
  }

  @override
  String get taxAmount => 'Tax Amount';

  @override
  String get interestRate => 'Interest Rate';

  @override
  String get assessedValue => 'Assessed Value';

  @override
  String get auctionDate => 'Auction Date';

  @override
  String get additionalInfo => 'Additional Information';

  @override
  String get county => 'County';

  @override
  String get state => 'State';

  @override
  String get redemptionDeadline => 'Redemption Deadline';

  @override
  String get status => 'Status';

  @override
  String get buyLien => 'Buy Lien';

  @override
  String get availableForPurchase => 'Available for purchase';

  @override
  String get sold => 'Sold';

  @override
  String get redeemed => 'Redeemed';

  @override
  String get foreclosed => 'Foreclosed';

  @override
  String get purchaseLien => 'Purchase Lien';

  @override
  String enterBidAmount(String amount) {
    return 'Enter bid amount (minimum $amount):';
  }

  @override
  String get bidAmount => 'Bid Amount';

  @override
  String get lienPurchasedSuccessfully => 'Lien purchased successfully!';

  @override
  String get purchaseError => 'Purchase error';

  @override
  String get invalidBidAmount => 'Invalid bid amount';

  @override
  String get buy => 'Buy';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get notAuthorized => 'Not authorized';

  @override
  String get loginForAccess => 'Log in to access features';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get edit => 'Edit';

  @override
  String get logout => 'Logout';

  @override
  String get balance => 'Balance';

  @override
  String get available => 'Available';

  @override
  String get topUp => 'Top Up';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get transactionHistory => 'Transaction History';

  @override
  String get viewAllTransactions => 'View all transactions';

  @override
  String get favoriteLiens => 'Favorite Liens';

  @override
  String get savedLiens => 'Your saved liens';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationSettings => 'Notification settings';

  @override
  String get help => 'Help';

  @override
  String get appSettings => 'App Settings';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get dark => 'Dark';

  @override
  String get light => 'Light';

  @override
  String get security => 'Security';

  @override
  String get securitySettings => 'Security settings';

  @override
  String get privacy => 'Privacy';

  @override
  String get privacySettings => 'Privacy settings';

  @override
  String get aboutApp => 'About App';

  @override
  String get version => 'Version';

  @override
  String get license => 'License';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get userAgreement => 'User Agreement';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get dataProcessing => 'Personal data processing';

  @override
  String get loginToAccount => 'Login to Account';

  @override
  String get password => 'Password';

  @override
  String get loginSuccessful => 'Login successful!';

  @override
  String get loginError => 'Login error';

  @override
  String get registration => 'Registration';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get registrationSuccessful => 'Registration successful!';

  @override
  String get registrationError => 'Registration error';

  @override
  String get registerAccount => 'Register';

  @override
  String get logoutConfirmation => 'Logout Confirmation';

  @override
  String get logoutConfirmationMessage => 'Are you sure you want to logout?';

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
