# Google Play Store Metadata

Эта директория содержит все метаданные для публикации в Google Play Store через Fastlane.

## Структура директорий

```
metadata/android/
└── en-US/
    ├── title.txt                  # Название приложения (макс. 50 символов)
    ├── short_description.txt      # Краткое описание (макс. 80 символов)
    ├── full_description.txt       # Полное описание (макс. 4000 символов)
    ├── video.txt                  # URL видео на YouTube (опционально)
    ├── changelogs/
    │   └── default.txt            # Список изменений по умолчанию
    └── images/
        ├── icon/
        │   └── icon.png           # Иконка приложения (512x512 px)
        ├── featureGraphic/
        │   └── featureGraphic.png # Главное изображение (1024x500 px)
        ├── phoneScreenshots/      # Скриншоты для телефонов (мин. 2, макс. 8)
        │   ├── 1_screenshot.png   # 16:9 или 9:16, мин. 320px
        │   └── 2_screenshot.png
        └── tenInchScreenshots/    # Скриншоты для планшетов (опционально)
```

## Требования к изображениям

### Иконка приложения (icon.png)
- Размер: 512x512 пикселей
- Формат: 32-bit PNG с альфа-каналом
- Максимальный размер файла: 1024KB

### Feature Graphic (featureGraphic.png)
- Размер: 1024x500 пикселей
- Формат: JPEG или 24-bit PNG (без альфа-канала)
- Обязательно для всех приложений

### Скриншоты (phoneScreenshots/)
- Минимум: 2 скриншота
- Максимум: 8 скриншотов
- Формат: JPEG или 24-bit PNG
- Соотношение сторон: 16:9 или 9:16
- Минимальная сторона: 320px
- Максимальная сторона: 3840px
- Названия файлов должны быть в порядке отображения (1_, 2_, 3_, и т.д.)

## Добавление других языков

Чтобы добавить поддержку других языков, создайте копию папки `en-US` с соответствующим языковым кодом:

```bash
# Пример для русского языка
cp -r en-US ru-RU

# Пример для испанского языка
cp -r en-US es-ES
```

Поддерживаемые языковые коды:
- `en-US` - English (United States)
- `ru-RU` - Русский
- `es-ES` - Español (España)
- `de-DE` - Deutsch
- `fr-FR` - Français
- `it-IT` - Italiano
- `pt-BR` - Português (Brasil)
- И другие...

## Changelogs

Changelog можно создать для конкретной версии:
```bash
# Создать changelog для версии с versionCode = 400
echo "• Bug fixes" > en-US/changelogs/400.txt
```

Если changelog для конкретной версии не найден, будет использован `default.txt`.

## Использование

После заполнения всех файлов и добавления изображений, запустите:

```bash
# Загрузить только метаданные (без APK/AAB)
fastlane android metadata

# Выгрузить существующие метаданные из Google Play
fastlane android download_metadata
```

## Проверка

Перед загрузкой убедитесь, что:
- ✅ title.txt не превышает 50 символов
- ✅ short_description.txt не превышает 80 символов
- ✅ full_description.txt не превышает 4000 символов
- ✅ Добавлена иконка 512x512px
- ✅ Добавлен feature graphic 1024x500px
- ✅ Добавлено минимум 2 скриншота телефона
- ✅ Все изображения в правильном формате и размере

