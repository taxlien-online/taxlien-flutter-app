import 'package:flutter/material.dart';
import '../services/education_service.dart';
import '../core/models/education_models.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

class EducationDashboardScreen extends StatefulWidget {
  final EducationService eduService;

  const EducationDashboardScreen({
    super.key,
    required this.eduService,
  });

  @override
  State<EducationDashboardScreen> createState() => _EducationDashboardScreenState();
}

class _EducationDashboardScreenState extends State<EducationDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.eduService,
      builder: (context, _) {
        if (widget.eduService.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final modules = widget.eduService.modules;
        final progress = widget.eduService.currentProgress;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Learn to Earn'),
            actions: [
              IconButton(
                icon: const Icon(Icons.help_outline),
                onPressed: () {
                  // Show educational system info
                },
              ),
            ],
          ),
          body: CustomScrollView(
            slivers: [
              // Header with overall progress
              SliverToBoxAdapter(
                child: _buildOverallProgress(modules, progress),
              ),

              // Modules list
              SliverPadding(
                padding: const EdgeInsets.all(AppDimensions.md),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final module = modules[index];
                      return _buildModuleCard(module, progress);
                    },
                    childCount: modules.length,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOverallProgress(List<EduModule> modules, UserEduProgress? progress) {
    double totalProgress = 0;
    if (modules.isNotEmpty && progress != null) {
      double sum = modules.fold(0.0, (prev, m) => prev + progress.getModuleProgress(m));
      totalProgress = sum / modules.length;
    }

    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Progress',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${(totalProgress * 100).toInt()}% of course completed',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              Stack(
                alignment: Center,
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      value: totalProgress,
                      strokeWidth: 8,
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                  Text(
                    '${(totalProgress * 100).toInt()}%',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCard(EduModule module, UserEduProgress? progress) {
    final moduleProgress = progress?.getModuleProgress(module) ?? 0.0;
    final isLocked = false; // Add logic for tier locking if needed

    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.md),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: isLocked ? Colors.grey : AppColors.primary,
              child: Text(
                '${module.order}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
              module.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(module.description),
            trailing: isLocked ? const Icon(Icons.lock_outline) : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
            child: LinearProgressIndicator(
              value: moduleProgress,
              backgroundColor: Colors.grey.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                moduleProgress == 1.0 ? AppColors.success : AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          Padding(
            padding: const EdgeInsets.all(AppDimensions.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: isLocked ? null : () => _openModule(module),
                  child: Text(moduleProgress == 1.0 ? 'Review' : 'Continue'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openModule(EduModule module) {
    if (module.lessons.isEmpty) return;

    // Find first uncompleted lesson
    final progress = widget.eduService.currentProgress;
    EduLesson targetLesson = module.lessons.first;
    
    for (var lesson in module.lessons) {
      if (progress?.completedLessons[lesson.id] != true) {
        targetLesson = lesson;
        break;
      }
    }

    Navigator.pushNamed(
      context,
      '/lesson-player',
      arguments: {'lesson': targetLesson},
    );
  }
}
