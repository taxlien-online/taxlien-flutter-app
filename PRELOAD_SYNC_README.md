# Preload Data & Scheduled Sync - Quick Start

## 🚀 Quick Overview

TaxLien.online теперь поддерживает:
- ✅ Загрузку offline данных из `/assets/taxlien_data.rada` при старте приложения
- ✅ Scheduled синхронизацию данных по штатам и counties
- ✅ Seamless переключение между online/offline режимами
- ✅ UI для управления расписанием синхронизации

## 📁 Key Files

```
lib/
├── services/
│   ├── offline_data_loader_service.dart      # Загрузка .rada файлов
│   ├── scheduled_data_sync_service.dart      # Управление расписанием
│   └── preload_service.dart                  # Центральный API (updated)
├── screens/
│   └── sync_management_screen.dart           # UI управления
└── core/services/
    └── hybrid_magento_service.dart           # Интеграция (updated)
```

## 🎯 Quick Usage

### 1. Инициализация (Автоматическая)

Выполняется автоматически при запуске в `main.dart`:

```dart
await PreloadService.initializePreloadData();
await PreloadService.createDefaultSyncSchedules();
```

### 2. Получение данных

```dart
// Все продукты для штата
final products = await PreloadService.getProductsByLocation(state: 'FL');

// Продукты для county
final countyProducts = await PreloadService.getProductsByLocation(
  state: 'FL',
  county: 'Polk',
  limit: 20,
);

// Список штатов
final states = await PreloadService.getAvailableStates();

// Counties для штата
final counties = await PreloadService.getCountiesForState('FL');
```

### 3. Управление расписанием

```dart
// Добавить schedule
await PreloadService.addSyncSchedule(
  state: 'FL',
  interval: Duration(hours: 24), // ежедневно
  enabled: true,
);

// Синхронизировать сейчас
await PreloadService.syncStateNow('FL');

// Получить статус
final status = PreloadService.getSyncStatus('FL');
```

### 4. UI Management

Навигация: **Профиль → Управление синхронизацией**

Или программно:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const SyncManagementScreen(),
  ),
);
```

## 📄 Формат .rada файла

Поместите файл: `/assets/taxlien_data.rada`

```json
{
  "products": [
    {
      "sku": "FL-POLK-001",
      "name": "Tax Lien Certificate - Polk County, FL",
      "price": 2500.00,
      "description": "Premium tax lien certificate",
      "custom_attributes": [
        {"attribute_code": "state", "value": "FL"},
        {"attribute_code": "county", "value": "Polk"},
        {"attribute_code": "interest_rate", "value": "18"}
      ]
    }
  ],
  "categories": [
    {
      "id": 2,
      "name": "Florida",
      "parent_id": 1,
      "is_active": true,
      "custom_attributes": [
        {"attribute_code": "state_code", "value": "FL"}
      ]
    }
  ]
}
```

## ⚙️ Конфигурация

### Интервалы синхронизации

```dart
Duration(hours: 1)    // Hourly
Duration(hours: 6)    // Every 6 hours
Duration(hours: 12)   // Every 12 hours
Duration(hours: 24)   // Daily
Duration(days: 7)     // Weekly
```

### Default Schedules

Создаются автоматически для: FL, TX, CA, NY, AZ (disabled по умолчанию)

## 🔍 API Reference

### PreloadService

```dart
// Data Access
getProductsByLocation({state, county, limit, offset})
getAvailableStates()
getCountiesForState(state)
getCombinedProducts({state, county})
getCombinedCategories()

// Schedule Management
addSyncSchedule({state, counties, interval, enabled})
removeSyncSchedule(state)
toggleSyncSchedule(state, enabled)

// Sync Operations
syncStateNow(state)
syncAllStates()

// Status & Info
getSyncStatus(state)
getSyncHistory()
getSyncStatistics()
getPreloadStatus()
getDataSourceInfo()

// Properties
bool isUsingRadaData
OfflineDataLoaderService? offlineLoader
ScheduledDataSyncService? syncService
```

### OfflineDataLoaderService

```dart
initialize()
loadFromRadaFile()
getProducts({state, county, limit, offset})
getCategories()
getAvailableStates()
getCountiesForState(state)
getDataStats()
clearCache()
reload()
```

### ScheduledDataSyncService

```dart
initialize()
addSchedule(config)
removeSchedule(state)
toggleSchedule(state, enabled)
syncStateData(schedule)
syncAllNow()
getSyncStatus(state)
getSyncStatistics()
createDefaultSchedules()
clearSyncHistory()
```

## 🎨 UI Components

### SyncManagementScreen

**Features:**
- Просмотр всех schedules
- Добавление/удаление schedules
- Включение/выключение schedules
- Ручная синхронизация
- Статистика и история
- Pull to refresh

**Access:** Profile → Управление синхронизацией

## 🔄 Data Flow

```
App Start
  ↓
Load .rada file → Cache → Enable Schedules
  ↓
Timer checks every minute
  ↓
If schedule due → Sync data
  ↓
Update history & stats
  ↓
HybridMagentoService uses preload data when offline
```

## 📊 Status Monitoring

```dart
// Check if using .rada data
if (PreloadService.isUsingRadaData) {
  print('Using offline .rada data');
}

// Get detailed status
final status = await PreloadService.getPreloadStatus();
print('Data source: ${status['data_source']}');
print('RADA loaded: ${status['rada_file_loaded']}');

// Offline loader stats
if (PreloadService.offlineLoader != null) {
  final stats = await PreloadService.offlineLoader!.getDataStats();
  print('Total products: ${stats['total_products']}');
  print('States: ${stats['states']}');
}

// Sync statistics
final syncStats = PreloadService.getSyncStatistics();
print('Total syncs: ${syncStats['total_syncs']}');
print('Successful: ${syncStats['successful_syncs']}');
```

## 🐛 Troubleshooting

### .rada file не загружается

1. Проверьте путь: `/assets/taxlien_data.rada`
2. Проверьте `pubspec.yaml`:
   ```yaml
   flutter:
     assets:
       - assets/
   ```
3. Проверьте JSON формат
4. Run: `flutter clean && flutter pub get`

### Синхронизация не работает

1. Проверьте connectivity
2. Убедитесь что schedule enabled
3. Проверьте интервал
4. Посмотрите историю: `PreloadService.getSyncHistory()`

### Данные не обновляются

```dart
// Очистить кеш
await PreloadService.offlineLoader?.clearCache();

// Перезагрузить
await PreloadService.reloadRadaData();
```

## 📚 Full Documentation

Для подробной документации см.:
- **OFFLINE_DATA_SYNC_GUIDE.md** - Полное руководство
- **IMPLEMENTATION_SUMMARY.md** - Детали реализации
- Inline code documentation

## ✅ Best Practices

1. **Размер файла**: < 5 MB рекомендуется, < 10 MB максимум
2. **Интервалы**: Не используйте < 1 час для экономии батареи
3. **Активные штаты**: 6-12 часов
4. **Редкие штаты**: Ежедневно или еженедельно
5. **Pagination**: Используйте для больших списков
6. **Error handling**: Всегда оборачивайте в try-catch

## 🎯 Examples

### Example 1: Add Daily Sync

```dart
await PreloadService.addSyncSchedule(
  state: 'FL',
  counties: ['Polk', 'Miami-Dade'],
  interval: Duration(hours: 24),
  enabled: true,
);
```

### Example 2: Get Products with Filtering

```dart
final products = await PreloadService.getProductsByLocation(
  state: 'FL',
  county: 'Polk',
  limit: 20,
  offset: 0,
);

for (var product in products) {
  print('${product['name']}: \$${product['price']}');
}
```

### Example 3: Monitor Sync Status

```dart
final status = PreloadService.getSyncStatus('FL');

print('State: ${status['state']}');
print('Enabled: ${status['enabled']}');
print('Last sync: ${status['last_sync']}');
print('Next sync: ${status['next_sync']}');
print('Success: ${status['last_sync_success']}');
print('Items synced: ${status['last_sync_items']}');
```

### Example 4: View Sync History

```dart
final history = PreloadService.getSyncHistory();

for (var entry in history) {
  print('${entry['timestamp']}: ${entry['state']}');
  print('  Success: ${entry['success']}');
  print('  Items: ${entry['items_synced']}');
  print('  Duration: ${entry['duration_ms']}ms');
}
```

## 🚀 Production Checklist

Before deployment:

- [ ] Prepare `/assets/taxlien_data.rada` file
- [ ] Verify JSON format
- [ ] Test offline mode
- [ ] Test online mode  
- [ ] Configure sync intervals
- [ ] Test UI on different devices
- [ ] Monitor performance
- [ ] Check file size (< 10 MB)
- [ ] Enable desired schedules
- [ ] Test error scenarios

## 📞 Support

Questions? Check:
1. OFFLINE_DATA_SYNC_GUIDE.md - Full guide
2. IMPLEMENTATION_SUMMARY.md - Implementation details
3. Code comments - Inline docs
4. Email: support@taxlien.online

---

**Quick Start Complete! Ready to use! 🎉**


