# Yuku Marketplace Integration

## Обзор

Интеграция с Yuku Marketplace позволяет пользователям покупать и продавать NFT закладные на блокчейне Internet Computer (ICP). Это расширяет функциональность приложения, предоставляя доступ к глобальному рынку NFT.

## Архитектура

### Сервисы

#### YukuService
Основной сервис для работы с Yuku Marketplace:

- **YukuListing** - модель для листингов NFT
- **YukuOffer** - модель для предложений покупки
- **Методы API**:
  - `createListing()` - создание листинга
  - `buyNFT()` - покупка NFT
  - `makeOffer()` - создание предложения
  - `acceptOffer()` / `rejectOffer()` - управление предложениями
  - `cancelListing()` - отмена листинга

### Экраны

#### YukuMarketplaceScreen
Основной экран маркетплейса с табами:
- **Browse** - просмотр активных листингов
- **My Listings** - управление своими листингами
- **My Offers** - просмотр своих предложений
- **Received** - входящие предложения

#### YukuIntegrationDemoScreen
Демонстрационный экран с возможностями интеграции

## Функциональность

### Покупка NFT
1. Просмотр доступных листингов
2. Выбор NFT для покупки
3. Подтверждение транзакции
4. Передача NFT в кошелек

### Продажа NFT
1. Создание листинга с ценой
2. Установка срока действия
3. Управление листингом
4. Получение предложений

### Предложения
1. Создание предложения на покупку
2. Установка цены и срока
3. Принятие/отклонение предложений
4. Отмена предложений

## Технические детали

### Поддерживаемые валюты
- **ICP** - Internet Computer Protocol
- **WICP** - Wrapped ICP
- **USD** - Доллар США

### Блокчейн
- **Internet Computer (ICP)**
- **NFT Standard**: ICRC-7
- **Безопасность**: Multi-signature кошельки

### API Endpoints
```dart
// Основные URL
static const String _yukuApiUrl = 'https://yuku.app/api';
static const String _yukuMarketplaceUrl = 'https://yuku.app/marketplace';
```

## Интеграция в приложение

### Добавление в навигацию
```dart
// В ProfileScreen добавлена кнопка
_buildActionTile(
  icon: Icons.store,
  title: 'Yuku Marketplace',
  subtitle: 'Buy and sell NFT tax liens',
  onTap: () => _showYukuMarketplace(context),
),
```

### Инициализация сервиса
```dart
// В main.dart
final yukuService = YukuService();
await yukuService.initialize();
```

## Использование

### Создание листинга
```dart
final success = await yukuService.createListing(
  nftId: 'nft_123',
  price: 1000.0,
  currency: 'ICP',
  expirationDays: 30,
);
```

### Покупка NFT
```dart
final success = await yukuService.buyNFT('listing_456');
```

### Создание предложения
```dart
final success = await yukuService.makeOffer(
  nftId: 'nft_123',
  amount: 950.0,
  currency: 'ICP',
  expirationDays: 7,
);
```

## Преимущества интеграции

### Для пользователей
- **Глобальный доступ** к рынку NFT закладных
- **Ликвидность** - возможность быстро продать активы
- **Прозрачность** - все транзакции в блокчейне
- **Безопасность** - децентрализованная торговля

### Для платформы
- **Расширение аудитории** - доступ к пользователям Yuku
- **Дополнительный доход** - комиссии с транзакций
- **Инновационность** - первая интеграция NFT закладных с ICP

## Будущие улучшения

### Планируемые функции
1. **Аукционы** - проведение аукционов NFT
2. **Коллекции** - группировка связанных NFT
3. **Аналитика** - статистика торговли
4. **Уведомления** - push-уведомления о событиях
5. **Мобильный кошелек** - интеграция с Plug Wallet

### Технические улучшения
1. **Real-time обновления** - WebSocket соединения
2. **Кэширование** - оптимизация производительности
3. **Офлайн режим** - работа без интернета
4. **Многоязычность** - поддержка разных языков

## Безопасность

### Меры безопасности
- **Валидация транзакций** - проверка всех операций
- **Ограничения** - лимиты на транзакции
- **Мониторинг** - отслеживание подозрительной активности
- **Резервное копирование** - защита данных

### Рекомендации
- Всегда проверяйте детали транзакции
- Используйте надежные кошельки
- Не делитесь приватными ключами
- Регулярно обновляйте приложение

## Поддержка

### Документация
- [Yuku API Documentation](https://yuku.app/docs)
- [Internet Computer Documentation](https://internetcomputer.org/docs)
- [ICRC-7 Standard](https://github.com/dfinity/ICRC)

### Контакты
- **Yuku Support**: support@yuku.app
- **TaxLien Support**: support@taxlien.online

## Лицензия

Интеграция распространяется под лицензией MIT. См. файл LICENSE для подробностей.
