// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'TaxLien.online';

  @override
  String get systemStatus => '系统状态';

  @override
  String get playback => '播放';

  @override
  String get stopped => '已停止';

  @override
  String get file => '文件';

  @override
  String get position => '位置';

  @override
  String get seconds => '秒';

  @override
  String get playbackControls => '播放控制';

  @override
  String get play => '播放';

  @override
  String get pause => '暂停';

  @override
  String get stop => '停止';

  @override
  String get volume => '音量';

  @override
  String get projectionSettings => '投影设置';

  @override
  String get brightness => '亮度';

  @override
  String get rotation => '旋转';

  @override
  String get mediaFiles => '媒体文件';

  @override
  String get image => '图像';

  @override
  String get calibration => '校准';

  @override
  String get calibrationTitle => '投影校准';

  @override
  String get preview => '预览';

  @override
  String get offset => '偏移';

  @override
  String get xOffset => 'X 偏移';

  @override
  String get yOffset => 'Y 偏移';

  @override
  String get scaleRotation => '缩放和旋转';

  @override
  String get scale => '缩放';

  @override
  String get apply => '应用';

  @override
  String get reset => '重置';

  @override
  String get calibrationApplied => '校准已应用';

  @override
  String get online => '在线';

  @override
  String get offline => '离线';

  @override
  String get languageSettings => '语言设置';

  @override
  String get languageChanged => '语言已更改';

  @override
  String get onboardingWelcomeTitle => '欢迎使用 TaxLien.online';

  @override
  String get onboardingWelcomeDescription => '通往数字自由和精神连接的网关';

  @override
  String get onboardingConnectionTitle => '连接到 FreeDome';

  @override
  String get onboardingConnectionDescription => '建立与您的 FreeDome 网络的安全连接';

  @override
  String get onboardingDomeControlTitle => '穹顶控制';

  @override
  String get onboardingDomeControlDescription => '控制您的穹顶设置和配置';

  @override
  String get onboardingCalibrationTitle => '校准';

  @override
  String get onboardingCalibrationDescription => '校准您的穹顶以获得最佳性能';

  @override
  String get onboardingMediaTitle => '媒体管理';

  @override
  String get onboardingMediaDescription => '上传和管理您的媒体文件';

  @override
  String get onboardingReadyTitle => '您已准备就绪！';

  @override
  String get onboardingReadyDescription => '开始您通往数字自由的旅程';

  @override
  String get next => '下一步';

  @override
  String get back => '返回';

  @override
  String get skip => '跳过';

  @override
  String get getStarted => '开始使用';

  @override
  String get skipConfirmationTitle => '跳过引导？';

  @override
  String get skipConfirmationMessage => '您确定要跳过引导吗？您随时可以从设置中访问教程。';

  @override
  String get cancel => '取消';

  @override
  String get connectingToFreedome => '正在连接到 FreeDome...';

  @override
  String get domeStatusActive => '穹顶状态：活跃';

  @override
  String get open => '打开';

  @override
  String get close => '关闭';

  @override
  String get calibrationProgress => '校准进度';

  @override
  String mediaFilesCount(int count) {
    return '媒体文件：$count 项';
  }

  @override
  String get upload => '上传';

  @override
  String get manage => '管理';

  @override
  String get serverSettings => '服务器设置';

  @override
  String get connectionStatus => '连接状态';

  @override
  String get russian => '俄语';

  @override
  String get ukrainian => '乌克兰语';

  @override
  String dataLoadError(String error) {
    return '数据加载错误：$error';
  }

  @override
  String get taxLienMarketplace => '税务留置权市场';

  @override
  String get filters => '筛选';

  @override
  String get refresh => '刷新';

  @override
  String get searchHint => '按地址、所有者或地块ID搜索...';

  @override
  String get clear => '清除';

  @override
  String foundLiens(int count) {
    return '找到：$count 个留置权';
  }

  @override
  String sortBy(String sortLabel) {
    return '排序方式：$sortLabel';
  }

  @override
  String get retry => '重试';

  @override
  String get noLiensFound => '未找到税务留置权';

  @override
  String get tryChangingSearch => '尝试更改搜索参数或筛选条件';

  @override
  String stateFilter(String state) {
    return '州：$state';
  }

  @override
  String countyFilter(String county) {
    return '县：$county';
  }

  @override
  String amountFrom(String amount) {
    return '从：$amount';
  }

  @override
  String amountTo(String amount) {
    return '至：$amount';
  }

  @override
  String interestRateFrom(String rate) {
    return '利率从：$rate%';
  }

  @override
  String auctionDateSort(String direction) {
    return '拍卖日期 $direction';
  }

  @override
  String taxAmountSort(String direction) {
    return '税额 $direction';
  }

  @override
  String interestRateSort(String direction) {
    return '利率 $direction';
  }

  @override
  String assessedValueSort(String direction) {
    return '评估价值 $direction';
  }

  @override
  String redemptionDeadlineSort(String direction) {
    return '赎回截止日期 $direction';
  }

  @override
  String lienNumber(String parcelId) {
    return '留置权 #$parcelId';
  }

  @override
  String owner(String owner) {
    return '所有者：$owner';
  }

  @override
  String get taxAmount => '税额';

  @override
  String get interestRate => '利率';

  @override
  String get assessedValue => '评估价值';

  @override
  String get auctionDate => '拍卖日期';

  @override
  String get additionalInfo => '附加信息';

  @override
  String get county => '县';

  @override
  String get state => '州';

  @override
  String get redemptionDeadline => '赎回截止日期';

  @override
  String get status => '状态';

  @override
  String get buyLien => '购买留置权';

  @override
  String get availableForPurchase => '可购买';

  @override
  String get sold => '已售出';

  @override
  String get redeemed => '已赎回';

  @override
  String get foreclosed => '已止赎';

  @override
  String get purchaseLien => '购买留置权';

  @override
  String enterBidAmount(String amount) {
    return '输入投标金额（最低 $amount）：';
  }

  @override
  String get bidAmount => '投标金额';

  @override
  String get lienPurchasedSuccessfully => '留置权购买成功！';

  @override
  String get purchaseError => '购买错误';

  @override
  String get invalidBidAmount => '无效的投标金额';

  @override
  String get buy => '购买';

  @override
  String get profile => '个人资料';

  @override
  String get settings => '设置';

  @override
  String get notAuthorized => '未授权';

  @override
  String get loginForAccess => '登录以访问功能';

  @override
  String get login => '登录';

  @override
  String get register => '注册';

  @override
  String get edit => '编辑';

  @override
  String get logout => '登出';

  @override
  String get balance => '余额';

  @override
  String get available => '可用';

  @override
  String get topUp => '充值';

  @override
  String get quickActions => '快速操作';

  @override
  String get transactionHistory => '交易历史';

  @override
  String get viewAllTransactions => '查看所有交易';

  @override
  String get favoriteLiens => '收藏留置权';

  @override
  String get savedLiens => '您保存的留置权';

  @override
  String get notifications => '通知';

  @override
  String get notificationSettings => '通知设置';

  @override
  String get help => '帮助';

  @override
  String get appSettings => '应用设置';

  @override
  String get language => '语言';

  @override
  String get theme => '主题';

  @override
  String get dark => '深色';

  @override
  String get light => '浅色';

  @override
  String get security => '安全';

  @override
  String get securitySettings => '安全设置';

  @override
  String get privacy => '隐私';

  @override
  String get privacySettings => '隐私设置';

  @override
  String get aboutApp => '关于应用';

  @override
  String get version => '版本';

  @override
  String get license => '许可证';

  @override
  String get termsOfService => '服务条款';

  @override
  String get userAgreement => '用户协议';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get dataProcessing => '个人数据处理';

  @override
  String get loginToAccount => '登录账户';

  @override
  String get password => '密码';

  @override
  String get loginSuccessful => '登录成功！';

  @override
  String get loginError => '登录错误';

  @override
  String get registration => '注册';

  @override
  String get firstName => '名字';

  @override
  String get lastName => '姓氏';

  @override
  String get registrationSuccessful => '注册成功！';

  @override
  String get registrationError => '注册错误';

  @override
  String get registerAccount => '注册';

  @override
  String get logoutConfirmation => '登出确认';

  @override
  String get logoutConfirmationMessage => '您确定要登出吗？';

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
