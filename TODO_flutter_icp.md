# TODO: Дополнительные портирования для flutter_icp

## Что нужно портировать из основного проекта в flutter_icp

### 1. Сервисы (Services)
- [ ] **PlugWalletService** - Полностью портирован ✅
- [ ] **YukuService** - Полностью портирован ✅
- [ ] **NFTService** - Нужно портировать оставшиеся методы

#### NFTService - Методы для портирования:
```dart
// lib/services/nft_service.dart
- loadMyNFTs() - Загрузить NFT пользователя
- loadMarketplaceNFTs() - Загрузить NFT с маркетплейса  
- mintNFTFromLien(lien) - Создать NFT из налогового залога
- transferNFT(nftId, toAddress) - Передать NFT
- burnNFT(nftId) - Сжечь NFT
- searchNFTs(query) - Поиск NFT
```

### 2. Модели данных (Models)
- [ ] **TaxLienNFT** - Специфичная модель NFT для налоговых залогов
- [ ] **TaxLienMetadata** - Метаданные для NFT налоговых залогов

#### TaxLienNFT модель:
```dart
class TaxLienNFT extends NFT {
  final String propertyAddress;
  final double lienAmount;
  final double interestRate;
  final String redemptionPeriod;
  final DateTime lienDate;
  final String county;
  final String state;
  final Map<String, dynamic> propertyDetails;
  
  // Конструкторы, fromJson, toJson, copyWith
}
```

### 3. Виджеты (Widgets)
- [ ] **NFTCard** - Карточка для отображения NFT
- [ ] **NFTDetailDialog** - Диалог с деталями NFT
- [ ] **MintNFTDialog** - Диалог для создания NFT
- [ ] **NFTTransactionDialog** - Диалог для операций с NFT

#### NFTCard виджет:
```dart
class NFTCard extends StatelessWidget {
  final NFT nft;
  final VoidCallback? onTap;
  final VoidCallback? onTransfer;
  final VoidCallback? onBurn;
  
  // UI для отображения NFT с кнопками действий
}
```

### 4. Утилиты (Utils)
- [ ] **NFTUtils** - Утилиты для работы с NFT (частично портированы)
- [ ] **ICPUtils** - Утилиты для работы с ICP
- [ ] **ValidationUtils** - Валидация адресов, сумм и т.д.

#### Дополнительные утилиты:
```dart
class ICPUtils {
  static String formatICPAmount(double amount);
  static String formatPrincipal(String principal);
  static bool isValidCanisterId(String canisterId);
  static String generateTransactionId();
}
```

### 5. Конфигурация (Configuration)
- [ ] **ICPNetworkConfig** - Конфигурация сетей ICP
- [ ] **CanisterConfig** - Конфигурация канстеров
- [ ] **WalletConfig** - Конфигурация кошельков

#### Конфигурация сетей:
```dart
class ICPNetworkConfig {
  final String name;
  final String url;
  final bool isTestnet;
  final Map<String, String> canisterIds;
  final Map<String, dynamic> additionalParams;
}
```

### 6. Обработка ошибок (Error Handling)
- [ ] **ICPSpecificExceptions** - Специфичные исключения ICP
- [ ] **TransactionExceptions** - Исключения транзакций
- [ ] **NetworkExceptions** - Исключения сети

#### Дополнительные исключения:
```dart
class ICPTransactionTimeoutException extends ICPException;
class ICPInsufficientCyclesException extends ICPException;
class ICPCanisterFullException extends ICPException;
class ICPMemoryException extends ICPException;
```

### 7. Тестирование (Testing)
- [ ] **Unit Tests** - Модульные тесты для всех сервисов
- [ ] **Integration Tests** - Интеграционные тесты
- [ ] **Mock Services** - Моки для тестирования

#### Тесты для создания:
```dart
// test/unit/services/plug_wallet_service_test.dart
// test/unit/services/yuku_service_test.dart  
// test/unit/services/nft_service_test.dart
// test/integration/icp_integration_test.dart
// test/mocks/mock_icp_client.dart
```

### 8. Документация (Documentation)
- [ ] **API Documentation** - Документация API
- [ ] **Usage Examples** - Примеры использования
- [ ] **Migration Guide** - Руководство по миграции

### 9. Оптимизация (Optimization)
- [ ] **Caching** - Кэширование данных
- [ ] **Batch Operations** - Пакетные операции
- [ ] **Connection Pooling** - Пулы соединений

### 10. Безопасность (Security)
- [ ] **Secure Storage** - Безопасное хранение ключей
- [ ] **Transaction Signing** - Подписание транзакций
- [ ] **Input Validation** - Валидация входных данных

## Приоритеты

### Высокий приоритет:
1. TaxLienNFT модель и TaxLienMetadata
2. Оставшиеся методы NFTService
3. NFTCard и NFTDetailDialog виджеты
4. ICPUtils утилиты

### Средний приоритет:
5. Конфигурация сетей и канстеров
6. Дополнительные исключения
7. Unit тесты для основных сервисов

### Низкий приоритет:
8. Интеграционные тесты
9. Документация
10. Оптимизация и безопасность

## Заметки

- Все портированные сервисы должны использовать новую архитектуру с провайдерами
- Модели должны наследоваться от базовых классов flutter_nft
- Виджеты должны быть переиспользуемыми и настраиваемыми
- Тесты должны покрывать как успешные, так и ошибочные сценарии
- Документация должна включать примеры кода и лучшие практики
