import 'package:flutter/foundation.dart';
import '../models/simulated_portfolio.dart';
import '../models/simulated_position.dart';
import '../models/simulation_outcome.dart';
import '../services/simulator_storage_service.dart';
import '../constants/simulator_constants.dart';

/// State management provider for Portfolio Simulator
///
/// Manages portfolios, positions, and simulation state.
/// Uses ChangeNotifier for state updates.
class SimulatorProvider extends ChangeNotifier {
  final SimulatorStorageService _storageService =
      SimulatorStorageService.instance;

  // State flags
  bool _isLoading = false;
  String? _error;

  // User state
  String? _userId;
  bool _isPremium = false;

  // Portfolio state
  List<SimulatedPortfolio> _portfolios = [];
  SimulatedPortfolio? _activePortfolio;

  // Position state
  List<SimulatedPosition> _positions = [];

  // Outcome state
  final Map<String, SimulationOutcome> _outcomes = {};

  // Simulation settings
  double _simulationSpeed = SimulatorConstants.defaultSimulationSpeed;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get userId => _userId;
  bool get isPremium => _isPremium;
  List<SimulatedPortfolio> get portfolios => _portfolios;
  SimulatedPortfolio? get activePortfolio => _activePortfolio;
  List<SimulatedPosition> get positions => _positions;
  double get simulationSpeed => _simulationSpeed;

  int get portfolioCount => _portfolios.length;
  int get activePositionCount => _positions.length;

  bool get canCreatePortfolio {
    if (_isPremium) return true;
    return _portfolios.length < SimulatorConstants.freeMaxPortfolios;
  }

  bool get canAddPosition {
    if (_activePortfolio == null) return false;
    if (_isPremium) return true;
    return _activePortfolio!.positionCount <
        SimulatorConstants.freeMaxPositions;
  }

  /// Check if a specific portfolio can add more positions
  bool canAddPosition(String portfolioId) {
    if (_isPremium) return true;
    final portfolio = _portfolios.firstWhere(
      (p) => p.id == portfolioId,
      orElse: () => _activePortfolio!,
    );
    return portfolio.positionCount < SimulatorConstants.freeMaxPositions;
  }

  // ===== INITIALIZATION =====

  /// Initialize provider with user data
  Future<void> initialize({
    required String userId,
    required bool isPremium,
  }) async {
    _userId = userId;
    _isPremium = isPremium;
    await loadPortfolios();
  }

  // ===== PORTFOLIO OPERATIONS =====

  /// Load all portfolios for current user
  Future<void> loadPortfolios() async {
    if (_userId == null) return;

    _setLoading(true);
    _clearError();

    try {
      _portfolios = await _storageService.getPortfolios(_userId!);

      // Set first portfolio as active if none selected
      if (_activePortfolio == null && _portfolios.isNotEmpty) {
        await setActivePortfolio(_portfolios.first.id);
      }

      _setLoading(false);
    } catch (e) {
      _setError('Failed to load portfolios: $e');
      _setLoading(false);
    }
  }

  /// Create a new portfolio
  Future<bool> createPortfolio({
    required String name,
    required double startingCapital,
  }) async {
    if (_userId == null) {
      _setError('User not initialized');
      return false;
    }

    if (!canCreatePortfolio) {
      _setError(SimulatorConstants.errorMaxPortfolios);
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      final portfolio = SimulatedPortfolio.create(
        name: name,
        userId: _userId!,
        startingCapital: startingCapital,
      );

      await _storageService.savePortfolio(portfolio);
      await loadPortfolios();

      // Set new portfolio as active
      await setActivePortfolio(portfolio.id);

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to create portfolio: $e');
      _setLoading(false);
      return false;
    }
  }

  /// Set active portfolio
  Future<void> setActivePortfolio(String portfolioId) async {
    _setLoading(true);
    _clearError();

    try {
      final portfolio = await _storageService.getPortfolio(portfolioId);
      if (portfolio == null) {
        _setError('Portfolio not found');
        _setLoading(false);
        return;
      }

      _activePortfolio = portfolio;
      await _loadPositions(portfolioId);
      _setLoading(false);
    } catch (e) {
      _setError('Failed to set active portfolio: $e');
      _setLoading(false);
    }
  }

  /// Update portfolio (e.g., after purchase or outcome)
  Future<void> updatePortfolio(SimulatedPortfolio portfolio) async {
    try {
      await _storageService.updatePortfolio(portfolio);

      // Update in-memory list
      final index = _portfolios.indexWhere((p) => p.id == portfolio.id);
      if (index != -1) {
        _portfolios[index] = portfolio;
      }

      // Update active portfolio if it's the same one
      if (_activePortfolio?.id == portfolio.id) {
        _activePortfolio = portfolio;
      }

      notifyListeners();
    } catch (e) {
      _setError('Failed to update portfolio: $e');
    }
  }

  /// Delete a portfolio
  Future<bool> deletePortfolio(String portfolioId) async {
    _setLoading(true);
    _clearError();

    try {
      await _storageService.deletePortfolio(portfolioId);

      // Remove from in-memory list
      _portfolios.removeWhere((p) => p.id == portfolioId);

      // Clear active portfolio if it was deleted
      if (_activePortfolio?.id == portfolioId) {
        _activePortfolio = null;
        _positions.clear();
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to delete portfolio: $e');
      _setLoading(false);
      return false;
    }
  }

  // ===== POSITION OPERATIONS =====

  /// Load positions for a portfolio
  Future<void> _loadPositions(String portfolioId) async {
    try {
      _positions = await _storageService.getPositions(portfolioId);

      // Load outcomes for positions
      for (final position in _positions) {
        if (position.outcomeId != null) {
          final outcome = await _storageService.getOutcome(position.id);
          if (outcome != null) {
            _outcomes[position.id] = outcome;
          }
        }
      }

      notifyListeners();
    } catch (e) {
      _setError('Failed to load positions: $e');
    }
  }

  /// Get outcome for a position
  SimulationOutcome? getOutcome(String positionId) {
    return _outcomes[positionId];
  }

  /// Reload positions (e.g., after purchase or outcome)
  Future<void> reloadPositions() async {
    if (_activePortfolio == null) return;
    await _loadPositions(_activePortfolio!.id);
  }

  /// Add a position to a portfolio (simulate purchase)
  Future<void> addPosition(
    String portfolioId,
    SimulatedPosition position,
  ) async {
    _setLoading(true);
    _clearError();

    try {
      // Get the portfolio
      final portfolio = await _storageService.getPortfolio(portfolioId);
      if (portfolio == null) {
        throw Exception('Portfolio not found');
      }

      // Check if portfolio can afford the purchase
      if (!portfolio.canAfford(position.purchasePrice)) {
        throw Exception('Insufficient capital');
      }

      // Check position limit
      if (!canAddPosition(portfolioId)) {
        throw Exception(SimulatorConstants.errorMaxPositions);
      }

      // Save the position
      await _storageService.savePosition(position);

      // Update portfolio (deduct capital, increment position count)
      final updatedPortfolio = portfolio.copyWith(
        availableCapital: portfolio.availableCapital - position.purchasePrice,
        positionCount: portfolio.positionCount + 1,
      );
      await updatePortfolio(updatedPortfolio);

      // Reload positions
      await reloadPositions();

      _setLoading(false);
    } catch (e) {
      _setError('Failed to add position: $e');
      _setLoading(false);
      rethrow;
    }
  }

  // ===== SIMULATION SETTINGS =====

  /// Set simulation speed multiplier
  void setSimulationSpeed(double speed) {
    if (SimulatorConstants.simulationSpeedOptions.contains(speed)) {
      _simulationSpeed = speed;
      notifyListeners();
    }
  }

  // ===== HELPER METHODS =====

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  /// Clear all state (for logout/reset)
  void clear() {
    _userId = null;
    _isPremium = false;
    _portfolios = [];
    _activePortfolio = null;
    _positions = [];
    _outcomes.clear();
    _simulationSpeed = SimulatorConstants.defaultSimulationSpeed;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
