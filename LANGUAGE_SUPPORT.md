# TaxLien.online - Multi-Language Support

## Supported Languages

The TaxLien.online application now supports 5 languages:

1. **English** (en) - Default language
2. **Russian** (ru) - Русский
3. **Hindi** (hi) - हिन्दी
4. **Chinese** (zh) - 中文
5. **Thai** (th) - ไทย

## Implementation Details

### Configuration Files

1. **l10n.yaml** - Localization configuration
   - Location: `/taxlien-app/l10n.yaml`
   - Defines the ARB directory and template file
   - Output class: `AppLocalizations`

2. **Translation Files (.arb)**
   - Location: `/taxlien-app/lib/l10n/`
   - Files:
     - `app_en.arb` - English (967 lines, complete)
     - `app_ru.arb` - Russian (971 lines, complete)
     - `app_hi.arb` - Hindi (941 lines, complete)
     - `app_zh.arb` - Chinese (941 lines, complete)
     - `app_th.arb` - Thai (941 lines, complete)

3. **Application Configuration**
   - Location: `/taxlien-app/lib/main.dart`
   - All 5 languages are configured in `supportedLocales`

4. **Language Service**
   - Location: `/taxlien-app/lib/services/localization_service.dart`
   - Handles language switching and persistence
   - Provides language names in their native scripts

## How to Use

### Switching Languages in the App

Users can switch languages through:
1. **Language Settings** - Navigate to Settings → Language
2. **System Language** - The app will use the device's system language if it's one of the supported languages
3. **Programmatic Toggle** - Quick language toggle between English, Russian, and Chinese

### For Developers

#### Accessing Translations in Code

```dart
import '../l10n/app_localizations.dart';

// In your widget
@override
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  
  return Text(l10n.appTitle); // Returns "TaxLien.online"
  return Text(l10n.login); // Returns "Login" / "Войти" / "लॉगिन" / "登录" / "เข้าสู่ระบบ"
}
```

#### Adding New Translations

1. Add the new key to `app_en.arb`:
```json
{
  "newKey": "New Value",
  "@newKey": {
    "description": "Description of the new key"
  }
}
```

2. Add translations to all other language files (`app_ru.arb`, `app_hi.arb`, `app_zh.arb`, `app_th.arb`)

3. Regenerate localization files:
```bash
cd taxlien-app
flutter gen-l10n
```

4. The new translation will be available as `AppLocalizations.of(context)!.newKey`

#### Adding Parameterized Translations

For translations with placeholders:

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

Usage in code:
```dart
Text(l10n.greeting("John")); // "Hello, John!"
```

## Language Coverage

All 5 languages have complete translations for:
- Authentication (Login, Registration, Logout)
- Navigation (Home, Profile, Settings)
- Tax Lien Marketplace
- Investment Management
- Search Functionality
- Onboarding Screens
- Error Messages
- Date/Time Formats

## Testing

To test different languages:

1. **Change device language**: 
   - iOS: Settings → General → Language & Region
   - Android: Settings → System → Languages

2. **In-app language selector**:
   - Open app → Settings → Language
   - Select desired language

3. **Programmatic testing**:
```dart
// In your widget or test
MaterialApp(
  locale: Locale('hi', 'IN'), // Force Hindi
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  // ...
)
```

## Regional Variants

The current implementation uses the following locale configurations:
- English: `en_US`
- Russian: `ru_RU`
- Hindi: `hi_IN`
- Chinese: `zh_CN` (Simplified Chinese)
- Thai: `th_TH`

## Future Enhancements

Potential improvements for the localization system:
- Add Traditional Chinese (zh_TW)
- Add regional currency formatting
- Add locale-specific date/time formats
- Add RTL (Right-to-Left) support for languages like Arabic
- Add pluralization rules for different languages
- Add locale-specific number formatting

## Troubleshooting

### Missing Translations
If you see untranslated text:
1. Check if the key exists in all `.arb` files
2. Run `flutter gen-l10n` to regenerate
3. Restart the app

### Wrong Language Displayed
1. Check device system language
2. Check app language settings
3. Clear app data and restart
4. Verify locale configuration in `main.dart`

### Build Errors
If you encounter build errors after adding translations:
```bash
flutter clean
flutter pub get
flutter gen-l10n
flutter run
```

## Resources

- [Flutter Internationalization Guide](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization)
- [ARB File Format](https://github.com/google/app-resource-bundle/wiki/ApplicationResourceBundleSpecification)
- [Intl Package Documentation](https://pub.dev/packages/intl)

## Contact

For questions or issues related to translations, please contact the development team or create an issue in the project repository.

---

Last Updated: October 13, 2025
Version: 3.4.0

