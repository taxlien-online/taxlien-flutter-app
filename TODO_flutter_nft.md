# TODO: Дополнительные портирования для flutter_nft

## Что нужно портировать из основного проекта в flutter_nft

### 1. Дополнительные модели (Models)
- [ ] **TaxLienSpecificNFT** - Специфичная модель для налоговых залогов
- [ ] **PropertyNFT** - Модель для NFT недвижимости
- [ ] **InvestmentNFT** - Модель для инвестиционных NFT

#### TaxLienSpecificNFT:
```dart
class TaxLienSpecificNFT extends NFT {
  final String propertyAddress;
  final double lienAmount;
  final double interestRate;
  final String redemptionPeriod;
  final DateTime lienDate;
  final String county;
  final String state;
  final Map<String, dynamic> propertyDetails;
  final List<String> legalDocuments;
  final Map<String, dynamic> auctionInfo;
  
  // Конструкторы, fromJson, toJson, copyWith
}
```

### 2. Дополнительные интерфейсы провайдеров (Provider Interfaces)
- [ ] **PropertyNFTProvider** - Провайдер для NFT недвижимости
- [ ] **InvestmentNFTProvider** - Провайдер для инвестиционных NFT
- [ ] **LegalDocumentProvider** - Провайдер для юридических документов

#### PropertyNFTProvider:
```dart
abstract class PropertyNFTProvider implements NFTProvider {
  Future<List<NFT>> getNFTsByPropertyAddress(String address);
  Future<List<NFT>> getNFTsByCounty(String county);
  Future<List<NFT>> getNFTsByState(String state);
  Future<Map<String, dynamic>> getPropertyDetails(String nftId);
  Future<List<String>> getLegalDocuments(String nftId);
}
```

### 3. Дополнительные типы транзакций (Transaction Types)
- [ ] **PropertyTransactionType** - Типы транзакций для недвижимости
- [ ] **LegalDocumentTransactionType** - Типы транзакций для документов
- [ ] **AuctionTransactionType** - Типы транзакций для аукционов

#### Дополнительные типы:
```dart
enum PropertyTransactionType {
  PropertyTransfer,
  LienPlacement,
  LienRelease,
  AuctionBid,
  AuctionWin,
  PropertySale,
  LegalDocumentUpdate,
}
```

### 4. Дополнительные утилиты (Utils)
- [ ] **PropertyUtils** - Утилиты для работы с недвижимостью
- [ ] **LegalUtils** - Утилиты для работы с юридическими документами
- [ ] **AuctionUtils** - Утилиты для работы с аукционами

#### PropertyUtils:
```dart
class PropertyUtils {
  static String formatPropertyAddress(String address);
  static bool isValidPropertyAddress(String address);
  static Map<String, String> parseAddressComponents(String address);
  static double calculatePropertyValue(Map<String, dynamic> details);
  static String generatePropertyId(String address, String county);
}
```

### 5. Дополнительные исключения (Exceptions)
- [ ] **PropertyNFTException** - Исключения для NFT недвижимости
- [ ] **LegalDocumentException** - Исключения для юридических документов
- [ ] **AuctionException** - Исключения для аукционов

#### PropertyNFTException:
```dart
class PropertyNFTException extends NFTException {
  const PropertyNFTException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);
}

class InvalidPropertyAddressException extends PropertyNFTException;
class PropertyNotFoundInDatabaseException extends PropertyNFTException;
class InsufficientPropertyOwnershipException extends PropertyNFTException;
```

### 6. Дополнительные провайдеры маркетплейса (Marketplace Providers)
- [ ] **PropertyMarketplaceProvider** - Маркетплейс для недвижимости
- [ ] **AuctionMarketplaceProvider** - Маркетплейс для аукционов
- [ ] **LegalDocumentMarketplaceProvider** - Маркетплейс для документов

#### PropertyMarketplaceProvider:
```dart
abstract class PropertyMarketplaceProvider implements MarketplaceProvider {
  Future<List<NFTListing>> getPropertyListings({
    String? county,
    String? state,
    double? minPrice,
    double? maxPrice,
    String? propertyType,
  });
  Future<List<NFTListing>> getLienListings({
    String? county,
    double? minLienAmount,
    double? maxLienAmount,
  });
  Future<String> createAuction({
    required String nftId,
    required double startingBid,
    required DateTime auctionStart,
    required DateTime auctionEnd,
  });
}
```

### 7. Дополнительные типы сетей (Network Types)
- [ ] **PropertyBlockchainNetwork** - Сети для недвижимости
- [ ] **LegalBlockchainNetwork** - Сети для юридических документов
- [ ] **GovernmentBlockchainNetwork** - Государственные сети

#### Дополнительные сети:
```dart
enum PropertyBlockchainNetwork {
  ethereum,
  polygon,
  binanceSmartChain,
  icp,
  custom,
}

enum LegalDocumentNetwork {
  ethereum,
  hyperledger,
  corda,
  custom,
}
```

### 8. Дополнительные конфигурации (Configurations)
- [ ] **PropertyNFTConfig** - Конфигурация для NFT недвижимости
- [ ] **LegalDocumentConfig** - Конфигурация для юридических документов
- [ ] **AuctionConfig** - Конфигурация для аукционов

#### PropertyNFTConfig:
```dart
class PropertyNFTConfig {
  final String contractAddress;
  final String metadataUri;
  final String imageBaseUrl;
  final Map<String, String> countyMappings;
  final Map<String, String> stateMappings;
  final Duration cacheExpiration;
  final int maxRetries;
}
```

### 9. Дополнительные валидаторы (Validators)
- [ ] **PropertyValidator** - Валидация недвижимости
- [ ] **LegalDocumentValidator** - Валидация юридических документов
- [ ] **AuctionValidator** - Валидация аукционов

#### PropertyValidator:
```dart
class PropertyValidator {
  static bool isValidPropertyAddress(String address);
  static bool isValidLienAmount(double amount);
  static bool isValidInterestRate(double rate);
  static bool isValidRedemptionPeriod(String period);
  static bool isValidCounty(String county);
  static bool isValidState(String state);
}
```

### 10. Дополнительные тесты (Testing)
- [ ] **PropertyNFTTests** - Тесты для NFT недвижимости
- [ ] **LegalDocumentTests** - Тесты для юридических документов
- [ ] **AuctionTests** - Тесты для аукционов

#### Тесты для создания:
```dart
// test/unit/models/tax_lien_nft_test.dart
// test/unit/providers/property_nft_provider_test.dart
// test/unit/utils/property_utils_test.dart
// test/integration/property_nft_integration_test.dart
// test/mocks/mock_property_nft_provider.dart
```

### 11. Дополнительная документация (Documentation)
- [ ] **PropertyNFTGuide** - Руководство по NFT недвижимости
- [ ] **LegalDocumentGuide** - Руководство по юридическим документам
- [ ] **AuctionGuide** - Руководство по аукционам

### 12. Дополнительные примеры (Examples)
- [ ] **PropertyNFTExample** - Пример использования NFT недвижимости
- [ ] **AuctionExample** - Пример использования аукционов
- [ ] **LegalDocumentExample** - Пример использования юридических документов

## Приоритеты

### Высокий приоритет:
1. TaxLienSpecificNFT модель
2. PropertyNFTProvider интерфейс
3. PropertyUtils утилиты
4. PropertyValidator валидаторы

### Средний приоритет:
5. PropertyMarketplaceProvider
6. Дополнительные типы транзакций
7. PropertyNFTConfig конфигурация
8. Unit тесты для основных компонентов

### Низкий приоритет:
9. LegalDocumentProvider и AuctionMarketplaceProvider
10. Дополнительные типы сетей
11. Интеграционные тесты
12. Документация и примеры

## Заметки

- Все новые модели должны наследоваться от базового класса NFT
- Новые провайдеры должны реализовывать соответствующие интерфейсы
- Валидаторы должны быть строгими и проверять все возможные ошибки
- Тесты должны покрывать как положительные, так и отрицательные сценарии
- Документация должна включать примеры использования и лучшие практики
- Примеры должны быть готовыми к использованию и хорошо документированными
