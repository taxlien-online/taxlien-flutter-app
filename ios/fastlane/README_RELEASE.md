# TaxLien iOS Release with Fastlane

Этот документ описывает процесс релиза iOS приложения TaxLien.online с использованием Fastlane.

## Предварительные требования

1. **Xcode** - установлен и настроен
2. **Fastlane** - установлен (`gem install fastlane`)
3. **Apple Developer Account** - активный аккаунт разработчика
4. **App Store Connect** - доступ к App Store Connect
5. **Code Signing** - настроенные сертификаты и профили

## Конфигурация

### Appfile
- `app_identifier`: `online.taxlien`
- `apple_id`: `anton.v.dodonov@gmail.com`
- `itc_team_id`: `120374799`
- `team_id`: `6XT4R7V83F`

### Fastfile
Настроены следующие lanes:
- `release` - полный релиз в App Store
- `beta` - релиз в TestFlight
- `build` - локальная сборка для тестирования
- `metadata` - обновление метаданных
- `submit` - отправка на ревью
- `release_auto` - автоматический релиз после одобрения

## Использование

### Быстрый запуск

Из корневой директории проекта:
```bash
# Полный релиз в App Store
./release_ios.sh

# Релиз в TestFlight
./release_ios.sh --beta

# Локальная сборка
./release_ios.sh --build

# Отправка на ревью
./release_ios.sh --submit

# Автоматический релиз после одобрения
./release_ios.sh --auto-release
```

### Прямой запуск Fastlane

Из директории `ios/`:
```bash
# Полный релиз
fastlane release

# TestFlight релиз
fastlane beta

# Локальная сборка
fastlane build

# Обновление метаданных
fastlane metadata

# Отправка на ревью
fastlane submit

# Автоматический релиз
fastlane release_auto
```

## Процесс релиза

### 1. Подготовка
- Очистка проекта (`flutter clean`)
- Получение зависимостей (`flutter pub get`)
- Запуск тестов (`flutter test`)

### 2. Сборка
- Сборка Flutter приложения (`flutter build ios --release --no-codesign`)
- Инкремент номера сборки
- Сборка iOS приложения с подписью

### 3. Загрузка
- Загрузка в App Store Connect
- Обновление метаданных и скриншотов
- Отправка на ревью (опционально)

## Метаданные

Метаданные приложения хранятся в `ios/fastlane/metadata/`:
- Описания на разных языках (en-US, ru, th)
- Ключевые слова
- Скриншоты
- Информация для ревью

## Скриншоты

Скриншоты должны быть размещены в `ios/fastlane/screenshots/`:
- iPhone 6.7" (iPhone 14 Pro Max)
- iPhone 6.5" (iPhone 11 Pro Max)
- iPhone 5.5" (iPhone 8 Plus)
- iPad Pro 12.9"
- iPad Pro 11"

## Troubleshooting

### Ошибки подписи
```bash
# Очистка профилей
fastlane match nuke development
fastlane match nuke distribution

# Пересоздание профилей
fastlane match development
fastlane match appstore
```

### Ошибки сборки
```bash
# Очистка проекта
flutter clean
cd ios && pod install
cd .. && flutter pub get
```

### Ошибки загрузки
- Проверьте подключение к интернету
- Убедитесь в правильности Apple ID
- Проверьте статус аккаунта разработчика

## Логи

Логи Fastlane сохраняются в:
- `ios/fastlane/report.xml`
- `ios/fastlane/test_output/`

## Безопасность

⚠️ **Важно**: Никогда не коммитьте сертификаты и приватные ключи в репозиторий!

Используйте `fastlane match` для безопасного управления сертификатами.

## Поддержка

При возникновении проблем:
1. Проверьте логи Fastlane
2. Убедитесь в правильности конфигурации
3. Проверьте статус Apple Developer Account
4. Обратитесь к документации Fastlane: https://docs.fastlane.tools/
