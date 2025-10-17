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
  String get welcome => 'ยินดีต้อนรับ';

  @override
  String get settings => 'การตั้งค่า';

  @override
  String get profile => 'โปรไฟล์';

  @override
  String get search => 'ค้นหา';

  @override
  String get marketplace => 'ตลาด';

  @override
  String get portfolio => 'พอร์ตโฟลิโอ';

  @override
  String get myInvestments => 'การลงทุนของฉัน';

  @override
  String get aiAdvisor => 'ที่ปรึกษา AI';

  @override
  String get login => 'เข้าสู่ระบบ';

  @override
  String get logout => 'ออกจากระบบ';

  @override
  String get register => 'ลงทะเบียน';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get save => 'บันทึก';

  @override
  String get apply => 'ใช้งาน';

  @override
  String get reset => 'รีเซ็ต';

  @override
  String get delete => 'ลบ';

  @override
  String get edit => 'แก้ไข';

  @override
  String get back => 'กลับ';

  @override
  String get next => 'ถัดไป';

  @override
  String get finish => 'เสร็จสิ้น';

  @override
  String get skip => 'ข้าม';

  @override
  String get retry => 'ลองใหม่';

  @override
  String get loading => 'กำลังโหลด...';

  @override
  String get error => 'ข้อผิดพลาด';

  @override
  String get success => 'สำเร็จ';

  @override
  String get confirm => 'ยืนยัน';

  @override
  String get yes => 'ใช่';

  @override
  String get no => 'ไม่';

  @override
  String get ok => 'ตกลง';

  @override
  String get online => 'ออนไลน์';

  @override
  String get offline => 'ออฟไลน์';

  @override
  String get connected => 'เชื่อมต่อแล้ว';

  @override
  String get disconnected => 'ขาดการเชื่อมต่อ';

  @override
  String get calibration => 'การปรับเทียบ';

  @override
  String get brightness => 'ความสว่าง';

  @override
  String get rotation => 'การหมุน';

  @override
  String get volume => 'ระดับเสียง';

  @override
  String get position => 'ตำแหน่ง';

  @override
  String get playback => 'การเล่น';

  @override
  String get play => 'เล่น';

  @override
  String get pause => 'หยุดชั่วคราว';

  @override
  String get stop => 'หยุด';

  @override
  String get language => 'ภาษา';

  @override
  String get languageSettings => 'การตั้งค่าภาษา';

  @override
  String get theme => 'ธีม';

  @override
  String get light => 'สว่าง';

  @override
  String get dark => 'มืด';

  @override
  String get system => 'ระบบ';

  @override
  String get lienSearch => 'ค้นหาหนี้ภาษี';

  @override
  String get searching => 'กำลังค้นหา...';

  @override
  String get nothingFound => 'ไม่พบข้อมูล';

  @override
  String get tryChangingSearchQuery => 'ลองเปลี่ยนคำค้นหา';

  @override
  String get searchHistory => 'ประวัติการค้นหา';

  @override
  String get searchHistoryEmpty => 'ประวัติการค้นหาว่างเปล่า';

  @override
  String get searchQueriesWillAppearHere =>
      'ประวัติการค้นหาของคุณจะปรากฏที่นี่';

  @override
  String foundLiensCount(int count) {
    return 'พบหนี้ภาษี $count รายการ';
  }

  @override
  String get availableForPurchase => 'พร้อมซื้อ';

  @override
  String get sold => 'ขายแล้ว';

  @override
  String get redeemed => 'ไถ่ถอนแล้ว';

  @override
  String get foreclosed => 'ยึดทรัพย์แล้ว';

  @override
  String get purchaseLien => 'ซื้อหนี้ภาษี';

  @override
  String enterBidAmount(String amount) {
    return 'ป้อนจำนวนเงินประมูล (ขั้นต่ำ $amount)';
  }

  @override
  String get lienPurchasedSuccessfully => 'ซื้อหนี้ภาษีสำเร็จ!';

  @override
  String get purchaseError => 'เกิดข้อผิดพลาดในการซื้อ';

  @override
  String get invalidBidAmount => 'จำนวนเงินประมูลไม่ถูกต้อง';

  @override
  String get purchase => 'ซื้อ';

  @override
  String daysAgo(int days) {
    return '$days วันที่แล้ว';
  }

  @override
  String hoursAgo(int hours) {
    return '$hours ชั่วโมงที่แล้ว';
  }

  @override
  String minutesAgo(int minutes) {
    return '$minutes นาทีที่แล้ว';
  }

  @override
  String get justNow => 'เมื่อสักครู่';

  @override
  String get notAuthorized => 'ไม่ได้รับอนุญาต';

  @override
  String get loginForAccess => 'กรุณาเข้าสู่ระบบเพื่อเข้าถึงฟีเจอร์';

  @override
  String get loginToAccount => 'เข้าสู่ระบบบัญชี';

  @override
  String get password => 'รหัสผ่าน';

  @override
  String get loginSuccessful => 'เข้าสู่ระบบสำเร็จ!';

  @override
  String get loginError => 'เกิดข้อผิดพลาดในการเข้าสู่ระบบ';

  @override
  String get registration => 'การลงทะเบียน';

  @override
  String get firstName => 'ชื่อ';

  @override
  String get lastName => 'นามสกุล';

  @override
  String get registerAccount => 'ลงทะเบียนบัญชี';

  @override
  String get registrationSuccessful => 'ลงทะเบียนสำเร็จ!';

  @override
  String get registrationError => 'เกิดข้อผิดพลาดในการลงทะเบียน';

  @override
  String get logoutConfirmation => 'ยืนยันการออกจากระบบ';

  @override
  String get logoutConfirmationMessage =>
      'คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบ?';

  @override
  String get balance => 'ยอดคงเหลือ';

  @override
  String get available => 'พร้อมใช้งาน';

  @override
  String get topUp => 'เติมเงิน';

  @override
  String get quickActions => 'การดำเนินการด่วน';

  @override
  String get transactionHistory => 'ประวัติธุรกรรม';

  @override
  String get viewAllTransactions => 'ดูธุรกรรมทั้งหมด';

  @override
  String get favoriteLiens => 'หนี้ภาษีที่ชื่นชอบ';

  @override
  String get savedLiens => 'หนี้ภาษีที่บันทึกไว้';

  @override
  String get notifications => 'การแจ้งเตือน';

  @override
  String get notificationSettings => 'การตั้งค่าการแจ้งเตือน';

  @override
  String get help => 'ช่วยเหลือ';

  @override
  String get appSettings => 'การตั้งค่าแอป';

  @override
  String get russian => 'รัสเซีย';

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
  String get license => 'ใบอนุญาต';

  @override
  String get termsOfService => 'เงื่อนไขการให้บริการ';

  @override
  String get userAgreement => 'ข้อตกลงผู้ใช้';

  @override
  String get privacyPolicy => 'นโยบายความเป็นส่วนตัว';

  @override
  String get dataProcessing => 'การประมวลผลข้อมูลส่วนบุคคล';

  @override
  String get digitalFreedomGateway => 'ประตูสู่เสรีภาพดิจิทัล';

  @override
  String get systemStatus => 'สถานะระบบ';

  @override
  String get stopped => 'หยุด';

  @override
  String get file => 'ไฟล์';

  @override
  String get seconds => 'วินาที';

  @override
  String get playbackControls => 'การควบคุมการเล่น';

  @override
  String get projectionSettings => 'การตั้งค่าการฉาย';

  @override
  String get connection => 'การเชื่อมต่อ';
}
