// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'TaxLien.online';

  @override
  String get systemStatus => 'システムステータス';

  @override
  String get playback => '再生';

  @override
  String get stopped => '停止';

  @override
  String get file => 'ファイル';

  @override
  String get position => '位置';

  @override
  String get seconds => '秒';

  @override
  String get playbackControls => '再生コントロール';

  @override
  String get play => '再生';

  @override
  String get pause => '一時停止';

  @override
  String get stop => '停止';

  @override
  String get volume => '音量';

  @override
  String get projectionSettings => '投影設定';

  @override
  String get brightness => '明度';

  @override
  String get rotation => '回転';

  @override
  String get mediaFiles => 'メディアファイル';

  @override
  String get image => '画像';

  @override
  String get calibration => 'キャリブレーション';

  @override
  String get calibrationTitle => '投影キャリブレーション';

  @override
  String get preview => 'プレビュー';

  @override
  String get offset => 'オフセット';

  @override
  String get xOffset => 'X オフセット';

  @override
  String get yOffset => 'Y オフセット';

  @override
  String get scaleRotation => 'スケールと回転';

  @override
  String get scale => 'スケール';

  @override
  String get apply => '適用';

  @override
  String get reset => 'リセット';

  @override
  String get calibrationApplied => 'キャリブレーションが適用されました';

  @override
  String get online => 'オンライン';

  @override
  String get offline => 'オフライン';

  @override
  String get languageSettings => '言語設定';

  @override
  String get languageChanged => '言語が変更されました';

  @override
  String get onboardingWelcomeTitle => 'TaxLien.online へようこそ';

  @override
  String get onboardingWelcomeDescription => 'デジタル自由とスピリチュアルなつながりへのゲートウェイ';

  @override
  String get onboardingConnectionTitle => 'FreeDome に接続';

  @override
  String get onboardingConnectionDescription => 'FreeDome ネットワークへの安全な接続を確立';

  @override
  String get onboardingDomeControlTitle => 'ドームコントロール';

  @override
  String get onboardingDomeControlDescription => 'ドームの設定と構成を制御';

  @override
  String get onboardingCalibrationTitle => 'キャリブレーション';

  @override
  String get onboardingCalibrationDescription => '最適なパフォーマンスのためにドームをキャリブレーション';

  @override
  String get onboardingMediaTitle => 'メディア管理';

  @override
  String get onboardingMediaDescription => 'メディアファイルをアップロードして管理';

  @override
  String get onboardingReadyTitle => '準備完了！';

  @override
  String get onboardingReadyDescription => 'デジタル自由への旅を始めましょう';

  @override
  String get next => '次へ';

  @override
  String get back => '戻る';

  @override
  String get skip => 'スキップ';

  @override
  String get getStarted => '開始';

  @override
  String get skipConfirmationTitle => 'オンボーディングをスキップしますか？';

  @override
  String get skipConfirmationMessage =>
      'オンボーディングをスキップしてもよろしいですか？設定からいつでもチュートリアルにアクセスできます。';

  @override
  String get cancel => 'キャンセル';

  @override
  String get connectingToFreedome => 'FreeDome に接続中...';

  @override
  String get domeStatusActive => 'ドームステータス：アクティブ';

  @override
  String get open => '開く';

  @override
  String get close => '閉じる';

  @override
  String get calibrationProgress => 'キャリブレーション進捗';

  @override
  String mediaFilesCount(int count) {
    return 'メディアファイル：$count 項目';
  }

  @override
  String get upload => 'アップロード';

  @override
  String get manage => '管理';

  @override
  String get serverSettings => 'サーバー設定';

  @override
  String get connectionStatus => '接続ステータス';

  @override
  String get russian => 'ロシア語';

  @override
  String get ukrainian => 'ウクライナ語';

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
    return 'データ読み込みエラー：$error';
  }

  @override
  String get taxLienMarketplace => '税務留置権マーケットプレイス';

  @override
  String get filters => 'フィルター';

  @override
  String get refresh => '更新';

  @override
  String get searchHint => '住所、所有者、または区画IDで検索...';

  @override
  String get clear => 'クリア';

  @override
  String foundLiens(int count) {
    return '見つかりました：$count 件の留置権';
  }

  @override
  String sortBy(String sortLabel) {
    return '並び替え：$sortLabel';
  }

  @override
  String get retry => '再試行';

  @override
  String get noLiensFound => '税務留置権が見つかりませんでした';

  @override
  String get tryChangingSearch => '検索パラメータやフィルターを変更してみてください';

  @override
  String stateFilter(String state) {
    return '州：$state';
  }

  @override
  String countyFilter(String county) {
    return '郡：$county';
  }

  @override
  String amountFrom(String amount) {
    return '金額：$amount から';
  }

  @override
  String amountTo(String amount) {
    return '金額：$amount まで';
  }

  @override
  String interestRateFrom(String rate) {
    return '金利：$rate% から';
  }

  @override
  String auctionDateSort(String direction) {
    return 'オークション日 $direction';
  }

  @override
  String taxAmountSort(String direction) {
    return '税額 $direction';
  }

  @override
  String interestRateSort(String direction) {
    return '金利 $direction';
  }

  @override
  String assessedValueSort(String direction) {
    return '評価額 $direction';
  }

  @override
  String redemptionDeadlineSort(String direction) {
    return '償還期限 $direction';
  }

  @override
  String lienNumber(String parcelId) {
    return '留置権 #$parcelId';
  }

  @override
  String owner(String owner) {
    return '所有者：$owner';
  }

  @override
  String get taxAmount => '税額';

  @override
  String get interestRate => '金利';

  @override
  String get assessedValue => '評価額';

  @override
  String get auctionDate => 'オークション日';

  @override
  String get additionalInfo => '追加情報';

  @override
  String get county => '郡';

  @override
  String get state => '州';

  @override
  String get redemptionDeadline => '償還期限';

  @override
  String get status => 'ステータス';

  @override
  String get buyLien => '留置権を購入';

  @override
  String get availableForPurchase => '購入可能';

  @override
  String get sold => '売却済み';

  @override
  String get redeemed => '償還済み';

  @override
  String get foreclosed => '差し押さえ済み';

  @override
  String get purchaseLien => '留置権を購入';

  @override
  String enterBidAmount(String amount) {
    return '入札金額を入力してください（最低 $amount）：';
  }

  @override
  String get bidAmount => '入札金額';

  @override
  String get lienPurchasedSuccessfully => '留置権の購入が完了しました！';

  @override
  String get purchaseError => '購入エラー';

  @override
  String get invalidBidAmount => '無効な入札金額';

  @override
  String get buy => '購入';

  @override
  String get profile => 'プロフィール';

  @override
  String get settings => '設定';

  @override
  String get notAuthorized => '認証されていません';

  @override
  String get loginForAccess => '機能にアクセスするにはログインしてください';

  @override
  String get login => 'ログイン';

  @override
  String get register => '登録';

  @override
  String get edit => '編集';

  @override
  String get logout => 'ログアウト';

  @override
  String get balance => '残高';

  @override
  String get available => '利用可能';

  @override
  String get topUp => 'チャージ';

  @override
  String get quickActions => 'クイックアクション';

  @override
  String get transactionHistory => '取引履歴';

  @override
  String get viewAllTransactions => 'すべての取引を表示';

  @override
  String get favoriteLiens => 'お気に入り留置権';

  @override
  String get savedLiens => '保存された留置権';

  @override
  String get notifications => '通知';

  @override
  String get notificationSettings => '通知設定';

  @override
  String get help => 'ヘルプ';

  @override
  String get appSettings => 'アプリ設定';

  @override
  String get language => '言語';

  @override
  String get theme => 'テーマ';

  @override
  String get dark => 'ダーク';

  @override
  String get light => 'ライト';

  @override
  String get security => 'セキュリティ';

  @override
  String get securitySettings => 'セキュリティ設定';

  @override
  String get privacy => 'プライバシー';

  @override
  String get privacySettings => 'プライバシー設定';

  @override
  String get aboutApp => 'アプリについて';

  @override
  String get version => 'バージョン';

  @override
  String get license => 'ライセンス';

  @override
  String get termsOfService => '利用規約';

  @override
  String get userAgreement => 'ユーザー契約';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get dataProcessing => '個人データ処理';

  @override
  String get loginToAccount => 'アカウントにログイン';

  @override
  String get password => 'パスワード';

  @override
  String get loginSuccessful => 'ログインが完了しました！';

  @override
  String get loginError => 'ログインエラー';

  @override
  String get registration => '登録';

  @override
  String get firstName => '名';

  @override
  String get lastName => '姓';

  @override
  String get registrationSuccessful => '登録が完了しました！';

  @override
  String get registrationError => '登録エラー';

  @override
  String get registerAccount => '登録';

  @override
  String get logoutConfirmation => 'ログアウト確認';

  @override
  String get logoutConfirmationMessage => 'ログアウトしてもよろしいですか？';

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
