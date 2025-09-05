import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
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
      final response = await http.get(
        Uri.parse('$_baseUrl/api/portfolio/liens'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _myLiens = (data['liens'] as List)
            .map((json) => TaxLien.fromJson(json))
            .toList();
      } else {
        // Fallback to mock data for development
        _myLiens = _generateMockLiens();
      }
      notifyListeners();
    } catch (e) {
      // Fallback to mock data for development
      _myLiens = _generateMockLiens();
      notifyListeners();
    }
  }
  
  /// Load user's products
  Future<void> loadMyProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/portfolio/products'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _myProducts = (data['products'] as List)
            .map((json) => MagentoProduct.fromJson(json))
            .toList();
      } else {
        // Fallback to mock data for development
        _myProducts = _generateMockProducts();
      }
      notifyListeners();
    } catch (e) {
      // Fallback to mock data for development
      _myProducts = _generateMockProducts();
      notifyListeners();
    }
  }
  
  /// Load transaction history
  Future<void> loadTransactions() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/portfolio/transactions'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _transactions = (data['transactions'] as List)
            .map((json) => PortfolioTransaction.fromJson(json))
            .toList();
      } else {
        // Fallback to mock data for development
        _transactions = _generateMockTransactions();
      }
      notifyListeners();
    } catch (e) {
      // Fallback to mock data for development
      _transactions = _generateMockTransactions();
      notifyListeners();
    }
  }
  
  /// Load performance data
  Future<void> loadPerformanceData() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/portfolio/performance'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _performance = PortfolioPerformance(
          totalReturn: data['totalReturn'].toDouble(),
          roiPercentage: data['roiPercentage'].toDouble(),
          monthlyReturn: data['monthlyReturn'].toDouble(),
          annualizedReturn: data['annualizedReturn'].toDouble(),
          sharpeRatio: data['sharpeRatio'].toDouble(),
          maxDrawdown: data['maxDrawdown'].toDouble(),
          volatility: data['volatility'].toDouble(),
          beta: data['beta'].toDouble(),
        );
      } else {
        // Fallback to calculated performance
        _performance = _calculatePerformance();
      }
      notifyListeners();
    } catch (e) {
      // Fallback to calculated performance
      _performance = _calculatePerformance();
      notifyListeners();
    }
  }
  
  /// Load portfolio goals
  Future<void> loadGoals() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/portfolio/goals'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _goals = PortfolioGoals(
          goals: (data['goals'] as List)
              .map((json) => PortfolioGoal.fromJson(json))
              .toList(),
          totalValue: data['totalValue'].toDouble(),
          achievedValue: data['achievedValue'].toDouble(),
        );
      } else {
        // Fallback to mock data for development
        _goals = _generateMockGoals();
      }
      notifyListeners();
    } catch (e) {
      // Fallback to mock data for development
      _goals = _generateMockGoals();
      notifyListeners();
    }
  }
  
  /// Load portfolio alerts
  Future<void> loadAlerts() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/portfolio/alerts'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _alerts = (data['alerts'] as List)
            .map((json) => PortfolioAlert.fromJson(json))
            .toList();
      } else {
        // Fallback to mock data for development
        _alerts = _generateMockAlerts();
      }
      notifyListeners();
    } catch (e) {
      // Fallback to mock data for development
      _alerts = _generateMockAlerts();
      notifyListeners();
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
      sharpeRatio: _calculateSharpeRatio(),
      maxDrawdown: _calculateMaxDrawdown(),
      volatility: _calculateVolatility(),
      beta: _calculateBeta()
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
  
  /// Calculate Sharpe ratio
  double _calculateSharpeRatio() {
    if (_performance == null) return 0.0;
    
    // Risk-free rate (assume 2% annually)
    const riskFreeRate = 0.02;
    
    // Calculate excess return
    final excessReturn = _performance!.annualizedReturn - riskFreeRate;
    
    // Calculate volatility (standard deviation of returns)
    final volatility = _calculateVolatility();
    
    if (volatility == 0) return 0.0;
    
    return excessReturn / volatility;
  }
  
  /// Calculate maximum drawdown
  double _calculateMaxDrawdown() {
    if (_performance == null) return 0.0;
    
    // Get performance data points
    final performanceData = _generateMockPerformanceData(TimePeriod.month);
    if (performanceData.length < 2) return 0.0;
    
    double maxValue = performanceData.first.value;
    double maxDrawdown = 0.0;
    
    for (final point in performanceData) {
      if (point.value > maxValue) {
        maxValue = point.value;
      }
      
      final drawdown = (maxValue - point.value) / maxValue;
      if (drawdown > maxDrawdown) {
        maxDrawdown = drawdown;
      }
    }
    
    return -maxDrawdown * 100; // Return as negative percentage
  }
  
  /// Calculate volatility (standard deviation of returns)
  double _calculateVolatility() {
    if (_performance == null) return 0.0;
    
    // Get performance data points
    final performanceData = _generateMockPerformanceData(TimePeriod.month);
    if (performanceData.length < 2) return 0.0;
    
    // Calculate daily returns
    final returns = <double>[];
    for (int i = 1; i < performanceData.length; i++) {
      final currentValue = performanceData[i].value;
      final previousValue = performanceData[i - 1].value;
      final dailyReturn = (currentValue - previousValue) / previousValue;
      returns.add(dailyReturn);
    }
    
    // Calculate mean return
    final meanReturn = returns.reduce((a, b) => a + b) / returns.length;
    
    // Calculate variance
    final variance = returns.map((r) => (r - meanReturn) * (r - meanReturn))
        .reduce((a, b) => a + b) / returns.length;
    
    // Calculate standard deviation (volatility)
    final volatility = math.sqrt(variance);
    
    // Annualize volatility (assuming daily data)
    return volatility * math.sqrt(252) * 100; // Return as percentage
  }
  
  /// Calculate beta (correlation with market)
  double _calculateBeta() {
    if (_performance == null) return 1.0;
    
    // For now, return a mock beta based on portfolio composition
    // In a real implementation, this would compare portfolio returns
    // to a market index (e.g., S&P 500)
    
    final summary = getPortfolioSummary();
    
    // Higher diversification typically means lower beta
    if (summary.diversificationScore > 0.8) {
      return 0.6; // Low beta for well-diversified portfolio
    } else if (summary.diversificationScore > 0.5) {
      return 0.8; // Medium beta
    } else {
      return 1.2; // High beta for concentrated portfolio
    }
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

  factory PortfolioGoal.fromJson(Map<String, dynamic> json) {
    return PortfolioGoal(
      id: json['id'],
      title: json['title'],
      targetAmount: json['targetAmount'].toDouble(),
      currentAmount: json['currentAmount'].toDouble(),
      targetDate: DateTime.parse(json['targetDate']),
      priority: GoalPriority.values.firstWhere(
        (e) => e.toString().split('.').last == json['priority'],
        orElse: () => GoalPriority.medium,
      ),
      status: GoalStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => GoalStatus.active,
      ),
    );
  }
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

  factory PortfolioTransaction.fromJson(Map<String, dynamic> json) {
    return PortfolioTransaction(
      id: json['id'],
      type: TransactionType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => TransactionType.purchase,
      ),
      assetType: AssetType.values.firstWhere(
        (e) => e.toString().split('.').last == json['assetType'],
        orElse: () => AssetType.taxLien,
      ),
      assetId: json['assetId'],
      amount: json['amount'].toDouble(),
      date: DateTime.parse(json['date']),
      description: json['description'],
      status: TransactionStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => TransactionStatus.completed,
      ),
    );
  }
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

  factory PortfolioAlert.fromJson(Map<String, dynamic> json) {
    return PortfolioAlert(
      id: json['id'],
      type: AlertType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => AlertType.system,
      ),
      title: json['title'],
      message: json['message'],
      date: DateTime.parse(json['date']),
      isRead: json['isRead'] ?? false,
      actionUrl: json['actionUrl'],
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
