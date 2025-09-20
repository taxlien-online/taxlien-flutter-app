# План реализации flutter_icp библиотеки

## Этап 1: Подготовка (1-2 недели)

### 1.1 Создание структуры проекта
```bash
# Создание нового Flutter package
flutter create --template=package flutter_icp

# Структура папок
mkdir -p lib/src/{core,wallet,nft,marketplace,providers,utils}
mkdir -p test/{unit,integration,mocks}
mkdir -p example/lib
```

### 1.2 Настройка зависимостей
```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  shared_preferences: ^2.2.2
  crypto: ^3.0.3
  convert: ^3.1.1
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.2
  build_runner: ^2.4.7
```

## Этап 2: Core Layer (2-3 недели)

### 2.1 Базовые типы и интерфейсы
```dart
// lib/src/core/icp_types.dart
class ICPAddress {
  final String principal;
  final String accountId;
  
  ICPAddress({required this.principal, required this.accountId});
}

class ICPTransaction {
  final String id;
  final String from;
  final String to;
  final double amount;
  final String currency;
  final DateTime timestamp;
  final TransactionStatus status;
}

enum TransactionStatus {
  pending,
  confirmed,
  failed,
}
```

### 2.2 Основной клиент
```dart
// lib/src/core/icp_client.dart
abstract class ICPClient {
  Future<bool> connect();
  Future<void> disconnect();
  Future<ICPResponse<T>> call<T>(String method, Map<String, dynamic> params);
  bool get isConnected;
}

class ICPClientImpl implements ICPClient {
  // Реализация с использованием HTTP клиента
}
```

## Этап 3: Wallet Layer (2-3 недели)

### 3.1 Интерфейс кошелька
```dart
// lib/src/wallet/icp_wallet_interface.dart
abstract class ICPWalletInterface {
  Future<bool> connect();
  Future<void> disconnect();
  Future<String?> getPrincipalId();
  Future<Map<String, double>> getBalance();
  Future<bool> sendTransaction(TransactionRequest request);
  Future<bool> signMessage(String message);
}
```

### 3.2 Plug Wallet интеграция
```dart
// lib/src/wallet/plug_wallet_service.dart
class PlugWalletService implements ICPWalletInterface {
  // Портируем существующий код из текущего проекта
}
```

## Этап 4: NFT Layer (3-4 недели)

### 4.1 ICRC-7 стандарт
```dart
// lib/src/nft/icrc7_nft.dart
class ICRC7NFT {
  final String tokenId;
  final String canisterId;
  final NFTMetadata metadata;
  final String owner;
  final DateTime createdAt;
  
  // ICRC-7 специфичные методы
  Future<bool> transfer(String toAddress);
  Future<bool> approve(String spender, String tokenId);
  Future<bool> burn();
}
```

### 4.2 NFT сервис
```dart
// lib/src/nft/icp_nft_service.dart
class ICPNFTService {
  Future<List<ICRC7NFT>> getMyNFTs();
  Future<bool> mintNFT(NFTMintRequest request);
  Future<bool> transferNFT(String tokenId, String toAddress);
  Future<bool> burnNFT(String tokenId);
}
```

## Этап 5: Marketplace Layer (2-3 недели)

### 5.1 Интерфейс маркетплейса
```dart
// lib/src/marketplace/marketplace_interface.dart
abstract class ICPMarketplaceInterface {
  String get name;
  String get version;
  
  Future<List<NFTListing>> getListings();
  Future<bool> createListing(CreateListingRequest request);
  Future<bool> buyNFT(String listingId);
  Future<bool> makeOffer(MakeOfferRequest request);
}
```

### 5.2 Yuku интеграция
```dart
// lib/src/marketplace/yuku_service.dart
class YukuService implements ICPMarketplaceInterface {
  // Портируем существующий код
}
```

## Этап 6: Provider Layer (1-2 недели)

### 6.1 Riverpod провайдеры
```dart
// lib/src/providers/icp_provider.dart
final icpClientProvider = Provider<ICPClient>((ref) {
  return ICPClientImpl();
});

final walletProvider = StateNotifierProvider<WalletNotifier, WalletState>((ref) {
  return WalletNotifier(ref.read(icpClientProvider));
});

final nftProvider = StateNotifierProvider<NFTNotifier, NFTState>((ref) {
  return NFTNotifier(ref.read(icpClientProvider));
});
```

## Этап 7: Тестирование (2-3 недели)

### 7.1 Unit тесты
```dart
// test/unit/icp_client_test.dart
void main() {
  group('ICPClient', () {
    test('should connect successfully', () async {
      final client = MockICPClient();
      when(() => client.connect()).thenAnswer((_) async => true);
      
      final result = await client.connect();
      expect(result, isTrue);
    });
  });
}
```

### 7.2 Integration тесты
```dart
// test/integration/wallet_integration_test.dart
void main() {
  group('Wallet Integration', () {
    testWidgets('should connect to wallet', (tester) async {
      // Тест полного флоу подключения кошелька
    });
  });
}
```

## Этап 8: Документация и примеры (1-2 недели)

### 8.1 Пример использования
```dart
// example/lib/main.dart
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Consumer(
        builder: (context, ref, child) {
          final walletState = ref.watch(walletProvider);
          final nftState = ref.watch(nftProvider);
          
          return Scaffold(
            body: Column(
              children: [
                WalletStatus(walletState: walletState),
                NFTList(nftState: nftState),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

### 8.2 Документация
- README.md с примерами
- API документация
- Архитектурные решения

## Этап 9: Публикация (1 неделя)

### 9.1 Подготовка к публикации
```bash
# Проверка кода
flutter analyze
flutter test

# Генерация документации
dart doc

# Публикация на pub.dev
flutter pub publish
```

## Миграция из текущего проекта

### Пошаговая миграция:

1. **Создать flutter_icp package**
2. **Портировать PlugWalletService** → `lib/src/wallet/plug_wallet_service.dart`
3. **Портировать NFTService** → `lib/src/nft/icp_nft_service.dart`
4. **Портировать YukuService** → `lib/src/marketplace/yuku_service.dart`
5. **Создать абстракции и интерфейсы**
6. **Добавить Provider layer**
7. **Написать тесты**
8. **Обновить основной проект для использования библиотеки**

### Обновление pubspec.yaml в основном проекте:
```yaml
dependencies:
  flutter_icp:
    path: ../flutter_icp  # Локальная разработка
    # git:
    #   url: https://github.com/your-org/flutter_icp.git
    #   ref: main
```

## Временные рамки

**Общее время: 12-18 недель**

- Подготовка: 1-2 недели
- Core Layer: 2-3 недели  
- Wallet Layer: 2-3 недели
- NFT Layer: 3-4 недели
- Marketplace Layer: 2-3 недели
- Provider Layer: 1-2 недели
- Тестирование: 2-3 недели
- Документация: 1-2 недели
- Публикация: 1 неделя

## Преимущества такого подхода

1. **Переиспользуемость** - библиотека может использоваться в других проектах
2. **Модульность** - каждый компонент независим
3. **Тестируемость** - легче писать тесты для изолированных компонентов
4. **Масштабируемость** - легко добавлять новые маркетплейсы и функционал
5. **Сообщество** - открытая библиотека может привлечь контрибьюторов
