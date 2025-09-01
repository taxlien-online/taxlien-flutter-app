// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'TaxLien.online';

  @override
  String get systemStatus => '시스템 상태';

  @override
  String get playback => '재생';

  @override
  String get stopped => '중지됨';

  @override
  String get file => '파일';

  @override
  String get position => '위치';

  @override
  String get seconds => '초';

  @override
  String get playbackControls => '재생 제어';

  @override
  String get play => '재생';

  @override
  String get pause => '일시정지';

  @override
  String get stop => '중지';

  @override
  String get volume => '볼륨';

  @override
  String get projectionSettings => '투영 설정';

  @override
  String get brightness => '밝기';

  @override
  String get rotation => '회전';

  @override
  String get mediaFiles => '미디어 파일';

  @override
  String get image => '이미지';

  @override
  String get calibration => '보정';

  @override
  String get calibrationTitle => '투영 보정';

  @override
  String get preview => '미리보기';

  @override
  String get offset => '오프셋';

  @override
  String get xOffset => 'X 오프셋';

  @override
  String get yOffset => 'Y 오프셋';

  @override
  String get scaleRotation => '스케일 및 회전';

  @override
  String get scale => '스케일';

  @override
  String get apply => '적용';

  @override
  String get reset => '재설정';

  @override
  String get calibrationApplied => '보정이 적용되었습니다';

  @override
  String get online => '온라인';

  @override
  String get offline => '오프라인';

  @override
  String get languageSettings => '언어 설정';

  @override
  String get languageChanged => '언어가 변경되었습니다';

  @override
  String get onboardingWelcomeTitle => 'TaxLien.online에 오신 것을 환영합니다';

  @override
  String get onboardingWelcomeDescription => '디지털 자유와 영적 연결로의 관문';

  @override
  String get onboardingConnectionTitle => 'FreeDome에 연결';

  @override
  String get onboardingConnectionDescription => 'FreeDome 네트워크에 안전한 연결을 설정하세요';

  @override
  String get onboardingDomeControlTitle => '돔 제어';

  @override
  String get onboardingDomeControlDescription => '돔의 설정과 구성을 제어하세요';

  @override
  String get onboardingCalibrationTitle => '보정';

  @override
  String get onboardingCalibrationDescription => '최적의 성능을 위해 돔을 보정하세요';

  @override
  String get onboardingMediaTitle => '미디어 관리';

  @override
  String get onboardingMediaDescription => '미디어 파일을 업로드하고 관리하세요';

  @override
  String get onboardingReadyTitle => '준비 완료!';

  @override
  String get onboardingReadyDescription => '디지털 자유로의 여정을 시작하세요';

  @override
  String get next => '다음';

  @override
  String get back => '뒤로';

  @override
  String get skip => '건너뛰기';

  @override
  String get getStarted => '시작하기';

  @override
  String get skipConfirmationTitle => '온보딩을 건너뛰시겠습니까?';

  @override
  String get skipConfirmationMessage =>
      '온보딩을 건너뛰시겠습니까? 설정에서 언제든지 튜토리얼에 접근할 수 있습니다.';

  @override
  String get cancel => '취소';

  @override
  String get connectingToFreedome => 'FreeDome에 연결 중...';

  @override
  String get domeStatusActive => '돔 상태: 활성';

  @override
  String get open => '열기';

  @override
  String get close => '닫기';

  @override
  String get calibrationProgress => '보정 진행률';

  @override
  String mediaFilesCount(int count) {
    return '미디어 파일: $count개 항목';
  }

  @override
  String get upload => '업로드';

  @override
  String get manage => '관리';

  @override
  String get serverSettings => '서버 설정';

  @override
  String get connectionStatus => '연결 상태';

  @override
  String get russian => '러시아어';

  @override
  String get ukrainian => '우크라이나어';

  @override
  String dataLoadError(String error) {
    return '데이터 로드 오류: $error';
  }

  @override
  String get taxLienMarketplace => '세금 압류 마켓플레이스';

  @override
  String get filters => '필터';

  @override
  String get refresh => '새로고침';

  @override
  String get searchHint => '주소, 소유자 또는 부지 ID로 검색...';

  @override
  String get clear => '지우기';

  @override
  String foundLiens(int count) {
    return '발견됨: $count개 압류';
  }

  @override
  String sortBy(String sortLabel) {
    return '정렬 기준: $sortLabel';
  }

  @override
  String get retry => '다시 시도';

  @override
  String get noLiensFound => '세금 압류를 찾을 수 없습니다';

  @override
  String get tryChangingSearch => '검색 매개변수나 필터를 변경해 보세요';

  @override
  String stateFilter(String state) {
    return '주: $state';
  }

  @override
  String countyFilter(String county) {
    return '카운티: $county';
  }

  @override
  String amountFrom(String amount) {
    return '금액: $amount부터';
  }

  @override
  String amountTo(String amount) {
    return '금액: $amount까지';
  }

  @override
  String interestRateFrom(String rate) {
    return '이자율: $rate%부터';
  }

  @override
  String auctionDateSort(String direction) {
    return '경매 날짜 $direction';
  }

  @override
  String taxAmountSort(String direction) {
    return '세금 금액 $direction';
  }

  @override
  String interestRateSort(String direction) {
    return '이자율 $direction';
  }

  @override
  String assessedValueSort(String direction) {
    return '평가 가치 $direction';
  }

  @override
  String redemptionDeadlineSort(String direction) {
    return '상환 기한 $direction';
  }

  @override
  String lienNumber(String parcelId) {
    return '압류 #$parcelId';
  }

  @override
  String owner(String owner) {
    return '소유자: $owner';
  }

  @override
  String get taxAmount => '세금 금액';

  @override
  String get interestRate => '이자율';

  @override
  String get assessedValue => '평가 가치';

  @override
  String get auctionDate => '경매 날짜';

  @override
  String get additionalInfo => '추가 정보';

  @override
  String get county => '카운티';

  @override
  String get state => '주';

  @override
  String get redemptionDeadline => '상환 기한';

  @override
  String get status => '상태';

  @override
  String get buyLien => '압류 구매';

  @override
  String get availableForPurchase => '구매 가능';

  @override
  String get sold => '판매됨';

  @override
  String get redeemed => '상환됨';

  @override
  String get foreclosed => '압류됨';

  @override
  String get purchaseLien => '압류 구매';

  @override
  String enterBidAmount(String amount) {
    return '입찰 금액을 입력하세요 (최소 $amount):';
  }

  @override
  String get bidAmount => '입찰 금액';

  @override
  String get lienPurchasedSuccessfully => '압류가 성공적으로 구매되었습니다!';

  @override
  String get purchaseError => '구매 오류';

  @override
  String get invalidBidAmount => '잘못된 입찰 금액';

  @override
  String get buy => '구매';

  @override
  String get profile => '프로필';

  @override
  String get settings => '설정';

  @override
  String get notAuthorized => '인증되지 않음';

  @override
  String get loginForAccess => '기능에 액세스하려면 로그인하세요';

  @override
  String get login => '로그인';

  @override
  String get register => '등록';

  @override
  String get edit => '편집';

  @override
  String get logout => '로그아웃';

  @override
  String get balance => '잔액';

  @override
  String get available => '사용 가능';

  @override
  String get topUp => '충전';

  @override
  String get quickActions => '빠른 작업';

  @override
  String get transactionHistory => '거래 내역';

  @override
  String get viewAllTransactions => '모든 거래 보기';

  @override
  String get favoriteLiens => '즐겨찾기 압류';

  @override
  String get savedLiens => '저장된 압류';

  @override
  String get notifications => '알림';

  @override
  String get notificationSettings => '알림 설정';

  @override
  String get help => '도움말';

  @override
  String get appSettings => '앱 설정';

  @override
  String get language => '언어';

  @override
  String get theme => '테마';

  @override
  String get dark => '어두운';

  @override
  String get light => '밝은';

  @override
  String get security => '보안';

  @override
  String get securitySettings => '보안 설정';

  @override
  String get privacy => '개인정보';

  @override
  String get privacySettings => '개인정보 설정';

  @override
  String get aboutApp => '앱 정보';

  @override
  String get version => '버전';

  @override
  String get license => '라이선스';

  @override
  String get termsOfService => '서비스 약관';

  @override
  String get userAgreement => '사용자 계약';

  @override
  String get privacyPolicy => '개인정보 처리방침';

  @override
  String get dataProcessing => '개인정보 처리';

  @override
  String get loginToAccount => '계정에 로그인';

  @override
  String get password => '비밀번호';

  @override
  String get loginSuccessful => '로그인이 성공했습니다!';

  @override
  String get loginError => '로그인 오류';

  @override
  String get registration => '등록';

  @override
  String get firstName => '이름';

  @override
  String get lastName => '성';

  @override
  String get registrationSuccessful => '등록이 성공했습니다!';

  @override
  String get registrationError => '등록 오류';

  @override
  String get registerAccount => '등록';

  @override
  String get logoutConfirmation => '로그아웃 확인';

  @override
  String get logoutConfirmationMessage => '로그아웃하시겠습니까?';

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
