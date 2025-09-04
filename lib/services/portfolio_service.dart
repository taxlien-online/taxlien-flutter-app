import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../core/models/tax_lien_models.dart';
import '../core/models/magento_models.dart';

/// Enhanced portfolio management service
class PortfolioService extends ChangeNotifier {
  static const String _baseUrl = 'https://api.taxlien.online';
  
  // Portfolio data
  List<TaxLien> _myLiens = [];
  List<MagentoProduct> _myProducts = [];
  List<PortfolioTransaction> _transactions = [];
  List<PortfolioAlert> _alerts = [];
  PortfolioPerformance? _performance;
  PortfolioGoals? _goals;
  
  // State
  bool _isLoading = false;
  String? _error;
  DateTime? _lastUpdated;
  
  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime? get lastUpdated => _lastUpdated;
  List<TaxLien> get myLiens => List.unmodifiable(_myLiens);
  List<MagentoProduct> get myProducts => List.unmodifiable(_myProducts);
  List<PortfolioTransaction> get transactions => List.unmodifiable(_transactions);
  List<PortfolioAlert> get alerts => List.unmodifiable(_alerts);
  PortfolioPerformance? get performance => _performance;
  PortfolioGoals? get goals => _goals;
  
  /// Initialize portfolio service
  Future<void> initialize() async {
    await loadPortfolioData();
    await loadPerformanceData();
    await loadGoals();
    await loadAlerts();
  }
  
  /// Load all portfolio data
  Future<void> loadPortfolioData() async {
    _setLoading(true);
    try {
      await Future.wait([
        loadMyLiens(),
        loadMyProducts(),
        loadTransactions(),
      ]);
      
      _lastUpdated = DateTime.now();
      _setError(null);
    } catch (e) {
      _setError('Failed to load portfolio data: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  /// Load user's tax liens
  Future<void> loadMyLiens() async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock data for now
      _myLiens = _generateMockLiens();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load tax liens: $e');
    }
  }
  
  /// Load user's products
  Future<void> loadMyProducts() async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock data for now
      _myProducts = _generateMockProducts();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }
  
  /// Load transaction history
  Future<void> loadTransactions() async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock data for now
      _transactions = _generateMockTransactions();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load transactions: $e');
    }
  }
  
  /// Load performance data
  Future<void> loadPerformanceData() async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      _performance = _calculatePerformance();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load performance data: $e');
    }
  }
  
  /// Load portfolio goals
  Future<void> loadGoals() async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      _goals = _generateMockGoals();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load goals: $e');
    }
  }
  
  /// Load portfolio alerts
  Future<void> loadAlerts() async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      _alerts = _generateMockAlerts();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load alerts: $e');
    }
  }
  
  /// Add a new goal
  Future<bool> addGoal(PortfolioGoal goal) async {
    try {
      // TODO: Implement API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (_goals != null) {
        _goals = PortfolioGoals(
          goals: [..._goals!.goals, goal],
          totalValue: _goals!.totalValue,
          achievedValue: _goals!.achievedValue,
        );
        notifyListeners();
      }
      
      return true;
    } catch (e) {
      _setError('Failed to add goal: $e');
      return false;
    }
  }
  
  /// Update a goal
  Future<bool> updateGoal(String goalId, PortfolioGoal updatedGoal) async {
    try {
      // TODO: Implement API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (_goals != null) {
        final updatedGoals = _goals!.goals.map((goal) {
          return goal.id == goalId ? updatedGoal : goal;
        }).toList();
        
        _goals = PortfolioGoals(
          goals: updatedGoals,
          totalValue: _goals!.totalValue,
          achievedValue: _goals!.achievedValue,
        );
        notifyListeners();
      }
      
      return true;
    } catch (e) {
      _setError('Failed to update goal: $e');
      return false;
    }
  }
  
  /// Delete a goal
  Future<bool> deleteGoal(String goalId) async {
    try {
      // TODO: Implement API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (_goals != null) {
        final updatedGoals = _goals!.goals.where((goal) => goal.id != goalId).toList();
        
        _goals = PortfolioGoals(
          goals: updatedGoals,
          totalValue: _goals!.totalValue,
          achievedValue: _goals!.achievedValue,
        );
        notifyListeners();
      }
      
      return true;
    } catch (e) {
      _setError('Failed to delete goal: $e');
      return false;
    }
  }
  
  /// Mark alert as read
  Future<bool> markAlertAsRead(String alertId) async {
    try {
      // TODO: Implement API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      final updatedAlerts = _alerts.map((alert) {
        return alert.id == alertId ? alert.copyWith(isRead: true) : alert;
      }).toList();
      
      _alerts = updatedAlerts;
      notifyListeners();
      
      return true;
    } catch (e) {
      _setError('Failed to mark alert as read: $e');
      return false;
    }
  }
  
  /// Get portfolio summary
  PortfolioSummary getPortfolioSummary() {
    final totalInvestment = _myLiens.fold<double>(
      0.0,
      (sum, lien) => sum + (lien.salePrice ?? lien.taxAmount),
    );
    
    final totalProductsValue = _myProducts.fold<double>(
      0.0,
      (sum, product) => sum + (product.price ?? 0),
    );
    
    final currentValue = _calculateCurrentValue();
    final totalReturn = currentValue - totalInvestment;
    final roiPercentage = totalInvestment > 0 ? (totalReturn / totalInvestment) * 100 : 0;
    
    return PortfolioSummary(
      totalInvestment: totalInvestment + totalProductsValue,
      currentValue: currentValue + totalProductsValue,
      totalReturn: totalReturn,
      roiPercentage: roiPercentage,
      activeInvestments: _myLiens.length + _myProducts.length,
      monthlyIncome: _calculateMonthlyIncome(),
      diversificationScore: _calculateDiversificationScore(),
      riskScore: _calculateRiskScore(),
    );
  }
  
  /// Get performance by time period
  List<PerformanceDataPoint> getPerformanceData(TimePeriod period) {
    // TODO: Implement based on actual data
    return _generateMockPerformanceData(period);
  }
  
  /// Get asset allocation
  Map<String, double> getAssetAllocation() {
    final summary = getPortfolioSummary();
    final totalValue = summary.currentValue;
    
    if (totalValue == 0) return {};
    
    final taxLiensValue = _myLiens.fold<double>(
      0.0,
      (sum, lien) => sum + (lien.salePrice ?? lien.taxAmount),
    );
    
    final productsValue = _myProducts.fold<double>(
      0.0,
      (sum, product) => sum + (product.price ?? 0),
    );
    
    return {
      'Tax Liens': (taxLiensValue / totalValue) * 100,
      'Products': (productsValue / totalValue) * 100,
    };
  }
  
  /// Get county distribution
  Map<String, double> getCountyDistribution() {
    final summary = getPortfolioSummary();
    final totalValue = summary.currentValue;
    
    if (totalValue == 0) return {};
    
    final countyValues = <String, double>{};
    
    for (final lien in _myLiens) {
      final value = lien.salePrice ?? lien.taxAmount;
      countyValues[lien.county] = (countyValues[lien.county] ?? 0) + value;
    }
    
    // Convert to percentages
    final result = <String, double>{};
    for (final entry in countyValues.entries) {
      result[entry.key] = (entry.value / totalValue) * 100;
    }
    
    return result;
  }
  
  double _calculateCurrentValue() {
    double currentValue = 0;
    
    for (final lien in _myLiens) {
      final principal = lien.salePrice ?? lien.taxAmount;
      final monthsHeld = DateTime.now().difference(lien.auctionDate).inDays ~/ 30;
      final interest = principal * (lien.interestRate / 100) * (monthsHeld / 12);
      currentValue += principal + interest;
    }
    
    return currentValue;
  }
  
  double _calculateMonthlyIncome() {
    double monthlyIncome = 0;
    
    for (final lien in _myLiens) {
      final principal = lien.salePrice ?? lien.taxAmount;
      monthlyIncome += principal * (lien.interestRate / 100) / 12;
    }
    
    return monthlyIncome;
  }
  
  double _calculateDiversificationScore() {
    // Simple diversification score based on county distribution
    final countyDistribution = getCountyDistribution();
    final numCounties = countyDistribution.length;
    
    if (numCounties == 0) return 0;
    if (numCounties == 1) return 20;
    if (numCounties <= 3) return 40;
    if (numCounties <= 5) return 60;
    if (numCounties <= 10) return 80;
    return 100;
  }
  
  double _calculateRiskScore() {
    // Simple risk score based on interest rates and property values
    if (_myLiens.isEmpty) return 0;
    
    double totalRisk = 0;
    for (final lien in _myLiens) {
      // Higher interest rate = higher risk
      // Lower property value = higher risk
      final interestRisk = lien.interestRate / 20; // Normalize to 0-5 scale
      final valueRisk = lien.assessedValue > 100000 ? 1 : 2; // Lower value = higher risk
      totalRisk += interestRisk * valueRisk;
    }
    
    return (totalRisk / _myLiens.length) * 20; // Normalize to 0-100 scale
  }
  
  PortfolioPerformance _calculatePerformance() {
    final summary = getPortfolioSummary();
    
    return PortfolioPerformance(
      totalReturn: summary.totalReturn,
      roiPercentage: summary.roiPercentage,
      monthlyReturn: summary.monthlyIncome,
      annualizedReturn: summary.roiPercentage,
      sharpeRatio: 1.2, // TODO: Calculate actual Sharpe ratio
      maxDrawdown: -5.2, // TODO: Calculate actual max drawdown
      volatility: 12.5, // TODO: Calculate actual volatility
      beta: 0.8, // TODO: Calculate actual beta
    );
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }
  
  // Mock data generators
  List<TaxLien> _generateMockLiens() {
    return [
      TaxLien(
        id: '1',
        address: '123 Main St, Miami, FL',
        county: 'Miami-Dade',
        state: 'FL',
        parcelId: '123456789',
        owner: 'John Doe',
        taxAmount: 5000.0,
        interestRate: 18.0,
        assessedValue: 150000.0,
        issueDate: DateTime(2023, 1, 15),
        auctionDate: DateTime(2023, 2, 1),
        status: 'active',
        salePrice: 5200.0,
      ),
      TaxLien(
        id: '2',
        address: '456 Oak Ave, Tampa, FL',
        county: 'Hillsborough',
        state: 'FL',
        parcelId: '987654321',
        owner: 'Jane Smith',
        taxAmount: 3200.0,
        interestRate: 15.0,
        assessedValue: 120000.0,
        issueDate: DateTime(2023, 3, 10),
        auctionDate: DateTime(2023, 4, 1),
        status: 'active',
        salePrice: 3300.0,
      ),
    ];
  }
  
  List<MagentoProduct> _generateMockProducts() {
    return [
      MagentoProduct(
        id: 1,
        sku: 'TL-001',
        name: 'Premium Tax Lien Certificate',
        price: 2500.0,
        typeId: 'tax_lien',
        status: 'active',
      ),
    ];
  }
  
  List<PortfolioTransaction> _generateMockTransactions() {
    return [
      PortfolioTransaction(
        id: '1',
        type: TransactionType.purchase,
        assetType: AssetType.taxLien,
        assetId: '1',
        amount: 5200.0,
        date: DateTime(2023, 2, 1),
        description: 'Purchased tax lien for 123 Main St',
        status: TransactionStatus.completed,
      ),
      PortfolioTransaction(
        id: '2',
        type: TransactionType.purchase,
        assetType: AssetType.taxLien,
        assetId: '2',
        amount: 3300.0,
        date: DateTime(2023, 4, 1),
        description: 'Purchased tax lien for 456 Oak Ave',
        status: TransactionStatus.completed,
      ),
    ];
  }
  
  PortfolioGoals _generateMockGoals() {
    return PortfolioGoals(
      goals: [
        PortfolioGoal(
          id: '1',
          title: 'Retirement Fund',
          targetAmount: 100000.0,
          currentAmount: 8500.0,
          targetDate: DateTime(2030, 12, 31),
          priority: GoalPriority.high,
          status: GoalStatus.active,
        ),
        PortfolioGoal(
          id: '2',
          title: 'Emergency Fund',
          targetAmount: 25000.0,
          currentAmount: 5000.0,
          targetDate: DateTime(2024, 12, 31),
          priority: GoalPriority.medium,
          status: GoalStatus.active,
        ),
      ],
      totalValue: 13500.0,
      achievedValue: 13500.0,
    );
  }
  
  List<PortfolioAlert> _generateMockAlerts() {
    return [
      PortfolioAlert(
        id: '1',
        type: AlertType.opportunity,
        title: 'New High-Yield Opportunity',
        message: 'New tax liens available in Miami-Dade County with 18% interest rates',
        date: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
        actionUrl: '/marketplace',
      ),
      PortfolioAlert(
        id: '2',
        type: AlertType.performance,
        title: 'Portfolio Performance Update',
        message: 'Your portfolio has gained 12.5% this month',
        date: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
        actionUrl: '/portfolio/performance',
      ),
    ];
  }
  
  List<PerformanceDataPoint> _generateMockPerformanceData(TimePeriod period) {
    final now = DateTime.now();
    final data = <PerformanceDataPoint>[];
    
    for (int i = 30; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final value = 10000 + (i * 50) + (i % 7 * 100); // Mock growth
      data.add(PerformanceDataPoint(date: date, value: value));
    }
    
    return data;
  }
}

// Models
class PortfolioSummary {
  final double totalInvestment;
  final double currentValue;
  final double totalReturn;
  final double roiPercentage;
  final int activeInvestments;
  final double monthlyIncome;
  final double diversificationScore;
  final double riskScore;

  const PortfolioSummary({
    required this.totalInvestment,
    required this.currentValue,
    required this.totalReturn,
    required this.roiPercentage,
    required this.activeInvestments,
    required this.monthlyIncome,
    required this.diversificationScore,
    required this.riskScore,
  });
}

class PortfolioPerformance {
  final double totalReturn;
  final double roiPercentage;
  final double monthlyReturn;
  final double annualizedReturn;
  final double sharpeRatio;
  final double maxDrawdown;
  final double volatility;
  final double beta;

  const PortfolioPerformance({
    required this.totalReturn,
    required this.roiPercentage,
    required this.monthlyReturn,
    required this.annualizedReturn,
    required this.sharpeRatio,
    required this.maxDrawdown,
    required this.volatility,
    required this.beta,
  });
}

class PortfolioGoals {
  final List<PortfolioGoal> goals;
  final double totalValue;
  final double achievedValue;

  const PortfolioGoals({
    required this.goals,
    required this.totalValue,
    required this.achievedValue,
  });
}

class PortfolioGoal {
  final String id;
  final String title;
  final double targetAmount;
  final double currentAmount;
  final DateTime targetDate;
  final GoalPriority priority;
  final GoalStatus status;

  const PortfolioGoal({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
    required this.targetDate,
    required this.priority,
    required this.status,
  });

  double get progressPercentage => (currentAmount / targetAmount) * 100;
  Duration get timeRemaining => targetDate.difference(DateTime.now());
}

enum GoalPriority { low, medium, high }
enum GoalStatus { active, paused, completed, cancelled }

class PortfolioTransaction {
  final String id;
  final TransactionType type;
  final AssetType assetType;
  final String assetId;
  final double amount;
  final DateTime date;
  final String description;
  final TransactionStatus status;

  const PortfolioTransaction({
    required this.id,
    required this.type,
    required this.assetType,
    required this.assetId,
    required this.amount,
    required this.date,
    required this.description,
    required this.status,
  });
}

enum TransactionType { purchase, sale, dividend, interest, fee }
enum AssetType { taxLien, product, nft }
enum TransactionStatus { pending, completed, failed, cancelled }

class PortfolioAlert {
  final String id;
  final AlertType type;
  final String title;
  final String message;
  final DateTime date;
  final bool isRead;
  final String? actionUrl;

  const PortfolioAlert({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.date,
    required this.isRead,
    this.actionUrl,
  });

  PortfolioAlert copyWith({
    String? id,
    AlertType? type,
    String? title,
    String? message,
    DateTime? date,
    bool? isRead,
    String? actionUrl,
  }) {
    return PortfolioAlert(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      date: date ?? this.date,
      isRead: isRead ?? this.isRead,
      actionUrl: actionUrl ?? this.actionUrl,
    );
  }
}

enum AlertType { opportunity, performance, risk, reminder, system }

class PerformanceDataPoint {
  final DateTime date;
  final double value;

  const PerformanceDataPoint({
    required this.date,
    required this.value,
  });
}

enum TimePeriod { day, week, month, quarter, year, all }
