# Исправление ошибки Apple ITMS-91061 ✅

## Проблема

Apple отклонило приложение для macOS с ошибкой:

```
ITMS-91061: Missing privacy manifest - Your app includes 
"package_info_plus", an SDK that was identified in the 
documentation as a commonly used third-party SDK.
```

## Решение

Обновлен пакет `package_info_plus` с версии `4.2.0` до `9.0.0`, которая содержит обязательный privacy manifest.

## Что было сделано

### 1. Обновлен pubspec.yaml

```yaml
package_info_plus: ^9.0.0  # Обновлено для требований Apple
```

### 2. Обновлены зависимости

```bash
flutter pub get
cd macos && pod install --repo-update
```

### 3. Пересобрано приложение

```bash
flutter clean
flutter build macos --release
```

## Проверка

✅ Privacy manifest успешно включен в сборку:
```
/Contents/Frameworks/package_info_plus.framework/.../PrivacyInfo.xcprivacy
```

## Следующие шаги

### 1. Создать архив в Xcode

```bash
# Открыть проект
open macos/Runner.xcworkspace
```

В Xcode:
1. Выбрать "Any Mac" как цель
2. Product → Archive
3. Дождаться завершения архивации

### 2. Проверить архив

1. В Organizer выбрать ваш архив
2. Нажать "Distribute App"
3. Выбрать "App Store Connect"
4. Нажать "Validate"
5. Дождаться завершения проверки

### 3. Загрузить в App Store Connect

1. Нажать "Distribute App"
2. Выбрать "App Store Connect"
3. Нажать "Upload"
4. Дождаться завершения загрузки

### 4. Отправить на ревью

1. Перейти в App Store Connect
2. Выбрать ваше приложение
3. Перейти в TestFlight
4. Выбрать новую сборку
5. Отправить на ревью

## Информация о сборке

- **Версия:** 4.0.0
- **Build:** 4.0.0
- **App ID:** 6754076866
- **Размер:** ~93.3MB (macOS)
- **Архитектура:** Universal (arm64 + x86_64)

## Обновленные файлы

```
✅ pubspec.yaml              - package_info_plus: ^9.0.0
✅ pubspec.lock             - Автообновлен
✅ macos/Podfile.lock       - Автообновлен
✅ APPLE_PRIVACY_MANIFEST_FIX.md - Документация на английском
✅ APPLE_FIX_RU.md          - Эта инструкция
```

## Проверка перед отправкой

- [x] Приложение успешно собирается
- [x] Privacy manifest включен
- [x] Все функции работают корректно
- [x] Готово к загрузке в App Store

## Если возникли проблемы

1. Очистить проект:
   ```bash
   flutter clean
   cd macos && rm -rf Pods Podfile.lock
   pod install
   cd ..
   flutter build macos --release
   ```

2. Проверить документацию Apple:
   - [Third-Party SDK Requirements](https://developer.apple.com/support/third-party-SDK-requirements)
   - [Privacy Manifest Files](https://developer.apple.com/documentation/bundleresources/privacy_manifest_files)

## Статус

✅ **Исправлено и готово к отправке в App Store**

**Дата:** 16 октября 2025

