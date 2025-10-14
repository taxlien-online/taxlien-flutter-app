# Onboarding Integration Guide for TaxLien.online

## Обзор

Это руководство описывает интеграцию системы управления onboarding через `flutter_adminpanel` в приложении TaxLien.online.

## Архитектура

### Компоненты

1. **flutter_adminpanel** - Основная библиотека с виджетами управления
2. **OnboardingDataProvider** - Локальное хранилище для onboarding данных
3. **OnboardingManagementScreen** - Экран управления в админ-панели
4. **OnboardingScreen** - Экран отображения onboarding пользователям

### Поток данных

```
Admin Panel → OnboardingDataProvider → SharedPreferences
                    ↓
User Onboarding Screen ← OnboardingDataProvider ← SharedPreferences
```

## Установка

### 1. Зависимости

В `pubspec.yaml` уже добавлено:

```yaml
dependencies:
  flutter_adminpanel:
    path: ../flutter_adminpanel
```

### 2. Запуск установки зависимостей

```bash
cd taxlien-app
flutter pub get
```

## Использование

### Управление через Админ-панель

1. Откройте админ-панель в приложении
2. Перейдите в раздел "Onboarding"
3. Доступные операции:
   - **Создать** - Добавить новую страницу onboarding
   - **Редактировать** - Изменить существующую страницу
   - **Удалить** - Удалить страницу
   - **Переупорядочить** - Изменить порядок страниц drag & drop
   - **Сбросить** - Вернуть настройки по умолчанию

### Структура страницы Onboarding

Каждая страница содержит:

```dart
{
  'id': '1',                                    // Уникальный ID
  'order': 0,                                   // Порядок отображения
  'title': 'Добро пожаловать',                 // Заголовок
  'subtitle': 'Платформа для инвестиций',      // Подзаголовок
  'description': 'Описание...',                // Описание
  'iconName': 'trending_up',                   // Название иконки
  'colorHex': '#2196F3',                       // Цвет в HEX
  'isActive': true,                            // Активна ли страница
  'createdAt': '2025-10-13T...',              // Дата создания
  'updatedAt': '2025-10-13T...',              // Дата обновления
}
```

### Доступные иконки

- `trending_up` - График роста
- `how_to_reg` - Регистрация
- `security` - Безопасность
- `rocket_launch` - Запуск
- `person` - Пользователь
- `shopping_cart` - Корзина
- `wallet` - Кошелёк
- `analytics` - Аналитика
- `settings` - Настройки
- `home` - Главная
- `favorite` - Избранное
- `star` - Звезда
- `info` - Информация
- `help` - Помощь
- `check_circle` - Галочка

### Доступные цвета

- `#2196F3` - Синий
- `#4CAF50` - Зелёный
- `#FF9800` - Оранжевый
- `#9C27B0` - Фиолетовый
- `#F44336` - Красный
- `#00BCD4` - Голубой
- `#FFEB3B` - Жёлтый
- `#795548` - Коричневый

## Обновление существующего OnboardingScreen

Чтобы использовать данные из админ-панели в существующем `OnboardingScreen`:

```dart
import 'package:TaxLien.online/services/onboarding_data_provider.dart';

class OnboardingScreen extends StatefulWidget {
  // ...
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final OnboardingDataProvider _dataProvider = OnboardingDataProvider();
  List<OnboardingPage> _pages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPages();
  }

  Future<void> _loadPages() async {
    try {
      final result = await _dataProvider.getList(
        sortField: 'order',
        sortOrder: 'ASC',
      );

      final pagesData = List<Map<String, dynamic>>.from(result['data'] as List)
          .where((page) => page['isActive'] == true)
          .toList();

      setState(() {
        _pages = pagesData.map((data) => OnboardingPage(
          title: data['title'] as String,
          subtitle: data['subtitle'] as String,
          description: data['description'] as String,
          icon: _getIconData(data['iconName'] as String),
          color: _getColor(data['colorHex'] as String),
        )).toList();
        _isLoading = false;
      });
    } catch (e) {
      // Fallback to default pages
      setState(() {
        _pages = _getDefaultPages();
        _isLoading = false;
      });
    }
  }

  IconData _getIconData(String iconName) {
    final iconMap = {
      'trending_up': Icons.trending_up,
      'how_to_reg': Icons.how_to_reg,
      'security': Icons.security,
      'rocket_launch': Icons.rocket_launch,
      // ... other icons
    };
    return iconMap[iconName] ?? Icons.info;
  }

  Color _getColor(String colorHex) {
    try {
      return Color(int.parse(colorHex.replaceFirst('#', '0xff')));
    } catch (e) {
      return Colors.blue;
    }
  }

  // ... rest of your widget code
}
```

## Настройки по умолчанию

Система поставляется с 4 страницами onboarding по умолчанию:

1. **Добро пожаловать в TaxLien Marketplace**
   - Платформа для инвестирования в налоговые закладные
   
2. **Как это работает**
   - Простой процесс инвестирования
   
3. **Безопасность и надежность**
   - Ваши инвестиции под защитой
   
4. **Начните инвестировать**
   - Присоединяйтесь к тысячам инвесторов

## Локализация

Для добавления переводов используйте поле `translations` в данных страницы:

```dart
{
  'title': 'Welcome to TaxLien',
  'translations': {
    'ru': 'Добро пожаловать в TaxLien',
    'es': 'Bienvenido a TaxLien',
    'de': 'Willkommen bei TaxLien',
    // ...
  }
}
```

## API

### OnboardingDataProvider

#### Методы

- `getList({int page, int perPage, String? sortField, String? sortOrder})` - Получить список страниц
- `getOne(String id)` - Получить одну страницу
- `create(Map<String, dynamic> data)` - Создать страницу
- `update(String id, Map<String, dynamic> data)` - Обновить страницу
- `delete(String id)` - Удалить страницу
- `resetToDefault()` - Сбросить к настройкам по умолчанию

## Хранение данных

Данные хранятся локально в `SharedPreferences` под ключом `onboarding_pages`.

### Очистка данных

Для сброса onboarding к настройкам по умолчанию:

```dart
final provider = OnboardingDataProvider();
await provider.resetToDefault();
```

## Навигация в админ-панели

Для доступа к управлению onboarding:

1. Главное меню → Настройки → Админ-панель
2. Боковое меню → Onboarding
3. Или прямой переход к `OnboardingManagementScreen`

## Интеграция с существующей системой

Система интегрирована с:

- ✅ **AdminPanelScreen** - Основная админ-панель
- ✅ **TaxLienAdminConfig** - Конфигурация ресурсов
- ✅ **TaxLienDataProvider** - Провайдер данных
- ✅ **OnboardingService** - Сервис управления состоянием onboarding

## Примеры

### Программное создание страницы

```dart
final provider = OnboardingDataProvider();
await provider.create({
  'order': 0,
  'title': 'Новый шаг',
  'subtitle': 'Подзаголовок',
  'description': 'Описание нового шага',
  'iconName': 'star',
  'colorHex': '#2196F3',
  'isActive': true,
});
```

### Получение активных страниц

```dart
final result = await provider.getList(sortField: 'order', sortOrder: 'ASC');
final activePages = (result['data'] as List)
    .where((page) => page['isActive'] == true)
    .toList();
```

## Тестирование

Для тестирования:

1. Откройте админ-панель
2. Перейдите в Onboarding
3. Создайте тестовую страницу
4. Проверьте отображение на экране onboarding
5. Протестируйте переупорядочение
6. Проверьте редактирование и удаление

## Поддержка

При возникновении проблем:
- Проверьте логи в консоли
- Убедитесь, что SharedPreferences инициализирован
- Проверьте, что все зависимости установлены

## Changelog

### v1.0.0 (2025-10-13)
- ✅ Начальная интеграция onboarding управления
- ✅ Поддержка CRUD операций
- ✅ Drag & drop переупорядочение
- ✅ Локальное хранилище через SharedPreferences
- ✅ Интеграция с flutter_adminpanel


