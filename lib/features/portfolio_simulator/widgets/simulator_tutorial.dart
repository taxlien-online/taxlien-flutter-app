import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tutorial overlay for first-time users
///
/// Shows a 3-step walkthrough of the Portfolio Simulator
class SimulatorTutorial extends StatefulWidget {
  final VoidCallback onComplete;

  const SimulatorTutorial({
    super.key,
    required this.onComplete,
  });

  /// Check if user has seen tutorial
  static Future<bool> hasSeenTutorial(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('simulator_tutorial_seen_$userId') ?? false;
  }

  /// Mark tutorial as seen
  static Future<void> markTutorialSeen(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('simulator_tutorial_seen_$userId', true);
  }

  /// Show tutorial if not seen before
  static Future<void> showIfNeeded(
    BuildContext context,
    String userId,
  ) async {
    final hasSeenTutorial = await SimulatorTutorial.hasSeenTutorial(userId);
    if (!hasSeenTutorial && context.mounted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => SimulatorTutorial(
          onComplete: () {
            Navigator.of(context).pop();
            SimulatorTutorial.markTutorialSeen(userId);
          },
        ),
      );
    }
  }

  @override
  State<SimulatorTutorial> createState() => _SimulatorTutorialState();
}

class _SimulatorTutorialState extends State<SimulatorTutorial> {
  int _currentStep = 0;
  final PageController _pageController = PageController();

  final List<_TutorialStep> _steps = [
    _TutorialStep(
      title: 'Welcome to Portfolio Simulator!',
      description:
          'Practice tax lien investing with virtual money. Learn strategies risk-free before investing real capital.',
      icon: Icons.school,
      color: Colors.blue,
    ),
    _TutorialStep(
      title: 'How It Works',
      description:
          '1. Create a portfolio with \$100K virtual capital\n'
          '2. Browse and purchase tax liens\n'
          '3. Time accelerates automatically (1 hour = 1 week)\n'
          '4. See outcomes and learn from results',
      icon: Icons.lightbulb,
      color: Colors.orange,
    ),
    _TutorialStep(
      title: 'Compete & Earn Achievements',
      description:
          'Climb the leaderboard, unlock achievements, and become a tax lien investing expert!',
      icon: Icons.emoji_events,
      color: Colors.amber,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      widget.onComplete();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skip() {
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: TextButton(
                  onPressed: _skip,
                  child: const Text('Skip'),
                ),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentStep = index;
                  });
                },
                itemCount: _steps.length,
                itemBuilder: (context, index) {
                  final step = _steps[index];
                  return _buildStepPage(step);
                },
              ),
            ),

            // Progress dots
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _steps.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentStep == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentStep == index
                          ? theme.primaryColor
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

            // Navigation buttons
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  if (_currentStep > 0)
                    TextButton(
                      onPressed: _previousStep,
                      child: const Row(
                        children: [
                          Icon(Icons.arrow_back, size: 20),
                          SizedBox(width: 4),
                          Text('Back'),
                        ],
                      ),
                    )
                  else
                    const SizedBox(width: 80),

                  // Next/Finish button
                  ElevatedButton(
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      _currentStep == _steps.length - 1
                          ? 'Get Started!'
                          : 'Next',
                      style: const TextStyle(fontSize: 16),
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

  Widget _buildStepPage(_TutorialStep step) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: step.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              step.icon,
              size: 64,
              color: step.color,
            ),
          ),
          const SizedBox(height: 32),

          // Title
          Text(
            step.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            step.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _TutorialStep {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  _TutorialStep({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
