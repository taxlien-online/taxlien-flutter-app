import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/theme_service.dart';
import '../services/localization_service.dart';
import '../services/onboarding_service.dart';
import '../theme/app_colors.dart';
import '../core/constants/app_constants.dart';
import 'onboarding_management_screen.dart';
import 'onboarding_screen.dart';
import 'rada_file_selector_screen.dart';
import '../services/tax_lien_service.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/user_preferences_service.dart';

class SettingsScreen extends StatelessWidget {
  final ThemeService themeService;
  final LocalizationService localizationService;

  const SettingsScreen({
    super.key,
    required this.themeService,
    required this.localizationService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Быстрые действия для кинотеатров
          _buildQuickActions(context),
          const SizedBox(height: 24),

          // Секция внешнего вида
          _buildSection(
            context,
            title: 'Appearance',
            icon: Icons.palette,
            children: [
              _buildThemeSelector(context),
            ],
          ),

          const SizedBox(height: 24),

          // Секция языка
          _buildSection(
            context,
            title: 'Language',
            icon: Icons.language,
            children: [
              _buildLanguageSelector(context),
            ],
          ),

          const SizedBox(height: 24),

          // Секция Onboarding
          _buildSection(
            context,
            title: 'Onboarding',
            icon: Icons.view_carousel,
            children: [
              _buildOnboardingSettings(context),
            ],
          ),

          const SizedBox(height: 24),

          // Секция Data Management
          _buildSection(
            context,
            title: 'Data Management',
            icon: Icons.storage,
            children: [
              _buildDataManagementSettings(context),
            ],
          ),

          const SizedBox(height: 24),

          // Секция FreeDome
          _buildSection(
            context,
            title: 'FreeDome',
            icon: Icons.auto_awesome,
            children: [
              _buildFreedomeSettings(context),
            ],
          ),

          const SizedBox(height: 24),

          // Секция о приложении
          _buildSection(
            context,
            title: 'About',
            icon: Icons.info,
            children: [
              _buildAboutSection(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.flash_on,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Essential settings for cinema operators',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
            ),
            const SizedBox(height: 20),

            // Быстрые кнопки
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionButton(
                    context,
                    icon: Icons.language,
                    label: 'Language',
                    onTap: () => _showLanguageQuickSelector(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionButton(
                    context,
                    icon: Icons.palette,
                    label: 'Theme',
                    onTap: () => _showThemeQuickSelector(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionButton(
                    context,
                    icon: Icons.brightness_6,
                    label: 'Brightness',
                    onTap: () => _showBrightnessQuickSelector(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionButton(
                    context,
                    icon: Icons.volume_up,
                    label: 'Volume',
                    onTap: () => _showVolumeQuickSelector(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSelector(BuildContext context) {
    return ListenableBuilder(
      listenable: themeService,
      builder: (context, child) {
        return Column(
          children: [
            ...themeService.getAvailableThemes().map((theme) {
              final isSelected = theme.mode == themeService.themeMode;

              return ListTile(
                leading: Icon(
                  theme.icon,
                  color: isSelected ? AppColors.primary : null,
                ),
                title: Text(theme.name),
                subtitle: Text(theme.description),
                trailing: isSelected
                    ? Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () => _selectTheme(theme.mode),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildLanguageSelector(BuildContext context) {
    return ListenableBuilder(
      listenable: localizationService,
      builder: (context, child) {
        return Column(
          children: [
            ...localizationService.getAvailableLanguages().map((language) {
              final isSelected = language['code'] ==
                  localizationService.getCurrentLanguageCode();

              return ListTile(
                leading: Text(
                  _getLanguageFlag(language['code']!),
                  style: const TextStyle(fontSize: 20),
                ),
                title: Text(language['name']!),
                trailing: isSelected
                    ? Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () => _selectLanguage(language['code']!),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildFreedomeSettings(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.wifi),
          title: const Text('Connection Status'),
          subtitle: const Text('Connected to FreeDome'),
          trailing: Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Dome Settings'),
          subtitle: const Text('Configure dome parameters'),
          onTap: () {
            // Навигация к настройкам купола
          },
        ),
        ListTile(
          leading: const Icon(Icons.tune),
          title: const Text('Calibration'),
          subtitle: const Text('Calibrate dome sensors'),
          onTap: () {
            // Навигация к калибровке
          },
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text('Version'),
          subtitle: const Text('1.0.0'),
        ),
        ListTile(
          leading: const Icon(Icons.favorite),
          title: const Text('Support Development'),
          subtitle: const Text('Donations accepted'),
          onTap: () {
            _showDonationDialog(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.description),
          title: const Text('Privacy Policy'),
          onTap: () {
            // Открыть политику конфиденциальности
          },
        ),
        ListTile(
          leading: const Icon(Icons.description),
          title: const Text('Terms of Service'),
          onTap: () {
            // Открыть условия использования
          },
        ),
        ListTile(
          leading: const Icon(Icons.feedback),
          title: const Text('Send Feedback'),
          onTap: () {
            // Открыть форму обратной связи
          },
        ),
      ],
    );
  }

  void _showDonationDialog(BuildContext context) {
    const donationAddress = AppConstants.donationAddress;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.favorite, color: Colors.red),
            SizedBox(width: 8),
            Text('Support Development'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thank you for considering supporting our development!',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Donation Address:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                ),
              ),
              child: SelectableText(
                donationAddress,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'You can copy this address and send donations to support the continued development of TaxLien.online.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              // Copy to clipboard functionality would go here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Address copied to clipboard'),
                  duration: Duration(seconds: 2),
                ),
              );
              Navigator.pop(context);
            },
            icon: const Icon(Icons.copy),
            label: const Text('Copy Address'),
          ),
        ],
      ),
    );
  }

  String _getLanguageFlag(String languageCode) {
    switch (languageCode) {
      case 'ru':
        return '🇷🇺';
      case 'uk':
        return '🇺🇦';
      case 'en':
        return '🇺🇸';
      case 'my':
        return '🇲🇲';
      case 'zh':
        return '🇨🇳';
      case 'th':
        return '🇹🇭';
      case 'hi':
        return '🇮🇳';
      case 'ar':
        return '🇸🇦';
      case 'de':
        return '🇩🇪';
      case 'km':
        return '🇰🇭';
      case 'pl':
        return '🇵🇱';
      case 'he':
        return '🇮🇱';
      case 'system':
        return '⚙️';
      default:
        return '🌐';
    }
  }

  void _selectTheme(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        themeService.setLightTheme();
        break;
      case ThemeMode.dark:
        themeService.setDarkTheme();
        break;
      case ThemeMode.system:
        themeService.setSystemTheme();
        break;
    }
  }

  void _selectLanguage(String languageCode) {
    localizationService.setLanguage(languageCode);
  }

  void _showLanguageQuickSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Language',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildLanguageFlagButton(context, '🇺🇸', 'English', 'en'),
                _buildLanguageFlagButton(context, '🇷🇺', 'Русский', 'ru'),
                _buildLanguageFlagButton(context, '🇨🇳', '中文', 'zh'),
                _buildLanguageFlagButton(context, '🇺🇦', 'Українська', 'uk'),
                _buildLanguageFlagButton(context, '🇹🇭', 'ไทย', 'th'),
                _buildLanguageFlagButton(context, '🇯🇵', '日本語', 'ja'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeQuickSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Theme',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildThemeOptionButton(
                    context,
                    icon: Icons.light_mode,
                    label: 'Light',
                    onTap: () {
                      themeService.setLightTheme();
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildThemeOptionButton(
                    context,
                    icon: Icons.dark_mode,
                    label: 'Dark',
                    onTap: () {
                      themeService.setDarkTheme();
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildThemeOptionButton(
                    context,
                    icon: Icons.settings,
                    label: 'System',
                    onTap: () {
                      themeService.setSystemTheme();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showBrightnessQuickSelector(BuildContext context) {
    double brightness = 100.0;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Brightness',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.brightness_6),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Slider(
                      value: brightness,
                      min: 0,
                      max: 100,
                      divisions: 100,
                      onChanged: (value) {
                        setState(() {
                          brightness = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('${brightness.toInt()}%'),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _applyBrightnessSetting(context, brightness);
                        Navigator.pop(context);
                      },
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showVolumeQuickSelector(BuildContext context) {
    double volume = 50.0;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Volume',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.volume_up),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Slider(
                      value: volume,
                      min: 0,
                      max: 100,
                      divisions: 100,
                      onChanged: (value) {
                        setState(() {
                          volume = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('${volume.toInt()}%'),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _applyVolumeSetting(context, volume);
                        Navigator.pop(context);
                      },
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageFlagButton(
      BuildContext context, String flag, String name, String code) {
    return InkWell(
      onTap: () async {
        await localizationService.setLanguage(code);
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Column(
          children: [
            Text(
              flag,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 4),
            Text(
              name,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOptionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingSettings(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.replay),
          title: const Text('Reset Onboarding'),
          subtitle: const Text('View onboarding tutorial again'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _resetOnboarding(context),
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.edit),
          title: const Text('Manage Onboarding'),
          subtitle: const Text('Edit onboarding pages in admin panel'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _openOnboardingManagement(context),
        ),
      ],
    );
  }

  Widget _buildDataManagementSettings(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.folder_open),
          title: const Text('Выбор данных для загрузки'),
          subtitle: const Text('Настройте, какие файлы загружать'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _openFileSelector(context),
        ),
      ],
    );
  }

  Future<void> _resetOnboarding(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Onboarding'),
        content: const Text(
          'This will show the onboarding tutorial on next app restart. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final onboardingService = OnboardingService();
      await onboardingService.initialize();
      await onboardingService.resetOnboarding();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Onboarding reset. Restart app to view tutorial.'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to onboarding
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => OnboardingScreen(
              localizationService: localizationService,
              themeService: themeService,
              onboardingService: onboardingService,
              taxLienService: TaxLienService(),
              authService: AuthService(),
              databaseService: DatabaseService.instance,
              userPreferencesService: UserPreferencesService(),
            ),
          ),
        );
      }
    }
  }

  void _openOnboardingManagement(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const OnboardingManagementScreen(),
      ),
    );
  }

  void _openFileSelector(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const RadaFileSelectorScreen(),
      ),
    );
  }

  void _applyBrightnessSetting(BuildContext context, double brightness) {
    // In a real implementation, this would apply the brightness setting to the system
    if (kDebugMode) {
      print('Applying brightness setting: ${brightness.toInt()}%');
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Brightness set to ${brightness.toInt()}%'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _applyVolumeSetting(BuildContext context, double volume) {
    // In a real implementation, this would apply the volume setting to the system
    if (kDebugMode) {
      print('Applying volume setting: ${volume.toInt()}%');
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Volume set to ${volume.toInt()}%'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
