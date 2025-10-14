import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_et.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_he.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_km.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_lo.dart';
import 'app_localizations_my.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_th.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('et'),
    Locale('fi'),
    Locale('fr'),
    Locale('he'),
    Locale('hi'),
    Locale('it'),
    Locale('ja'),
    Locale('km'),
    Locale('ko'),
    Locale('lo'),
    Locale('my'),
    Locale('pl'),
    Locale('pt'),
    Locale('ru'),
    Locale('th'),
    Locale('uk'),
    Locale('zh')
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'TaxLien.online'**
  String get appTitle;

  /// System status section header
  ///
  /// In en, this message translates to:
  /// **'System Status'**
  String get systemStatus;

  /// Playback status
  ///
  /// In en, this message translates to:
  /// **'Playback'**
  String get playback;

  /// Stopped status
  ///
  /// In en, this message translates to:
  /// **'Stopped'**
  String get stopped;

  /// File label
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get file;

  /// Playback position label
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get position;

  /// Seconds abbreviation
  ///
  /// In en, this message translates to:
  /// **'sec'**
  String get seconds;

  /// Playback controls section header
  ///
  /// In en, this message translates to:
  /// **'Playback Controls'**
  String get playbackControls;

  /// Play button
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// Pause button
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// Stop button
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// Volume label
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get volume;

  /// Projection settings section header
  ///
  /// In en, this message translates to:
  /// **'Projection Settings'**
  String get projectionSettings;

  /// Brightness label
  ///
  /// In en, this message translates to:
  /// **'Brightness'**
  String get brightness;

  /// Rotation label
  ///
  /// In en, this message translates to:
  /// **'Rotation'**
  String get rotation;

  /// Media files section header
  ///
  /// In en, this message translates to:
  /// **'Media Files'**
  String get mediaFiles;

  /// File type - image
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get image;

  /// Calibration button
  ///
  /// In en, this message translates to:
  /// **'Calibration'**
  String get calibration;

  /// Calibration screen title
  ///
  /// In en, this message translates to:
  /// **'Projection Calibration'**
  String get calibrationTitle;

  /// Preview section header
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// Offset section header
  ///
  /// In en, this message translates to:
  /// **'Offset'**
  String get offset;

  /// X offset label
  ///
  /// In en, this message translates to:
  /// **'X Offset'**
  String get xOffset;

  /// Y offset label
  ///
  /// In en, this message translates to:
  /// **'Y Offset'**
  String get yOffset;

  /// Scale and rotation section header
  ///
  /// In en, this message translates to:
  /// **'Scale and Rotation'**
  String get scaleRotation;

  /// Scale label
  ///
  /// In en, this message translates to:
  /// **'Scale'**
  String get scale;

  /// Apply button
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// Reset button
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Calibration applied successfully message
  ///
  /// In en, this message translates to:
  /// **'Calibration applied'**
  String get calibrationApplied;

  /// Connection status - online
  ///
  /// In en, this message translates to:
  /// **'ONLINE'**
  String get online;

  /// Connection status - offline
  ///
  /// In en, this message translates to:
  /// **'OFFLINE'**
  String get offline;

  /// Language settings screen title
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get languageSettings;

  /// Language change notification
  ///
  /// In en, this message translates to:
  /// **'Language changed'**
  String get languageChanged;

  /// Onboarding welcome screen title
  ///
  /// In en, this message translates to:
  /// **'Welcome to TaxLien.online'**
  String get onboardingWelcomeTitle;

  /// Onboarding welcome screen description
  ///
  /// In en, this message translates to:
  /// **'Your gateway to digital freedom and spiritual connection'**
  String get onboardingWelcomeDescription;

  /// Onboarding connection screen title
  ///
  /// In en, this message translates to:
  /// **'Connect to FreeDome'**
  String get onboardingConnectionTitle;

  /// Onboarding connection screen description
  ///
  /// In en, this message translates to:
  /// **'Establish a secure connection to your FreeDome network'**
  String get onboardingConnectionDescription;

  /// Onboarding dome control screen title
  ///
  /// In en, this message translates to:
  /// **'Dome Control'**
  String get onboardingDomeControlTitle;

  /// Onboarding dome control screen description
  ///
  /// In en, this message translates to:
  /// **'Control your dome settings and configurations'**
  String get onboardingDomeControlDescription;

  /// Onboarding calibration screen title
  ///
  /// In en, this message translates to:
  /// **'Calibration'**
  String get onboardingCalibrationTitle;

  /// Onboarding calibration screen description
  ///
  /// In en, this message translates to:
  /// **'Calibrate your dome for optimal performance'**
  String get onboardingCalibrationDescription;

  /// Onboarding media management screen title
  ///
  /// In en, this message translates to:
  /// **'Media Management'**
  String get onboardingMediaTitle;

  /// Onboarding media management screen description
  ///
  /// In en, this message translates to:
  /// **'Upload and manage your media files'**
  String get onboardingMediaDescription;

  /// Onboarding ready screen title
  ///
  /// In en, this message translates to:
  /// **'You\'re Ready!'**
  String get onboardingReadyTitle;

  /// Onboarding ready screen description
  ///
  /// In en, this message translates to:
  /// **'Start your journey to digital freedom'**
  String get onboardingReadyDescription;

  /// Next button in onboarding
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Back button in onboarding
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Skip button in onboarding
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Get started button in onboarding
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// Skip onboarding confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Skip Onboarding?'**
  String get skipConfirmationTitle;

  /// Skip onboarding confirmation dialog message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to skip the onboarding? You can always access the tutorial later from settings.'**
  String get skipConfirmationMessage;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Connection status message
  ///
  /// In en, this message translates to:
  /// **'Connecting to FreeDome...'**
  String get connectingToFreedome;

  /// Dome status message
  ///
  /// In en, this message translates to:
  /// **'Dome Status: Active'**
  String get domeStatusActive;

  /// Open button
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// Close button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Calibration progress message
  ///
  /// In en, this message translates to:
  /// **'Calibration Progress'**
  String get calibrationProgress;

  /// Media files count message
  ///
  /// In en, this message translates to:
  /// **'Media Files: {count} items'**
  String mediaFilesCount(int count);

  /// Upload button
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// Manage button
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manage;

  /// Server settings screen title
  ///
  /// In en, this message translates to:
  /// **'Server Settings'**
  String get serverSettings;

  /// Connection status screen title
  ///
  /// In en, this message translates to:
  /// **'Connection Status'**
  String get connectionStatus;

  /// Russian language name
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get russian;

  /// Ukrainian language name
  ///
  /// In en, this message translates to:
  /// **'Ukrainian'**
  String get ukrainian;

  /// English language name
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Chinese language name
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get chinese;

  /// Hindi language name
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get hindi;

  /// Thai language name
  ///
  /// In en, this message translates to:
  /// **'Thai'**
  String get thai;

  /// Data loading error message
  ///
  /// In en, this message translates to:
  /// **'Data loading error: {error}'**
  String dataLoadError(String error);

  /// Tax lien marketplace screen title
  ///
  /// In en, this message translates to:
  /// **'Tax Lien Marketplace'**
  String get taxLienMarketplace;

  /// Filters button tooltip
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// Refresh button tooltip
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// Search field hint text
  ///
  /// In en, this message translates to:
  /// **'Search by address, owner or parcel ID...'**
  String get searchHint;

  /// Clear button
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// Found liens count message
  ///
  /// In en, this message translates to:
  /// **'Found: {count} liens'**
  String foundLiens(int count);

  /// Sort by label
  ///
  /// In en, this message translates to:
  /// **'Sort by: {sortLabel}'**
  String sortBy(String sortLabel);

  /// Retry button
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No liens found message
  ///
  /// In en, this message translates to:
  /// **'No tax liens found'**
  String get noLiensFound;

  /// Suggestion to change search parameters
  ///
  /// In en, this message translates to:
  /// **'Try changing search parameters or filters'**
  String get tryChangingSearch;

  /// State filter label
  ///
  /// In en, this message translates to:
  /// **'State: {state}'**
  String stateFilter(String state);

  /// County filter label
  ///
  /// In en, this message translates to:
  /// **'County: {county}'**
  String countyFilter(String county);

  /// Minimum amount filter
  ///
  /// In en, this message translates to:
  /// **'From: {amount}'**
  String amountFrom(String amount);

  /// Maximum amount filter
  ///
  /// In en, this message translates to:
  /// **'To: {amount}'**
  String amountTo(String amount);

  /// Minimum interest rate filter
  ///
  /// In en, this message translates to:
  /// **'Rate from: {rate}%'**
  String interestRateFrom(String rate);

  /// Auction date sort label
  ///
  /// In en, this message translates to:
  /// **'Auction Date {direction}'**
  String auctionDateSort(String direction);

  /// Tax amount sort label
  ///
  /// In en, this message translates to:
  /// **'Tax Amount {direction}'**
  String taxAmountSort(String direction);

  /// Interest rate sort label
  ///
  /// In en, this message translates to:
  /// **'Interest Rate {direction}'**
  String interestRateSort(String direction);

  /// Assessed value sort label
  ///
  /// In en, this message translates to:
  /// **'Assessed Value {direction}'**
  String assessedValueSort(String direction);

  /// Redemption deadline sort label
  ///
  /// In en, this message translates to:
  /// **'Redemption Deadline {direction}'**
  String redemptionDeadlineSort(String direction);

  /// Lien number with parcel ID
  ///
  /// In en, this message translates to:
  /// **'Lien #{parcelId}'**
  String lienNumber(String parcelId);

  /// Owner information
  ///
  /// In en, this message translates to:
  /// **'Owner: {owner}'**
  String owner(String owner);

  /// Tax amount label
  ///
  /// In en, this message translates to:
  /// **'Tax Amount'**
  String get taxAmount;

  /// Interest rate label
  ///
  /// In en, this message translates to:
  /// **'Interest Rate'**
  String get interestRate;

  /// Assessed value label
  ///
  /// In en, this message translates to:
  /// **'Assessed Value'**
  String get assessedValue;

  /// Auction date label
  ///
  /// In en, this message translates to:
  /// **'Auction Date'**
  String get auctionDate;

  /// Additional information section header
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get additionalInfo;

  /// County label
  ///
  /// In en, this message translates to:
  /// **'County'**
  String get county;

  /// State label
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// Redemption deadline label
  ///
  /// In en, this message translates to:
  /// **'Redemption Deadline'**
  String get redemptionDeadline;

  /// Status label
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// Buy lien button
  ///
  /// In en, this message translates to:
  /// **'Buy Lien'**
  String get buyLien;

  /// Available for purchase status
  ///
  /// In en, this message translates to:
  /// **'Available for purchase'**
  String get availableForPurchase;

  /// Sold status
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get sold;

  /// Redeemed status
  ///
  /// In en, this message translates to:
  /// **'Redeemed'**
  String get redeemed;

  /// Foreclosed status
  ///
  /// In en, this message translates to:
  /// **'Foreclosed'**
  String get foreclosed;

  /// Purchase lien dialog title
  ///
  /// In en, this message translates to:
  /// **'Purchase Lien'**
  String get purchaseLien;

  /// Enter bid amount prompt
  ///
  /// In en, this message translates to:
  /// **'Enter bid amount (minimum {amount}):'**
  String enterBidAmount(String amount);

  /// Bid amount field label
  ///
  /// In en, this message translates to:
  /// **'Bid Amount'**
  String get bidAmount;

  /// Lien purchased success message
  ///
  /// In en, this message translates to:
  /// **'Lien purchased successfully!'**
  String get lienPurchasedSuccessfully;

  /// Purchase error message
  ///
  /// In en, this message translates to:
  /// **'Purchase error'**
  String get purchaseError;

  /// Invalid bid amount message
  ///
  /// In en, this message translates to:
  /// **'Invalid bid amount'**
  String get invalidBidAmount;

  /// Buy button
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get buy;

  /// Profile screen title
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Settings button label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Not authorized message
  ///
  /// In en, this message translates to:
  /// **'Not authorized'**
  String get notAuthorized;

  /// Login prompt message
  ///
  /// In en, this message translates to:
  /// **'Log in to access features'**
  String get loginForAccess;

  /// Login button
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Register button
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// Edit button
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Logout button
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Balance label
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// Available balance label
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// Top up button
  ///
  /// In en, this message translates to:
  /// **'Top Up'**
  String get topUp;

  /// Quick actions section header
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// Transaction history menu item
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transactionHistory;

  /// Transaction history subtitle
  ///
  /// In en, this message translates to:
  /// **'View all transactions'**
  String get viewAllTransactions;

  /// Favorite liens menu item
  ///
  /// In en, this message translates to:
  /// **'Favorite Liens'**
  String get favoriteLiens;

  /// Favorite liens subtitle
  ///
  /// In en, this message translates to:
  /// **'Your saved liens'**
  String get savedLiens;

  /// Notifications menu item
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Notifications subtitle
  ///
  /// In en, this message translates to:
  /// **'Notification settings'**
  String get notificationSettings;

  /// Help menu item
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// App settings section header
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// Language menu item
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Theme menu item
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Dark theme label
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// Light theme label
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// Security menu item
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// Security subtitle
  ///
  /// In en, this message translates to:
  /// **'Security settings'**
  String get securitySettings;

  /// Privacy menu item
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// Privacy subtitle
  ///
  /// In en, this message translates to:
  /// **'Privacy settings'**
  String get privacySettings;

  /// About app section header
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// Version menu item
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// License menu item
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get license;

  /// Terms of service menu item
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// Terms of service subtitle
  ///
  /// In en, this message translates to:
  /// **'User Agreement'**
  String get userAgreement;

  /// Privacy policy menu item
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Privacy policy subtitle
  ///
  /// In en, this message translates to:
  /// **'Personal data processing'**
  String get dataProcessing;

  /// Login dialog title
  ///
  /// In en, this message translates to:
  /// **'Login to Account'**
  String get loginToAccount;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Login success message
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get loginSuccessful;

  /// Login error message
  ///
  /// In en, this message translates to:
  /// **'Login error'**
  String get loginError;

  /// Registration dialog title
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get registration;

  /// First name field label
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// Last name field label
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// Registration success message
  ///
  /// In en, this message translates to:
  /// **'Registration successful!'**
  String get registrationSuccessful;

  /// Registration error message
  ///
  /// In en, this message translates to:
  /// **'Registration error'**
  String get registrationError;

  /// Register button in registration dialog
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerAccount;

  /// Logout confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Logout Confirmation'**
  String get logoutConfirmation;

  /// Logout confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmationMessage;

  /// My investments screen title
  ///
  /// In en, this message translates to:
  /// **'My Investments'**
  String get myInvestments;

  /// My liens tab title
  ///
  /// In en, this message translates to:
  /// **'My Liens'**
  String get myLiens;

  /// Favorites tab title
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// Statistics tab title
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No investments message
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any investments yet'**
  String get noInvestmentsYet;

  /// Suggestion to go to marketplace
  ///
  /// In en, this message translates to:
  /// **'Go to marketplace to buy tax liens'**
  String get goToMarketplace;

  /// Go to marketplace button
  ///
  /// In en, this message translates to:
  /// **'Go to Marketplace'**
  String get goToMarketplaceButton;

  /// No favorite liens message
  ///
  /// In en, this message translates to:
  /// **'No favorite liens'**
  String get noFavoriteLiens;

  /// Hint to add liens to favorites
  ///
  /// In en, this message translates to:
  /// **'Add liens to favorites for quick access'**
  String get addToFavoritesHint;

  /// Overall statistics section title
  ///
  /// In en, this message translates to:
  /// **'Overall Statistics'**
  String get overallStatistics;

  /// Total invested amount label
  ///
  /// In en, this message translates to:
  /// **'Total Invested'**
  String get totalInvested;

  /// Current value label
  ///
  /// In en, this message translates to:
  /// **'Current Value'**
  String get currentValue;

  /// Profit/loss label
  ///
  /// In en, this message translates to:
  /// **'Profit/Loss'**
  String get profitLoss;

  /// ROI label
  ///
  /// In en, this message translates to:
  /// **'ROI'**
  String get roi;

  /// Status statistics section title
  ///
  /// In en, this message translates to:
  /// **'Status Statistics'**
  String get statusStatistics;

  /// Active liens label
  ///
  /// In en, this message translates to:
  /// **'Active Liens'**
  String get activeLiens;

  /// Redeemed liens label
  ///
  /// In en, this message translates to:
  /// **'Redeemed Liens'**
  String get redeemedLiens;

  /// Foreclosed liens label
  ///
  /// In en, this message translates to:
  /// **'Foreclosed Liens'**
  String get foreclosedLiens;

  /// Total liens label
  ///
  /// In en, this message translates to:
  /// **'Total Liens'**
  String get totalLiens;

  /// Monthly returns chart title
  ///
  /// In en, this message translates to:
  /// **'Monthly Returns'**
  String get monthlyReturns;

  /// Profit chart development message
  ///
  /// In en, this message translates to:
  /// **'Profit Chart\n(in development)'**
  String get profitChartInDevelopment;

  /// Top performing liens section title
  ///
  /// In en, this message translates to:
  /// **'Top Performing Liens'**
  String get topPerformingLiens;

  /// Investment information section title
  ///
  /// In en, this message translates to:
  /// **'Investment Information'**
  String get investmentInfo;

  /// Purchase date label
  ///
  /// In en, this message translates to:
  /// **'Purchase Date'**
  String get purchaseDate;

  /// Purchase amount label
  ///
  /// In en, this message translates to:
  /// **'Purchase Amount'**
  String get purchaseAmount;

  /// Days in investment label
  ///
  /// In en, this message translates to:
  /// **'Days in Investment'**
  String get daysInInvestment;

  /// Interest earned label
  ///
  /// In en, this message translates to:
  /// **'Interest Earned'**
  String get interestEarned;

  /// Redemption date label
  ///
  /// In en, this message translates to:
  /// **'Redemption Date'**
  String get redemptionDate;

  /// App subtitle
  ///
  /// In en, this message translates to:
  /// **'Digital Freedom Gateway'**
  String get digitalFreedomGateway;

  /// Connection button label
  ///
  /// In en, this message translates to:
  /// **'Connection'**
  String get connection;

  /// Calibration screen coming soon message
  ///
  /// In en, this message translates to:
  /// **'Calibration screen coming soon'**
  String get calibrationScreenComingSoon;

  /// Media management coming soon message
  ///
  /// In en, this message translates to:
  /// **'Media management coming soon'**
  String get mediaManagementComingSoon;

  /// Lien search screen title
  ///
  /// In en, this message translates to:
  /// **'Lien Search'**
  String get lienSearch;

  /// Searching message
  ///
  /// In en, this message translates to:
  /// **'Searching...'**
  String get searching;

  /// No search history message
  ///
  /// In en, this message translates to:
  /// **'No search history'**
  String get noSearchHistory;

  /// Clear search history message
  ///
  /// In en, this message translates to:
  /// **'Clear search history'**
  String get clearSearchHistory;

  /// Search history section title
  ///
  /// In en, this message translates to:
  /// **'Search History'**
  String get searchHistory;

  /// Recent searches section title
  ///
  /// In en, this message translates to:
  /// **'Recent Searches'**
  String get recentSearches;

  /// Purchase button
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get purchase;

  /// Search history empty message
  ///
  /// In en, this message translates to:
  /// **'Search history is empty'**
  String get searchHistoryEmpty;

  /// Search queries will appear here message
  ///
  /// In en, this message translates to:
  /// **'Your search queries will appear here'**
  String get searchQueriesWillAppearHere;

  /// Nothing found message
  ///
  /// In en, this message translates to:
  /// **'Nothing found'**
  String get nothingFound;

  /// Try changing search query message
  ///
  /// In en, this message translates to:
  /// **'Try changing your search query'**
  String get tryChangingSearchQuery;

  /// Found liens count message
  ///
  /// In en, this message translates to:
  /// **'Found: {count} liens'**
  String foundLiensCount(int count);

  /// Days ago format
  ///
  /// In en, this message translates to:
  /// **'{days} days ago'**
  String daysAgo(int days);

  /// Hours ago format
  ///
  /// In en, this message translates to:
  /// **'{hours} hours ago'**
  String hoursAgo(int hours);

  /// Minutes ago format
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes ago'**
  String minutesAgo(int minutes);

  /// Just now format
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'de',
        'en',
        'es',
        'et',
        'fi',
        'fr',
        'he',
        'hi',
        'it',
        'ja',
        'km',
        'ko',
        'lo',
        'my',
        'pl',
        'pt',
        'ru',
        'th',
        'uk',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'et':
      return AppLocalizationsEt();
    case 'fi':
      return AppLocalizationsFi();
    case 'fr':
      return AppLocalizationsFr();
    case 'he':
      return AppLocalizationsHe();
    case 'hi':
      return AppLocalizationsHi();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'km':
      return AppLocalizationsKm();
    case 'ko':
      return AppLocalizationsKo();
    case 'lo':
      return AppLocalizationsLo();
    case 'my':
      return AppLocalizationsMy();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'th':
      return AppLocalizationsTh();
    case 'uk':
      return AppLocalizationsUk();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
