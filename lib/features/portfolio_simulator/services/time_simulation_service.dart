import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/simulated_position.dart';
import '../models/simulation_outcome.dart';
import '../constants/simulator_constants.dart';
import 'simulator_storage_service.dart';
import 'outcome_generation_service.dart';

/// Time simulation service for portfolio simulator
///
/// Manages accelerated time simulation and triggers outcome generation
/// when positions are ready.
class TimeSimulationService extends ChangeNotifier {
  static final TimeSimulationService _instance =
      TimeSimulationService._internal();
  factory TimeSimulationService() => _instance;
  TimeSimulationService._internal();

  final SimulatorStorageService _storageService =
      SimulatorStorageService.instance;
  final OutcomeGenerationService _outcomeService =
      OutcomeGenerationService.instance;

  Timer? _timer;
  bool _isRunning = false;
  double _simulationSpeed = SimulatorConstants.defaultSimulationSpeed;

  // Active positions being tracked
  final Map<String, SimulatedPosition> _activePositions = {};

  // ===== GETTERS =====

  bool get isRunning => _isRunning;
  double get simulationSpeed => _simulationSpeed;
  int get activePositionCount => _activePositions.length;

  // ===== ENGINE CONTROL =====

  /// Start the time simulation engine
  void start() {
    if (_isRunning) return;

    _isRunning = true;
    _startTimer();
    notifyListeners();

    debugPrint('🕐 Time simulation engine started');
  }

  /// Stop the time simulation engine
  void stop() {
    if (!_isRunning) return;

    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    notifyListeners();

    debugPrint('⏸️ Time simulation engine stopped');
  }

  /// Set simulation speed multiplier
  void setSimulationSpeed(double speed) {
    if (!SimulatorConstants.simulationSpeedOptions.contains(speed)) {
      debugPrint('⚠️ Invalid simulation speed: $speed');
      return;
    }

    _simulationSpeed = speed;
    notifyListeners();

    // Restart timer with new speed if running
    if (_isRunning) {
      _timer?.cancel();
      _startTimer();
    }

    debugPrint('⚡ Simulation speed set to ${speed}x');
  }

  // ===== POSITION TRACKING =====

  /// Register a position for time tracking
  void trackPosition(SimulatedPosition position) {
    if (position.status != PositionStatus.simulating) {
      debugPrint('⚠️ Cannot track position with status: ${position.status}');
      return;
    }

    _activePositions[position.id] = position;
    notifyListeners();

    debugPrint('📍 Tracking position: ${position.id} (${position.propertyAddress})');

    // Start engine if not running
    if (!_isRunning) {
      start();
    }
  }

  /// Unregister a position from time tracking
  void untrackPosition(String positionId) {
    _activePositions.remove(positionId);
    notifyListeners();

    debugPrint('🗑️ Stopped tracking position: $positionId');

    // Stop engine if no active positions
    if (_activePositions.isEmpty) {
      stop();
    }
  }

  /// Load all active positions from storage
  Future<void> loadActivePositions(String userId) async {
    try {
      // Get all portfolios for user
      final portfolios = await _storageService.getPortfolios(userId);

      // Get all positions for each portfolio
      for (final portfolio in portfolios) {
        final positions = await _storageService.getPositions(portfolio.id);

        // Track positions that are simulating
        for (final position in positions) {
          if (position.status == PositionStatus.simulating) {
            _activePositions[position.id] = position;
          }
        }
      }

      notifyListeners();

      debugPrint('📦 Loaded ${_activePositions.length} active positions');

      // Start engine if there are active positions
      if (_activePositions.isNotEmpty && !_isRunning) {
        start();
      }
    } catch (e) {
      debugPrint('❌ Failed to load active positions: $e');
    }
  }

  // ===== PRIVATE METHODS =====

  /// Start the background timer
  void _startTimer() {
    // Timer ticks every minute (real time)
    // Each tick represents simulated time based on speed multiplier
    const tickInterval = Duration(minutes: 1);

    _timer = Timer.periodic(tickInterval, (timer) {
      _onTimerTick();
    });
  }

  /// Handle timer tick - check for ready outcomes
  Future<void> _onTimerTick() async {
    if (_activePositions.isEmpty) {
      stop();
      return;
    }

    debugPrint('⏰ Timer tick - checking ${_activePositions.length} positions');

    final now = DateTime.now();
    final readyPositions = <SimulatedPosition>[];

    // Check which positions are ready for outcomes
    for (final position in _activePositions.values) {
      if (position.isOutcomeReady(now, _simulationSpeed)) {
        readyPositions.add(position);
      }
    }

    if (readyPositions.isEmpty) {
      debugPrint('⏳ No positions ready yet');
      return;
    }

    debugPrint('✅ ${readyPositions.length} positions ready for outcomes');

    // Generate outcomes for ready positions
    for (final position in readyPositions) {
      await _generateOutcome(position);
    }

    notifyListeners();
  }

  /// Generate outcome for a position
  Future<void> _generateOutcome(SimulatedPosition position) async {
    try {
      debugPrint('🎲 Generating outcome for position: ${position.id}');

      // Generate outcome using ML service or rule-based fallback
      final outcome = await _outcomeService.generateOutcome(position);

      // Save outcome to storage
      await _storageService.saveOutcome(outcome);

      // Update position status
      final updatedPosition = position.copyWith(
        status: PositionStatus.outcomeReady,
        outcomeId: outcome.id,
      );
      await _storageService.updatePositionStatus(
        updatedPosition.id,
        PositionStatus.outcomeReady,
        outcomeId: outcome.id,
      );

      // Remove from active tracking
      untrackPosition(position.id);

      debugPrint('🎉 Outcome generated: ${outcome.type} (ROI: ${outcome.roi}%)');

      // TODO: Send push notification to user
      _sendOutcomeNotification(position, outcome);
    } catch (e) {
      debugPrint('❌ Failed to generate outcome for ${position.id}: $e');
    }
  }

  /// Send push notification when outcome is ready
  void _sendOutcomeNotification(
    SimulatedPosition position,
    SimulationOutcome outcome,
  ) {
    // TODO: Implement push notification via Firebase
    debugPrint('🔔 Notification: Outcome ready for ${position.propertyAddress}');
  }

  // ===== LIFECYCLE =====

  /// Clean up resources
  void dispose() {
    stop();
    _activePositions.clear();
    super.dispose();
  }
}
