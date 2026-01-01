import 'package:json_annotation/json_annotation.dart';

part 'simulated_position.g.dart';

/// Status of a simulated position
enum PositionStatus {
  /// Position just purchased, waiting for outcome
  purchased,

  /// Simulation in progress, outcome being calculated
  simulating,

  /// Outcome determined, user can view result
  outcomeReady,

  /// User has viewed the outcome
  completed,

  /// Position was manually closed before outcome
  closed,
}

/// Represents a simulated property investment position
///
/// A position tracks a single property investment within a portfolio,
/// including purchase details, current status, and eventual outcome.
@JsonSerializable()
class SimulatedPosition {
  /// Unique identifier for this position
  final String id;

  /// ID of the portfolio this position belongs to
  final String portfolioId;

  /// ID of the property being simulated (from tax lien data)
  final String propertyId;

  /// Property address (cached for display)
  final String propertyAddress;

  /// County where property is located
  final String county;

  /// State where property is located
  final String state;

  /// Simulated purchase price (may differ from real price due to variance)
  final double purchasePrice;

  /// Transaction fees paid
  final double transactionFees;

  /// Total cost (purchase price + fees)
  double get totalCost => purchasePrice + transactionFees;

  /// Current status of this position
  @JsonKey(unknownEnumValue: PositionStatus.purchased)
  final PositionStatus status;

  /// Timestamp when position was created (purchased)
  final DateTime purchasedAt;

  /// Expected timestamp when outcome will be ready (simulated time)
  final DateTime expectedOutcomeAt;

  /// Actual timestamp when outcome was determined
  final DateTime? outcomeAt;

  /// ID of the simulation outcome (if determined)
  final String? outcomeId;

  /// Simulation speed multiplier used
  final double simulationSpeed;

  const SimulatedPosition({
    required this.id,
    required this.portfolioId,
    required this.propertyId,
    required this.propertyAddress,
    required this.county,
    required this.state,
    required this.purchasePrice,
    required this.transactionFees,
    required this.status,
    required this.purchasedAt,
    required this.expectedOutcomeAt,
    required this.simulationSpeed,
    this.outcomeAt,
    this.outcomeId,
  });

  /// Create a copy with updated fields
  SimulatedPosition copyWith({
    String? id,
    String? portfolioId,
    String? propertyId,
    String? propertyAddress,
    String? county,
    String? state,
    double? purchasePrice,
    double? transactionFees,
    PositionStatus? status,
    DateTime? purchasedAt,
    DateTime? expectedOutcomeAt,
    DateTime? outcomeAt,
    String? outcomeId,
    double? simulationSpeed,
  }) {
    return SimulatedPosition(
      id: id ?? this.id,
      portfolioId: portfolioId ?? this.portfolioId,
      propertyId: propertyId ?? this.propertyId,
      propertyAddress: propertyAddress ?? this.propertyAddress,
      county: county ?? this.county,
      state: state ?? this.state,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      transactionFees: transactionFees ?? this.transactionFees,
      status: status ?? this.status,
      purchasedAt: purchasedAt ?? this.purchasedAt,
      expectedOutcomeAt: expectedOutcomeAt ?? this.expectedOutcomeAt,
      outcomeAt: outcomeAt ?? this.outcomeAt,
      outcomeId: outcomeId ?? this.outcomeId,
      simulationSpeed: simulationSpeed ?? this.simulationSpeed,
    );
  }

  /// Create a new position from a property purchase
  factory SimulatedPosition.create({
    required String portfolioId,
    required String propertyId,
    required String propertyAddress,
    required String county,
    required String state,
    required double purchasePrice,
    required double transactionFees,
    required int weeksToOutcome,
    double simulationSpeed = 1.0,
  }) {
    final now = DateTime.now();
    final hoursToOutcome = (weeksToOutcome / simulationSpeed).ceil();
    final expectedOutcomeAt = now.add(Duration(hours: hoursToOutcome));

    return SimulatedPosition(
      id: _generateId(),
      portfolioId: portfolioId,
      propertyId: propertyId,
      propertyAddress: propertyAddress,
      county: county,
      state: state,
      purchasePrice: purchasePrice,
      transactionFees: transactionFees,
      status: PositionStatus.purchased,
      purchasedAt: now,
      expectedOutcomeAt: expectedOutcomeAt,
      simulationSpeed: simulationSpeed,
    );
  }

  /// Generate a unique ID for a position
  static String _generateId() {
    return 'position_${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecondsSinceEpoch % 1000}';
  }

  /// Check if outcome is ready to be revealed
  bool get isOutcomeReady {
    return status == PositionStatus.outcomeReady ||
        (status == PositionStatus.simulating &&
            DateTime.now().isAfter(expectedOutcomeAt));
  }

  /// Time remaining until outcome (null if already ready)
  Duration? get timeUntilOutcome {
    if (isOutcomeReady) return null;
    final now = DateTime.now();
    if (now.isAfter(expectedOutcomeAt)) return null;
    return expectedOutcomeAt.difference(now);
  }

  /// JSON serialization
  factory SimulatedPosition.fromJson(Map<String, dynamic> json) =>
      _$SimulatedPositionFromJson(json);

  Map<String, dynamic> toJson() => _$SimulatedPositionToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SimulatedPosition &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'SimulatedPosition(id: $id, propertyAddress: $propertyAddress, status: $status, cost: \$${totalCost.toStringAsFixed(2)})';
  }
}
