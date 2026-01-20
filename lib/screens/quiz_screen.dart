import 'package:flutter/material.dart';
import '../services/education_service.dart';
import '../services/analytics_service.dart';
import '../core/models/education_models.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

class QuizScreen extends StatefulWidget {
  final EduLesson lesson;
  final EducationService eduService;

  const QuizScreen({
    super.key,
    required this.lesson,
    required this.eduService,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _showResult = false;
  int? _selectedOptionIndex;
  bool _answered = false;

  List<QuizQuestion> get _questions => widget.lesson.quiz;

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No quiz for this lesson')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz: ${widget.lesson.title}'),
        automaticallyImplyLeading: !_showResult,
      ),
      body: _showResult ? _buildResult() : _buildQuiz(),
    );
  }

  Widget _buildQuiz() {
    final question = _questions[_currentQuestionIndex];

    return Padding(
      padding: const EdgeInsets.all(AppDimensions.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / _questions.length,
            backgroundColor: Colors.grey.withOpacity(0.1),
          ),
          const SizedBox(height: AppDimensions.lg),
          Text(
            'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
            style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppDimensions.md),
          Text(
            question.question,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.lg),
          ...List.generate(question.options.length, (index) {
            final option = question.options[index];
            return _buildOption(index, option, question);
          }),
          const Spacer(),
          if (_answered)
            ElevatedButton(
              onPressed: _nextQuestion,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(_currentQuestionIndex + 1 == _questions.length ? 'Show Results' : 'Next Question'),
            ),
        ],
      ),
    );
  }

  Widget _buildOption(int index, String text, QuizQuestion question) {
    Color borderColor = Colors.grey.withOpacity(0.3);
    Color? bgColor;

    if (_answered) {
      if (index == question.correctAnswerIndex) {
        borderColor = AppColors.success;
        bgColor = AppColors.success.withOpacity(0.1);
      } else if (index == _selectedOptionIndex) {
        borderColor = AppColors.error;
        bgColor = AppColors.error.withOpacity(0.1);
      }
    } else if (_selectedOptionIndex == index) {
      borderColor = AppColors.primary;
      bgColor = AppColors.primary.withOpacity(0.05);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: InkWell(
        onTap: _answered ? null : () => setState(() => _selectedOptionIndex = index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.md),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 2),
            borderRadius: BorderRadius.circular(12),
            color: bgColor,
          ),
          child: Row(
            children: [
              Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
              if (_answered && index == question.correctAnswerIndex)
                const Icon(Icons.check_circle, color: AppColors.success),
              if (_answered && index == _selectedOptionIndex && index != question.correctAnswerIndex)
                const Icon(Icons.cancel, color: AppColors.error),
            ],
          ),
        ),
      ),
    );
  }

  void _nextQuestion() {
    if (_selectedOptionIndex == _questions[_currentQuestionIndex].correctAnswerIndex) {
      _score++;
    }

    if (_currentQuestionIndex + 1 < _questions.length) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOptionIndex = null;
        _answered = false;
      });
    } else {
      _finishQuiz();
    }
  }

  // Allow clicking an option to answer immediately
  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    if (_selectedOptionIndex != null && !_answered && !_showResult) {
      _answered = true;
    }
  }

  void _finishQuiz() async {
    final finalScore = (_score / _questions.length * 100).toInt();
    await widget.eduService.submitQuizScore(widget.lesson.id, finalScore);
    
    AnalyticsService().logQuizPass(widget.lesson.id, finalScore);

    if (finalScore >= 80) {
      await widget.eduService.completeLesson(widget.lesson.id);
    }

    setState(() => _showResult = true);
  }

  Widget _buildResult() {
    final percent = (_score / _questions.length * 100).toInt();
    final passed = percent >= 80;

    return Padding(
      padding: const EdgeInsets.all(AppDimensions.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            passed ? Icons.emoji_events : Icons.sentiment_dissatisfied,
            size: 100,
            color: passed ? AppColors.warning : AppColors.error,
          ),
          const SizedBox(height: AppDimensions.md),
          Text(
            passed ? 'Congratulations!' : 'Keep Learning!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(
            'You scored $percent%',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.lg),
          if (passed)
            const Text(
              'Lesson completed and feature unlocked! 🚀',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold),
            )
          else
            const Text(
              'Try again to score 80% or more to unlock the next level.',
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
            child: const Text('Back to Lessons'),
          ),
          if (!passed)
            TextButton(
              onPressed: () => setState(() {
                _currentQuestionIndex = 0;
                _score = 0;
                _showResult = false;
                _selectedOptionIndex = null;
                _answered = false;
              }),
              child: const Text('Retry Quiz'),
            ),
        ],
      ),
    );
  }
}
