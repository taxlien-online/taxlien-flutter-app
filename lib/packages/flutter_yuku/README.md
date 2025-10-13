# Flutter Yuku

A comprehensive Flutter SDK for Yuku NFT Marketplace on Internet Computer (ICP).

## Features

- ✅ NFT marketplace operations
- ✅ Collection management
- ✅ NFT listing and sales
- ✅ Offer system
- ✅ Collection stats
- ✅ Trending collections
- ✅ User profiles
- ✅ Type-safe models
- ✅ Error handling

## Usage

```dart
import 'package:flutter_yuku/flutter_yuku.dart';

// Initialize
final yuku = YukuClient();
await yuku.initialize();

// Get all active listings
final listings = await yuku.marketplace.getActiveListings(
  collectionId: 'collection-123',
  minPrice: 1.0,
  maxPrice: 100.0,
);

// Create listing
final listing = await yuku.marketplace.createListing(
  tokenId: 'token-456',
  collectionId: 'collection-123',
  price: 10.0,
  currency: 'ICP',
  durationDays: 7,
);

// Buy NFT
await yuku.marketplace.buyNFT(
  listingId: listing.id,
  buyerPrincipal: 'buyer-principal',
);

// Make offer
final offer = await yuku.marketplace.makeOffer(
  tokenId: 'token-789',
  collectionId: 'collection-123',
  price: 8.0,
  durationDays: 3,
);

// Get collections
final collections = await yuku.collections.getAllCollections();

// Get trending collections
final trending = await yuku.collections.getTrendingCollections(limit: 10);

// Get NFTs owned by user
final ownedNFTs = await yuku.nfts.getOwnedNFTs('user-principal');
```

## License

NativeMindNONC

