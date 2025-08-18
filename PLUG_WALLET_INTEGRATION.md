# Plug Wallet Integration Guide

## Overview

This document describes the integration of Plug Wallet with the TaxLien Mobile App, providing users with the ability to manage ICP tokens and NFTs on the Internet Computer blockchain.

## Features

### Core Functionality
- **Wallet Connection**: Connect to Plug Wallet extension
- **Balance Management**: View and manage ICP, WICP, and other token balances
- **Transaction History**: View detailed transaction history
- **NFT Management**: Import and manage NFT tax lien certificates
- **Network Switching**: Switch between mainnet and testnet
- **Transaction Signing**: Sign and approve transactions
- **Portfolio Statistics**: View portfolio performance and statistics

### UI Components
- **Wallet Tab**: Main wallet interface with connection status
- **Balance Tab**: Detailed balance view with portfolio value
- **Transactions Tab**: Complete transaction history
- **NFTs Tab**: NFT collection management
- **Stats Tab**: Portfolio performance and statistics

## Architecture

### Services
- `PlugWalletService`: Core service for wallet operations
- `WalletService`: General wallet management
- `NFTService`: NFT-specific operations

### Screens
- `PlugWalletScreen`: Main wallet interface
- `ProfileScreen`: Entry point to wallet features
- `WalletSettingsScreen`: Wallet configuration

## Implementation Details

### PlugWalletService

The main service class that handles all Plug Wallet interactions:

```dart
class PlugWalletService extends ChangeNotifier {
  // Connection management
  Future<bool> connect();
  Future<bool> disconnect();
  Future<void> initialize();
  
  // Balance and transaction operations
  Future<Map<String, double>> getBalance();
  Future<List<Map<String, dynamic>>> getTransactionHistory();
  Future<List<Map<String, dynamic>>> getNFTBalances();
  
  // Transaction operations
  Future<bool> sendTransaction({required String to, required double amount, required String currency});
  Future<bool> signMessage(String message);
  Future<bool> approveTransaction({required String canisterId, required String method, required Map<String, dynamic> args});
  
  // NFT operations
  Future<bool> importNFT({required String canisterId, required String tokenId});
  
  // Utility methods
  String formatPrincipal(String principal);
  String formatAccountId(String accountId);
  String formatBalance(double amount, String currency);
}
```

### State Management

The service uses `ChangeNotifier` for state management, providing:
- Connection status updates
- Balance updates
- Transaction status updates
- Error handling

### Data Persistence

Wallet state is persisted using `SharedPreferences`:
- Connection status
- Principal ID
- Account ID
- Network preference (mainnet/testnet)

## Usage

### Connecting to Plug Wallet

1. Navigate to Profile screen
2. Tap "Plug Wallet" in Quick Actions
3. Tap "Connect Wallet" button
4. Approve connection in Plug Wallet extension

### Managing Balances

1. View balances in the Balance tab
2. Send tokens using the send button
3. Receive tokens by sharing your address

### Managing NFTs

1. View NFTs in the NFTs tab
2. Import new NFTs using the import button
3. View NFT details and metadata

### Network Switching

1. Tap settings icon in wallet screen
2. Toggle "Testnet Mode" switch
3. Confirm network change

## Development Setup

### Prerequisites

1. Flutter SDK (3.2.3 or higher)
2. Android Studio with Android SDK
3. Plug Wallet browser extension
4. Internet Computer testnet/mainnet access

### Dependencies

Add to `pubspec.yaml`:
```yaml
dependencies:
  shared_preferences: ^2.2.0
  http: ^1.1.0
  url_launcher: ^6.2.1
  webview_flutter: ^4.4.2
```

### Building for Android

Use the provided build script:
```bash
# Run on connected device
./build_and_run_android.sh

# Build APK for distribution
./build_and_run_android.sh apk
```

## Testing

### Mock Data

The service includes comprehensive mock data for development:
- Sample balances (ICP, WICP, USD, BTC, ETH)
- Sample transactions with fees and block heights
- Sample NFTs with metadata

### Test Scenarios

1. **Connection Flow**: Test wallet connection/disconnection
2. **Balance Operations**: Test balance retrieval and updates
3. **Transaction Flow**: Test sending and receiving transactions
4. **NFT Operations**: Test NFT import and management
5. **Network Switching**: Test mainnet/testnet switching
6. **Error Handling**: Test various error scenarios

## Security Considerations

### Best Practices

1. **Secure Storage**: Sensitive data is stored using SharedPreferences
2. **Input Validation**: All user inputs are validated
3. **Error Handling**: Comprehensive error handling and user feedback
4. **Network Security**: HTTPS connections for all network requests

### Privacy

1. **Data Minimization**: Only necessary data is stored locally
2. **User Consent**: Clear user consent for wallet connections
3. **Transparency**: Clear indication of data usage

## Future Enhancements

### Planned Features

1. **Real Plug Wallet Integration**: Replace mock data with actual Plug Wallet API
2. **Multi-chain Support**: Support for additional blockchains
3. **Advanced Analytics**: Enhanced portfolio analytics
4. **DeFi Integration**: Integration with DeFi protocols
5. **Social Features**: Social trading and sharing features

### Technical Improvements

1. **Performance Optimization**: Optimize for large transaction histories
2. **Offline Support**: Basic offline functionality
3. **Push Notifications**: Transaction and price alerts
4. **Biometric Authentication**: Secure wallet access
5. **Backup & Recovery**: Wallet backup and recovery features

## Troubleshooting

### Common Issues

1. **Connection Failed**
   - Ensure Plug Wallet extension is installed
   - Check internet connection
   - Verify extension permissions

2. **Balance Not Loading**
   - Check network connectivity
   - Verify wallet connection
   - Clear app cache if needed

3. **Transaction Failed**
   - Verify sufficient balance
   - Check network fees
   - Ensure correct recipient address

### Debug Mode

Enable debug logging by setting:
```dart
// In PlugWalletService
bool _debugMode = true;
```

## Support

For technical support or questions about the Plug Wallet integration:

1. Check the troubleshooting section
2. Review the mock data implementation
3. Test with different network configurations
4. Verify all dependencies are properly installed

## License

This integration is part of the TaxLien Mobile App and follows the same licensing terms.
