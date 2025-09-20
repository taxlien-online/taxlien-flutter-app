# Migration Guide: Using flutter_nft and flutter_icp Libraries

This guide explains how to migrate your existing taxlien-mobile-app to use the new `flutter_nft` and `flutter_icp` libraries.

## Overview

The existing ICP and NFT functionality has been extracted into two separate libraries:

1. **flutter_nft** - Universal NFT library with provider architecture
2. **flutter_icp** - ICP-specific implementation as a provider for flutter_nft

## Benefits of Migration

- ✅ **Modularity** - Separate concerns into focused libraries
- ✅ **Reusability** - Libraries can be used in other projects
- ✅ **Maintainability** - Easier to maintain and update
- ✅ **Extensibility** - Easy to add new blockchain providers
- ✅ **Type Safety** - Better type safety with unified interfaces

## Migration Steps

### 1. Update pubspec.yaml

Add the new dependencies to your main project:

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Existing dependencies...
  
  # New NFT libraries
  flutter_nft:
    path: ../flutter_nft
  flutter_icp:
    path: ../flutter_icp
  
  # Remove these if they exist (functionality moved to libraries):
  # - Direct ICP/NFT service imports
```

### 2. Update main.dart

Replace the existing service initialization with the new provider architecture:

**Before:**
```dart
// Old approach
final yukuService = YukuService();
final plugWalletService = PlugWalletService();
final nftService = NFTService();

await yukuService.initialize();
await plugWalletService.initialize();
await nftService.initialize();
```

**After:**
```dart
import 'package:flutter_nft/flutter_nft.dart';
import 'package:flutter_icp/flutter_icp.dart';

// New approach
final nftClient = NFTClient();

// Register ICP providers
nftClient.registerNFTProvider(ICPNFTProvider());
nftClient.registerWalletProvider(PlugWalletProvider());
nftClient.registerMarketplaceProvider(YukuMarketplaceProvider());

// Initialize all providers
await nftClient.initialize();
```

### 3. Update Service Usage

Replace direct service calls with provider calls:

**Before:**
```dart
// Old approach
final nfts = await nftService.getMyNFTs();
final listings = await yukuService.getActiveListings();
final balance = await plugWalletService.getBalance();
```

**After:**
```dart
// New approach
final nftProvider = nftClient.getNFTProvider(BlockchainNetwork.icp);
final walletProvider = nftClient.getWalletProvider(BlockchainNetwork.icp);
final marketplaceProvider = nftClient.getMarketplaceProvider(BlockchainNetwork.icp);

final nfts = await nftProvider.getNFTsByOwner(userAddress);
final listings = await marketplaceProvider.getActiveListings();
final balance = await walletProvider.getBalance('ICP');
```

### 4. Update Widget Imports

Replace existing service imports:

**Before:**
```dart
import '../services/yuku_service.dart';
import '../services/plug_wallet_service.dart';
import '../services/nft_service.dart';
```

**After:**
```dart
import 'package:flutter_nft/flutter_nft.dart';
import 'package:flutter_icp/flutter_icp.dart';
```

### 5. Update State Management

If you're using Provider/Riverpod, update your providers:

**Before:**
```dart
// Old approach
final yukuServiceProvider = ChangeNotifierProvider((ref) => YukuService());
final plugWalletProvider = ChangeNotifierProvider((ref) => PlugWalletService());
final nftServiceProvider = ChangeNotifierProvider((ref) => NFTService());
```

**After:**
```dart
// New approach
final nftClientProvider = Provider((ref) => NFTClient());
final nftProviderProvider = Provider((ref) => 
  ref.read(nftClientProvider).getNFTProvider(BlockchainNetwork.icp));
final walletProviderProvider = Provider((ref) => 
  ref.read(nftClientProvider).getWalletProvider(BlockchainNetwork.icp));
final marketplaceProviderProvider = Provider((ref) => 
  ref.read(nftClientProvider).getMarketplaceProvider(BlockchainNetwork.icp));
```

## File-by-File Migration

### Files to Remove

These files are no longer needed as their functionality is now in the libraries:

```
lib/services/plug_wallet_service.dart → flutter_icp/lib/src/services/plug_wallet_service.dart
lib/services/yuku_service.dart → flutter_icp/lib/src/services/yuku_service.dart
lib/services/nft_service.dart → flutter_icp/lib/src/services/nft_service.dart
```

### Files to Update

Update these files to use the new libraries:

#### lib/main.dart
```dart
import 'package:flutter_nft/flutter_nft.dart';
import 'package:flutter_icp/flutter_icp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize NFT client with ICP providers
  final nftClient = NFTClient();
  nftClient.registerNFTProvider(ICPNFTProvider());
  nftClient.registerWalletProvider(PlugWalletProvider());
  nftClient.registerMarketplaceProvider(YukuMarketplaceProvider());
  await nftClient.initialize();
  
  runApp(MyApp(nftClient: nftClient));
}
```

#### lib/screens/plug_wallet_screen.dart
```dart
import 'package:flutter_nft/flutter_nft.dart';
import 'package:flutter_icp/flutter_icp.dart';

class PlugWalletScreen extends StatefulWidget {
  final NFTClient nftClient;
  
  const PlugWalletScreen({Key? key, required this.nftClient}) : super(key: key);

  @override
  State<PlugWalletScreen> createState() => _PlugWalletScreenState();
}

class _PlugWalletScreenState extends State<PlugWalletScreen> {
  late WalletProvider walletProvider;
  
  @override
  void initState() {
    super.initState();
    walletProvider = widget.nftClient.getWalletProvider(BlockchainNetwork.icp);
  }
  
  // Update all wallet operations to use walletProvider
}
```

#### lib/screens/yuku_marketplace_screen.dart
```dart
import 'package:flutter_nft/flutter_nft.dart';
import 'package:flutter_icp/flutter_icp.dart';

class YukuMarketplaceScreen extends StatefulWidget {
  final NFTClient nftClient;
  
  const YukuMarketplaceScreen({Key? key, required this.nftClient}) : super(key: key);

  @override
  State<YukuMarketplaceScreen> createState() => _YukuMarketplaceScreenState();
}

class _YukuMarketplaceScreenState extends State<YukuMarketplaceScreen> {
  late MarketplaceProvider marketplaceProvider;
  
  @override
  void initState() {
    super.initState();
    marketplaceProvider = widget.nftClient.getMarketplaceProvider(BlockchainNetwork.icp);
  }
  
  // Update all marketplace operations to use marketplaceProvider
}
```

## Configuration

### ICP Configuration

The ICP configuration is now centralized in `ICPConfig`:

```dart
import 'package:flutter_icp/flutter_icp.dart';

// Switch networks
ICPConfig.instance.useMainnet();
ICPConfig.instance.useTestnet();

// Custom configuration
ICPConfig.instance.setNetworkConfig(ICPNetworkConfig(
  name: 'Custom Network',
  url: 'https://custom-icp.network',
  isTestnet: false,
  canisterIds: {
    'ledger': 'your-ledger-canister-id',
    'nft': 'your-nft-canister-id',
  },
));
```

## Error Handling

Update error handling to use the new exception types:

```dart
try {
  final nfts = await nftProvider.getNFTsByOwner(address);
} on WalletNotConnectedException catch (e) {
  // Handle wallet not connected
} on ICPTransactionException catch (e) {
  // Handle ICP transaction failure
} on MarketplaceException catch (e) {
  // Handle marketplace errors
} on NFTOperationException catch (e) {
  // Handle NFT operation errors
}
```

## Testing

Update your tests to use the new architecture:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_nft/flutter_nft.dart';
import 'package:flutter_icp/flutter_icp.dart';
import 'package:mockito/mockito.dart';

class MockNFTProvider extends Mock implements NFTProvider {}

void main() {
  group('NFT Operations', () {
    late MockNFTProvider mockNFTProvider;
    late NFTClient nftClient;

    setUp(() {
      mockNFTProvider = MockNFTProvider();
      nftClient = NFTClient();
      nftClient.registerNFTProvider(mockNFTProvider);
    });

    test('should get NFTs by owner', () async {
      // Test implementation
    });
  });
}
```

## Benefits After Migration

1. **Cleaner Code** - Less boilerplate, more focused functionality
2. **Better Architecture** - Clear separation of concerns
3. **Easier Testing** - Mockable interfaces for all providers
4. **Future-Proof** - Easy to add new blockchain support
5. **Reusable Components** - Libraries can be used in other projects

## Rollback Plan

If you need to rollback:

1. Revert pubspec.yaml changes
2. Restore the original service files
3. Revert main.dart and other updated files
4. Remove the flutter_nft and flutter_icp directories

## Support

If you encounter issues during migration:

1. Check the example apps in both libraries
2. Review the API documentation
3. Create an issue in the respective library repositories
4. Contact the development team

## Next Steps

After successful migration:

1. Test all functionality thoroughly
2. Update documentation
3. Consider contributing improvements back to the libraries
4. Explore adding support for additional blockchains
