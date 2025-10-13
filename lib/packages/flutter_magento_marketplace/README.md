# Flutter Magento Marketplace

A comprehensive Flutter SDK for Magento 2 Marketplace / Multi-vendor extension.

## Features

- ✅ Vendor management
- ✅ Seller management
- ✅ Multi-vendor product listings
- ✅ Product approval workflow
- ✅ Vendor statistics
- ✅ Seller permissions
- ✅ Type-safe models
- ✅ Error handling

## Usage

```dart
import 'package:flutter_magento_marketplace/flutter_magento_marketplace.dart';

// Initialize
final marketplace = FlutterMagentoMarketplace();
await marketplace.initialize(
  baseUrl: 'https://your-magento-store.com',
  authToken: 'your-auth-token',
);

// Get all vendors
final vendors = await marketplace.vendors.getAllVendors(activeOnly: true);

// Get vendor products
final products = await marketplace.products.getVendorProducts(vendorId);

// Create vendor
final vendor = MarketplaceVendor(...);
final createdVendor = await marketplace.vendors.createVendor(vendor);

// Approve product (admin)
await marketplace.products.approveProduct(productId);
```

## License

NativeMindNONC

