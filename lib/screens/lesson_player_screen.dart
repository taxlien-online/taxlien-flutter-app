import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../services/education_service.dart';
import '../services/analytics_service.dart';
import '../core/models/education_models.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

class LessonPlayerScreen extends StatefulWidget {
  final EduLesson lesson;
  final EducationService eduService;

  const LessonPlayerScreen({
    super.key,
    required this.lesson,
    required this.eduService,
  });

  @override
  State<LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends State<LessonPlayerScreen> {
  WebViewController? _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    AnalyticsService().logCourseModuleStart(widget.lesson.id);

    if (widget.lesson.type == 'video' && widget.lesson.videoUrl != null) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (String url) {
              setState(() => _isLoading = false);
            },
          ),
        )
        ..loadRequest(Uri.parse(widget.lesson.videoUrl!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Player Area
            if (widget.lesson.type == 'video' && widget.lesson.videoUrl != null && _controller != null)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: Colors.black,
                  child: Stack(
                    children: [
                      WebViewWidget(controller: _controller!),
                      if (_isLoading)
                        const Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ),
              )
            else if (widget.lesson.type == 'article')
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                ),
                child: const Icon(Icons.article, size: 80, color: AppColors.primary),
              ),

            Padding(
              padding: const EdgeInsets.all(AppDimensions.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.lesson.durationMinutes} min',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const Spacer(),
                      ListenableBuilder(
                        listenable: widget.eduService,
                        builder: (context, _) {
                          final isCompleted = widget.eduService.currentProgress?.completedLessons[widget.lesson.id] == true;
                          if (!isCompleted) return const SizedBox.shrink();
                          return const Chip(
                            label: Text('Completed'),
                            backgroundColor: AppColors.success,
                            labelStyle: TextStyle(color: Colors.white, fontSize: 12),
                          );
                        }
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.md),
                  Text(
                    widget.lesson.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.sm),
                  Text(
                    widget.lesson.content,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 40),
                  
                  // Action Buttons
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _startQuiz(),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Take Quiz to Unlock'),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.sm),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => _markAsCompleted(),
                      child: const Text('Mark as Completed'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startQuiz() {
    if (widget.lesson.quiz.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No quiz available for this lesson.')),
      );
      return;
    }

    Navigator.pushNamed(
      context,
      '/quiz',
      arguments: {'lesson': widget.lesson},
    );
  }

  Future<void> _markAsCompleted() async {
    await widget.eduService.completeLesson(widget.lesson.id);
    AnalyticsService().logCourseModuleComplete(widget.lesson.id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lesson completed!')),
      );
    }
  }
}