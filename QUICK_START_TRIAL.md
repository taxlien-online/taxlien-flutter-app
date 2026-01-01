# Quick Start - Trial Mode

## 🎉 Trial режим готов!

В TaxLien.online добавлен **trial режим с максимально долгим периодом - 365 дней (1 год)**, аналогичный `/legacy/trials/vedicgames-trials`.

---

## Быстрый старт

### 1. Запуск тестов

```bash
cd /Users/anton/proj/magento.nativemind.net/taxlien-app
./test_trial.sh
```

Или вручную:

```bash
flutter test test/trial_service_test.dart
```

### 2. Запуск приложения

```bash
# iOS
flutter run -d iPhone

# Android
flutter run -d emulator
```

### 3. Открыть Paywall

В приложении:
1. Запустите приложение
2. Trial автоматически предложится при первом запуске
3. Или навигируйте: Settings → Subscription → Show Paywall

---

## Основные файлы

| Файл | Назначение |
|------|-----------|
| `lib/services/trial_service.dart` | Core service (365 days) |
| `lib/screens/paywall_screen.dart` | Beautiful UI |
| `lib/core/providers/subscription_provider.dart` | Riverpod state |
| `docs/TRIAL_AND_SUBSCRIPTIONS_SETUP.md` | Store setup |
| `TRIAL_MODE_README.md` | Full guide |
| `TRIAL_IMPLEMENTATION_COMPLETE.md` | Complete report |

---

## Trial характеристики

- **Длительность**: 365 дней (максимально долгий)
- **Доступ**: Все Premium функции
- **Активация**: Одна на устройство
- **Хранение**: Local (SharedPreferences)
- **Платформы**: iOS + Android

---

## Что дальше?

### Перед релизом:

1. **App Store Connect**
   - Создать subscription products
   - Product IDs: `taxlien_premium_monthly`, etc.

2. **Google Play Console**
   - Создать те же products

3. **Тестирование**
   - iOS: StoreKit в Xcode
   - Android: Internal Test track

4. **Релиз**
   ```bash
   # iOS
   cd ios && fastlane release
   
   # Android
   cd android && fastlane deploy
   ```

---

## Помощь

**Документация:**
- 📘 `TRIAL_MODE_README.md` - как использовать
- 📗 `docs/TRIAL_AND_SUBSCRIPTIONS_SETUP.md` - настройка магазинов
- 📕 `TRIAL_IMPLEMENTATION_COMPLETE.md` - что реализовано

**Скрипты:**
- `./test_trial.sh` - тестирование и запуск

**Тесты:**
- `test/trial_service_test.dart` - unit tests

---

## Статус ✅

- [x] TrialService (365 дней)
- [x] PaywallScreen (красивый UI)
- [x] Subscription constants
- [x] Riverpod providers
- [x] Локализация (EN, RU)
- [x] Интеграция в app
- [x] Unit tests
- [x] Документация
- [x] StoreKit config
- [ ] **Store products (нужно настроить вручную)**

---

## Быстрая справка

### Проверить доступ

```dart
final hasAccess = ref.watch(hasAccessProvider);
```

### Запустить trial

```dart
final trialService = ref.read(trialServiceProvider);
await trialService.startTrial();
```

### Показать paywall

```dart
Navigator.pushNamed(context, AppRouter.paywall);
```

---

**Готово к запуску!** 🚀

Мозгач108, если что-то нужно - смотри документацию выше.

