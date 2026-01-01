import 'package:json_annotation/json_annotation.dart';

part 'simulated_portfolio.g.dart';

/// Represents a simulated investment portfolio
///
/// A portfolio contains virtual capital and a collection of simulated positions.
/// Users can create multiple portfolios to test different investment strategies.
@JsonSerializable()
class SimulatedPortfolio {
  /// Unique identifier for this portfolio
  final String id;

  /// User-provided name for this portfolio
  final String name;

  /// Current available capital (not invested in positions)
  final double availableCapital;

  /// Total value of all positions (invested capital + gains/losses)
  final double investedValue;

  /// Number of active positions in this portfolio
  final int positionCount;

  /// Overall ROI percentage for this portfolio
  final double roi;

  /// Timestamp when this portfolio was created
  final DateTime createdAt;

  /// Timestamp of last update
  final DateTime updatedAt;

  /// User ID who owns this portfolio
  final String userId;

  /// Whether this portfolio is archived
  final bool isArchived;

  const SimulatedPortfolio({
    required this.id,
    required this.name,
    required this.availableCapital,
    required this.investedValue,
    required this.positionCount,
    required this.roi,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    this.isArchived = false,
  });

  /// Total portfolio value (available capital + invested value)
  double get totalValue => availableCapital + investedValue;

  /// Check if portfolio can afford a purchase
  bool canAfford(double amount) => availableCapital >= amount;

  /// Create a copy of this portfolio with updated fields
  SimulatedPortfolio copyWith({
    String? id,
    String? name,
    double? availableCapital,
    double? investedValue,
    int? positionCount,
    double? roi,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
    bool? isArchived,
  }) {
    return SimulatedPortfolio(
      id: id ?? this.id,
      name: name ?? this.name,
      availableCapital: availableCapital ?? this.availableCapital,
      investedValue: investedValue ?? this.investedValue,
      positionCount: positionCount ?? this.positionCount,
      roi: roi ?? this.roi,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  /// Create a new portfolio with default starting capital
  factory SimulatedPortfolio.create({
    required String name,
    required String userId,
    required double startingCapital,
  }) {
    final now = DateTime.now();
    return SimulatedPortfolio(
      id: _generateId(),
      name: name,
      availableCapital: startingCapital,
      investedValue: 0.0,
      positionCount: 0,
      roi: 0.0,
      createdAt: now,
      updatedAt: now,
      userId: userId,
      isArchived: false,
    );
  }

  /// Generate a unique ID for a portfolio
  static String _generateId() {
    return 'portfolio_${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecondsSinceEpoch % 1000}';
  }

  /// JSON serialization
  factory SimulatedPortfolio.fromJson(Map<String, dynamic> json) =>
      _$SimulatedPortfolioFromJson(json);

  Map<String, dynamic> toJson() => _$SimulatedPortfolioToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SimulatedPortfolio &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'SimulatedPortfolio(id: $id, name: $name, totalValue: \$${totalValue.toStringAsFixed(2)}, roi: ${roi.toStringAsFixed(2)}%)';
  }
}
