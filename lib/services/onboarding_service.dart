import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Сервис для управления onboarding в FreeDome Manager
/// Позволяет показывать вводный экран для новых пользователей
class OnboardingService extends ChangeNotifier {
  static const String _onboardingCompletedKey = 'freedome_onboarding_completed';
  static const String _lastOnboardingVersionKey = 'freedome_last_onboarding_version';
  static const String _currentOnboardingStepKey = 'freedome_current_onboarding_step';
  static const String _onboardingSkippedKey = 'freedome_onboarding_skipped';
  
  bool _isOnboardingCompleted = false;
  bool _isOnboardingSkipped = false;
  String _lastOnboardingVersion = '';
  int _currentStep = 0;
  bool _isNavigating = false; // Флаг для предотвращения множественных переходов
  
  bool get isOnboardingCompleted => _isOnboardingCompleted;
  bool get isOnboardingSkipped => _isOnboardingSkipped;
  String get lastOnboardingVersion => _lastOnboardingVersion;
  int get currentStep => _currentStep;
  bool get isNavigating => _isNavigating;
  
  /// Инициализация сервиса
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isOnboardingCompleted = prefs.getBool(_onboardingCompletedKey) ?? false;
      _isOnboardingSkipped = prefs.getBool(_onboardingSkippedKey) ?? false;
      _lastOnboardingVersion = prefs.getString(_lastOnboardingVersionKey) ?? '';
      _currentStep = prefs.getInt(_currentOnboardingStepKey) ?? 0;
    } catch (e) {
      // В тестовой среде SharedPreferences может быть недоступен
      _isOnboardingCompleted = false;
      _isOnboardingSkipped = false;
      _lastOnboardingVersion = '';
      _currentStep = 0;
    }
    notifyListeners();
  }
  
  /// Установка текущего шага
  Future<void> setCurrentStep(int step) async {
    if (step < 0 || step >= totalSteps) return;
    
    _isNavigating = true;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_currentOnboardingStepKey, step);
    } catch (e) {
      // В тестовой среде SharedPreferences может быть недоступен
    }
    
    _currentStep = step;
    _isNavigating = false;
    notifyListeners();
  }
  
  /// Завершение onboarding
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
      // В тестовой среде SharedPreferences может быть недоступен
    }
    
    _isOnboardingCompleted = true;
    _isOnboardingSkipped = false;
    _currentStep = 0;
    _isNavigating = false;
    notifyListeners();
  }
  
  /// Пропуск onboarding
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
      // В тестовой среде SharedPreferences может быть недоступен
    }
    
    _isOnboardingCompleted = true;
    _isOnboardingSkipped = true;
    _currentStep = 0;
    _isNavigating = false;
    notifyListeners();
  }
  
  /// Проверка необходимости показа onboarding
  bool shouldShowOnboarding() {
    return !_isOnboardingCompleted || _lastOnboardingVersion != '1.0.0';
  }
  
  /// Проверка, был ли onboarding пропущен
  bool wasOnboardingSkipped() {
    return _isOnboardingSkipped;
  }
  
  /// Сброс onboarding (для тестирования)
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
      // В тестовой среде SharedPreferences может быть недоступен
    }
    
    _isOnboardingCompleted = false;
    _isOnboardingSkipped = false;
    _lastOnboardingVersion = '';
    _currentStep = 0;
    _isNavigating = false;
    notifyListeners();
  }
  
  /// Получить общее количество шагов onboarding
  int get totalSteps => 6;
  
  /// Получить прогресс onboarding
  double get progress => _currentStep / (totalSteps - 1);
  
  /// Проверка, является ли текущий шаг последним
  bool get isLastStep => _currentStep >= totalSteps - 1;
  
  /// Проверка, является ли текущий шаг первым
  bool get isFirstStep => _currentStep == 0;
  
  /// Проверка, можно ли перейти к следующему шагу
  bool get canGoNext => _currentStep < totalSteps - 1 && !_isNavigating;
  
  /// Проверка, можно ли перейти к предыдущему шагу
  bool get canGoPrevious => _currentStep > 0 && !_isNavigating;
  
  /// Переход к следующему шагу
  Future<void> nextStep() async {
    if (!canGoNext) return;
    
    try {
      await setCurrentStep(_currentStep + 1);
    } catch (e) {
      // В случае ошибки сбрасываем флаг навигации
      _isNavigating = false;
      notifyListeners();
      rethrow;
    }
  }
  
  /// Переход к предыдущему шагу
  Future<void> previousStep() async {
    if (!canGoPrevious) return;
    
    try {
      await setCurrentStep(_currentStep - 1);
    } catch (e) {
      // В случае ошибки сбрасываем флаг навигации
      _isNavigating = false;
      notifyListeners();
      rethrow;
    }
  }
  
  /// Переход к конкретному шагу
  Future<void> goToStep(int step) async {
    if (step >= 0 && step < totalSteps && !_isNavigating) {
      await setCurrentStep(step);
    }
  }
  
  /// Переход к первому шагу
  Future<void> goToFirstStep() async {
    await setCurrentStep(0);
  }
  
  /// Переход к последнему шагу
  Future<void> goToLastStep() async {
    await setCurrentStep(totalSteps - 1);
  }
  
  /// Получить информацию о текущем шаге
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
  
  /// Проверка, завершен ли onboarding
  bool get isCompleted => _isOnboardingCompleted;
  
  /// Получить статус onboarding
  String get status {
    if (_isOnboardingCompleted) {
      return _isOnboardingSkipped ? 'skipped' : 'completed';
    }
    return 'in_progress';
  }
  
  /// Проверка, можно ли показать кнопку Skip для текущего шага
  bool canShowSkip(int step) {
    return step < totalSteps - 1; // Не показываем на последнем шаге
  }
  
  /// Проверка, можно ли завершить onboarding
  bool get canCompleteOnboarding => !_isNavigating && isLastStep;
  
  /// Проверка, можно ли пропустить onboarding
  bool get canSkipOnboarding => !_isNavigating && !isLastStep;
} 