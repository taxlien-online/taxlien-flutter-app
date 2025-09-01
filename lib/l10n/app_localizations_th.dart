// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'TaxLien.online';

  @override
  String get systemStatus => 'สถานะระบบ';

  @override
  String get playback => 'การเล่น';

  @override
  String get stopped => 'หยุดแล้ว';

  @override
  String get file => 'ไฟล์';

  @override
  String get position => 'ตำแหน่ง';

  @override
  String get seconds => 'วินาที';

  @override
  String get playbackControls => 'ควบคุมการเล่น';

  @override
  String get play => 'Play';

  @override
  String get pause => 'Pause';

  @override
  String get stop => 'Stop';

  @override
  String get volume => 'ระดับเสียง';

  @override
  String get projectionSettings => 'การตั้งค่าการฉาย';

  @override
  String get brightness => 'ความสว่าง';

  @override
  String get rotation => 'การหมุน';

  @override
  String get mediaFiles => 'ไฟล์มีเดีย';

  @override
  String get image => 'ภาพ';

  @override
  String get calibration => 'การปรับเทียบ';

  @override
  String get calibrationTitle => 'การปรับเทียบการฉาย';

  @override
  String get preview => 'ตัวอย่าง';

  @override
  String get offset => 'การชดเชย';

  @override
  String get xOffset => 'การชดเชย X';

  @override
  String get yOffset => 'การชดเชย Y';

  @override
  String get scaleRotation => 'ขนาดและการหมุน';

  @override
  String get scale => 'ขนาด';

  @override
  String get apply => 'ใช้';

  @override
  String get reset => 'รีเซ็ต';

  @override
  String get calibrationApplied => 'การปรับเทียบถูกใช้แล้ว';

  @override
  String get online => 'ONLINE';

  @override
  String get offline => 'OFFLINE';

  @override
  String get languageSettings => 'การตั้งค่าภาษา';

  @override
  String get languageChanged => 'ภาษาเปลี่ยนแล้ว';

  @override
  String get onboardingWelcomeTitle => 'ยินดีต้อนรับสู่ TaxLien.online';

  @override
  String get onboardingWelcomeDescription =>
      'ประตูสู่เสรีภาพดิจิทัลและการเชื่อมต่อทางจิตวิญญาณของคุณ';

  @override
  String get onboardingConnectionTitle => 'เชื่อมต่อกับ FreeDome';

  @override
  String get onboardingConnectionDescription =>
      'สร้างการเชื่อมต่อที่ปลอดภัยกับเครือข่าย FreeDome ของคุณ';

  @override
  String get onboardingDomeControlTitle => 'การควบคุมโดม';

  @override
  String get onboardingDomeControlDescription =>
      'ควบคุมการตั้งค่าและการกำหนดค่าของโดมของคุณ';

  @override
  String get onboardingCalibrationTitle => 'การปรับเทียบ';

  @override
  String get onboardingCalibrationDescription =>
      'ปรับเทียบโดมของคุณเพื่อประสิทธิภาพที่ดีที่สุด';

  @override
  String get onboardingMediaTitle => 'การจัดการมีเดีย';

  @override
  String get onboardingMediaDescription => 'อัปโหลดและจัดการไฟล์มีเดียของคุณ';

  @override
  String get onboardingReadyTitle => 'คุณพร้อมแล้ว!';

  @override
  String get onboardingReadyDescription =>
      'เริ่มต้นการเดินทางสู่เสรีภาพดิจิทัลของคุณ';

  @override
  String get next => 'ถัดไป';

  @override
  String get back => 'กลับ';

  @override
  String get skip => 'ข้าม';

  @override
  String get getStarted => 'เริ่มต้น';

  @override
  String get skipConfirmationTitle => 'ข้ามการแนะนำ?';

  @override
  String get skipConfirmationMessage =>
      'คุณแน่ใจหรือไม่ว่าต้องการข้ามการแนะนำ? คุณสามารถเข้าถึงบทเรียนได้ในภายหลังจากการตั้งค่า';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get connectingToFreedome => 'กำลังเชื่อมต่อกับ FreeDome...';

  @override
  String get domeStatusActive => 'สถานะโดม: ใช้งาน';

  @override
  String get open => 'เปิด';

  @override
  String get close => 'ปิด';

  @override
  String get calibrationProgress => 'ความคืบหน้าการปรับเทียบ';

  @override
  String mediaFilesCount(int count) {
    return 'ไฟล์มีเดีย: $count รายการ';
  }

  @override
  String get upload => 'อัปโหลด';

  @override
  String get manage => 'จัดการ';

  @override
  String get serverSettings => 'การตั้งค่าเซิร์ฟเวอร์';

  @override
  String get connectionStatus => 'สถานะการเชื่อมต่อ';

  @override
  String get russian => 'รัสเซีย';

  @override
  String get ukrainian => 'ยูเครน';

  @override
  String dataLoadError(String error) {
    return 'ข้อผิดพลาดในการโหลดข้อมูล: $error';
  }

  @override
  String get taxLienMarketplace => 'ตลาดจำนองภาษี';

  @override
  String get filters => 'ตัวกรอง';

  @override
  String get refresh => 'รีเฟรช';

  @override
  String get searchHint => 'ค้นหาตามที่อยู่ เจ้าของ หรือรหัสที่ดิน...';

  @override
  String get clear => 'ล้าง';

  @override
  String foundLiens(int count) {
    return 'พบ: $count จำนอง';
  }

  @override
  String sortBy(String sortLabel) {
    return 'เรียงตาม: $sortLabel';
  }

  @override
  String get retry => 'ลองใหม่';

  @override
  String get noLiensFound => 'ไม่พบจำนองภาษี';

  @override
  String get tryChangingSearch => 'ลองเปลี่ยนพารามิเตอร์การค้นหาหรือตัวกรอง';

  @override
  String stateFilter(String state) {
    return 'รัฐ: $state';
  }

  @override
  String countyFilter(String county) {
    return 'เขต: $county';
  }

  @override
  String amountFrom(String amount) {
    return 'ตั้งแต่: $amount';
  }

  @override
  String amountTo(String amount) {
    return 'ถึง: $amount';
  }

  @override
  String interestRateFrom(String rate) {
    return 'อัตราดอกเบี้ยตั้งแต่: $rate%';
  }

  @override
  String auctionDateSort(String direction) {
    return 'วันที่ประมูล $direction';
  }

  @override
  String taxAmountSort(String direction) {
    return 'จำนวนภาษี $direction';
  }

  @override
  String interestRateSort(String direction) {
    return 'อัตราดอกเบี้ย $direction';
  }

  @override
  String assessedValueSort(String direction) {
    return 'มูลค่าประเมิน $direction';
  }

  @override
  String redemptionDeadlineSort(String direction) {
    return 'วันครบกำหนดไถ่ถอน $direction';
  }

  @override
  String lienNumber(String parcelId) {
    return 'จำนอง #$parcelId';
  }

  @override
  String owner(String owner) {
    return 'เจ้าของ: $owner';
  }

  @override
  String get taxAmount => 'จำนวนภาษี';

  @override
  String get interestRate => 'อัตราดอกเบี้ย';

  @override
  String get assessedValue => 'มูลค่าประเมิน';

  @override
  String get auctionDate => 'วันที่ประมูล';

  @override
  String get additionalInfo => 'ข้อมูลเพิ่มเติม';

  @override
  String get county => 'เขต';

  @override
  String get state => 'รัฐ';

  @override
  String get redemptionDeadline => 'วันครบกำหนดไถ่ถอน';

  @override
  String get status => 'สถานะ';

  @override
  String get buyLien => 'ซื้อจำนอง';

  @override
  String get availableForPurchase => 'พร้อมสำหรับการซื้อ';

  @override
  String get sold => 'ขายแล้ว';

  @override
  String get redeemed => 'ไถ่ถอนแล้ว';

  @override
  String get foreclosed => 'ยึดแล้ว';

  @override
  String get purchaseLien => 'ซื้อจำนอง';

  @override
  String enterBidAmount(String amount) {
    return 'ป้อนจำนวนเงินประมูล (ขั้นต่ำ $amount):';
  }

  @override
  String get bidAmount => 'จำนวนเงินประมูล';

  @override
  String get lienPurchasedSuccessfully => 'ซื้อจำนองสำเร็จแล้ว!';

  @override
  String get purchaseError => 'ข้อผิดพลาดในการซื้อ';

  @override
  String get invalidBidAmount => 'จำนวนเงินประมูลไม่ถูกต้อง';

  @override
  String get buy => 'ซื้อ';

  @override
  String get profile => 'โปรไฟล์';

  @override
  String get settings => 'การตั้งค่า';

  @override
  String get notAuthorized => 'ไม่ได้รับอนุญาต';

  @override
  String get loginForAccess => 'เข้าสู่ระบบเพื่อเข้าถึงฟีเจอร์';

  @override
  String get login => 'เข้าสู่ระบบ';

  @override
  String get register => 'ลงทะเบียน';

  @override
  String get edit => 'แก้ไข';

  @override
  String get logout => 'ออกจากระบบ';

  @override
  String get balance => 'ยอดเงิน';

  @override
  String get available => 'ใช้ได้';

  @override
  String get topUp => 'เติมเงิน';

  @override
  String get quickActions => 'การดำเนินการด่วน';

  @override
  String get transactionHistory => 'ประวัติธุรกรรม';

  @override
  String get viewAllTransactions => 'ดูธุรกรรมทั้งหมด';

  @override
  String get favoriteLiens => 'จำนองที่ชื่นชอบ';

  @override
  String get savedLiens => 'จำนองที่บันทึกของคุณ';

  @override
  String get notifications => 'การแจ้งเตือน';

  @override
  String get notificationSettings => 'การตั้งค่าการแจ้งเตือน';

  @override
  String get help => 'ความช่วยเหลือ';

  @override
  String get appSettings => 'การตั้งค่าแอป';

  @override
  String get language => 'ภาษา';

  @override
  String get theme => 'ธีม';

  @override
  String get dark => 'มืด';

  @override
  String get light => 'สว่าง';

  @override
  String get security => 'ความปลอดภัย';

  @override
  String get securitySettings => 'การตั้งค่าความปลอดภัย';

  @override
  String get privacy => 'ความเป็นส่วนตัว';

  @override
  String get privacySettings => 'การตั้งค่าความเป็นส่วนตัว';

  @override
  String get aboutApp => 'เกี่ยวกับแอป';

  @override
  String get version => 'เวอร์ชัน';

  @override
  String get license => 'ลิขสิทธิ์';

  @override
  String get termsOfService => 'เงื่อนไขการให้บริการ';

  @override
  String get userAgreement => 'ข้อตกลงผู้ใช้';

  @override
  String get privacyPolicy => 'นโยบายความเป็นส่วนตัว';

  @override
  String get dataProcessing => 'การประมวลผลข้อมูลส่วนบุคคล';

  @override
  String get loginToAccount => 'เข้าสู่ระบบบัญชี';

  @override
  String get password => 'รหัสผ่าน';

  @override
  String get loginSuccessful => 'เข้าสู่ระบบสำเร็จแล้ว!';

  @override
  String get loginError => 'ข้อผิดพลาดในการเข้าสู่ระบบ';

  @override
  String get registration => 'การลงทะเบียน';

  @override
  String get firstName => 'ชื่อ';

  @override
  String get lastName => 'นามสกุล';

  @override
  String get registrationSuccessful => 'ลงทะเบียนสำเร็จแล้ว!';

  @override
  String get registrationError => 'ข้อผิดพลาดในการลงทะเบียน';

  @override
  String get registerAccount => 'ลงทะเบียน';

  @override
  String get logoutConfirmation => 'ยืนยันการออกจากระบบ';

  @override
  String get logoutConfirmationMessage =>
      'คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบ?';

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
