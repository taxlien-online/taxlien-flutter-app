# Cloud Integration with Magento Backend

This document describes the cloud integration features added to the TaxLien.online mobile application using GraphQL and REST APIs with offline capabilities.

## Overview

The application now supports both standalone offline operation and cloud-based features through Magento backend integration. Users can choose to use the app completely offline or leverage cloud functionality when available.

## Architecture

### Services

1. **MagentoApiService** - Original REST API service for Magento backend
2. **MagentoGraphQLService** - New GraphQL service for advanced Magento operations
3. **HybridMagentoService** - Intelligent service that combines both APIs with offline fallback

### Key Features

#### 🌐 Hybrid Cloud/Offline Operation
- **Automatic Detection**: App automatically detects internet connectivity
- **Smart Fallback**: Gracefully falls back to cached data when offline
- **Seamless Sync**: Automatically syncs data when connection is restored

#### 🔄 Dual API Support
- **GraphQL Primary**: Uses GraphQL for better performance and flexibility
- **REST Fallback**: Falls back to REST API if GraphQL is unavailable
- **User Choice**: Users can prefer GraphQL or REST in settings

#### 💾 Offline Capabilities
- **Data Caching**: Products, categories, and user data cached locally
- **Offline Cart**: Shopping cart works offline with local storage
- **Credential Caching**: Secure offline authentication (when enabled)

#### ⚙️ Configuration Options
- **Cloud Sync**: Enable/disable cloud synchronization
- **Offline Mode**: Enable/disable offline functionality
- **API Preference**: Choose between GraphQL and REST
- **Auto Sync**: Automatic synchronization when online

## Implementation Details

### Dependencies Added

```yaml
dependencies:
  # GraphQL for Magento integration
  graphql_flutter: ^5.1.2
  graphql: ^5.1.3
```

### App Constants

New cloud integration flags in `AppConstants`:

```dart
// Cloud Integration Flags
static const bool enableCloudSync = true;
static const bool enableOfflineMode = true;
static const bool preferCloudWhenAvailable = true;
static const bool enableCloudBackup = true;
static const bool enableCloudAnalytics = true;
```

### Service Usage

#### Basic Usage

```dart
// Initialize hybrid service
final hybridService = HybridMagentoService();

// Authenticate (works online/offline)
final success = await hybridService.authenticateCustomer(
  email: 'user@example.com',
  password: 'password',
);

// Get products (with automatic fallback)
final products = await hybridService.getProducts(
  page: 1,
  pageSize: 20,
  searchQuery: 'tax lien',
);
```

#### Configuration

```dart
// Set API preference
await hybridService.setPreferGraphQL(true);

// Enable offline mode
await hybridService.setEnableOfflineMode(true);

// Check service status
final status = hybridService.getServiceStatus();
print('Connection: ${status['connectionStatus']}');
```

### UI Components

#### Cloud Status Widget

Shows current connection status in the app bar:

```dart
AppBar(
  title: Text('TaxLien.online'),
  actions: [
    CloudStatusWidget(
      showIcon: true,
      showLabel: false,
    ),
  ],
)
```

#### Cloud Settings

Comprehensive settings panel for cloud configuration:

```dart
CloudSettingsTile() // Expands to show all cloud settings
```

#### Connection Indicator

Simple dot indicator for connection status:

```dart
ConnectionIndicator(size: 8.0)
```

## GraphQL Operations

### Authentication

```graphql
mutation GenerateCustomerToken($email: String!, $password: String!) {
  generateCustomerToken(email: $email, password: $password) {
    token
  }
}
```

### Product Queries

```graphql
query GetProducts(
  $currentPage: Int!,
  $pageSize: Int!,
  $search: String,
  $filter: ProductAttributeFilterInput,
  $sort: ProductAttributeSortInput
) {
  products(
    currentPage: $currentPage,
    pageSize: $pageSize,
    search: $search,
    filter: $filter,
    sort: $sort
  ) {
    total_count
    items {
      sku
      name
      price_range {
        minimum_price {
          final_price {
            value
            currency
          }
        }
      }
    }
  }
}
```

### Cart Operations

```graphql
mutation AddProductsToCart($cartId: String!, $cartItems: [CartItemInput!]!) {
  addProductsToCart(cartId: $cartId, cartItems: $cartItems) {
    cart {
      id
      items {
        quantity
        product {
          sku
          name
        }
      }
    }
  }
}
```

## Offline Data Management

### Caching Strategy

1. **Products**: Cached after first load, expires after 1 hour
2. **Categories**: Cached indefinitely, refreshed when online
3. **Customer Data**: Cached securely, refreshed on login
4. **Cart**: Local cart for offline operations

### Storage

- **SharedPreferences**: For app settings and non-sensitive cache
- **SecureStorage**: For authentication tokens and credentials
- **Local Database**: For complex data structures (future enhancement)

## User Experience

### Connection States

1. **Online (GraphQL)**: 🟢 Full cloud features with GraphQL
2. **Online (REST)**: 🟡 Cloud features with REST API fallback
3. **Offline**: 🟠 Local features with cached data

### Automatic Behavior

- **App Startup**: Checks connectivity and initializes appropriate service
- **Connection Lost**: Seamlessly switches to offline mode
- **Connection Restored**: Automatically syncs pending changes
- **API Failure**: Falls back to alternative API or cached data

## Configuration

### Environment Variables

Set up your Magento backend URLs in `AppConstants`:

```dart
static const String magentoBaseUrl = 'https://your-magento-store.com';
static const String magentoGraphQLEndpoint = '$magentoBaseUrl/graphql';
static const String magentoRestEndpoint = '$magentoBaseUrl/rest/V1';
```

### Feature Flags

Control cloud features through constants:

```dart
// Enable/disable specific features
static const bool enableCloudSync = true;
static const bool enableOfflineMode = true;
static const bool preferCloudWhenAvailable = true;
```

## Testing

### Online Testing
1. Connect to internet
2. Verify GraphQL operations work
3. Test REST API fallback
4. Check data synchronization

### Offline Testing
1. Disable internet connection
2. Verify cached data loads
3. Test offline cart operations
4. Check graceful degradation

### Hybrid Testing
1. Start online, go offline mid-operation
2. Verify seamless transition
3. Come back online and check sync
4. Test error handling

## Security Considerations

### Authentication
- Tokens stored in secure storage
- Offline credentials hashed (simple implementation)
- Auto-logout on security events

### Data Protection
- Sensitive data encrypted in storage
- Network requests use HTTPS
- Cached data has expiration

## Future Enhancements

### Planned Features
1. **Local SQLite Database**: For better offline data management
2. **Background Sync**: Sync data in background when online
3. **Conflict Resolution**: Handle data conflicts between local and remote
4. **Push Notifications**: Real-time updates when online
5. **Advanced Caching**: More intelligent cache management

### Performance Optimizations
1. **Image Caching**: Cache product images for offline viewing
2. **Pagination**: Better handling of large datasets
3. **Compression**: Compress cached data
4. **Lazy Loading**: Load data on demand

## Troubleshooting

### Common Issues

1. **GraphQL Errors**: Check endpoint configuration and network
2. **Cache Issues**: Clear app data and restart
3. **Sync Problems**: Verify authentication and connectivity
4. **Performance**: Check cache size and clear if needed

### Debug Tools

```dart
// Get service status
final status = hybridService.getServiceStatus();
print('Debug info: $status');

// Enable debug logging
if (kDebugMode) {
  print('Connection status: ${hybridService.connectionStatus}');
}
```

## Support

For issues related to cloud integration:
1. Check network connectivity
2. Verify Magento backend is accessible
3. Review app logs for error messages
4. Contact support at support@taxlien.online

## License

This cloud integration follows the same license as the main application (NativeMindNONC).
