import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tutorial/Onboarding for Deal Detective feature
///
/// Swipeable tutorial cards explaining how to use the swipe interface
class DetectiveTutorial extends StatefulWidget {
  final VoidCallback onComplete;

  const DetectiveTutorial({
    super.key,
    required this.onComplete,
  });

  @override
  State<DetectiveTutorial> createState() => _DetectiveTutorialState();

  /// Show tutorial if first time user
  static Future<void> showIfNeeded(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenTutorial = prefs.getBool('detective_tutorial_seen') ?? false;

    if (!hasSeenTutorial && context.mounted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => DetectiveTutorial(
          onComplete: () async {
            await prefs.setBool('detective_tutorial_seen', true);
            if (context.mounted) {
              Navigator.pop(context);
            }
          },
        ),
      );
    }
  }

  /// Reset tutorial (for testing)
  static Future<void> resetTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('detective_tutorial_seen', false);
  }
}

class _DetectiveTutorialState extends State<DetectiveTutorial> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<TutorialPage> _pages = [
    TutorialPage(
      icon: Icons.swipe,
      title: 'Swipe to Discover',
      description:
          'Browse tax lien properties with simple swipes. Swipe right to like, left to pass.',
      gradient: LinearGradient(
        colors: [Colors.blue.shade400, Colors.blue.shade700],
      ),
      illustration: Icons.touch_app,
    ),
    TutorialPage(
      icon: Icons.arrow_upward,
      title: 'Super Like Properties',
      description:
          'Swipe up to add properties to your watchlist and get notifications on price changes.',
      gradient: LinearGradient(
        colors: [Colors.green.shade400, Colors.green.shade700],
      ),
      illustration: Icons.favorite,
    ),
    TutorialPage(
      icon: Icons.celebration,
      title: 'Get Matched',
      description:
          'We\'ll match you with properties that fit your investment criteria and notify you of great deals.',
      gradient: LinearGradient(
        colors: [Colors.purple.shade400, Colors.purple.shade700],
      ),
      illustration: Icons.stars,
    ),
    TutorialPage(
      icon: Icons.tune,
      title: 'Personalize Your Feed',
      description:
          'Set your preferences for location, price range, and ROI to see the most relevant properties.',
      gradient: LinearGradient(
        colors: [Colors.orange.shade400, Colors.orange.shade700],
      ),
      illustration: Icons.settings,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      widget.onComplete();
    }
  }

  void _skipTutorial() {
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: TextButton(
                  onPressed: _skipTutorial,
                  child: const Text('Skip'),
                ),
              ),
            ),

            // Page view
            SizedBox(
              height: 450,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),

            // Page indicators
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => _buildPageIndicator(index == _currentPage),
                ),
              ),
            ),

            // Next button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _currentPage == _pages.length - 1
                        ? 'Get Started'
                        : 'Next',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(TutorialPage page) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Gradient illustration background
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: page.gradient,
              shape: BoxShape.circle,
            ),
            child: Icon(
              page.illustration,
              size: 100,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 32),

          // Icon badge
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              page.icon,
              size: 32,
              color: Colors.blue.shade700,
            ),
          ),

          const SizedBox(height: 16),

          // Title
          Text(
            page.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          // Description
          Text(
            page.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

/// Tutorial page model
class TutorialPage {
  final IconData icon;
  final String title;
  final String description;
  final Gradient gradient;
  final IconData illustration;

  const TutorialPage({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
    required this.illustration,
  });
}
