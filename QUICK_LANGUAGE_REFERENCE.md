# Quick Language Reference Guide

## 🌍 Available Languages

| Language | Code | Native Name | Flag |
|----------|------|-------------|------|
| English | `en` | English | 🇺🇸 |
| Russian | `ru` | Русский | 🇷🇺 |
| Hindi | `hi` | हिन्दी | 🇮🇳 |
| Chinese | `zh` | 中文 | 🇨🇳 |
| Thai | `th` | ไทย | 🇹🇭 |

## 🚀 Quick Start

### Use Translation in Your Widget

```dart
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      children: [
        Text(l10n.appTitle),
        Text(l10n.login),
        Text(l10n.myInvestments),
        ElevatedButton(
          onPressed: () {},
          child: Text(l10n.buy),
        ),
      ],
    );
  }
}
```

### Switch Language Programmatically

```dart
import '../services/localization_service.dart';
import 'package:provider/provider.dart';

// In your widget
final localizationService = Provider.of<LocalizationService>(context);

// Switch to Russian
await localizationService.setLanguage('ru');

// Switch to Hindi
await localizationService.setLanguage('hi');

// Switch to Chinese
await localizationService.setLanguage('zh');

// Switch to Thai
await localizationService.setLanguage('th');

// Use system language
await localizationService.setLanguage('system');
```

### Get Current Language

```dart
final currentLang = localizationService.getCurrentLanguageCode();
print('Current language: $currentLang'); // 'en', 'ru', 'hi', 'zh', or 'th'
```

## 📝 Common Translation Keys

### Authentication
```dart
l10n.login              // "Login" / "Войти" / "लॉगिन" / "登录" / "เข้าสู่ระบบ"
l10n.register           // "Register" / "Регистрация" / "पंजीकरण" / "注册" / "ลงทะเบียน"
l10n.logout             // "Logout" / "Выйти" / "लॉगआउट" / "登出" / "ออกจากระบบ"
l10n.password           // "Password" / "Пароль" / "पासवर्ड" / "密码" / "รหัสผ่าน"
```

### Navigation
```dart
l10n.profile            // "Profile" / "Профиль" / "प्रोफ़ाइल" / "个人资料" / "โปรไฟล์"
l10n.settings           // "Settings" / "Настройки" / "सेटिंग्स" / "设置" / "การตั้งค่า"
l10n.myInvestments      // "My Investments" / "Мои инвестиции" / "मेरे निवेश" / "我的投资" / "การลงทุนของฉัน"
l10n.statistics         // "Statistics" / "Статистика" / "सांख्यिकी" / "统计" / "สถิติ"
```

### Actions
```dart
l10n.buy                // "Buy" / "Купить" / "खरीदें" / "购买" / "ซื้อ"
l10n.search             // Search functionality
l10n.filter             // Filter options
l10n.save               // Save action
l10n.cancel             // "Cancel" / "Отмена" / "रद्द करें" / "取消" / "ยกเลิก"
```

### Investment Related
```dart
l10n.taxLienMarketplace // "Tax Lien Marketplace"
l10n.buyLien            // "Buy Lien"
l10n.availableForPurchase
l10n.totalInvested
l10n.currentValue
l10n.profitLoss
l10n.roi
```

### Time
```dart
l10n.justNow            // "Just now" / "Только что" / "अभी-अभी" / "刚刚" / "เมื่อสักครู่"
l10n.minutesAgo(30)     // "30 minutes ago"
l10n.hoursAgo(2)        // "2 hours ago"
l10n.daysAgo(5)         // "5 days ago"
```

## 🎨 Language-Specific Formatting

### Numbers
```dart
import 'package:intl/intl.dart';

final locale = Localizations.localeOf(context).toString();
final formatter = NumberFormat.currency(locale: locale, symbol: '\$');
Text(formatter.format(1234.56));
// en: $1,234.56
// ru: 1 234,56 $
// hi: $1,234.56
// zh: $1,234.56
// th: $1,234.56
```

### Dates
```dart
import 'package:intl/intl.dart';

final locale = Localizations.localeOf(context).toString();
final formatter = DateFormat.yMMMMd(locale);
Text(formatter.format(DateTime.now()));
// en: October 13, 2025
// ru: 13 октября 2025 г.
// hi: 13 अक्तूबर 2025
// zh: 2025年10月13日
// th: 13 ตุลาคม 2025
```

## 🛠️ Development Workflow

### 1. Add New Translation

**Step 1**: Add to `lib/l10n/app_en.arb` (English template)
```json
{
  "newFeature": "New Feature",
  "@newFeature": {
    "description": "Title for new feature"
  }
}
```

**Step 2**: Add to all other languages
- `app_ru.arb`: `"newFeature": "Новая функция"`
- `app_hi.arb`: `"newFeature": "नई सुविधा"`
- `app_zh.arb`: `"newFeature": "新功能"`
- `app_th.arb`: `"newFeature": "คุณลักษณะใหม่"`

**Step 3**: Generate
```bash
flutter gen-l10n
```

**Step 4**: Use in code
```dart
Text(l10n.newFeature)
```

### 2. Add Parameterized Translation

**In ARB files**:
```json
{
  "greeting": "Hello, {name}!",
  "@greeting": {
    "description": "Greeting message",
    "placeholders": {
      "name": {
        "type": "String",
        "example": "John"
      }
    }
  }
}
```

**In code**:
```dart
Text(l10n.greeting("John"))
// en: Hello, John!
// ru: Привет, John!
// hi: नमस्ते, John!
// zh: 你好，John!
// th: สวัสดี John!
```

## 🔍 Debugging

### Check Current Locale
```dart
final locale = Localizations.localeOf(context);
print('Language: ${locale.languageCode}'); // en, ru, hi, zh, th
print('Country: ${locale.countryCode}');   // US, RU, IN, CN, TH
```

### Test Specific Language
```dart
// Force a specific locale for testing
MaterialApp(
  locale: Locale('hi', 'IN'), // Test Hindi
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  home: MyHomePage(),
)
```

### View All Available Languages
```dart
final locService = LocalizationService();
final languages = locService.getAvailableLanguages();

for (var lang in languages) {
  print('${lang['code']}: ${lang['name']}');
}
// Output:
// system: System
// en: English
// ru: Русский
// hi: हिन्दी
// zh: 中文
// th: ไทย
```

## 📱 UI Components

### Language Selector Widget
```dart
DropdownButton<String>(
  value: localizationService.getCurrentLanguageCode(),
  items: [
    DropdownMenuItem(value: 'en', child: Text('English')),
    DropdownMenuItem(value: 'ru', child: Text('Русский')),
    DropdownMenuItem(value: 'hi', child: Text('हिन्दी')),
    DropdownMenuItem(value: 'zh', child: Text('中文')),
    DropdownMenuItem(value: 'th', child: Text('ไทย')),
  ],
  onChanged: (String? newValue) {
    if (newValue != null) {
      localizationService.setLanguage(newValue);
    }
  },
)
```

### Language Toggle Button
```dart
IconButton(
  icon: Icon(Icons.language),
  onPressed: () {
    // Quick toggle between en, ru, zh
    localizationService.toggleLanguage();
  },
)
```

## 🌐 Testing Checklist

- [ ] Test on English device
- [ ] Test on Russian device  
- [ ] Test on Hindi device
- [ ] Test on Chinese device
- [ ] Test on Thai device
- [ ] Test language switching
- [ ] Test persistence (restart app)
- [ ] Test all screens render correctly
- [ ] Test text overflow on long translations
- [ ] Test RTL layout (if adding Arabic later)

## 💡 Best Practices

1. **Always use l10n keys**, never hardcode strings
   ```dart
   // ❌ Bad
   Text('Login')
   
   // ✅ Good
   Text(l10n.login)
   ```

2. **Extract context early**
   ```dart
   @override
   Widget build(BuildContext context) {
     final l10n = AppLocalizations.of(context)!; // Get once
     return Column(
       children: [
         Text(l10n.title),
         Text(l10n.subtitle),
       ],
     );
   }
   ```

3. **Use meaningful key names**
   ```dart
   // ❌ Bad
   "str1": "Login"
   
   // ✅ Good
   "login": "Login"
   "loginButton": "Login"
   "loginTitle": "Login to Account"
   ```

4. **Add descriptions to all keys**
   ```json
   {
     "login": "Login",
     "@login": {
       "description": "Login button text on auth screen"
     }
   }
   ```

## 📊 Performance Tips

1. **Cache l10n instance** in build method
2. **Don't create multiple instances** per widget
3. **Use const widgets** where possible
4. **Avoid rebuilding** entire tree on language change

## 🐛 Common Issues

### Issue: Translation not showing
**Solution**: Run `flutter gen-l10n` after adding new keys

### Issue: Wrong language displayed
**Solution**: Check device settings and app language preference

### Issue: Build error after adding translation
**Solution**: 
```bash
flutter clean
flutter pub get
flutter gen-l10n
```

## 📚 Resources

- Flutter Internationalization: https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization
- ARB Format: https://github.com/google/app-resource-bundle
- Intl Package: https://pub.dev/packages/intl

---

**Last Updated**: October 13, 2025  
**Version**: 1.0.0

