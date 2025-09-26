# TaxLien.online Demo Data

Этот каталог содержит демо данные для приложения TaxLien.online, совместимые с flutter_magento 3.2.0.

## Структура файлов

### `demo_data.dart`
Основной файл с демо данными, включающий:
- **Продукты**: Tax lien сертификаты с полными атрибутами
- **Категории**: Иерархическая структура штатов
- **Клиенты**: Демо пользователи-инвесторы
- **Заказы**: Примеры транзакций
- **Корзина**: Демо корзина покупок
- **Магазин**: Конфигурация магазина

### `categories_demo_data.dart`
Расширенные данные категорий:
- **Все штаты США** с программами tax lien
- **Иерархическая структура** категорий
- **Атрибуты штатов** (коды, описания)
- **Методы поиска** и фильтрации

### `counties_demo_data.dart`
Данные округов:
- **Полный список округов** для каждого штата
- **Демографические данные** (население, площадь)
- **Методы фильтрации** по различным критериям
- **Статистические данные** по штатам

## Использование

### Инициализация

```dart
import '../data/demo_data.dart';
import '../data/categories_demo_data.dart';
import '../data/counties_demo_data.dart';

// Получение продуктов
final products = TaxLienDemoData.demoProducts;

// Получение категорий
final categories = TaxLienCategoriesDemoData.allCategories;

// Получение округов по штату
final counties = TaxLienCountiesDemoData.getCountiesByState('FL');
```

### Сервисы

#### `DemoDataService`
Основной сервис для работы с демо данными:

```dart
import '../services/demo_data_service.dart';

final demoService = DemoDataService();
await demoService.initialize();

// Получение продуктов
final products = demoService.getDemoProducts();

// Поиск по штату
final floridaProducts = demoService.getTaxLienProductsByState('FL');

// Поиск по округу
final columbiaProducts = demoService.getTaxLienProductsByCounty('Columbia');
```

#### `SimplifiedDemoIntegration`
Упрощенная интеграция для быстрого старта:

```dart
import '../services/simplified_demo_integration.dart';

final integration = SimplifiedDemoIntegration();
await integration.initialize();

// Получение продуктов с фильтрацией
final products = integration.getProducts(
  page: 1,
  pageSize: 20,
  searchQuery: 'Florida',
  minPrice: 1000.0,
  maxPrice: 5000.0,
);
```

## Структура данных

### Продукты (Tax Liens)

Каждый продукт содержит:
- **Основные поля**: id, sku, name, price, status
- **Кастомные атрибуты**:
  - `parcel_id`: ID участка
  - `property_address`: Адрес недвижимости
  - `county`: Округ
  - `state`: Штат
  - `owner_name`: Имя владельца
  - `assessed_value`: Оценочная стоимость
  - `tax_amount`: Сумма налога
  - `interest_rate`: Процентная ставка
  - `auction_date`: Дата аукциона
  - `redemption_deadline`: Срок выкупа
  - `lien_status`: Статус залога

### Категории

Иерархическая структура:
```
Tax Liens (root)
├── Florida
├── Texas
├── California
├── New York
├── Arizona
├── Georgia
└── ... (все штаты с tax lien программами)
```

### Клиенты

Демо клиенты включают:
- **Профили инвесторов** с различным опытом
- **Предпочтения** по штатам и округам
- **Лимиты инвестиций**
- **Типы инвесторов** (частные, профессиональные)

## Фильтрация и поиск

### Поиск продуктов

```dart
// Поиск по названию, SKU или описанию
final results = integration.searchProducts('Columbia County');

// Фильтрация по цене
final affordableLiens = integration.getProducts(
  minPrice: 1000.0,
  maxPrice: 2000.0,
);

// Фильтрация по штату
final floridaLiens = integration.getTaxLiensByState('FL');
```

### Работа с округами

```dart
// Получение всех округов штата
final counties = integration.getCountiesByState('FL');

// Поиск округа по имени
final county = integration.getCountyByName('FL', 'Columbia');

// Фильтрация по населению
final largeCounties = integration.getCountiesByPopulationRange(
  'FL', 
  100000, 
  1000000,
);
```

## Интеграция с flutter_magento

Демо данные полностью совместимы с flutter_magento 3.2.0 и могут использоваться как:

1. **Замена реального API** для разработки и тестирования
2. **Fallback данные** при отсутствии интернета
3. **Демонстрационные данные** для презентаций
4. **Тестовые данные** для unit и integration тестов

### Переключение между демо и реальными данными

```dart
// Включение демо режима
integration.toggleDemoMode(true);

// Отключение демо режима
integration.toggleDemoMode(false);
```

## Расширение данных

### Добавление новых штатов

1. Обновите `categories_demo_data.dart`
2. Добавьте штат в `statesWithTaxLiens`
3. Обновите `getStateNameByCode`

### Добавление новых округов

1. Обновите `counties_demo_data.dart`
2. Добавьте округа в соответствующий штат
3. Обновите статистические методы

### Добавление новых продуктов

1. Обновите `demo_data.dart`
2. Добавьте продукт в массив `products`
3. Убедитесь в корректности всех атрибутов

## Производительность

- **Быстрая инициализация**: Данные загружаются из JSON
- **Эффективный поиск**: Оптимизированные алгоритмы фильтрации
- **Минимальная память**: Данные не кэшируются в памяти
- **Масштабируемость**: Легко добавлять новые данные

## Безопасность

- **Нет реальных данных**: Все данные являются демонстрационными
- **Валидация**: Все входные параметры проверяются
- **Изоляция**: Демо данные не влияют на продакшн

## Поддержка

Для вопросов и предложений по демо данным обращайтесь к команде разработки TaxLien.online.
