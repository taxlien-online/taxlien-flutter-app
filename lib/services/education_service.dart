import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/models/education_models.dart';
import 'auth_service.dart';

class EducationService extends ChangeNotifier {
  final AuthService _authService;
  static const String _progressKeyPrefix = 'edu_progress_';
  
  UserEduProgress? _currentProgress;
  List<EduModule> _modules = [];
  bool _isLoading = false;

  EducationService(this._authService);

  UserEduProgress? get currentProgress => _currentProgress;
  List<EduModule> get modules => _modules;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Load static module definitions (In production, these come from API)
      _modules = _getStaticModules();
      
      // 2. Load user progress from local storage
      if (_authService.currentUser != null) {
        await _loadProgress(_authService.currentUser!.id);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadProgress(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('$_progressKeyPrefix$userId');
    
    if (data != null) {
      final json = jsonDecode(data);
      _currentProgress = UserEduProgress(
        userId: userId,
        completedLessons: Map<String, bool>.from(json['completedLessons'] ?? {}),
        quizScores: Map<String, int>.from(json['quizScores'] ?? {}),
        unlockedAchievements: List<String>.from(json['unlockedAchievements'] ?? []),
      );
    } else {
      _currentProgress = UserEduProgress(userId: userId);
    }
  }

  Future<void> _saveProgress() async {
    if (_currentProgress == null) return;
    
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode({
      'completedLessons': _currentProgress!.completedLessons,
      'quizScores': _currentProgress!.quizScores,
      'unlockedAchievements': _currentProgress!.unlockedAchievements,
    });
    
    await prefs.setString('$_progressKeyPrefix${_currentProgress!.userId}', data);
    notifyListeners();
  }

  Future<void> completeLesson(String lessonId) async {
    if (_currentProgress == null) return;
    
    final updatedLessons = Map<String, bool>.from(_currentProgress!.completedLessons);
    updatedLessons[lessonId] = true;
    
    _currentProgress = UserEduProgress(
      userId: _currentProgress!.userId,
      completedLessons: updatedLessons,
      quizScores: _currentProgress!.quizScores,
      unlockedAchievements: _currentProgress!.unlockedAchievements,
    );
    
    await _checkAndUnlockAchievements();
    await _saveProgress();
  }

  Future<void> _checkAndUnlockAchievements() async {
    if (_currentProgress == null) return;

    final updatedAchievements = List<String>.from(_currentProgress!.unlockedAchievements);
    bool added = false;

    // Module 1 (Basics) -> Unlock Search
    if (_isModuleCompleted('mod1') && !updatedAchievements.contains('feature_search')) {
      updatedAchievements.add('feature_search');
      added = true;
    }

    // Module 2 (Research) -> Unlock County Data
    if (_isModuleCompleted('mod2') && !updatedAchievements.contains('feature_county_data')) {
      updatedAchievements.add('feature_county_data');
      added = true;
    }

    // Module 3 (Strategy) -> Unlock AI Predictions
    if (_isModuleCompleted('mod3') && !updatedAchievements.contains('feature_ai_predictions')) {
      updatedAchievements.add('feature_ai_predictions');
      added = true;
    }

    if (added) {
      _currentProgress = UserEduProgress(
        userId: _currentProgress!.userId,
        completedLessons: _currentProgress!.completedLessons,
        quizScores: _currentProgress!.quizScores,
        unlockedAchievements: updatedAchievements,
      );
      debugPrint('EducationService: Unlocked achievements: $updatedAchievements');
    }
  }

  bool _isModuleCompleted(String moduleId) {
    final module = _modules.firstWhere((m) => m.id == moduleId, orElse: () => EduModule(id: '', title: '', description: '', lessons: [], order: 0));
    if (module.id.isEmpty || module.lessons.isEmpty) return false;
    
    return module.lessons.every((lesson) => _currentProgress?.completedLessons[lesson.id] == true);
  }

  bool hasAchievement(String achievementId) {
    return _currentProgress?.unlockedAchievements.contains(achievementId) ?? false;
  }

  Future<void> submitQuizScore(String lessonId, int score) async {
    if (_currentProgress == null) return;
    
    final updatedScores = Map<String, int>.from(_currentProgress!.quizScores);
    final currentBest = updatedScores[lessonId] ?? 0;
    
    if (score > currentBest) {
      updatedScores[lessonId] = score;
    }
    
    _currentProgress = UserEduProgress(
      userId: _currentProgress!.userId,
      completedLessons: _currentProgress!.completedLessons,
      quizScores: updatedScores,
      unlockedAchievements: _currentProgress!.unlockedAchievements,
    );
    
    await _saveProgress();
  }

  List<EduModule> _getStaticModules() {
    return [
      EduModule(
        id: 'mod1',
        title: 'Tax Lien Basics',
        description: 'Learn the fundamentals of tax lien investing.',
        order: 1,
        requiredTier: 'free',
        lessons: [
          EduLesson(
            id: 'l1.1',
            moduleId: 'mod1',
            title: 'What is a Tax Lien?',
            type: 'video',
            content: 'In this lesson, you will learn what a tax lien is and how it differs from other investments.',
            videoUrl: 'https://vimeo.com/placeholder1',
            durationMinutes: 8,
            quiz: [
              QuizQuestion(
                question: 'What is a tax lien?',
                options: ['A debt on a property', 'A type of mortgage', 'A property insurance'],
                correctAnswerIndex: 0,
                explanation: 'A tax lien is a legal claim against a property for unpaid property taxes.',
              ),
            ],
          ),
          EduLesson(
            id: 'l1.2',
            moduleId: 'mod1',
            title: 'Tax Lien vs Tax Deed',
            type: 'article',
            content: 'Understand the key differences between tax liens and tax deeds.',
            durationMinutes: 6,
          ),
        ],
      ),
      EduModule(
        id: 'mod2',
        title: 'Property Research',
        description: 'How to research properties effectively.',
        order: 2,
        requiredTier: 'starter',
        lessons: [
          EduLesson(
            id: 'l2.1',
            moduleId: 'mod2',
            title: 'County Website Research',
            type: 'video',
            content: 'Master the art of navigating county websites.',
            videoUrl: 'https://vimeo.com/placeholder2',
            durationMinutes: 10,
          ),
        ],
      ),
    ];
  }
}
