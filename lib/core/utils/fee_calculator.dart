import '../constants/fee_constants.dart';

enum FeeType { purchase, nftMinting, nftSale, withdrawal }

class FeeCalculator {
  /// Calculate fee for a given transaction amount and type
  static double calculateFee(double amount, FeeType type) {
    switch (type) {
      case FeeType.purchase:
        double fee = amount * (TransactionFees.purchaseFeePercent / 100);
        return fee < TransactionFees.minPurchaseFee ? TransactionFees.minPurchaseFee : fee;
      
      case FeeType.nftMinting:
        return TransactionFees.nftMintingFee;
      
      case FeeType.nftSale:
        return amount * (TransactionFees.nftSaleFeePercent / 100);
      
      case FeeType.withdrawal:
        double fee = amount * (TransactionFees.withdrawalFeePercent / 100);
        return fee < TransactionFees.minWithdrawalFee ? TransactionFees.minWithdrawalFee : fee;
    }
  }

  /// Get total amount including fees
  static double calculateTotal(double amount, FeeType type) {
    return amount + calculateFee(amount, type);
  }
}

class TransactionFees {
  // Lien purchase fees
  static const double purchaseFeePercent = 2.5;
  static const double minPurchaseFee = 5.00;

  // NFT minting & trading
  static const double nftMintingFee = 19.99;      // Flat fee
  static const double nftSaleFeePercent = 5.0;    // 5% from sale
  static const double nftListingFee = 9.99;       // Flat fee for listing

  // Withdrawal fees
  static const double withdrawalFeePercent = 1.0;
  static const double minWithdrawalFee = 2.00;
}
