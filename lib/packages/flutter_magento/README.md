# Flutter Magento

A comprehensive Flutter SDK for Magento 2 REST API integration.

## Features

- ✅ Complete Magento 2 REST API support
- ✅ Authentication (Customer & Admin)
- ✅ Product management
- ✅ Cart operations
- ✅ Customer management
- ✅ Order processing
- ✅ Category browsing
- ✅ Type-safe models
- ✅ Error handling
- ✅ Singleton pattern

## Usage

```dart
import 'package:flutter_magento/flutter_magento.dart';

// Initialize
final magento = FlutterMagento();
await magento.initialize(
  baseUrl: 'https://your-magento-store.com',
  storeCode: 'default',
);

// Authenticate
final token = await magento.auth.loginCustomer('email@example.com', 'password');

// Search products
final products = await magento.products.searchProducts(
  searchTerm: 'shirt',
  pageSize: 20,
);

// Add to cart
await magento.cart.addItemToCart(sku: 'PRODUCT-SKU', quantity: 1);

// Place order
final order = await magento.orders.placeOrder();
```

## License

NativeMindNONC

