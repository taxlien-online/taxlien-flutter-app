import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  final String? investmentType; // 'lien' or 'deed' (comma-separated for multiple)
  final String? profitType; // 'guaranteed' or 'collateral'
  final List<String> selectedCounties;
  final List<String> selectedStates; // New: for state-level selection
  final double investmentAmount;
  final String experienceLevel; // 'beginner', 'intermediate', 'expert'
  final bool notifications;
  final bool autoBidding;
  
  // NFT preferences
  final bool wantsNFTTokenization;
  final bool wantsICPNFT;
  final bool wantsTraditionalNFT;
  final bool wantsFractionalOwnership;
  final bool wantsLiquidityPool;
  final double nftInvestmentPercentage;
  
  final DateTime createdAt;

  UserPreferences({
    this.investmentType,
    this.profitType,
    required this.selectedCounties,
    required this.selectedStates,
    required this.investmentAmount,
    required this.experienceLevel,
    required this.notifications,
    required this.autoBidding,
    required this.wantsNFTTokenization,
    required this.wantsICPNFT,
    required this.wantsTraditionalNFT,
    required this.wantsFractionalOwnership,
    required this.wantsLiquidityPool,
    required this.nftInvestmentPercentage,
    required this.createdAt,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      investmentType: json['investmentType'],
      profitType: json['profitType'],
      selectedCounties: List<String>.from(json['selectedCounties'] ?? []),
      selectedStates: List<String>.from(json['selectedStates'] ?? []),
      investmentAmount: json['investmentAmount']?.toDouble() ?? 1000.0,
      experienceLevel: json['experienceLevel'] ?? 'beginner',
      notifications: json['notifications'] ?? true,
      autoBidding: json['autoBidding'] ?? false,
      wantsNFTTokenization: json['wantsNFTTokenization'] ?? false,
      wantsICPNFT: json['wantsICPNFT'] ?? false,
      wantsTraditionalNFT: json['wantsTraditionalNFT'] ?? false,
      wantsFractionalOwnership: json['wantsFractionalOwnership'] ?? false,
      wantsLiquidityPool: json['wantsLiquidityPool'] ?? false,
      nftInvestmentPercentage: json['nftInvestmentPercentage']?.toDouble() ?? 25.0,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'investmentType': investmentType,
      'profitType': profitType,
      'selectedCounties': selectedCounties,
      'selectedStates': selectedStates,
      'investmentAmount': investmentAmount,
      'experienceLevel': experienceLevel,
      'notifications': notifications,
      'autoBidding': autoBidding,
      'wantsNFTTokenization': wantsNFTTokenization,
      'wantsICPNFT': wantsICPNFT,
      'wantsTraditionalNFT': wantsTraditionalNFT,
      'wantsFractionalOwnership': wantsFractionalOwnership,
      'wantsLiquidityPool': wantsLiquidityPool,
      'nftInvestmentPercentage': nftInvestmentPercentage,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  UserPreferences copyWith({
    String? investmentType,
    String? profitType,
    List<String>? selectedCounties,
    List<String>? selectedStates,
    double? investmentAmount,
    String? experienceLevel,
    bool? notifications,
    bool? autoBidding,
    bool? wantsNFTTokenization,
    bool? wantsICPNFT,
    bool? wantsTraditionalNFT,
    bool? wantsFractionalOwnership,
    bool? wantsLiquidityPool,
    double? nftInvestmentPercentage,
    DateTime? createdAt,
  }) {
    return UserPreferences(
      investmentType: investmentType ?? this.investmentType,
      profitType: profitType ?? this.profitType,
      selectedCounties: selectedCounties ?? this.selectedCounties,
      selectedStates: selectedStates ?? this.selectedStates,
      investmentAmount: investmentAmount ?? this.investmentAmount,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      notifications: notifications ?? this.notifications,
      autoBidding: autoBidding ?? this.autoBidding,
      wantsNFTTokenization: wantsNFTTokenization ?? this.wantsNFTTokenization,
      wantsICPNFT: wantsICPNFT ?? this.wantsICPNFT,
      wantsTraditionalNFT: wantsTraditionalNFT ?? this.wantsTraditionalNFT,
      wantsFractionalOwnership: wantsFractionalOwnership ?? this.wantsFractionalOwnership,
      wantsLiquidityPool: wantsLiquidityPool ?? this.wantsLiquidityPool,
      nftInvestmentPercentage: nftInvestmentPercentage ?? this.nftInvestmentPercentage,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class UserPreferencesService extends ChangeNotifier {
  static const String _preferencesKey = 'user_preferences';
  
  UserPreferences? _preferences;
  bool _isLoading = false;

  UserPreferences? get preferences => _preferences;
  bool get isLoading => _isLoading;
  bool get hasPreferences => _preferences != null;

  Future<void> initialize() async {
    await loadPreferences();
  }

  Future<void> loadPreferences() async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_preferencesKey);
      
      if (jsonString != null) {
        final json = Map<String, dynamic>.from(
          jsonDecode(jsonString) as Map,
        );
        _preferences = UserPreferences.fromJson(json);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading preferences: $e');
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> savePreferences(UserPreferences preferences) async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(preferences.toJson());
      await prefs.setString(_preferencesKey, jsonString);
      _preferences = preferences;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error saving preferences: $e');
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updatePreferences(Map<String, dynamic> updates) async {
    if (_preferences == null) return;
    
    final updatedPreferences = _preferences!.copyWith(
      investmentType: updates['investmentType'],
      profitType: updates['profitType'],
      selectedCounties: updates['selectedCounties'],
      investmentAmount: updates['investmentAmount'],
      experienceLevel: updates['experienceLevel'],
      notifications: updates['notifications'],
      autoBidding: updates['autoBidding'],
    );
    
    await savePreferences(updatedPreferences);
  }

  Future<void> clearPreferences() async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_preferencesKey);
      _preferences = null;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing preferences: $e');
      }
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Helper methods for specific preferences
  bool get prefersLiens => _preferences?.investmentType == 'lien';
  bool get prefersDeeds => _preferences?.investmentType == 'deed';
  bool get prefersGuaranteedProfit => _preferences?.profitType == 'guaranteed';
  bool get prefersCollateralProperty => _preferences?.profitType == 'collateral';
  bool get isBeginner => _preferences?.experienceLevel == 'beginner';
  bool get isIntermediate => _preferences?.experienceLevel == 'intermediate';
  bool get isExpert => _preferences?.experienceLevel == 'expert';
  
  List<String> get preferredCounties => _preferences?.selectedCounties ?? [];
  double get typicalInvestmentAmount => _preferences?.investmentAmount ?? 1000.0;
  bool get wantsNotifications => _preferences?.notifications ?? true;
  bool get wantsAutoBidding => _preferences?.autoBidding ?? false;
  
  // NFT helper methods
  bool get wantsNFTTokenization => _preferences?.wantsNFTTokenization ?? false;
  bool get wantsICPNFT => _preferences?.wantsICPNFT ?? false;
  bool get wantsTraditionalNFT => _preferences?.wantsTraditionalNFT ?? false;
  bool get wantsFractionalOwnership => _preferences?.wantsFractionalOwnership ?? false;
  bool get wantsLiquidityPool => _preferences?.wantsLiquidityPool ?? false;
  double get nftInvestmentPercentage => _preferences?.nftInvestmentPercentage ?? 25.0;
}
