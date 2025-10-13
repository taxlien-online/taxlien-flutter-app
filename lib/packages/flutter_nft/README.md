# Flutter NFT

A comprehensive Flutter SDK for NFT operations across multiple blockchains.

## Features

- ✅ Multi-chain NFT support
- ✅ NFT minting
- ✅ NFT transfers
- ✅ NFT metadata (ERC-721/ERC-1155)
- ✅ Wallet integration
- ✅ Marketplace operations
- ✅ Collection management
- ✅ Offer system
- ✅ Provider architecture
- ✅ Type-safe models

## Supported Networks

- Internet Computer (ICP)
- Ethereum (via providers)
- Other EVM chains (via providers)

## Usage

```dart
import 'package:flutter_nft/flutter_nft.dart';

// Initialize
final nftClient = NFTClient();
await nftClient.initialize();

// Register providers
nftClient.registerNFTProvider('icp', ICPNFTProvider());
nftClient.registerWalletProvider('icp', PlugWalletProvider());
nftClient.registerMarketplaceProvider('yuku', YukuMarketplaceProvider());

// Mint NFT
final nft = await nftClient.mintNFT(
  network: 'icp',
  metadataUrl: 'https://...',
  recipientAddress: '0x...',
);

// Transfer NFT
await nftClient.transferNFT(
  network: 'icp',
  tokenId: 'token123',
  toAddress: '0x...',
);

// List on marketplace
final listing = await nftClient.createListing(
  marketplace: 'yuku',
  tokenId: 'token123',
  price: 10.0,
  currency: 'ICP',
  sellerAddress: '0x...',
);

// Buy NFT
await nftClient.buyNFT(
  marketplace: 'yuku',
  listingId: 'listing456',
  buyerAddress: '0x...',
);
```

## Implementing Custom Providers

```dart
class MyNFTProvider extends NFTProvider {
  @override
  Future<NFT> mintNFT({
    required String metadataUrl,
    required String recipientAddress,
    String? collectionId,
  }) async {
    // Your implementation
  }
  
  // Implement other methods...
}
```

## License

NativeMindNONC

