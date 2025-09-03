# 🚀 Быстрый старт: Публикация в Apple Store

## ⚡ Быстрая проверка готовности

```bash
# Проверьте готовность приложения
./check_app_store_ready.sh
```

## 🎯 Основные шаги

### 1. Подготовка (5 минут)
```bash
./prepare_app_store.sh
```

### 2. Настройка в Xcode (10 минут)
```bash
open ios/Runner.xcworkspace
```
- Настройте Bundle Identifier
- Включите автоматическое подписание
- Выберите ваш Team ID

### 3. Сборка и загрузка (15-30 минут)
```bash
./build_and_upload.sh
```

## 📱 Что нужно иметь

- ✅ Apple Developer Account ($99/год)
- ✅ macOS с Xcode
- ✅ Flutter SDK
- ✅ CocoaPods

## 🔑 Ключевые настройки

### Bundle Identifier
```
com.yourcompany.taxlien-online
```

### Team ID
Найдите в [Apple Developer](https://developer.apple.com/account/)

### Версия приложения
Текущая: `2.0.0+1` (из pubspec.yaml)

## 🚨 Если что-то пошло не так

1. **Ошибки подписи**: Проверьте Apple Developer подписку
2. **Bundle ID занят**: Измените на уникальный
3. **Проблемы сборки**: Запустите `flutter clean && flutter pub get`

## 📞 Поддержка

- [Apple Developer Documentation](https://developer.apple.com/)
- [Flutter iOS Deployment](https://docs.flutter.dev/deployment/ios)
- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)

## ⏱️ Время выполнения

- **Проверка**: 2 минуты
- **Подготовка**: 5 минут  
- **Настройка Xcode**: 10 минут
- **Сборка**: 15-30 минут
- **Загрузка**: 5-10 минут
- **Проверка Apple**: 1-7 дней

**Итого**: ~1 час + ожидание проверки Apple

---

💡 **Совет**: Запустите `./check_app_store_ready.sh` для диагностики проблем!
