# Flutter ICP

A comprehensive Flutter SDK for Internet Computer Protocol (ICP).

## Features

- ✅ ICP Ledger operations
- ✅ Token transfers
- ✅ Balance queries
- ✅ Transaction history
- ✅ Principal management
- ✅ Canister calls (query & update)
- ✅ Network status
- ✅ Testnet support
- ✅ Type-safe models

## Usage

```dart
import 'package:flutter_icp/flutter_icp.dart';

// Initialize
final icp = ICPClient();
await icp.initialize(isTestnet: false);

// Get balance
final balance = await icp.ledger.getBalance('principal-address');

// Send tokens
final transaction = await icp.ledger.sendTokens(
  from: 'sender-address',
  to: 'recipient-address',
  amount: 1.5,
  memo: 'Payment',
);

// Get transaction history
final history = await icp.ledger.getTransactionHistory('address');

// Call canister
final result = await icp.canisters.query(
  canisterId: 'canister-id',
  method: 'get_balance',
  args: ['principal'],
);

// Validate principal
final isValid = icp.identity.validatePrincipal('principal-id');

// Switch to testnet
await icp.switchNetwork(toTestnet: true);
```

## License

NativeMindNONC

