# Offline Data & Scheduled Sync Guide

## Overview

TaxLien.online теперь поддерживает:
1. **Preload данных из `.rada` файлов** - автоматическая загрузка offline данных при запуске
2. **Scheduled sync по штатам и counties** - настраиваемое расписание обновления данных
3. **Seamless online/offline режим** - автоматическое переключение между online и offline данными

## Архитектура

### Компоненты

1. **OfflineDataLoaderService** (`lib/services/offline_data_loader_service.dart`)
   - Загружает данные из `/assets/taxlien_data.rada`
   - Кеширует данные в SharedPreferences
   - Предоставляет фильтрацию по штатам и counties

2. **ScheduledDataSyncService** (`lib/services/scheduled_data_sync_service.dart`)
   - Управляет расписанием синхронизации
   - Поддерживает настройку по штатам и counties
   - Ведет историю синхронизации

3. **PreloadService** (`lib/services/preload_service.dart`)
   - Центральный сервис для управления offline данными
   - Интегрируется с flutter_magento
   - Предоставляет единый API для доступа к данным

4. **HybridMagentoService** (`lib/core/services/hybrid_magento_service.dart`)
   - Автоматически переключается между online/offline
   - Использует preload данные в offline режиме
   - Синхронизирует с Magento API когда online

## Использование

### Инициализация

Preload данные автоматически загружаются при старте приложения в `main.dart`:

```dart
await PreloadService.initializePreloadData();
await PreloadService.createDefaultSyncSchedules();
```

### Формат .rada файла

Файл `/assets/taxlien_data.rada` должен быть в JSON формате:

```json
{
  "products": [
    {
      "sku": "FL-POLK-001",
      "name": "Tax Lien Certificate - Polk County, FL",
      "price": 2500.00,
      "custom_attributes": [
        {
          "attribute_code": "state",
          "value": "FL"
        },
        {
          "attribute_code": "county",
          "value": "Polk"
        }
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
        {
          "attribute_code": "state_code",
          "value": "FL"
        }
      ]
    }
  ]
}
```

### API для работы с данными

#### Получение продуктов по локации

```dart
// Получить все продукты для штата
final products = await PreloadService.getProductsByLocation(
  state: 'FL',
);

// Получить продукты для county
final countyProducts = await PreloadService.getProductsByLocation(
  state: 'FL',
  county: 'Polk',
  limit: 20,
  offset: 0,
);
```

#### Получение списка штатов и counties

```dart
// Получить все доступные штаты
final states = await PreloadService.getAvailableStates();

// Получить counties для штата
final counties = await PreloadService.getCountiesForState('FL');
```

### Управление расписанием синхронизации

#### Добавить schedule

```dart
await PreloadService.addSyncSchedule(
  state: 'FL',
  counties: ['Polk', 'Miami-Dade'], // опционально
  interval: Duration(hours: 24), // ежедневно
  enabled: true,
);
```

#### Изменить schedule

```dart
// Включить/выключить
await PreloadService.toggleSyncSchedule('FL', true);

// Удалить
await PreloadService.removeSyncSchedule('FL');
```

#### Ручная синхронизация

```dart
// Синхронизировать конкретный штат
await PreloadService.syncStateNow('FL');

// Синхронизировать все активные schedules
await PreloadService.syncAllStates();
```

#### Получить статус синхронизации

```dart
// Статус для штата
final status = PreloadService.getSyncStatus('FL');
print('Last sync: ${status['last_sync']}');
print('Next sync: ${status['next_sync']}');

// Общая статистика
final stats = PreloadService.getSyncStatistics();
print('Total syncs: ${stats['total_syncs']}');
print('Successful: ${stats['successful_syncs']}');
```

#### История синхронизации

```dart
final history = PreloadService.getSyncHistory();
for (var entry in history) {
  print('${entry['timestamp']}: ${entry['state']} - ${entry['success']}');
}
```

## UI Компоненты

### Sync Management Screen

Экран управления синхронизацией доступен из профиля пользователя:
- Просмотр всех schedules
- Добавление/удаление schedules
- Включение/отключение schedules
- Ручная синхронизация
- Просмотр статистики

Навигация: **Профиль → Управление синхронизацией**

## Работа с offline/online режимом

### Автоматическое переключение

`HybridMagentoService` автоматически определяет connectivity:

```dart
// При offline - использует preload данные
if (!isOnline) {
  return PreloadService.getCombinedProducts(
    state: state,
    county: county,
  );
}

// При online - загружает из Magento API
return magentoService.getProducts();
```

### Проверка источника данных

```dart
// Проверить используются ли .rada данные
final usingRada = PreloadService.isUsingRadaData;

// Получить информацию об источнике
final dataSource = await PreloadService.getDataSourceInfo();
print('Primary source: ${dataSource['primary_source']}');
print('RADA loaded: ${dataSource['rada_loaded']}');
```

## Конфигурация Sync Schedules

### SyncScheduleConfig

```dart
final schedule = SyncScheduleConfig(
  state: 'FL',                        // Штат (обязательно)
  counties: ['Polk', 'Miami-Dade'],   // Counties (опционально)
  interval: Duration(hours: 24),      // Интервал синхронизации
  enabled: true,                      // Включен/выключен
);
```

### Интервалы синхронизации

- **Hourly**: `Duration(hours: 1)`
- **Every 6 hours**: `Duration(hours: 6)`
- **Every 12 hours**: `Duration(hours: 12)`
- **Daily**: `Duration(hours: 24)`
- **Weekly**: `Duration(days: 7)`

## Кеширование

### Автоматическое кеширование

Все загруженные данные автоматически кешируются:
- Products - в SharedPreferences
- Categories - в SharedPreferences
- .rada данные - в SharedPreferences

### Очистка кеша

```dart
// Очистить offline cache
await PreloadService.offlineLoader?.clearCache();

// Перезагрузить из .rada файла
await PreloadService.reloadRadaData();

// Очистить историю синхронизации
await PreloadService.clearSyncHistory();
```

## Best Practices

### 1. Размещение .rada файла

```
/assets/
  taxlien_data.rada  <- Здесь
```

Убедитесь что файл указан в `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/
```

### 2. Размер файла

- Рекомендуется: < 5 MB
- Максимум: < 10 MB
- Для больших данных используйте сжатие

### 3. Периодичность синхронизации

- **Активные штаты**: каждые 6-12 часов
- **Редко используемые**: ежедневно или еженедельно
- **Не используйте интервал < 1 час** для экономии батареи и трафика

### 4. Обработка ошибок

```dart
try {
  final success = await PreloadService.syncStateNow('FL');
  if (!success) {
    // Обработать ошибку синхронизации
  }
} catch (e) {
  // Обработать exception
  print('Sync error: $e');
}
```

## Debugging

### Проверка статуса preload

```dart
final status = await PreloadService.getPreloadStatus();
print('Data source: ${status['data_source']}');
print('RADA loaded: ${status['rada_file_loaded']}');
print('Version: ${status['current_version']}');

if (status['offline_loader'] != null) {
  print('Total products: ${status['offline_loader']['total_products']}');
  print('States: ${status['offline_loader']['states']}');
}
```

### Логи

В debug режиме все операции логируются:
- Загрузка .rada файла
- Инициализация sync service
- Выполнение синхронизации
- Ошибки

## Troubleshooting

### .rada файл не загружается

1. Проверьте путь: `/assets/taxlien_data.rada`
2. Проверьте `pubspec.yaml` - assets должны быть указаны
3. Проверьте формат JSON
4. Запустите `flutter clean && flutter pub get`

### Синхронизация не работает

1. Проверьте connectivity
2. Проверьте что schedule enabled
3. Проверьте интервал синхронизации
4. Посмотрите историю: `PreloadService.getSyncHistory()`

### Данные не обновляются

1. Очистите кеш: `clearCache()`
2. Перезагрузите данные: `reloadRadaData()`
3. Проверьте версию: версия в `_currentVersion` должна измениться при обновлении

## Performance

### Оптимизация

1. **Pagination**: Используйте limit/offset для больших списков
2. **Filtering**: Фильтруйте на уровне service, не в UI
3. **Caching**: Полагайтесь на автоматическое кеширование
4. **Lazy Loading**: Загружайте counties только при необходимости

### Рекомендации по памяти

- .rada файл загружается в память полностью
- Используйте pagination для отображения
- Очищайте кеш периодически для старых устройств

## Future Enhancements

Планируемые улучшения:

1. **Compression support** - сжатие .rada файлов (gzip)
2. **Incremental sync** - загрузка только изменений
3. **Background sync** - фоновая синхронизация (WorkManager)
4. **Partial loading** - загрузка только нужных штатов
5. **Cloud backup** - резервное копирование schedules

## API Reference

### PreloadService

- `initializePreloadData()` - Инициализация preload
- `getCombinedProducts({state, county})` - Получить продукты
- `getAvailableStates()` - Список штатов
- `getCountiesForState(state)` - Counties для штата
- `addSyncSchedule({...})` - Добавить schedule
- `syncStateNow(state)` - Синхронизировать сейчас
- `getSyncStatus(state)` - Статус синхронизации
- `getSyncHistory()` - История
- `getPreloadStatus()` - Общий статус

### OfflineDataLoaderService

- `initialize()` - Инициализация
- `loadFromRadaFile()` - Загрузить .rada файл
- `getProducts({state, county, limit, offset})` - Получить продукты
- `getCategories()` - Получить категории
- `getDataStats()` - Статистика данных
- `clearCache()` - Очистить кеш
- `reload()` - Перезагрузить

### ScheduledDataSyncService

- `initialize()` - Инициализация
- `addSchedule(config)` - Добавить schedule
- `removeSchedule(state)` - Удалить schedule
- `toggleSchedule(state, enabled)` - Включить/выключить
- `syncStateData(schedule)` - Синхронизировать
- `syncAllNow()` - Синхронизировать все
- `getSyncStatus(state)` - Статус
- `getSyncStatistics()` - Статистика

## Contributing

При добавлении новых features:

1. Обновите documentation
2. Добавьте unit tests
3. Обновите UI если нужно
4. Проверьте backward compatibility

## License

See LICENSE file in project root.

## Support

Для вопросов и поддержки:
- GitHub Issues
- Email: support@taxlien.online

