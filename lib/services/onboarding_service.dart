import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing onboarding in TaxLien.online
/// Allows showing an introductory screen for new users
class OnboardingService extends ChangeNotifier {
  static const String _onboardingCompletedKey = 'freedome_onboarding_completed';
  static const String _lastOnboardingVersionKey = 'freedome_last_onboarding_version';
  static const String _currentOnboardingStepKey = 'freedome_current_onboarding_step';
  static const String _onboardingSkippedKey = 'freedome_onboarding_skipped';
  
  bool _isOnboardingCompleted = false;
  bool _isOnboardingSkipped = false;
  String _lastOnboardingVersion = '';
  int _currentStep = 0;
  bool _isNavigating = false; // Flag to prevent multiple transitions
  
  bool get isOnboardingCompleted => _isOnboardingCompleted;
  bool get isOnboardingSkipped => _isOnboardingSkipped;
  String get lastOnboardingVersion => _lastOnboardingVersion;
  int get currentStep => _currentStep;
  bool get isNavigating => _isNavigating;
  
  /// Initialize the service
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isOnboardingCompleted = prefs.getBool(_onboardingCompletedKey) ?? false;
      _isOnboardingSkipped = prefs.getBool(_onboardingSkippedKey) ?? false;
      _lastOnboardingVersion = prefs.getString(_lastOnboardingVersionKey) ?? '';
      _currentStep = prefs.getInt(_currentOnboardingStepKey) ?? 0;
    } catch (e) {
      // In test environment SharedPreferences may be unavailable
      _isOnboardingCompleted = false;
      _isOnboardingSkipped = false;
      _lastOnboardingVersion = '';
      _currentStep = 0;
    }
    notifyListeners();
  }
  
  /// Set current step
  Future<void> setCurrentStep(int step) async {
    if (step < 0 || step >= totalSteps) return;
    
    _isNavigating = true;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_currentOnboardingStepKey, step);
    } catch (e) {
      // In test environment SharedPreferences may be unavailable
    }
    
    _currentStep = step;
    _isNavigating = false;
    notifyListeners();
  }
  
  /// Complete onboarding
  Future<void> completeOnboarding() async {
    if (_isNavigating) return;
    
    _isNavigating = true;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingCompletedKey, true);
      await prefs.setString(_lastOnboardingVersionKey, '1.0.0');
      await prefs.remove(_currentOnboardingStepKey);
      await prefs.setBool(_onboardingSkippedKey, false);
    } catch (e) {
      // In test environment SharedPreferences may be unavailable
    }
    
    _isOnboardingCompleted = true;
    _isOnboardingSkipped = false;
    _currentStep = 0;
    _isNavigating = false;
    notifyListeners();
  }
  
  /// Skip onboarding
  Future<void> skipOnboarding() async {
    if (_isNavigating) return;
    
    _isNavigating = true;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingCompletedKey, true);
      await prefs.setString(_lastOnboardingVersionKey, '1.0.0');
      await prefs.remove(_currentOnboardingStepKey);
      await prefs.setBool(_onboardingSkippedKey, true);
    } catch (e) {
      // In test environment SharedPreferences may be unavailable
    }
    
    _isOnboardingCompleted = true;
    _isOnboardingSkipped = true;
    _currentStep = 0;
    _isNavigating = false;
    notifyListeners();
  }
  
  /// Check if onboarding should be shown
  bool shouldShowOnboarding() {
    return !_isOnboardingCompleted || _lastOnboardingVersion != '1.0.0';
  }
  
  /// Check if onboarding was skipped
  bool wasOnboardingSkipped() {
    return _isOnboardingSkipped;
  }
  
  /// Reset onboarding (for testing)
  Future<void> resetOnboarding() async {
    if (_isNavigating) return;
    
    _isNavigating = true;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_onboardingCompletedKey);
      await prefs.remove(_lastOnboardingVersionKey);
      await prefs.remove(_currentOnboardingStepKey);
      await prefs.remove(_onboardingSkippedKey);
    } catch (e) {
      // In test environment SharedPreferences may be unavailable
    }
    
    _isOnboardingCompleted = false;
    _isOnboardingSkipped = false;
    _lastOnboardingVersion = '';
    _currentStep = 0;
    _isNavigating = false;
    notifyListeners();
  }
  
  /// Get total number of onboarding steps
  int get totalSteps => 6;
  
  /// Get onboarding progress
  double get progress => _currentStep / (totalSteps - 1);
  
  /// Check if current step is the last
  bool get isLastStep => _currentStep >= totalSteps - 1;
  
  /// Check if current step is the first
  bool get isFirstStep => _currentStep == 0;
  
  /// Check if can go to next step
  bool get canGoNext => _currentStep < totalSteps - 1 && !_isNavigating;
  
  /// Check if can go to previous step
  bool get canGoPrevious => _currentStep > 0 && !_isNavigating;
  
  /// Go to next step
  Future<void> nextStep() async {
    if (!canGoNext) return;
    
    try {
      await setCurrentStep(_currentStep + 1);
    } catch (e) {
      // In case of error, reset navigation flag
      _isNavigating = false;
      notifyListeners();
      rethrow;
    }
  }
  
  /// Go to previous step
  Future<void> previousStep() async {
    if (!canGoPrevious) return;
    
    try {
      await setCurrentStep(_currentStep - 1);
    } catch (e) {
      // In case of error, reset navigation flag
      _isNavigating = false;
      notifyListeners();
      rethrow;
    }
  }
  
  /// Go to specific step
  Future<void> goToStep(int step) async {
    if (step >= 0 && step < totalSteps && !_isNavigating) {
      await setCurrentStep(step);
    }
  }
  
  /// Go to first step
  Future<void> goToFirstStep() async {
    await setCurrentStep(0);
  }
  
  /// Go to last step
  Future<void> goToLastStep() async {
    await setCurrentStep(totalSteps - 1);
  }
  
  /// Get current step information
  Map<String, dynamic> getCurrentStepInfo() {
    return {
      'step': _currentStep,
      'totalSteps': totalSteps,
      'progress': progress,
      'isFirst': isFirstStep,
      'isLast': isLastStep,
      'canGoNext': canGoNext,
      'canGoPrevious': canGoPrevious,
      'isNavigating': _isNavigating,
    };
  }
  
  /// Check if onboarding is completed
  bool get isCompleted => _isOnboardingCompleted;
  
  /// Get onboarding status
  String get status {
    if (_isOnboardingCompleted) {
      return _isOnboardingSkipped ? 'skipped' : 'completed';
    }
    return 'in_progress';
  }
  
  /// Check if Skip button can be shown for current step
  bool canShowSkip(int step) {
    return step < totalSteps - 1; // Don't show on last step
  }
  
  /// Check if onboarding can be completed
  bool get canCompleteOnboarding => !_isNavigating && isLastStep;
  
  /// Check if onboarding can be skipped
  bool get canSkipOnboarding => !_isNavigating && !isLastStep;
} 