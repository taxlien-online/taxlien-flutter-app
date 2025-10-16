# Настройка локализации в TaxLien.online

## Поддерживаемые языки

Приложение теперь поддерживает следующие языки:

1. 🇺🇸 **Английский (English)** - `en`
2. 🇹🇭 **Тайский (ไทย)** - `th`
3. 🇷🇺 **Русский** - `ru`
4. 🇨🇳 **Китайский (中文)** - `zh`
5. 🇮🇱 **Иврит (עברית)** - `he`
6. 🇮🇳 **Хинди (हिन्दी)** - `hi`

## Автоматический выбор языка

Приложение автоматически определяет язык системы и использует его, если он поддерживается. Если язык системы не поддерживается, приложение по умолчанию использует английский язык.

## Структура файлов

```
lib/
└── l10n/
    ├── app_en.arb    # Английский (основной шаблон)
    ├── app_th.arb    # Тайский
    ├── app_ru.arb    # Русский
    ├── app_zh.arb    # Китайский
    ├── app_he.arb    # Иврит
    ├── app_hi.arb    # Хинди
    └── app_localizations.dart  # Сгенерированный файл
```

## Конфигурация

### pubspec.yaml
```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.20.2

flutter:
  generate: true
```

### l10n.yaml
```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
```

### main.dart
```dart
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

MaterialApp(
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: const [
    Locale('en', ''), // English
    Locale('th', ''), // Thai
    Locale('ru', ''), // Russian
    Locale('zh', ''), // Chinese
    Locale('he', ''), // Hebrew
    Locale('hi', ''), // Hindi
  ],
  localeResolutionCallback: (locale, supportedLocales) {
    // Проверяем, поддерживается ли язык устройства
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale?.languageCode) {
        return supportedLocale;
      }
    }
    // Если язык не поддерживается, используем английский
    return supportedLocales.first;
  },
  // ... остальные настройки
)
```

## Использование переводов в коде

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// В build методе виджета:
Text(AppLocalizations.of(context)!.appTitle)
```

## Генерация локализационных файлов

После изменения `.arb` файлов, выполните:

```bash
flutter gen-l10n
```

Или просто запустите приложение - файлы сгенерируются автоматически:

```bash
flutter run
```

## Добавление нового языка

1. Создайте новый файл `lib/l10n/app_XX.arb` (где XX - код языка)
2. Скопируйте содержимое из `app_en.arb`
3. Переведите все строки
4. Добавьте новый Locale в `supportedLocales` в `main.dart`:
   ```dart
   Locale('XX', ''), // Название языка
   ```
5. Запустите `flutter gen-l10n`

## Проверка работы

Чтобы проверить работу локализации:

1. Измените язык в настройках вашего устройства/эмулятора
2. Перезапустите приложение
3. Интерфейс должен отобразиться на выбранном языке (если он поддерживается)

## Текущее состояние переводов

- ✅ Английский (en): Полный перевод (базовый шаблон)
- ✅ Тайский (th): ~983 строк
- ✅ Русский (ru): ~983 строк
- ✅ Китайский (zh): ~953 строк
- ⚠️ Иврит (he): ~721 строк (52 непереведенных сообщений)
- ⚠️ Хинди (hi): ~953 строк (52 непереведенных сообщений)

## Примечания

- Все .arb файлы используют формат JSON
- Ключи должны совпадать во всех файлах
- Непереведенные строки будут отображаться на английском языке
- Для языков с написанием справа налево (иврит) Flutter автоматически изменяет направление текста

