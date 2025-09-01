# 🏪 TaxLien.online Native Marketplace

## Overview

Современная нативная реализация маркетплейса налоговых закладных с полной интеграцией Magento API, современным дизайном Material Design 3 и расширенной функциональностью для торговли налоговыми закладными.

## 🚀 Новые возможности

### 1. Современный UI/UX
- **Material Design 3**: Современный дизайн с поддержкой тем
- **Enhanced Product Cards**: Расширенные карточки продуктов с специфичными для налоговых закладных данными
- **Grid Layout**: Адаптивная сетка продуктов с оптимизированным отображением
- **Quick View**: Быстрый просмотр продуктов без перехода на детальную страницу
- **Pull-to-Refresh**: Обновление данных жестом
- **Infinite Scroll**: Автоматическая подгрузка при прокрутке

### 2. Magento API Integration
- **REST API**: Полная интеграция с Magento REST API
- **Аутентификация**: Безопасная авторизация через токены
- **Управление корзиной**: Добавление, удаление, обновление товаров
- **Wishlist**: Список избранного с синхронизацией
- **Заказы**: Просмотр истории заказов
- **Категории**: Иерархическое отображение категорий

### 3. Расширенный поиск и фильтрация
- **Smart Search Bar**: Умная поисковая строка с автодополнением
- **Category Filters**: Фильтрация по категориям с chip-интерфейсом
- **Quick Filters**: Быстрые фильтры для популярных запросов
- **Advanced Filters**: Расширенные фильтры по налоговым параметрам:
  - Сумма налога
  - Процентная ставка
  - Локация недвижимости
  - Дата аукциона
  - Период выкупа
- **Sort Options**: Сортировка по различным параметрам

### 4. Специфичные для налоговых закладных функции
- **Tax Lien Details**: Детальная информация о налоговых закладных
- **Interest Rate Display**: Отображение процентных ставок
- **Property Information**: Информация о недвижимости
- **Auction Dates**: Даты аукционов и сроки
- **Risk Assessment**: Отображение оценки рисков
- **Investment Recommendations**: Рекомендации по инвестициям

### 5. Performance и UX улучшения
- **Lazy Loading**: Ленивая загрузка изображений
- **Caching**: Кэширование данных для быстрого доступа
- **Error Handling**: Улучшенная обработка ошибок
- **Loading States**: Правильные состояния загрузки
- **Offline Support**: Базовая поддержка офлайн режима

## 📱 UI Компоненты

### EnhancedProductCard
Расширенная карточка продукта с:
- Изображением продукта с плейсхолдером
- Статусом доступности
- Специфичными атрибутами налоговых закладных
- Кнопками быстрых действий
- Анимациями и переходами

### SearchFilterBar
Умная поисковая панель с:
- Анимированным полем поиска
- Кнопками фильтрации и сортировки
- Индикатором активных фильтров
- Кнопкой очистки фильтров

### CategoryChipList
Список категорий с:
- Горизонтальной прокруткой
- Выбором категорий
- Счетчиком товаров
- Иерархическим отображением

### QuickFilterChips
Быстрые фильтры с:
- Иконками и лейблами
- Счетчиком товаров
- Состоянием выбора
- Настраиваемыми фильтрами

## 🔧 Техническая реализация

### State Management
- **Riverpod**: Современное управление состоянием
- **Provider Pattern**: Разделение логики и UI
- **State Persistence**: Сохранение состояния между сессиями

### Navigation
- **GoRouter**: Декларативная навигация
- **Deep Linking**: Поддержка глубоких ссылок
- **Route Guards**: Защищенные маршруты

### API Layer
- **Dio HTTP Client**: Расширенный HTTP клиент с интерцепторами
- **Error Handling**: Централизованная обработка ошибок
- **Response Caching**: Кэширование ответов API
- **Request Interceptors**: Автоматическое добавление заголовков

### Data Models
```dart
// Magento Product Model
class MagentoProduct {
  final String sku;
  final String name;
  final double price;
  final double? specialPrice;
  final int status;
  final List<MagentoCustomAttribute>? customAttributes;
  final List<MagentoMediaGalleryEntry>? mediaGalleryEntries;
}

// Tax Lien Specific Attributes
- tax_amount: Сумма налога
- interest_rate: Процентная ставка
- property_location: Локация недвижимости
- auction_date: Дата аукциона
- redemption_period: Период выкупа
- risk_assessment: Оценка рисков
```

## 🎨 Design System

### Colors
- **Primary**: Deep Blue (#1E3A8A) - Доверие и стабильность
- **Secondary**: Gold (#F59E0B) - Богатство и процветание
- **Success**: Green (#10B981) - Рост и успех
- **Warning**: Orange (#F97316) - Осторожность
- **Error**: Red (#EF4444) - Опасность

### Typography
- **Font Family**: Inter
- **Weights**: Regular (400), Medium (500), SemiBold (600), Bold (700)

### Spacing
- **Base Unit**: 4px
- **Scale**: xs(4), sm(8), md(16), lg(24), xl(32), xxl(48), xxxl(64)

## 🚀 Запуск приложения

### Быстрый запуск
```bash
./launch_marketplace.sh run
```

### Доступные команды
```bash
# Запуск в debug режиме
./launch_marketplace.sh run

# Запуск в release режиме
./launch_marketplace.sh release

# Сборка APK
./launch_marketplace.sh build-apk

# Сборка iOS
./launch_marketplace.sh build-ios

# Настройка зависимостей
./launch_marketplace.sh setup

# Проверка Flutter
./launch_marketplace.sh doctor

# Показать возможности
./launch_marketplace.sh features
```

## 📊 Производительность

### Оптимизации
- **Image Optimization**: Оптимизация изображений с кэшированием
- **List Virtualization**: Виртуализация больших списков
- **Lazy Loading**: Ленивая загрузка контента
- **Memory Management**: Правильное управление памятью
- **Network Optimization**: Оптимизация сетевых запросов

### Метрики
- **App Startup Time**: < 2 секунды
- **Screen Transition**: < 300ms
- **API Response Time**: < 1 секунда
- **Image Loading**: < 500ms
- **Search Response**: < 200ms

## 🔐 Безопасность

### Реализованные меры
- **Token-based Authentication**: Аутентификация на основе токенов
- **Secure Storage**: Безопасное хранение чувствительных данных
- **HTTPS Enforcement**: Принудительное использование HTTPS
- **Input Validation**: Валидация всех пользовательских данных
- **Error Sanitization**: Очистка ошибок от чувствительной информации

## 🧪 Тестирование

### Типы тестов
- **Unit Tests**: Тестирование бизнес-логики
- **Widget Tests**: Тестирование UI компонентов
- **Integration Tests**: End-to-end тестирование
- **Performance Tests**: Тесты производительности

### Запуск тестов
```bash
# Unit и Widget тесты
flutter test

# Integration тесты
flutter test integration_test/

# Coverage отчет
flutter test --coverage
```

## 📚 Документация разработчика

### Структура проекта
```
lib/
├── core/                    # Ядро приложения
│   ├── constants/          # Константы
│   ├── models/             # Модели данных Magento
│   ├── services/           # API сервисы
│   ├── theme/              # Тема и стили
│   └── widgets/            # Переиспользуемые виджеты
├── screens/                # Экраны приложения
│   ├── marketplace_screen.dart
│   └── product_detail_screen.dart
├── widgets/                # Специфичные виджеты
│   ├── enhanced_product_card.dart
│   ├── category_chip.dart
│   └── search_filter_bar.dart
└── main.dart              # Точка входа
```

### Добавление новых функций

1. **Создание нового экрана**:
```dart
class NewScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<NewScreen> createState() => _NewScreenState();
}
```

2. **Добавление нового API endpoint**:
```dart
// В MagentoApiService
Future<NewModel?> getNewData() async {
  final response = await _dio.get('/new-endpoint');
  return NewModel.fromJson(response.data);
}
```

3. **Создание нового виджета**:
```dart
class NewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(/* implementation */);
  }
}
```

## 🔄 Миграция с WebView

Для пользователей legacy WebView приложения реализован механизм миграции:

1. **Сохранение пользовательских данных**
2. **Перенос избранного**
3. **Синхронизация истории покупок**
4. **Обновление настроек**

## 🚀 Roadmap

### Ближайшие планы
- [ ] AI-powered рекомендации продуктов
- [ ] Расширенная аналитика портфеля
- [ ] Real-time уведомления о аукционах
- [ ] Интеграция с blockchain для NFT
- [ ] Многовалютная поддержка
- [ ] Расширенные отчеты

### Долгосрочные цели
- [ ] Machine Learning для оценки рисков
- [ ] Социальные функции
- [ ] White-label решение
- [ ] Enterprise функции
- [ ] Международная экспансия

## 📞 Поддержка

- **Email**: support@taxlien.online
- **Документация**: [Confluence Wiki]
- **Issues**: [GitHub Issues]
- **Slack**: #taxlien-mobile

---

**Разработано с ❤️ командой TaxLien.online**
