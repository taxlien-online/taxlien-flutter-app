import 'package:flutter/material.dart';
// import '../l10n/app_localizations.dart'; // Not used
import '../services/localization_service.dart';
import '../services/theme_service.dart';
import '../services/onboarding_service.dart';
import '../services/onboarding_data_provider.dart';
import '../services/tax_lien_service.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/user_preferences_service.dart';
import '../services/offline_data_loader_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import '../theme/app_theme_export.dart'; // Not used
import 'main_navigation_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final LocalizationService localizationService;
  final ThemeService themeService;
  final OnboardingService onboardingService;
  final TaxLienService taxLienService;
  final AuthService authService;
  final DatabaseService databaseService;
  final UserPreferencesService userPreferencesService;

  const OnboardingScreen({
    super.key,
    required this.localizationService,
    required this.themeService,
    required this.onboardingService,
    required this.taxLienService,
    required this.authService,
    required this.databaseService,
    required this.userPreferencesService,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final OnboardingDataProvider _dataProvider = OnboardingDataProvider();
  int _currentPage = 0;
  List<OnboardingPage> _pages = [];
  bool _isLoading = true;

  // File selection state
  final Map<String, RadaFileInfo> _availableFiles = {
    'ALL': RadaFileInfo(
      key: 'ALL',
      name: 'Все штаты',
      description: 'Полный набор данных по всем штатам США',
      file: 'assets/taxlien_data.rada',
      estimatedRecords: 250000,
      size: '45 MB',
      states: ['ALL'],
      icon: Icons.public,
      color: Colors.blue,
    ),
    'FL': RadaFileInfo(
      key: 'FL',
      name: 'Florida',
      description: 'Налоговые закладные штата Флорида',
      file: 'assets/taxlien_florida.rada',
      estimatedRecords: 15000,
      size: '3.2 MB',
      states: ['FL'],
      icon: Icons.beach_access,
      color: Colors.orange,
    ),
    'AZ': RadaFileInfo(
      key: 'AZ',
      name: 'Arizona',
      description: 'Налоговые закладные штата Аризона',
      file: 'assets/taxlien_arizona.rada',
      estimatedRecords: 8500,
      size: '1.8 MB',
      states: ['AZ'],
      icon: Icons.landscape,
      color: Colors.deepOrange,
    ),
    'DEMO': RadaFileInfo(
      key: 'DEMO',
      name: 'Демо данные',
      description: 'Демонстрационные данные для тестирования',
      file: 'assets/taxlien_demo.rada',
      estimatedRecords: 100,
      size: '15 KB',
      states: ['DEMO'],
      icon: Icons.play_circle_outline,
      color: Colors.purple,
    ),
    'DEFAULT': RadaFileInfo(
      key: 'DEFAULT',
      name: 'Базовый набор',
      description: 'Базовый набор данных',
      file: 'assets/taxlien.rada',
      estimatedRecords: 5000,
      size: '950 KB',
      states: ['DEFAULT'],
      icon: Icons.folder,
      color: Colors.grey,
    ),
  };

  Set<String> _selectedFiles = {'DEMO'};
  bool _isLoadingFiles = false;

  @override
  void initState() {
    super.initState();
    _loadOnboardingPages();
    _loadSavedSelection();
  }

  Future<void> _loadSavedSelection() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getStringList('selected_rada_states');
      if (saved != null && saved.isNotEmpty) {
        setState(() {
          _selectedFiles = saved.toSet();
        });
      }
    } catch (e) {
      // Use default selection if error
    }
  }

  Future<void> _loadOnboardingPages() async {
    try {
      final result = await _dataProvider.getList(
        sortField: 'order',
        sortOrder: 'ASC',
      );

      final pagesData = List<Map<String, dynamic>>.from(result['data'] as List)
          .where((page) => page['isActive'] == true)
          .toList();

      if (pagesData.isEmpty) {
        // Use default pages if no data
        _pages = _getDefaultPages();
      } else {
        _pages = pagesData
            .map((data) => OnboardingPage(
                  title: data['title'] as String,
                  subtitle: data['subtitle'] as String,
                  description: data['description'] as String,
                  icon: _getIconData(data['iconName'] as String),
                  color: _getColor(data['colorHex'] as String),
                ))
            .toList();
      }

      // Add file selection page
      _pages.add(OnboardingPage(
        title: 'Выберите данные для загрузки',
        subtitle: 'Настройте источники данных',
        description:
            'Выберите, какие файлы с налоговыми закладными вы хотите загрузить. Вы можете изменить это позже в настройках.',
        icon: Icons.folder_open,
        color: Colors.teal,
        isFileSelection: true,
      ));

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      // Fallback to default pages on error
      setState(() {
        _pages = _getDefaultPages();
        // Add file selection page
        _pages.add(OnboardingPage(
          title: 'Выберите данные для загрузки',
          subtitle: 'Настройте источники данных',
          description:
              'Выберите, какие файлы с налоговыми закладными вы хотите загрузить. Вы можете изменить это позже в настройках.',
          icon: Icons.folder_open,
          color: Colors.teal,
          isFileSelection: true,
        ));
        _isLoading = false;
      });
    }
  }

  List<OnboardingPage> _getDefaultPages() {
    return [
      OnboardingPage(
        title: 'Добро пожаловать в TaxLien Marketplace',
        subtitle: 'Платформа для инвестирования в налоговые закладные',
        description:
            'Откройте для себя мир прибыльных инвестиций в налоговые закладные. Получайте высокие проценты и диверсифицируйте свой портфель.',
        icon: Icons.trending_up,
        color: Colors.blue,
      ),
      OnboardingPage(
        title: 'Как это работает',
        subtitle: 'Простой процесс инвестирования',
        description:
            '1. Выберите налоговую закладную\n2. Разместите ставку\n3. Получайте проценты\n4. Дождитесь погашения или выкупа',
        icon: Icons.how_to_reg,
        color: Colors.green,
      ),
      OnboardingPage(
        title: 'Безопасность и надежность',
        subtitle: 'Ваши инвестиции под защитой',
        description:
            'Все сделки защищены законодательством. Налоговые закладные - это обеспеченные инвестиции с государственной гарантией.',
        icon: Icons.security,
        color: Colors.orange,
      ),
      OnboardingPage(
        title: 'Начните инвестировать',
        subtitle: 'Присоединяйтесь к тысячам инвесторов',
        description:
            'Создайте аккаунт и начните инвестировать уже сегодня. Минимальная сумма инвестиций от \$100.',
        icon: Icons.rocket_launch,
        color: Colors.purple,
      ),
    ];
  }

  IconData _getIconData(String iconName) {
    final iconMap = {
      'trending_up': Icons.trending_up,
      'how_to_reg': Icons.how_to_reg,
      'security': Icons.security,
      'rocket_launch': Icons.rocket_launch,
      'person': Icons.person,
      'shopping_cart': Icons.shopping_cart,
      'wallet': Icons.wallet,
      'analytics': Icons.analytics,
      'settings': Icons.settings,
      'home': Icons.home,
      'favorite': Icons.favorite,
      'star': Icons.star,
      'info': Icons.info,
      'help': Icons.help,
      'check_circle': Icons.check_circle,
    };
    return iconMap[iconName] ?? Icons.info;
  }

  Color _getColor(String colorHex) {
    try {
      return Color(int.parse(colorHex.replaceFirst('#', '0xff')));
    } catch (e) {
      return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  if (page.isFileSelection) {
                    return _buildFileSelectionPage();
                  }
                  return _buildPage(page);
                },
              ),
            ),
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: page.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              page.icon,
              size: 60,
              color: page.color,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            page.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            page.subtitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: page.color,
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            page.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFileSelectionPage() {
    return _isLoadingFiles
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: const Icon(
                        Icons.folder_open,
                        size: 40,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Выберите данные для загрузки',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Выбранные файлы будут загружены при первом запуске',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Info banner
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${_selectedFiles.length} ${_selectedFiles.length == 1 ? "файл" : "файла"} · ≈${(_totalRecords / 1000).toStringAsFixed(1)}K записей',
                        style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Files list
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: _availableFiles.entries.map((entry) {
                    final info = entry.value;
                    final isSelected = _selectedFiles.contains(entry.key);

                    return _RadaFileCard(
                      info: info,
                      isSelected: isSelected,
                      onTap: () => _toggleSelection(entry.key),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
  }

  void _toggleSelection(String key) {
    setState(() {
      if (key == 'ALL') {
        // If selecting ALL, deselect others
        if (_selectedFiles.contains('ALL')) {
          _selectedFiles.remove('ALL');
        } else {
          _selectedFiles = {'ALL'};
        }
      } else {
        // If selecting specific state, remove ALL
        _selectedFiles.remove('ALL');
        if (_selectedFiles.contains(key)) {
          _selectedFiles.remove(key);
        } else {
          _selectedFiles.add(key);
        }
      }

      // Ensure at least one is selected
      if (_selectedFiles.isEmpty) {
        _selectedFiles.add('DEMO');
      }
    });
  }

  int get _totalRecords {
    if (_selectedFiles.contains('ALL')) {
      return _availableFiles['ALL']!.estimatedRecords;
    }
    return _selectedFiles.fold<int>(
      0,
      (sum, key) => sum + (_availableFiles[key]?.estimatedRecords ?? 0),
    );
  }

  Future<void> _saveFileSelection() async {
    setState(() {
      _isLoadingFiles = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
          'selected_rada_states', _selectedFiles.toList());

      // Initialize data loader
      final dataLoader = OfflineDataLoaderService();
      await dataLoader.initialize();

      if (mounted) {
        setState(() {
          _isLoadingFiles = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingFiles = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка сохранения: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _pages.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              if (_currentPage > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: const Text('Назад'),
                  ),
                ),
              if (_currentPage > 0) const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage < _pages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      _completeOnboarding();
                    }
                  },
                  child: Text(
                      _currentPage < _pages.length - 1 ? 'Далее' : 'Начать'),
                ),
              ),
            ],
          ),
          if (_currentPage < _pages.length - 1) ...[
            const SizedBox(height: 16),
            TextButton(
              onPressed: _completeOnboarding,
              child: const Text('Пропустить'),
            ),
          ],
        ],
      ),
    );
  }

  void _completeOnboarding() async {
    // Save file selection before completing onboarding
    await _saveFileSelection();
    await widget.onboardingService.completeOnboarding();

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MainNavigationScreen(
            localizationService: widget.localizationService,
            themeService: widget.themeService,
            onboardingService: widget.onboardingService,
            taxLienService: widget.taxLienService,
            authService: widget.authService,
            databaseService: widget.databaseService,
            userPreferencesService: widget.userPreferencesService,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class OnboardingPage {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;
  final bool isFileSelection;

  OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
    this.isFileSelection = false,
  });
}

/// Widget for displaying rada file card
class _RadaFileCard extends StatelessWidget {
  final RadaFileInfo info;
  final bool isSelected;
  final VoidCallback onTap;

  const _RadaFileCard({
    required this.info,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: info.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  info.icon,
                  color: info.color,
                  size: 24,
                ),
              ),

              const SizedBox(width: 12),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      info.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      info.description,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _InfoChip(
                          icon: Icons.folder_outlined,
                          label:
                              '${(info.estimatedRecords / 1000).toStringAsFixed(1)}K',
                        ),
                        const SizedBox(width: 6),
                        _InfoChip(
                          icon: Icons.storage,
                          label: info.size,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Checkbox
              Checkbox(
                value: isSelected,
                onChanged: (_) => onTap(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey.shade600),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Information about a .rada file
class RadaFileInfo {
  final String key;
  final String name;
  final String description;
  final String file;
  final int estimatedRecords;
  final String size;
  final List<String> states;
  final IconData icon;
  final Color color;

  RadaFileInfo({
    required this.key,
    required this.name,
    required this.description,
    required this.file,
    required this.estimatedRecords,
    required this.size,
    required this.states,
    required this.icon,
    required this.color,
  });
}
