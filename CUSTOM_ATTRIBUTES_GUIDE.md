# 🎯 TaxLien.online - Работа с кастомными атрибутами

## 📋 Обзор

Приложение использует **универсальную систему кастомных атрибутов flutter_magento** для работы с данными налоговых закладных. Это позволяет хранить и обрабатывать специфичные для tax liens данные, сохраняя совместимость с Magento API.

## 🏗️ Архитектура

### 1. Flutter Magento (Библиотека)

**Файл:** `/libs/libsflutter/flutter_magento/lib/src/adapters/tax_lien_adapter.dart`

**TaxLienAdapter** предоставляет:
- ✅ Типизированные кастомные атрибуты
- ✅ Автоматическую конвертацию типов
- ✅ Валидацию данных
- ✅ Фильтры для поиска
- ✅ Совместимость с Magento API

**Поддерживаемые атрибуты:**

```dart
class TaxLienAttributes {
  // Основная информация
  String? parcelId;            // ID земельного участка
  double? taxAmount;           // Сумма налога
  double? interestRate;        // Процентная ставка
  String? county;              // Округ
  String? state;               // Штат
  String? zipCode;             // Почтовый индекс
  
  // Информация о недвижимости
  String? address;             // Адрес
  String? city;                // Город
  String? propertyType;        // Тип (residential/commercial/land)
  double? assessedValue;       // Оценочная стоимость
  double? lotSize;             // Площадь участка
  int? yearBuilt;              // Год постройки
  int? bedrooms;               // Спальни
  double? bathrooms;           // Ванные
  double? squareFeet;          // Площадь кв.футы
  
  // Специфичные для tax lien
  DateTime? auctionDate;       // Дата аукциона
  DateTime? saleDate;          // Дата продажи
  DateTime? redemptionDeadline; // Срок выкупа
  String? status;              // Статус
  String? ownerName;           // Владелец
  
  // Финансовые детали
  double? openingBid;          // Начальная ставка
  double? currentBid;          // Текущая ставка
  double? premiumAmount;       // Премия
  double? penaltyAmount;       // Штраф
  double? totalAmount;         // Общая сумма
  
  // Рыночные данные
  double? marketValue;         // Рыночная стоимость
  double? rentEstimate;        // Оценка аренды
  String? neighborhood;        // Район
  double? schoolRating;        // Рейтинг школ
  double? crimeIndex;          // Индекс преступности
  
  // Метаданные
  List<String>? liens;         // Другие залоги
  List<String>? attachments;   // Документы
  Map<String, dynamic>? metadata; // Гибкие данные
}
```

### 2. TaxLien App (Приложение)

**Файл:** `lib/services/tax_lien_magento_adapter.dart`

**TaxLienMagentoAdapter** обеспечивает:
- Конвертацию Magento Product ↔ TaxLien
- Построение фильтров поиска
- Валидацию данных
- Extension methods для Product

## 📖 Использование

### Инициализация

```dart
import 'package:flutter_magento/flutter_magento.dart';

void main() async {
  // Регистрируем TaxLien адаптер
  final taxLienAdapter = TaxLienAdapter();
  CustomAttributesManager.instance.registerAdapter(
    'tax_lien',
    taxLienAdapter,
  );
  
  // Инициализируем FlutterMagento
  final magento = FlutterMagento();
  await magento.initialize(
    baseUrl: 'https://your-magento-store.com',
    customAdapters: [taxLienAdapter],
  );
}
```

### Поиск с кастомными атрибутами

```dart
// Через TaxLienSearchService (упрощенный)
final searchService = TaxLienSearchService(dataLoader);
final liens = await searchService.searchLiens(
  state: 'FL',
  county: 'Miami-Dade',
  minAmount: 5000,
  maxAmount: 50000,
  minInterestRate: 10.0,
);

// Через Magento API напрямую
final products = await magento.enhancedProducts.getEnhancedProducts<TaxLienAttributes>(
  adapterId: 'tax_lien',
  customAttributeFilters: {
    'state': 'FL',
    'county': 'Miami-Dade',
    'tax_amount': {'range': {'from': '5000', 'to': '50000'}},
    'interest_rate': {'gteq': '10.0'},
  },
);

// Конвертация в TaxLien
final adapter = TaxLienMagentoAdapter();
final liens = products.items.map((p) => adapter.fromMagentoProduct(p.baseProduct)).toList();
```

### Работа с продуктами

```dart
// Получить продукт
final product = await magento.products.getProduct('TAX-FL-001');

// Проверить, является ли tax lien
if (product.isTaxLien()) {
  // Конвертировать в TaxLien
  final lien = product.toTaxLien();
  
  print('Parcel ID: ${lien.parcelId}');
  print('Amount: \$${lien.amount}');
  print('Interest Rate: ${lien.interestRate}%');
  print('County: ${lien.county}, ${lien.state}');
}
```

### Сохранение данных

```dart
final adapter = TaxLienMagentoAdapter();

// Создать новый tax lien
final newLien = TaxLien(
  id: '',
  parcelId: '12-34-56-789',
  address: '123 Main St',
  city: 'Miami',
  county: 'Miami-Dade',
  state: 'FL',
  zipCode: '33139',
  amount: 12500.00,
  interestRate: 18.0,
  status: 'available',
);

// Конвертировать в Magento продукт
final productData = adapter.toMagentoProduct(newLien);

// Сохранить через Magento API
await magento.products.createProduct(productData);
```

## 📂 Формат RADA файлов

### Структура data.json внутри .rada (ZIP)

```json
{
  "products": [
    {
      "id": 1,
      "sku": "TAX-FL-001",
      "name": "123 Ocean Drive, Miami, FL",
      "price": 12500.00,
      "status": 1,
      "type_id": "simple",
      "custom_attributes": [
        {"attribute_code": "parcel_id", "value": "12-34-56-789"},
        {"attribute_code": "tax_amount", "value": "12500.00"},
        {"attribute_code": "interest_rate", "value": "18.0"},
        {"attribute_code": "county", "value": "Miami-Dade"},
        {"attribute_code": "state", "value": "FL"},
        {"attribute_code": "zip_code", "value": "33139"},
        {"attribute_code": "address", "value": "123 Ocean Drive"},
        {"attribute_code": "city", "value": "Miami"},
        {"attribute_code": "property_type", "value": "residential"},
        {"attribute_code": "assessed_value", "value": "450000.00"},
        {"attribute_code": "year_built", "value": "2010"},
        {"attribute_code": "bedrooms", "value": "3"},
        {"attribute_code": "bathrooms", "value": "2.5"},
        {"attribute_code": "square_feet", "value": "2200"},
        {"attribute_code": "auction_date", "value": "2024-12-15T10:00:00Z"},
        {"attribute_code": "status", "value": "available"},
        {"attribute_code": "owner_name", "value": "John Smith"},
        {"attribute_code": "market_value", "value": "475000.00"}
      ]
    }
  ],
  "categories": []
}
```

### Создание .rada файла

```bash
# 1. Создайте структуру
mkdir -p taxlien_florida
cd taxlien_florida
mkdir -p assets/products
mkdir l10n

# 2. Создайте manifest.json
cat > manifest.json << 'EOF'
{
  "version": "1.0",
  "format": "rada",
  "createdAt": "2024-10-15T12:00:00Z",
  "createdBy": "taxlien-app",
  "source": {
    "storeUrl": "https://taxlien.online",
    "categoryId": 1,
    "categoryName": "Florida Tax Liens"
  },
  "stats": {
    "productsCount": 100,
    "categoriesCount": 1
  }
}
EOF

# 3. Создайте data.json с вашими данными

# 4. Упакуйте в .rada (zip)
zip -r ../taxlien_florida.rada .
```

## 🔧 Конфигурация приложения

### pubspec.yaml

```yaml
dependencies:
  flutter_magento:
    path: ../../../libs/libsflutter/flutter_magento

flutter:
  assets:
    - assets/  # Включает все .rada файлы
```

### Доступные .rada файлы

- `assets/taxlien_florida.rada` - Florida tax liens
- `assets/taxlien_arizona.rada` - Arizona tax liens
- `assets/taxlien_data.rada` - Все штаты
- `assets/taxlien_demo.rada` - Демо данные
- `assets/taxlien.rada` - Базовый набор

## 🎨 UI Компоненты

### Маркетплейс пакетов

**Файл:** `lib/screens/marketplace_packages_screen.dart`

Показывает доступные пакеты данных от конкурентов с ценами, функциями и возможностью покупки.

### Выбор .rada файлов

**Файл:** `lib/screens/rada_file_selector_screen.dart`

Позволяет пользователю выбрать, какие .rada файлы загружать для поиска.

### Поиск закладных

**Файл:** `lib/main.dart` (SearchTab)

Полнофункциональный поиск с:
- Строкой поиска
- Фильтрами (штат, сумма)
- Статистикой
- Детальной информацией
- Добавлением в избранное

## 🔄 Синхронизация данных

### Offline → Online

```dart
// 1. Загрузить из .rada (offline)
final offlineLoader = OfflineDataLoaderService();
await offlineLoader.initialize();
final products = await offlineLoader.getProducts(state: 'FL');

// 2. Синхронизировать с Magento (online)
for (final product in products) {
  final lien = TaxLien.fromMap(product);
  final productData = adapter.toMagentoProduct(lien);
  await magento.products.createOrUpdateProduct(productData);
}
```

### Online → Offline

```dart
// 1. Получить из Magento
final products = await magento.products.getProducts(
  categoryId: 'tax-liens',
  pageSize: 1000,
);

// 2. Экспортировать в .rada
final exporter = RadaExporter(magento);
await exporter.exportCategory(
  categoryId: 'tax-liens',
  outputPath: 'assets/taxlien_florida.rada',
  includeCustomAttributes: true,
);
```

## 📊 Валидация

```dart
final adapter = TaxLienMagentoAdapter();

// Валидация перед сохранением
final validation = adapter.validateTaxLien(lien);

if (!validation.isValid) {
  for (final error in validation.errors) {
    print('❌ $error');
  }
} else {
  // Сохранить
  await saveLien(lien);
}
```

## 🎯 Лучшие практики

### 1. Именование атрибутов

✅ **Хорошо:**
```dart
'parcel_id'
'tax_amount'
'interest_rate'
'auction_date'
```

❌ **Плохо:**
```dart
'pid'
'amt'
'rate'
'date'
```

### 2. Типы данных

```dart
// Всегда используйте правильные типы
taxAmount: 12500.00,          // double, не String
interestRate: 18.0,           // double, не int
auctionDate: DateTime(...),   // DateTime, не String
bedrooms: 3,                  // int, не String
```

### 3. Fallback стратегия

```dart
// 1. Попытка загрузить из .rada
try {
  final products = await dataLoader.getProducts();
  liens = products.map((p) => TaxLien.fromMap(p)).toList();
} catch (e) {
  // 2. Fallback на demo data
  liens = demoData;
}

// 3. Показать пользователю источник
if (liens.isNotEmpty) {
  final source = liens == demoData ? 'Demo' : 'RADA';
  print('Data source: $source');
}
```

### 4. Производительность

```dart
// Кэшируйте адаптер
final adapter = TaxLienMagentoAdapter(); // Создать один раз

// Используйте повторно
for (final product in products) {
  final lien = adapter.fromMagentoProduct(product);
  // ...
}
```

## 🚀 Интеграция в приложении

### Текущая реализация

1. **OfflineDataLoaderService** - Загрузка .rada файлов
2. **TaxLienSearchService** - Поиск с fallback на demo data
3. **TaxLienMagentoAdapter** - Конвертация Magento ↔ TaxLien
4. **MarketplacePackagesScreen** - Покупка пакетов данных
5. **RadaFileSelectorScreen** - Выбор загружаемых файлов

### Путь данных

```
┌─────────────────┐
│  .rada файлы    │
│  (ZIP архив)    │
└────────┬────────┘
         │
         ▼
┌─────────────────────────┐
│ OfflineDataLoaderService │
│ - Распаковка ZIP        │
│ - Парсинг JSON          │
│ - Кэширование           │
└────────┬────────────────┘
         │
         ▼
┌─────────────────────────┐
│  TaxLienSearchService   │
│ - Поиск по атрибутам    │
│ - Фильтрация            │
│ - Fallback на demo      │
└────────┬────────────────┘
         │
         ▼
┌─────────────────────────┐
│   TaxLienAdapter        │
│ - Типизация атрибутов   │
│ - Валидация             │
│ - Конвертация типов     │
└────────┬────────────────┘
         │
         ▼
┌─────────────────────────┐
│      TaxLien Model      │
│ - Готовые данные для UI │
└─────────────────────────┘
```

## 📝 Примеры использования

### Пример 1: Поиск по штату

```dart
final service = TaxLienSearchService(dataLoader);
final liens = await service.searchLiens(
  state: 'FL',
  limit: 50,
);

print('Найдено ${liens.length} закладных во Флориде');
```

### Пример 2: Фильтрация по цене и ставке

```dart
final liens = await service.searchLiens(
  minAmount: 10000,
  maxAmount: 50000,
  minInterestRate: 15.0,
  state: 'FL',
);

for (final lien in liens) {
  print('${lien.address}: \$${lien.amount} @ ${lien.interestRate}%');
}
```

### Пример 3: Текстовый поиск

```dart
final liens = await service.searchLiens(
  query: 'Miami',  // Поиск по адресу, городу, округу
  state: 'FL',
);
```

### Пример 4: Статистика

```dart
final stats = await service.getStatistics();
print('Всего закладных: ${stats.totalCount}');
print('Общая сумма: \$${stats.totalAmount}');
print('Средняя ставка: ${stats.avgInterestRate}%');
print('По штатам: ${stats.stateCount}');
```

## 🔗 Связь с Magento backend

### На сервере (PHP)

```php
// app/code/Vendor/TaxLien/Setup/Patch/Data/AddTaxLienAttributes.php

public function apply() {
    $attributes = [
        'parcel_id' => ['type' => 'varchar', 'label' => 'Parcel ID'],
        'tax_amount' => ['type' => 'decimal', 'label' => 'Tax Amount'],
        'interest_rate' => ['type' => 'decimal', 'label' => 'Interest Rate'],
        'county' => ['type' => 'varchar', 'label' => 'County'],
        'state' => ['type' => 'varchar', 'label' => 'State'],
        // ... остальные атрибуты
    ];
    
    foreach ($attributes as $code => $config) {
        $this->eavSetup->addAttribute(
            \Magento\Catalog\Model\Product::ENTITY,
            $code,
            [
                'type' => $config['type'],
                'label' => $config['label'],
                'input' => 'text',
                'required' => false,
                'user_defined' => true,
                'searchable' => true,
                'filterable' => true,
                'comparable' => true,
                'visible_on_front' => true,
            ]
        );
    }
}
```

## 📦 Структура файлов

```
taxlien-app/
├── lib/
│   ├── services/
│   │   ├── tax_lien_search_service.dart      # Поиск с fallback
│   │   ├── tax_lien_magento_adapter.dart     # Конвертация Magento ↔ TaxLien
│   │   └── offline_data_loader_service.dart  # Загрузка .rada
│   ├── screens/
│   │   ├── marketplace_packages_screen.dart  # Пакеты конкурентов
│   │   └── rada_file_selector_screen.dart    # Выбор .rada файлов
│   └── main.dart                             # UI с SearchTab
├── assets/
│   ├── taxlien_florida.rada                  # Florida данные
│   ├── taxlien_arizona.rada                  # Arizona данные
│   ├── taxlien_data.rada                     # Все штаты
│   └── taxlien_demo.rada                     # Demo данные
└── pubspec.yaml                              # flutter_magento: path

libs/libsflutter/flutter_magento/
└── lib/
    └── src/
        └── adapters/
            └── tax_lien_adapter.dart         # TaxLien адаптер
```

## ✅ Готово к использованию

Приложение **TaxLien.online** теперь полностью интегрировано с:
- ✅ Универсальной системой кастомных атрибутов
- ✅ TaxLienAdapter в flutter_magento
- ✅ Локальной версией библиотеки
- ✅ Поиском по .rada файлам
- ✅ Fallback на demo data
- ✅ Маркетплейсом пакетов
- ✅ Выбором источников данных

**Made with ❤️ by NativeMind Team**



