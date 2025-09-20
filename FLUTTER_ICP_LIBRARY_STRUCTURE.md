# Flutter ICP Library Structure

## Рекомендуемая архитектура библиотеки `flutter_icp`

```
flutter_icp/
├── lib/
│   ├── src/
│   │   ├── core/
│   │   │   ├── icp_client.dart           # Основной клиент ICP
│   │   │   ├── icp_config.dart           # Конфигурация сети
│   │   │   ├── icp_exceptions.dart       # Обработка ошибок
│   │   │   └── icp_types.dart            # Базовые типы данных
│   │   ├── wallet/
│   │   │   ├── plug_wallet_service.dart  # Plug Wallet интеграция
│   │   │   ├── icp_wallet_interface.dart # Интерфейс кошелька
│   │   │   └── wallet_models.dart        # Модели кошелька
│   │   ├── nft/
│   │   │   ├── icp_nft_service.dart      # NFT операции
│   │   │   ├── icrc7_nft.dart           # ICRC-7 стандарт
│   │   │   ├── nft_models.dart          # NFT модели
│   │   │   └── nft_marketplace.dart     # Маркетплейс функционал
│   │   ├── marketplace/
│   │   │   ├── yuku_service.dart        # Yuku интеграция
│   │   │   ├── marketplace_interface.dart # Интерфейс маркетплейса
│   │   │   └── marketplace_models.dart  # Модели маркетплейса
│   │   ├── providers/
│   │   │   ├── icp_provider.dart        # Provider для состояния
│   │   │   ├── wallet_provider.dart     # Wallet Provider
│   │   │   └── nft_provider.dart        # NFT Provider
│   │   └── utils/
│   │       ├── icp_utils.dart           # Утилиты
│   │       ├── crypto_utils.dart        # Криптографические утилиты
│   │       └── network_utils.dart       # Сетевые утилиты
│   ├── flutter_icp.dart                # Главный экспорт
│   └── flutter_icp_base.dart           # Базовые классы
├── example/
│   ├── lib/
│   │   └── main.dart                    # Пример использования
│   └── pubspec.yaml
├── test/
│   ├── unit/
│   ├── integration/
│   └── mocks/
├── pubspec.yaml
└── README.md
```

## Ключевые компоненты

### 1. Core Layer
```dart
// lib/src/core/icp_client.dart
abstract class ICPClient {
  Future<ICPResponse<T>> call<T>(ICPMethod method, Map<String, dynamic> params);
  Future<bool> connect();
  Future<void> disconnect();
  bool get isConnected;
}

class ICPClientImpl implements ICPClient {
  // Реализация
}
```

### 2. Wallet Layer
```dart
// lib/src/wallet/icp_wallet_interface.dart
abstract class ICPWalletInterface {
  Future<bool> connect();
  Future<String?> getPrincipalId();
  Future<Map<String, double>> getBalance();
  Future<bool> sendTransaction(TransactionRequest request);
}
```

### 3. NFT Layer
```dart
// lib/src/nft/icrc7_nft.dart
class ICRC7NFT {
  final String tokenId;
  final String canisterId;
  final NFTMetadata metadata;
  final String owner;
  
  // ICRC-7 специфичные методы
}
```

### 4. Marketplace Layer
```dart
// lib/src/marketplace/marketplace_interface.dart
abstract class ICPMarketplaceInterface {
  Future<List<NFTListing>> getListings();
  Future<bool> createListing(CreateListingRequest request);
  Future<bool> buyNFT(String listingId);
  Future<bool> makeOffer(MakeOfferRequest request);
}
```

## Преимущества такой архитектуры

1. **Модульность** - каждый компонент независим
2. **Расширяемость** - легко добавлять новые маркетплейсы
3. **Тестируемость** - каждый слой можно тестировать отдельно
4. **Переиспользуемость** - компоненты можно использовать независимо
5. **Типобезопасность** - строгая типизация на всех уровнях

## Интерфейсы для расширения

```dart
// lib/src/marketplace/marketplace_interface.dart
abstract class ICPMarketplaceInterface {
  String get name;
  String get version;
  
  Future<List<NFTListing>> getListings();
  Future<bool> createListing(CreateListingRequest request);
  Future<bool> buyNFT(String listingId);
}

// Конкретные реализации
class YukuMarketplace implements ICPMarketplaceInterface {
  // Yuku специфичная реализация
}

class EntrepotMarketplace implements ICPMarketplaceInterface {
  // Entrepot специфичная реализация
}
```

## Provider Pattern для состояния

```dart
// lib/src/providers/icp_provider.dart
class ICPProvider extends ChangeNotifier {
  final ICPClient _client;
  final ICPWalletInterface _wallet;
  final List<ICPMarketplaceInterface> _marketplaces;
  
  ICPProvider({
    required ICPClient client,
    required ICPWalletInterface wallet,
    required List<ICPMarketplaceInterface> marketplaces,
  });
}
```
