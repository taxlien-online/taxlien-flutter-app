# TaxLien.online Data - Unified .rada Files Architecture

**ВАЖНО:** Все данные теперь загружаются из `.rada` файлов!

## 🔄 Архитектура данных

Все устаревшие файлы с захардкоженными данными были удалены. Вся система использует единый источник данных - `.rada` файлы.

## 📦 Структура данных

### Источники данных

Все данные загружаются из файлов `.rada` в директории `/assets/`:
- `assets/taxlien_data.rada` - основные данные
- `assets/taxlien_florida.rada` - данные по Флориде
- `assets/taxlien_arizona.rada` - данные по Аризоне
- `assets/taxlien_demo.rada` - демо данные
- `assets/taxlien.rada` - базовые данные

### Сервисы для работы с данными

1. **OfflineDataLoaderService** - основной сервис загрузки из .rada файлов
   - Загрузка и кеширование данных
   - Фильтрация по штатам и округам
   - Поддержка пагинации
   - Офлайн-режим

2. **DemoDataService** - обновленный сервис с обратной совместимостью
   - Использует OfflineDataLoaderService под капотом
   - Предоставляет удобный API для работы с данными
   - Поддерживает все методы фильтрации и поиска

3. **PreloadService** - сервис предзагрузки данных
   - Предзагрузка данных при старте приложения
   - Управление кешем
   - Оптимизация производительности

4. **SimplifiedDemoIntegration** - упрощенный интерфейс
   - Обратная совместимость с существующим кодом
   - Использует OfflineDataLoaderService
   - Поддержка фильтрации и поиска

5. **FlutterMagentoDemoIntegration** - интеграция с Flutter Magento
   - Единый интерфейс для Magento и демо-данных
   - Переключение между реальными и демо-данными
   - Использует DemoDataService для демо-режима

## 🚀 Использование

### Основной способ (рекомендуется)

```dart
import 'package:flutter/material.dart';
import '../services/offline_data_loader_service.dart';

// Инициализация
final loader = OfflineDataLoaderService();
await loader.initialize();

// Получение продуктов
final products = await loader.getProducts(
  state: 'FL',
  county: 'Polk',
  limit: 20,
);

// Получение категорий
final categories = await loader.getCategories();

// Получение данных об округах
final counties = await loader.getCountiesForState('FL');
final county = await loader.getCountyByName('FL', 'Polk');

// Статистика
final stats = await loader.getDataStats();
print('Total products: ${stats['total_products']}');
print('Available states: ${stats['state_list']}');
```

### С использованием DemoDataService

```dart
import '../services/demo_data_service.dart';

final demoService = DemoDataService();
await demoService.initialize();

// Все методы асинхронные
final products = await demoService.getDemoProducts();
final counties = await demoService.getCountiesByState('FL');
final taxLiens = await demoService.getTaxLienProductsByState('FL');
```

### С использованием SimplifiedDemoIntegration

```dart
import '../services/simplified_demo_integration.dart';

final integration = SimplifiedDemoIntegration();
await integration.initialize();

final products = await integration.getProducts(
  page: 1,
  pageSize: 20,
  searchQuery: 'polk',
);
final counties = await integration.getCountiesByState('FL');
```

## 🔧 Функции OfflineDataLoaderService

### Управление данными

```dart
// Выбор штатов для загрузки
await loader.setSelectedStates({'FL', 'AZ'});

// Получение доступных .rada файлов
final availableStates = loader.getAvailableRadaStates();
// ['FL', 'AZ', 'ALL', 'DEMO', 'DEFAULT']

// Размер данных для штата
final sizeInfo = await loader.getStateDataSize('FL');
print('Products: ${sizeInfo['products']}');
print('Size: ${sizeInfo['file_size_kb']} KB');

// Перезагрузка данных
await loader.reload();

// Очистка кеша
await loader.clearCache();
```

### Фильтрация данных

```dart
// По штату и округу
final floridaProducts = await loader.getProducts(state: 'FL');
final polkProducts = await loader.getProducts(
  state: 'FL', 
  county: 'Polk'
);

// С пагинацией
final page1 = await loader.getProducts(limit: 20, offset: 0);
final page2 = await loader.getProducts(limit: 20, offset: 20);

// Получение списка округов
final countyNames = await loader.getCountyNamesForState('FL');

// Получение доступных штатов
final states = await loader.getAvailableStates();
```

## 📊 Структура данных в .rada файлах

Файлы `.rada` содержат JSON со следующей структурой:

```json
{
  "products": [
    {
      "id": "...",
      "sku": "...",
      "name": "...",
      "price": 1000.00,
      "custom_attributes": [
        {"attribute_code": "state", "value": "FL"},
        {"attribute_code": "county", "value": "Polk"},
        {"attribute_code": "interest_rate", "value": "18.0"}
      ]
    }
  ],
  "categories": [
    {
      "id": 1,
      "name": "Florida",
      "custom_attributes": [
        {"attribute_code": "state_code", "value": "FL"}
      ]
    }
  ],
  "counties": {
    "FL": [
      {
        "name": "Polk",
        "code": "polk",
        "population": 720000,
        "area": 1866
      }
    ]
  }
}
```

## 🎯 Преимущества новой архитектуры

✅ **Единый источник данных** - все данные в .rada файлах  
✅ **Динамическая загрузка** - данные загружаются по требованию  
✅ **Мультиштатность** - поддержка загрузки данных по нескольким штатам  
✅ **Кеширование** - автоматическое кеширование для быстрого доступа  
✅ **Масштабируемость** - легко добавлять новые .rada файлы  
✅ **Производительность** - оптимизированная загрузка и фильтрация  
✅ **Офлайн режим** - полная поддержка работы без интернета  
✅ **Чистый код** - нет захардкоженных данных в коде  

## 🔍 Troubleshooting

**Проблема:** Ошибка "Failed to load .rada files"  
**Решение:** Проверьте наличие файлов в `/assets/` и добавьте их в `pubspec.yaml`

**Проблема:** Пустые данные  
**Решение:** Убедитесь что вызвали `await loader.initialize()` перед использованием

**Проблема:** Методы не async  
**Решение:** Все методы загрузки данных асинхронные - используйте `await`

## 📚 Дополнительная информация

- Документация по OfflineDataLoaderService: `lib/services/offline_data_loader_service.dart`
- Документация по PreloadService: `lib/services/preload_service.dart`  
- Примеры использования: `lib/services/demo_data_service.dart`

---

**Версия:** 4.0.0  
**Дата обновления:** 2025-01-17  
**Статус:** ✅ Активная архитектура (все устаревшие файлы удалены)
