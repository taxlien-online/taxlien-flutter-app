# TaxLien.online Data - Migration to .rada Files

**ВАЖНО:** Все захардкоженные данные перенесены в `.rada` файлы!

## 🔄 Изменения

Все классы в этой папке теперь являются **DEPRECATED** и сохранены только для обратной совместимости.

### Было
Данные хранились в захардкоженном виде в:
- `demo_data.dart` - продукты, категории, клиенты, заказы
- `counties_demo_data.dart` - данные об округах
- `categories_demo_data.dart` - категории штатов
- `historical_data.dart` - исторические данные

### Стало
Все данные загружаются из файлов `.rada` в директории `/assets/`:
- `assets/taxlien_data.rada` - все данные
- `assets/taxlien_florida.rada` - данные по Флориде
- `assets/taxlien_arizona.rada` - данные по Аризоне
- `assets/taxlien_demo.rada` - демо данные
- `assets/taxlien.rada` - базовые данные

## 📦 Новая архитектура

### Основные сервисы для работы с данными:

1. **OfflineDataLoaderService** - основной сервис загрузки из .rada файлов
2. **PreloadService** - сервис предзагрузки данных
3. **DemoDataService** - обновленный сервис с обратной совместимостью

## 🚀 Использование

### Правильно ✅

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

### С использованием DemoDataService (обратная совместимость)

```dart
import '../services/demo_data_service.dart';

final demoService = DemoDataService();
await demoService.initialize(); // Теперь загружает из .rada

// Все методы теперь async и возвращают Future
final products = await demoService.getDemoProducts();
final counties = await demoService.getCountiesByState('FL');
final taxLiens = await demoService.getTaxLienProductsByState('FL');
```

### Неправильно ❌

```dart
// НЕ ИСПОЛЬЗУЙТЕ НАПРЯМУЮ!
import '../data/demo_data.dart';
import '../data/counties_demo_data.dart';

// Это вернет пустые массивы и выведет предупреждения
final products = TaxLienDemoData.demoProducts; // []
final counties = TaxLienCountiesDemoData.getCountiesByState('FL'); // []
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

## ⚠️ Миграция существующего кода

Если ваш код использует старые классы, выполните следующие шаги:

1. **Замените импорты:**
   ```dart
   // Было:
   import '../data/demo_data.dart';
   
   // Стало:
   import '../services/offline_data_loader_service.dart';
   // или
   import '../services/demo_data_service.dart';
   ```

2. **Обновите вызовы методов на async:**
   ```dart
   // Было:
   final products = TaxLienDemoData.demoProducts;
   
   // Стало:
   final products = await loader.getProducts();
   // или
   final products = await demoService.getDemoProducts();
   ```

3. **Обновите инициализацию:**
   ```dart
   // Добавьте инициализацию в начале
   final loader = OfflineDataLoaderService();
   await loader.initialize();
   ```

## 🎯 Преимущества новой архитектуры

✅ **Динамическая загрузка** - данные загружаются из файлов, а не хардкодятся  
✅ **Мультиштатность** - поддержка загрузки данных по нескольким штатам  
✅ **Кеширование** - автоматическое кеширование для быстрого доступа  
✅ **Масштабируемость** - легко добавлять новые .rada файлы  
✅ **Производительность** - оптимизированная загрузка и фильтрация  
✅ **Офлайн режим** - полная поддержка работы без интернета  

## 📝 Поддержка обратной совместимости

Все старые классы сохранены с deprecation warnings:
- `TaxLienDemoData` - все методы возвращают пустые массивы
- `TaxLienCountiesDemoData` - все методы возвращают пустые массивы
- `TaxLienCategoriesDemoData` - все методы возвращают пустые массивы (кроме `getStateNameByCode`)
- `TaxLienHistoricalData` - все методы возвращают null/пустые массивы
- `InitialPreloadData` - минимальная структура с указателями на новые сервисы

## 🔍 Troubleshooting

**Проблема:** Получаю пустые массивы  
**Решение:** Убедитесь что используете `OfflineDataLoaderService` или `DemoDataService`, а не старые классы напрямую

**Проблема:** Ошибка "Failed to load .rada files"  
**Решение:** Проверьте наличие файлов в `/assets/` и добавьте их в `pubspec.yaml`

**Проблема:** Методы не async  
**Решение:** Обновите ваш код - все новые методы асинхронные

## 📚 Дополнительная информация

- Документация по OfflineDataLoaderService: см. код с комментариями
- Документация по PreloadService: см. код с комментариями  
- Примеры использования: `lib/services/demo_data_service.dart`

---

**Версия:** 3.0.0  
**Дата обновления:** 2025-01-14  
**Статус:** ✅ Активно используется
