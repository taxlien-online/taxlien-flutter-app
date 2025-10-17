# TaxLien.online Internationalization Guide

## Overview

TaxLien.online supports internationalization with automatic system language detection. The application uses Flutter Localizations for translation management.

## Supported Languages

- **English (en)** - default language
- **Russian (ru)** - Russian
- **Thai (th)** - Thai
- **Chinese (zh)** - Chinese (Simplified)
- **Hebrew (he)** - Hebrew
- **Hindi (hi)** - Hindi
- **Ukrainian (uk)** - Ukrainian

## File Structure

```
lib/
├── l10n/
│   ├── app_en.arb    # English translations
│   └── app_ru.arb    # Russian translations
└── main.dart         # Localization setup
```

## Adding a New Language

### Step 1: Creating Translation File

Create a new file `lib/l10n/app_[language_code].arb`. For example, for German:

```json
{
  "@@locale": "de",
  "appTitle": "TaxLien.online",
  "@appTitle": {
    "description": "Application title"
  },
  "systemStatus": "System Status",
  "@systemStatus": {
    "description": "System status section header"
  }
  // ... other translations
}
```

### Step 2: Adding Support in main.dart

Add the new Locale to the list of supported languages:

```dart
supportedLocales: const [
  Locale('en'), // English
  Locale('ru'), // Russian
  Locale('de'), // German (new language)
],
```

### Step 3: Generating Files

Run the command to generate localization files:

```bash
flutter gen-l10n
```

## Using Translations in Code

### Getting Localization Instance

```dart
final l10n = AppLocalizations.of(context)!;
```

### Using Translations

```dart
// Simple text
Text(l10n.appTitle)

// Text with parameters (if available)
Text(l10n.welcomeMessage('John'))

// In buttons
ElevatedButton(
  onPressed: () {},
  child: Text(l10n.play),
)
```

## ARB File Format

### Basic Structure

```json
{
  "@@locale": "en",
  "key": "translation",
  "@key": {
    "description": "key description"
  }
}
```

### Supported Types

- **Strings**: `"key": "translation"`
- **Parameters**: `"key": "Hello, {name}"`
- **Plural**: `"key": "{count, plural, =0{none} =1{one} other{many}}"`
- **Gender**: `"key": "{gender, select, male{he} female{she} other{it}}"`

### Examples

```json
{
  "@@locale": "en",
  "welcome": "Welcome",
  "@welcome": {
    "description": "Welcome message"
  },
  "greeting": "Hello, {name}",
  "@greeting": {
    "description": "Greeting with name",
    "placeholders": {
      "name": {
        "type": "String"
      }
    }
  },
  "itemsCount": "{count, plural, =0{no items} =1{one item} other{{count} items}}",
  "@itemsCount": {
    "description": "Number of items",
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
}
```

## Automatic Language Detection

The application automatically detects the system language and uses appropriate translations. If the system language is not supported, English is used as the default language.

### Detection Logic

1. Check the device system language
2. If the language is supported - use it
3. If the language is not supported - use English
4. If English is not available - use the first available language

## Testing

### Running Localization Tests

```bash
flutter test test/localization_test.dart
```

### Manual Testing

To test different languages, you can temporarily change the locale in main.dart:

```dart
locale: const Locale('ru'), // Force Russian
```

## Best Practices

### 1. Key Naming

Use descriptive key names:

```json
// Good
"playbackControls": "Playback Controls"

// Bad
"pc": "Playback Controls"
```

### 2. Descriptions

Always add descriptions for keys:

```json
"@key": {
  "description": "Description of the key's purpose"
}
```

### 3. Parameters

Use parameters for dynamic content:

```json
"fileInfo": "File: {fileName}, size: {size}",
"@fileInfo": {
  "placeholders": {
    "fileName": {
      "type": "String"
    },
    "size": {
      "type": "String"
    }
  }
}
```

### 4. Plural Forms

Use plural forms for correct translations:

```json
"itemsCount": "{count, plural, =0{no items} =1{one item} other{{count} items}}"
```

## Debugging

### Checking Available Translations

```dart
print('Available locales: ${AppLocalizations.supportedLocales}');
print('Current locale: ${Localizations.localeOf(context)}');
```

### Checking Missing Translations

If a translation is missing, Flutter will show the key in angle brackets: `<key>`

## Updating Translations

1. Edit the `.arb` files
2. Run `flutter gen-l10n`
3. Restart the application

## Compatibility

- Flutter 3.2.3+
- Dart 3.0+
- flutter_localizations
- intl package 