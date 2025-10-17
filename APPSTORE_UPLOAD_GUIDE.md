# Инструкция по загрузке в App Store

## ✅ Архив готов!

**Версия:** 4.0.3  
**Build:** 22  
**IPA файл:** `build/ios/ipa/taxlien.online.ipa`  
**Размер:** 50 MB

---

## 🚀 Способы загрузки

### Способ 1: Apple Transporter (Рекомендуется) ⭐

**Самый простой и надежный способ**

#### Шаг 1: Установите Transporter
- Откройте: https://apps.apple.com/app/transporter/id1450874784
- Или найдите "Transporter" в Mac App Store
- Скачайте и установите приложение

#### Шаг 2: Откройте Transporter
```bash
open -a "Transporter"
```

#### Шаг 3: Войдите с Apple ID
- Используйте ваш Apple Developer аккаунт
- Введите пароль (может потребоваться двухфакторная аутентификация)

#### Шаг 4: Загрузите IPA
1. Перетащите файл `taxlien.online.ipa` в окно Transporter
2. Или нажмите "+" и выберите файл
3. Файл находится здесь:
   ```
   /Users/anton/proj/APPLICATIONS/TAXLIEN.online/taxlien-app/build/ios/ipa/taxlien.online.ipa
   ```

#### Шаг 5: Доставка
- Нажмите кнопку **"Deliver"**
- Дождитесь завершения загрузки (обычно 5-15 минут)
- Вы получите уведомление о успешной загрузке

---

### Способ 2: Командная строка с API ключом

**Для автоматизации и CI/CD**

#### Шаг 1: Создайте API ключ App Store Connect

1. Перейдите: https://appstoreconnect.apple.com/access/api
2. Нажмите "+" для создания нового ключа
3. Выберите роль: **App Manager** или **Developer**
4. Скачайте файл `.p8`
5. Сохраните:
   - **Key ID** (например: ABC123XYZ)
   - **Issuer ID** (например: 12345678-1234-1234-1234-123456789012)

#### Шаг 2: Загрузите через терминал

```bash
xcrun altool --upload-app \
    --type ios \
    --file build/ios/ipa/taxlien.online.ipa \
    --apiKey "YOUR_KEY_ID" \
    --apiIssuer "YOUR_ISSUER_ID"
```

**Или используйте скрипт:**
```bash
./upload_to_appstore.sh
```

---

### Способ 3: Через Xcode Organizer

#### Шаг 1: Откройте Xcode
```bash
open ios/Runner.xcworkspace
```

#### Шаг 2: Создайте архив
1. Выберите устройство: **Any iOS Device (arm64)**
2. Меню: **Product → Archive**
3. Дождитесь завершения архивации

#### Шаг 3: Загрузите в App Store
1. После архивации откроется окно **Organizer**
2. Выберите последний архив
3. Нажмите **"Distribute App"**
4. Выберите **"App Store Connect"**
5. Нажмите **"Upload"**
6. Следуйте инструкциям на экране

---

## 📱 После загрузки

### 1. Проверьте статус в App Store Connect

Перейдите: https://appstoreconnect.apple.com

1. Выберите **"Мои приложения"**
2. Выберите **TaxLien.online**
3. Перейдите в раздел **TestFlight**

### 2. Дождитесь обработки

- Обработка обычно занимает **5-15 минут**
- Вы получите email от Apple после завершения
- Статус изменится с "Processing" на "Ready to Test"

### 3. Проверьте сборку

Убедитесь что:
- ✅ Версия: **4.0.3**
- ✅ Build: **22**
- ✅ Статус: **Ready to Submit**
- ✅ Privacy manifest включен
- ✅ Нет ошибок валидации

### 4. Отправьте на ревью

1. В App Store Connect выберите вашу сборку
2. Нажмите **"Submit for Review"**
3. Заполните информацию о релизе (если требуется)
4. Подтвердите отправку

---

## 🔧 Решение проблем

### Ошибка: "Invalid Signature"
```bash
# Пересоберите IPA
flutter clean
flutter build ipa --release
```

### Ошибка: "Missing API Key"
- Убедитесь, что вы создали API ключ в App Store Connect
- Проверьте права доступа ключа (нужен App Manager)
- Сохраните файл .p8 в безопасном месте

### Ошибка: "Authentication Failed"
- Проверьте Apple ID и пароль
- Включите двухфакторную аутентификацию, если требуется
- Используйте пароль приложения для Transporter

### Ошибка: "Version Already Exists"
- Измените версию в `pubspec.yaml`
- Пересоберите: `flutter build ipa --release`

---

## 📋 Полезные команды

### Собрать новую версию
```bash
# Обновите версию в pubspec.yaml
# Затем:
flutter clean
flutter pub get
flutter build ipa --release
```

### Проверить сборку
```bash
# Размер IPA
du -h build/ios/ipa/taxlien.online.ipa

# Информация о сборке
plutil -p build/ios/ipa/DistributionSummary.plist
```

### Открыть IPA в Finder
```bash
open build/ios/ipa/
```

### Запустить скрипт загрузки
```bash
./upload_to_appstore.sh
```

---

## 📞 Полезные ссылки

- **App Store Connect:** https://appstoreconnect.apple.com
- **Apple Developer Portal:** https://developer.apple.com
- **TestFlight:** https://appstoreconnect.apple.com/apps/{app-id}/testflight
- **Transporter:** https://apps.apple.com/app/transporter/id1450874784
- **API Keys:** https://appstoreconnect.apple.com/access/api

---

## ✅ Текущий статус

- [x] Версия обновлена до 4.0.3
- [x] IPA архив создан (50 MB)
- [x] Privacy manifest включен (package_info_plus 9.0.0)
- [x] Папка с IPA открыта в Finder
- [x] Скрипт загрузки создан
- [ ] Загрузка в App Store Connect (выполните вручную)
- [ ] TestFlight обработка (подождите 5-15 минут)
- [ ] Отправка на ревью

---

## 🎯 Следующие шаги

1. **Установите Transporter** (если еще не установлен)
2. **Откройте Transporter** и войдите с Apple ID
3. **Перетащите файл** `taxlien.online.ipa` в Transporter
4. **Нажмите "Deliver"** для загрузки
5. **Дождитесь завершения** загрузки
6. **Перейдите в App Store Connect** для отправки на ревью

---

**Готово!** 🎉 IPA архив создан и готов к загрузке в App Store.

**Дата:** 17 октября 2025  
**Версия:** 4.0.3 (Build 22)

