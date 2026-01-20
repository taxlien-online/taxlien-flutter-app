import 'tax_lien_models.dart';

class EduModule {
  final String id;
  final String title;
  final String description;
  final List<EduLesson> lessons;
  final String requiredTier; // 'free', 'starter', 'premium'
  final int order;

  EduModule({
    required this.id,
    required this.title,
    required this.description,
    required this.lessons,
    this.requiredTier = 'free',
    required this.order,
  });
}

class EduLesson {
  final String id;
  final String moduleId;
  final String title;
  final String type; // 'video', 'article'
  final String content;
  final String? videoUrl;
  final String? pdfUrl;
  final int durationMinutes;
  final List<QuizQuestion> quiz;

  EduLesson({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.type,
    required this.content,
    this.videoUrl,
    this.pdfUrl,
    required this.durationMinutes,
    this.quiz = const [],
  });
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
  });
}

class UserEduProgress {
  final String userId;
  final Map<String, bool> completedLessons; // lessonId -> completed
  final Map<String, int> quizScores; // lessonId -> bestScore
  final List<String> unlockedAchievements;

  UserEduProgress({
    required this.userId,
    this.completedLessons = const {},
    this.quizScores = const {},
    this.unlockedAchievements = const [],
  });

  double getModuleProgress(EduModule module) {
    if (module.lessons.isEmpty) return 0.0;
    int completed = module.lessons.where((l) => completedLessons[l.id] == true).length;
    return completed / module.lessons.length;
  }
}
