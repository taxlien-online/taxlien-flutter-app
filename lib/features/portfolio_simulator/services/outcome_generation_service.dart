import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/simulated_position.dart';
import '../models/simulation_outcome.dart';
import '../constants/simulator_constants.dart';

/// Service for generating simulation outcomes
///
/// Uses ML API when available, falls back to rule-based generation.
class OutcomeGenerationService {
  static final OutcomeGenerationService _instance =
      OutcomeGenerationService._internal();
  factory OutcomeGenerationService() => _instance;
  OutcomeGenerationService._internal();

  static OutcomeGenerationService get instance => _instance;

  final Random _random = Random();

  // Historical redemption rates by state (example data)
  static const Map<String, double> _stateRedemptionRates = {
    'FL': 0.65, // Florida: 65% redemption rate
    'TX': 0.70, // Texas: 70%
    'CA': 0.60, // California: 60%
    'NY': 0.55, // New York: 55%
    'PA': 0.68, // Pennsylvania: 68%
    'IL': 0.62, // Illinois: 62%
    'OH': 0.66, // Ohio: 66%
    'default': 0.63, // Default for unknown states
  };

  // ===== PUBLIC API =====

  /// Generate outcome for a simulated position
  ///
  /// First tries ML API, falls back to rule-based if unavailable
  Future<SimulationOutcome> generateOutcome(
    SimulatedPosition position,
  ) async {
    try {
      // Try ML-based generation first
      return await _generateMLBasedOutcome(position);
    } catch (e) {
      debugPrint('⚠️ ML service unavailable, using rule-based fallback: $e');
      // Fall back to rule-based generation
      return _generateRuleBasedOutcome(position);
    }
  }

  // ===== ML-BASED GENERATION =====

  /// Generate outcome using ML service
  Future<SimulationOutcome> _generateMLBasedOutcome(
    SimulatedPosition position,
  ) async {
    // TODO: Implement ML API call
    // Example endpoint: POST /api/simulator/predict-outcome
    // Payload: {
    //   propertyId: position.propertyId,
    //   purchasePrice: position.purchasePrice,
    //   county: position.county,
    //   state: position.state,
    //   interestRate: position.interestRate,
    //   estimatedValue: position.estimatedValue,
    // }

    // For now, throw to trigger fallback
    throw UnimplementedError('ML API not yet implemented');
  }

  // ===== RULE-BASED GENERATION =====

  /// Generate outcome using historical data and rules
  SimulationOutcome _generateRuleBasedOutcome(
    SimulatedPosition position,
  ) {
    // Get redemption probability for state
    final redemptionRate =
        _stateRedemptionRates[position.state] ?? _stateRedemptionRates['default']!;

    // Add property-specific factors
    final adjustedRate = _calculateAdjustedRedemptionRate(
      baseRate: redemptionRate,
      position: position,
    );

    // Roll the dice!
    final roll = _random.nextDouble();

    OutcomeType outcomeType;
    double finalValue;
    double profitLoss;
    double roi;

    if (roll < adjustedRate) {
      // REDEEMED: Owner paid back taxes
      outcomeType = OutcomeType.redeemed;
      finalValue = _calculateRedeemedValue(position);
      profitLoss = finalValue - position.purchasePrice;
      roi = (profitLoss / position.purchasePrice) * 100;
    } else if (roll < adjustedRate + 0.15) {
      // PARTIAL PAYMENT: Owner paid part, negotiated settlement
      outcomeType = OutcomeType.partialPayment;
      finalValue = _calculatePartialPaymentValue(position);
      profitLoss = finalValue - position.purchasePrice;
      roi = (profitLoss / position.purchasePrice) * 100;
    } else if (roll < adjustedRate + 0.25) {
      // FORECLOSED: You own the property now
      outcomeType = OutcomeType.foreclosed;
      finalValue = _calculateForeclosedValue(position);
      profitLoss = finalValue - position.purchasePrice;
      roi = (profitLoss / position.purchasePrice) * 100;
    } else {
      // LOSS: Legal issues, errors, or total loss
      outcomeType = OutcomeType.loss;
      finalValue = _calculateLossValue(position);
      profitLoss = finalValue - position.purchasePrice;
      roi = (profitLoss / position.purchasePrice) * 100;
    }

    return SimulationOutcome.generate(
      positionId: position.id,
      type: outcomeType,
      finalValue: finalValue,
      profitLoss: profitLoss,
      roi: roi,
      originalInvestment: position.purchasePrice,
      interestEarned: outcomeType == OutcomeType.redeemed
          ? finalValue - position.purchasePrice
          : 0,
    );
  }

  // ===== CALCULATION HELPERS =====

  /// Calculate adjusted redemption rate based on property factors
  double _calculateAdjustedRedemptionRate({
    required double baseRate,
    required SimulatedPosition position,
  }) {
    double adjustedRate = baseRate;

    // Factor 1: Property value ratio
    // Higher value properties are more likely to be redeemed
    final valueRatio = position.estimatedValue / position.purchasePrice;
    if (valueRatio > 10) {
      adjustedRate += 0.10; // +10% redemption chance
    } else if (valueRatio > 5) {
      adjustedRate += 0.05; // +5% redemption chance
    } else if (valueRatio < 2) {
      adjustedRate -= 0.05; // -5% redemption chance
    }

    // Factor 2: Interest rate
    // Higher interest rates incentivize owners to pay faster
    if (position.interestRate > 15) {
      adjustedRate += 0.05;
    } else if (position.interestRate < 8) {
      adjustedRate -= 0.03;
    }

    // Factor 3: Property type
    // Residential more likely to redeem than commercial
    if (position.propertyType == 'Residential') {
      adjustedRate += 0.05;
    } else if (position.propertyType == 'Commercial') {
      adjustedRate -= 0.03;
    }

    // Clamp to valid range [0, 1]
    return adjustedRate.clamp(0.0, 1.0);
  }

  /// Calculate value for redeemed outcome
  double _calculateRedeemedValue(SimulatedPosition position) {
    // Redeemed = Principal + Interest + Penalties
    // Interest accrued over simulated time
    final simulatedMonths = SimulatorConstants.simulationDurationHours *
        SimulatorConstants.timeAccelerationFactor *
        4.33; // weeks to months

    final interestEarned = position.purchasePrice *
        (position.interestRate / 100) *
        (simulatedMonths / 12);

    // Add random penalty (0-10% of principal)
    final penalty = position.purchasePrice * (_random.nextDouble() * 0.10);

    return position.purchasePrice + interestEarned + penalty;
  }

  /// Calculate value for partial payment outcome
  double _calculatePartialPaymentValue(SimulatedPosition position) {
    // Partial payment = 50-90% of full redemption value
    final fullValue = _calculateRedeemedValue(position);
    final partialPercentage = 0.5 + (_random.nextDouble() * 0.4); // 50-90%
    return fullValue * partialPercentage;
  }

  /// Calculate value for foreclosed outcome
  double _calculateForeclosedValue(SimulatedPosition position) {
    // Foreclosed = Property value - Selling costs - Time
    // Typically get 70-90% of estimated value after costs
    final salePercentage = 0.70 + (_random.nextDouble() * 0.20); // 70-90%
    return position.estimatedValue * salePercentage;
  }

  /// Calculate value for loss outcome
  double _calculateLossValue(SimulatedPosition position) {
    // Loss scenarios:
    // - Total loss (legal issues): 0%
    // - Partial loss (errors, liens): 10-50% recovery
    final lossScenario = _random.nextDouble();

    if (lossScenario < 0.2) {
      // Total loss (20% chance)
      return 0;
    } else {
      // Partial recovery (80% chance)
      final recoveryPercentage = 0.10 + (_random.nextDouble() * 0.40); // 10-50%
      return position.purchasePrice * recoveryPercentage;
    }
  }

  // ===== BATCH GENERATION =====

  /// Generate outcomes for multiple positions (for testing)
  Future<List<SimulationOutcome>> generateBatchOutcomes(
    List<SimulatedPosition> positions,
  ) async {
    final outcomes = <SimulationOutcome>[];

    for (final position in positions) {
      final outcome = await generateOutcome(position);
      outcomes.add(outcome);
    }

    return outcomes;
  }

  // ===== STATISTICS =====

  /// Get outcome distribution statistics (for testing/validation)
  Map<OutcomeType, double> getOutcomeDistribution(int sampleSize) {
    final distribution = <OutcomeType, int>{
      OutcomeType.redeemed: 0,
      OutcomeType.foreclosed: 0,
      OutcomeType.partialPayment: 0,
      OutcomeType.loss: 0,
    };

    // Generate sample outcomes
    final samplePosition = SimulatedPosition.create(
      portfolioId: 'test',
      propertyId: 'test',
      propertyAddress: '123 Test St',
      county: 'Test County',
      state: 'FL',
      purchasePrice: 10000,
      estimatedValue: 50000,
      interestRate: 12,
      propertyType: 'Residential',
      images: [],
    );

    for (int i = 0; i < sampleSize; i++) {
      final outcome = _generateRuleBasedOutcome(samplePosition);
      distribution[outcome.type] = (distribution[outcome.type] ?? 0) + 1;
    }

    // Convert to percentages
    return distribution.map(
      (type, count) => MapEntry(type, (count / sampleSize) * 100),
    );
  }
}
