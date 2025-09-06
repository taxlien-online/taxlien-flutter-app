#!/bin/bash

# TaxLien.online - Автоматическая загрузка в Google Play Store
# Этот скрипт автоматизирует процесс публикации приложения в Google Play Store

set -e

echo "🚀 TaxLien.online - Автоматическая загрузка в Google Play Store"
echo "================================================================"

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Конфигурация
APP_NAME="TaxLien.online"
PACKAGE_NAME="taxlien.online"
AAB_FILE="build/app/outputs/bundle/release/app-release.aab"
SERVICE_ACCOUNT_JSON="google-play-service-account.json"
TRACK="internal" # internal, alpha, beta, production

# Проверка зависимостей
echo -e "${BLUE}📋 Проверка зависимостей...${NC}"

# Проверка наличия AAB файла
if [ ! -f "$AAB_FILE" ]; then
    echo -e "${RED}❌ AAB файл не найден: $AAB_FILE${NC}"
    echo -e "${YELLOW}💡 Сначала соберите приложение: flutter build appbundle --release${NC}"
    exit 1
fi

# Проверка наличия service account JSON
if [ ! -f "$SERVICE_ACCOUNT_JSON" ]; then
    echo -e "${YELLOW}⚠️  Service Account JSON не найден: $SERVICE_ACCOUNT_JSON${NC}"
    echo -e "${BLUE}📝 Создание инструкций для настройки Google Play API...${NC}"
    
    cat > google_play_api_setup.md << 'EOF'
# Настройка Google Play Console API

## Шаг 1: Создание Service Account

1. Перейдите в [Google Cloud Console](https://console.cloud.google.com/)
2. Выберите ваш проект или создайте новый
3. Перейдите в "IAM & Admin" → "Service Accounts"
4. Нажмите "Create Service Account"
5. Заполните:
   - Name: `taxlien-play-store-uploader`
   - Description: `Service account for TaxLien.online Play Store uploads`
6. Нажмите "Create and Continue"
7. Роли: `Editor` (или `Service Account User`)
8. Нажмите "Done"

## Шаг 2: Создание JSON ключа

1. Найдите созданный service account
2. Нажмите на него
3. Перейдите в "Keys" → "Add Key" → "Create new key"
4. Выберите "JSON"
5. Скачайте файл и переименуйте в `google-play-service-account.json`
6. Поместите файл в корень проекта

## Шаг 3: Настройка прав в Google Play Console

1. Перейдите в [Google Play Console](https://play.google.com/console)
2. Выберите ваше приложение
3. Перейдите в "Setup" → "API access"
4. Нажмите "Link project" (если проект не связан)
5. Найдите ваш service account
6. Нажмите "Grant access"
7. Выберите права:
   - ✅ View app information and download bulk reports
   - ✅ Manage production releases
   - ✅ Manage testing track releases
   - ✅ View financial data, orders, and cancellation survey responses
8. Нажмите "Invite user"

## Шаг 4: Установка Google Play Developer API

```bash
pip install google-api-python-client google-auth-httplib2 google-auth-oauthlib
```

После выполнения этих шагов запустите скрипт снова.
EOF

    echo -e "${GREEN}✅ Инструкции созданы в файле: google_play_api_setup.md${NC}"
    echo -e "${BLUE}📖 Прочитайте инструкции и выполните настройку${NC}"
    exit 1
fi

# Проверка Python и библиотек
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}❌ Python3 не найден. Установите Python 3${NC}"
    exit 1
fi

# Проверка установки библиотек Google Play API
if ! python3 -c "import googleapiclient.discovery" 2>/dev/null; then
    echo -e "${YELLOW}⚠️  Google Play API библиотеки не установлены${NC}"
    echo -e "${BLUE}📦 Устанавливаем необходимые библиотеки...${NC}"
    pip3 install google-api-python-client google-auth-httplib2 google-auth-oauthlib
fi

echo -e "${GREEN}✅ Все зависимости проверены${NC}"

# Создание Python скрипта для загрузки
cat > upload_to_play.py << 'EOF'
#!/usr/bin/env python3
"""
TaxLien.online - Автоматическая загрузка в Google Play Store
"""

import os
import sys
import json
from google.oauth2 import service_account
from googleapiclient.discovery import build
from googleapiclient.http import MediaFileUpload
from googleapiclient.errors import HttpError

def upload_to_play_store():
    # Конфигурация
    PACKAGE_NAME = "taxlien.online"
    AAB_FILE = "build/app/outputs/bundle/release/app-release.aab"
    SERVICE_ACCOUNT_JSON = "google-play-service-account.json"
    TRACK = "internal"  # internal, alpha, beta, production
    
    print(f"🚀 Загрузка {PACKAGE_NAME} в Google Play Store...")
    
    # Проверка файлов
    if not os.path.exists(AAB_FILE):
        print(f"❌ AAB файл не найден: {AAB_FILE}")
        return False
        
    if not os.path.exists(SERVICE_ACCOUNT_JSON):
        print(f"❌ Service Account JSON не найден: {SERVICE_ACCOUNT_JSON}")
        return False
    
    try:
        # Аутентификация
        print("🔐 Аутентификация с Google Play API...")
        credentials = service_account.Credentials.from_service_account_file(
            SERVICE_ACCOUNT_JSON,
            scopes=['https://www.googleapis.com/auth/androidpublisher']
        )
        
        # Создание сервиса
        service = build('androidpublisher', 'v3', credentials=credentials)
        
        # Получение информации о приложении
        print("📱 Получение информации о приложении...")
        app_info = service.edits().insert(
            packageName=PACKAGE_NAME
        ).execute()
        
        edit_id = app_info['id']
        print(f"✅ Edit ID: {edit_id}")
        
        # Загрузка AAB файла
        print(f"📦 Загрузка AAB файла: {AAB_FILE}")
        media = MediaFileUpload(
            AAB_FILE,
            mimetype='application/octet-stream',
            resumable=True
        )
        
        bundle_response = service.edits().bundles().upload(
            editId=edit_id,
            packageName=PACKAGE_NAME,
            media_body=media
        ).execute()
        
        version_code = bundle_response['versionCode']
        print(f"✅ AAB загружен, версия: {version_code}")
        
        # Создание релиза
        print(f"🎯 Создание релиза в треке: {TRACK}")
        
        release_body = {
            'releases': [{
                'versionCodes': [version_code],
                'status': 'draft',  # draft, completed, halted, inProgress
                'releaseNotes': [{
                    'language': 'ru-RU',
                    'text': 'Первая версия TaxLien.online - мобильное приложение для инвестирования в налоговые залоги'
                }]
            }]
        }
        
        service.edits().tracks().update(
            editId=edit_id,
            packageName=PACKAGE_NAME,
            track=TRACK,
            body=release_body
        ).execute()
        
        print(f"✅ Релиз создан в треке {TRACK}")
        
        # Валидация
        print("🔍 Валидация изменений...")
        validation_result = service.edits().validate(
            editId=edit_id,
            packageName=PACKAGE_NAME
        ).execute()
        
        if validation_result.get('status') == 'VALID':
            print("✅ Валидация прошла успешно")
        else:
            print(f"⚠️  Валидация: {validation_result}")
        
        # Коммит изменений
        print("💾 Сохранение изменений...")
        commit_result = service.edits().commit(
            editId=edit_id,
            packageName=PACKAGE_NAME
        ).execute()
        
        print("🎉 Приложение успешно загружено в Google Play Store!")
        print(f"📱 Пакет: {PACKAGE_NAME}")
        print(f"📦 Версия: {version_code}")
        print(f"🎯 Трек: {TRACK}")
        print(f"🔗 Управление: https://play.google.com/console/developers/")
        
        return True
        
    except HttpError as e:
        print(f"❌ Ошибка Google Play API: {e}")
        if e.resp.status == 403:
            print("💡 Проверьте права доступа service account в Google Play Console")
        return False
    except Exception as e:
        print(f"❌ Ошибка: {e}")
        return False

if __name__ == "__main__":
    success = upload_to_play_store()
    sys.exit(0 if success else 1)
EOF

echo -e "${BLUE}🐍 Создание Python скрипта для загрузки...${NC}"

# Запуск загрузки
echo -e "${BLUE}🚀 Запуск автоматической загрузки...${NC}"
python3 upload_to_play.py

if [ $? -eq 0 ]; then
    echo -e "${GREEN}🎉 Успешно! Приложение загружено в Google Play Store${NC}"
    echo -e "${BLUE}📱 Перейдите в Google Play Console для завершения публикации${NC}"
    echo -e "${BLUE}🔗 https://play.google.com/console/developers/${NC}"
else
    echo -e "${RED}❌ Ошибка при загрузке. Проверьте настройки и попробуйте снова${NC}"
    exit 1
fi

# Очистка временных файлов
echo -e "${BLUE}🧹 Очистка временных файлов...${NC}"
rm -f upload_to_play.py

echo -e "${GREEN}✅ Готово!${NC}"

