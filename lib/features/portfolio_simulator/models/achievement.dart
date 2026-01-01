import 'package:flutter/material.dart';
import '../constants/simulator_constants.dart';

/// Achievement model
///
/// Represents a gamification achievement in the simulator
class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final int targetValue;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final int currentProgress;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.targetValue,
    this.isUnlocked = false,
    this.unlockedAt,
    this.currentProgress = 0,
  });

  /// Calculate progress percentage
  double get progressPercentage {
    if (isUnlocked) return 100.0;
    if (targetValue == 0) return 0.0;
    return ((currentProgress / targetValue) * 100).clamp(0.0, 100.0);
  }

  /// Check if achievement is in progress
  bool get isInProgress => currentProgress > 0 && !isUnlocked;

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    IconData? icon,
    Color? color,
    int? targetValue,
    bool? isUnlocked,
    DateTime? unlockedAt,
    int? currentProgress,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      targetValue: targetValue ?? this.targetValue,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      currentProgress: currentProgress ?? this.currentProgress,
    );
  }

  /// Predefined achievements
  static List<Achievement> getAll() {
    return [
      Achievement(
        id: SimulatorConstants.achievementFirstPurchase,
        title: 'First Steps',
        description: 'Make your first simulated purchase',
        icon: Icons.shopping_cart,
        color: Colors.blue,
        targetValue: 1,
      ),
      Achievement(
        id: SimulatorConstants.achievement10xROI,
        title: '10x Returns',
        description: 'Achieve 1000% ROI on a single position',
        icon: Icons.rocket_launch,
        color: Colors.purple,
        targetValue: 1,
      ),
      Achievement(
        id: SimulatorConstants.achievement100Positions,
        title: 'Century Club',
        description: 'Complete 100 simulated positions',
        icon: Icons.military_tech,
        color: Colors.orange,
        targetValue: 100,
      ),
      Achievement(
        id: SimulatorConstants.achievementMillionaire,
        title: 'Millionaire',
        description: 'Grow your portfolio to \$1,000,000',
        icon: Icons.attach_money,
        color: Colors.green,
        targetValue: 1000000,
      ),
      Achievement(
        id: SimulatorConstants.achievementPerfectWeek,
        title: 'Perfect Week',
        description: 'Win all 7 positions in a single week',
        icon: Icons.star,
        color: Colors.amber,
        targetValue: 7,
      ),
      Achievement(
        id: SimulatorConstants.achievementDiversified,
        title: 'Diversification Master',
        description: 'Invest in properties from 10 different counties',
        icon: Icons.map,
        color: Colors.teal,
        targetValue: 10,
      ),
      Achievement(
        id: SimulatorConstants.achievementRiskTaker,
        title: 'Risk Taker',
        description: 'Complete 50 high-risk positions',
        icon: Icons.trending_up,
        color: Colors.red,
        targetValue: 50,
      ),
      Achievement(
        id: SimulatorConstants.achievementSafePlayer,
        title: 'Safe Player',
        description: 'Complete 50 low-risk positions',
        icon: Icons.shield,
        color: Colors.cyan,
        targetValue: 50,
      ),
      Achievement(
        id: SimulatorConstants.achievementQuickFlip,
        title: 'Quick Flip',
        description: 'Get redeemed in under 4 simulated weeks',
        icon: Icons.flash_on,
        color: Colors.yellow,
        targetValue: 1,
      ),
      Achievement(
        id: SimulatorConstants.achievementLongHold,
        title: 'Patient Investor',
        description: 'Hold a position for 24+ simulated weeks',
        icon: Icons.access_time,
        color: Colors.indigo,
        targetValue: 1,
      ),
    ];
  }

  /// Get achievement by ID
  static Achievement? getById(String id) {
    try {
      return getAll().firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }
}
