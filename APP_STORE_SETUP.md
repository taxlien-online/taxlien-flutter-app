# TaxLien.online - Руководство по публикации в Apple Store

## 📋 Предварительные требования

### 1. Apple Developer Account
- Активная подписка Apple Developer Program ($99/год)
- Доступ к App Store Connect
- Доступ к Xcode

### 2. Системные требования
- macOS (рекомендуется последняя версия)
- Xcode (последняя версия)
- Flutter SDK
- CocoaPods

## 🚀 Пошаговая инструкция

### Шаг 1: Подготовка проекта

```bash
# Перейдите в директорию проекта
cd taxlien-mobile-app

# Сделайте скрипты исполняемыми
chmod +x prepare_app_store.sh
chmod +x build_and_upload.sh

# Запустите подготовку
./prepare_app_store.sh
```

### Шаг 2: Настройка Bundle Identifier

1. Откройте проект в Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```

2. В Xcode:
   - Выберите проект "Runner" в навигаторе
   - Выберите target "Runner"
   - Перейдите на вкладку "General"
   - В поле "Bundle Identifier" введите уникальный идентификатор:
     ```
     com.yourcompany.taxlien-online
     ```
   - Убедитесь, что "Version" и "Build" соответствуют pubspec.yaml

### Шаг 3: Настройка подписи кода

1. В Xcode:
   - Перейдите на вкладку "Signing & Capabilities"
   - Включите "Automatically manage signing"
   - Выберите ваш Team ID
   - Убедитесь, что "Bundle Identifier" уникален

2. Если возникают ошибки:
   - Проверьте, что Bundle Identifier уникален
   - Убедитесь, что у вас есть активная подписка Apple Developer
   - Проверьте, что профили provisioning созданы автоматически

### Шаг 4: Настройка Info.plist

Проверьте файл `ios/Runner/Info.plist`:

```xml
<key>CFBundleDisplayName</key>
<string>TaxLien.online</string>

<key>CFBundleName</key>
<string>taxlien.online</string>

<key>CFBundleShortVersionString</key>
<string>$(FLUTTER_BUILD_NAME)</string>

<key>CFBundleVersion</key>
<string>$(FLUTTER_BUILD_NUMBER)</string>
```

### Шаг 5: Настройка иконок приложения

Убедитесь, что у вас есть все необходимые размеры иконок в `ios/Runner/Assets.xcassets/AppIcon.appiconset/`:

- iPhone: 60pt (@2x, @3x) - 120x120, 180x180
- iPad: 76pt (@2x) - 152x152
- App Store: 1024x1024

### Шаг 6: Настройка Launch Screen

Проверьте файл `ios/Runner/Base.lproj/LaunchScreen.storyboard`:
- Убедитесь, что launch screen соответствует дизайну приложения
- Проверьте, что все элементы правильно расположены

### Шаг 7: Сборка и архивирование

```bash
# Запустите автоматическую сборку и загрузку
./build_and_upload.sh
```

Или вручную в Xcode:

1. Выберите "Product" → "Archive"
2. Дождитесь завершения архивирования
3. В Organizer выберите "Distribute App"
4. Выберите "App Store Connect"
5. Следуйте инструкциям мастера

### Шаг 8: Настройка App Store Connect

1. Войдите в [App Store Connect](https://appstoreconnect.apple.com)
2. Создайте новое приложение:
   - Название: "TaxLien.online"
   - Bundle ID: выбранный вами Bundle Identifier
   - SKU: уникальный идентификатор (например, "taxlien-online-ios")
   - User Access: "Full Access"

### Шаг 9: Загрузка метаданных

В App Store Connect заполните:

#### Основная информация:
- **Название**: TaxLien.online
- **Подзаголовок**: Инвестиции в налоговые залоги
- **Описание**: Подробное описание функциональности приложения
- **Ключевые слова**: tax lien, investment, real estate, taxes

#### Скриншоты:
- iPhone 6.7" Display: 1290x2796
- iPhone 6.5" Display: 1242x2688
- iPhone 5.5" Display: 1242x2208
- iPad Pro 12.9" Display: 2048x2732

#### Категория:
- **Основная**: Finance
- **Дополнительная**: Business

### Шаг 10: Отправка на проверку

1. Убедитесь, что все поля заполнены
2. Проверьте, что приложение соответствует [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
3. Нажмите "Submit for Review"

## 🔐 Важные настройки безопасности

### App Transport Security
В `ios/Runner/Info.plist` добавьте:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <false/>
    <key>NSExceptionDomains</key>
    <dict>
        <key>yourdomain.com</key>
        <dict>
            <key>NSExceptionAllowsInsecureHTTPLoads</key>
            <true/>
        </dict>
    </dict>
</dict>
```

### Разрешения
Добавьте необходимые разрешения:

```xml
<key>NSCameraUsageDescription</key>
<string>Приложению необходим доступ к камере для сканирования QR-кодов</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>Приложению необходим доступ к галерее для выбора изображений</string>

<key>NSLocationWhenInUseUsageDescription</key>
<string>Приложению необходим доступ к местоположению для поиска ближайших объектов</string>
```

## 📱 Тестирование перед публикацией

### TestFlight
1. Загрузите приложение в App Store Connect
2. Создайте группу тестировщиков
3. Отправьте приглашения
4. Протестируйте на реальных устройствах

### Локальное тестирование
```bash
# Сборка для симулятора
flutter build ios --debug

# Сборка для устройства
flutter build ios --release
```

## 🚨 Частые проблемы и решения

### Ошибка "Bundle Identifier already exists"
- Измените Bundle Identifier на уникальный
- Используйте формат: `com.yourcompany.appname`

### Ошибка подписи кода
- Проверьте Apple Developer подписку
- Убедитесь, что Team ID выбран правильно
- Очистите и пересоберите проект

### Ошибка "Missing Push Notification Entitlement"
- Добавьте capability "Push Notifications" в Xcode
- Или удалите неиспользуемые capabilities

### Ошибка "Invalid Binary"
- Проверьте размер приложения (максимум 4GB)
- Убедитесь, что все ресурсы оптимизированы
- Проверьте соответствие App Store Guidelines

## 📞 Поддержка

Если возникли проблемы:

1. Проверьте [Apple Developer Documentation](https://developer.apple.com/)
2. Обратитесь в [Apple Developer Support](https://developer.apple.com/contact/)
3. Проверьте [Flutter iOS Deployment](https://docs.flutter.dev/deployment/ios)

## 🎯 Чек-лист перед отправкой

- [ ] Bundle Identifier уникален
- [ ] Код подписан правильно
- [ ] Все иконки добавлены
- [ ] Launch Screen настроен
- [ ] Метаданные заполнены
- [ ] Скриншоты добавлены
- [ ] Приложение протестировано
- [ ] Соответствует App Store Guidelines

## ⏱️ Время проверки

- **Первая публикация**: 1-7 дней
- **Обновления**: 1-3 дня
- **Критические исправления**: 24-48 часов

Удачи с публикацией! 🚀

