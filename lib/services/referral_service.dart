import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';

class ReferralData {
  final String code;
  final int referralCount;
  final double pendingRewards;
  final double totalEarned;

  ReferralData({
    required this.code,
    this.referralCount = 0,
    this.pendingRewards = 0.0,
    this.totalEarned = 0.0,
  });

  factory ReferralData.fromJson(Map<String, dynamic> json) {
    return ReferralData(
      code: json['code'] as String,
      referralCount: json['referralCount'] as int? ?? 0,
      pendingRewards: (json['pendingRewards'] as num? ?? 0.0).toDouble(),
      totalEarned: (json['totalEarned'] as num? ?? 0.0).toDouble(),
    );
  }
}

class ReferralService extends ChangeNotifier {
  final AuthService _authService;
  static const String _referralDataKey = 'user_referral_data';
  
  ReferralData? _currentData;
  bool _isLoading = false;

  ReferralService(this._authService);

  ReferralData? get currentData => _currentData;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    if (_authService.currentUser == null) return;
    
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? rawData = prefs.getString('${_referralDataKey}_${_authService.currentUser!.id}');
      
      if (rawData != null) {
        // In real app, fetch latest stats from backend here
        _currentData = ReferralData(code: _generateCode()); // Placeholder for existing code
      } else {
        // Generate new referral code for user
        final newCode = _generateCode();
        _currentData = ReferralData(code: newCode);
        await _saveData();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _generateCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        6, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  Future<void> _saveData() async {
    if (_currentData == null || _authService.currentUser == null) return;
    
    final prefs = await SharedPreferences.getInstance();
    // This would be a POST to backend in production
    await prefs.setString('${_referralDataKey}_${_authService.currentUser!.id}', _currentData!.code);
  }

  /// Simulate applying a referral code from another user
  Future<bool> applyReferralCode(String code) async {
    // In production: POST /api/referrals/apply { code }
    await Future.delayed(const Duration(seconds: 1));
    return code.length == 6; 
  }
}
