import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/simulator_constants.dart';
import '../services/time_simulation_service.dart';
import '../widgets/simulator_tutorial.dart';

/// Settings screen for Portfolio Simulator
///
/// Allows users to configure simulation preferences
class SimulatorSettingsScreen extends StatefulWidget {
  final String userId;

  const SimulatorSettingsScreen({
    super.key,
    required this.userId,
  });

  @override
  State<SimulatorSettingsScreen> createState() =>
      _SimulatorSettingsScreenState();
}

class _SimulatorSettingsScreenState extends State<SimulatorSettingsScreen> {
  final _timeService = TimeSimulationService();

  double _simulationSpeed = SimulatorConstants.defaultSimulationSpeed;
  bool _notificationsEnabled = SimulatorConstants.defaultNotificationsEnabled;
  bool _soundEnabled = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = widget.userId;

      setState(() {
        _simulationSpeed = prefs.getDouble('sim_speed_$userId') ??
            SimulatorConstants.defaultSimulationSpeed;
        _notificationsEnabled =
            prefs.getBool('sim_notifications_$userId') ?? true;
        _soundEnabled = prefs.getBool('sim_sound_$userId') ?? true;
        _isLoading = false;
      });

      // Update time service speed
      _timeService.setSimulationSpeed(_simulationSpeed);
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = widget.userId;

      await prefs.setDouble('sim_speed_$userId', _simulationSpeed);
      await prefs.setBool('sim_notifications_$userId', _notificationsEnabled);
      await prefs.setBool('sim_sound_$userId', _soundEnabled);

      // Update time service
      _timeService.setSimulationSpeed(_simulationSpeed);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings saved'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save settings: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulator Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveSettings,
            tooltip: 'Save Settings',
          ),
        ],
      ),
      body: ListView(
        children: [
          // Simulation section
          _buildSectionHeader('Simulation'),
          _buildSimulationSpeedSetting(),
          const Divider(),

          // Notifications section
          _buildSectionHeader('Notifications'),
          _buildNotificationsSetting(),
          _buildSoundSetting(),
          const Divider(),

          // Tutorial section
          _buildSectionHeader('Help'),
          _buildTutorialSetting(),
          const Divider(),

          // Data section
          _buildSectionHeader('Data'),
          _buildResetPortfolioSetting(),
          _buildResetAchievementsSetting(),
          const Divider(),

          // About section
          _buildSectionHeader('About'),
          _buildAboutTile(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildSimulationSpeedSetting() {
    return ListTile(
      leading: const Icon(Icons.speed),
      title: const Text('Simulation Speed'),
      subtitle: Text('${_simulationSpeed}x (1 hour = ${_simulationSpeed} weeks)'),
      trailing: DropdownButton<double>(
        value: _simulationSpeed,
        items: SimulatorConstants.simulationSpeedOptions.map((speed) {
          return DropdownMenuItem<double>(
            value: speed,
            child: Text('${speed}x'),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _simulationSpeed = value;
            });
          }
        },
      ),
    );
  }

  Widget _buildNotificationsSetting() {
    return SwitchListTile(
      secondary: const Icon(Icons.notifications),
      title: const Text('Outcome Notifications'),
      subtitle: const Text('Get notified when simulations complete'),
      value: _notificationsEnabled,
      onChanged: (value) {
        setState(() {
          _notificationsEnabled = value;
        });
      },
    );
  }

  Widget _buildSoundSetting() {
    return SwitchListTile(
      secondary: const Icon(Icons.volume_up),
      title: const Text('Sound Effects'),
      subtitle: const Text('Play sounds for achievements and outcomes'),
      value: _soundEnabled,
      onChanged: (value) {
        setState(() {
          _soundEnabled = value;
        });
      },
    );
  }

  Widget _buildTutorialSetting() {
    return ListTile(
      leading: const Icon(Icons.help_outline),
      title: const Text('Show Tutorial Again'),
      subtitle: const Text('Replay the first-time walkthrough'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () async {
        // Reset tutorial flag
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('simulator_tutorial_seen_${widget.userId}', false);

        if (mounted) {
          // Show tutorial
          await SimulatorTutorial.showIfNeeded(context, widget.userId);
        }
      },
    );
  }

  Widget _buildResetPortfolioSetting() {
    return ListTile(
      leading: const Icon(Icons.refresh, color: Colors.orange),
      title: const Text('Reset All Portfolios'),
      subtitle: const Text('Delete all simulated portfolios and positions'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _showResetConfirmation(
        title: 'Reset All Portfolios?',
        message:
            'This will permanently delete all your simulated portfolios, positions, and outcomes. This action cannot be undone.',
        onConfirm: _resetPortfolios,
      ),
    );
  }

  Widget _buildResetAchievementsSetting() {
    return ListTile(
      leading: const Icon(Icons.emoji_events, color: Colors.red),
      title: const Text('Reset Achievements'),
      subtitle: const Text('Clear all unlocked achievements'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _showResetConfirmation(
        title: 'Reset Achievements?',
        message:
            'This will reset all your achievements and progress. You can unlock them again by completing the tasks.',
        onConfirm: _resetAchievements,
      ),
    );
  }

  Widget _buildAboutTile() {
    return ListTile(
      leading: const Icon(Icons.info_outline),
      title: const Text('About Portfolio Simulator'),
      subtitle: const Text('Version 1.0.0'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        showAboutDialog(
          context: context,
          applicationName: 'Portfolio Simulator',
          applicationVersion: '1.0.0',
          applicationLegalese: '© 2026 TAXLIEN.online',
          children: [
            const SizedBox(height: 16),
            const Text(
              'Practice tax lien investing with virtual money. '
              'Learn strategies risk-free before investing real capital.',
            ),
          ],
        );
      },
    );
  }

  void _showResetConfirmation({
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  Future<void> _resetPortfolios() async {
    // TODO: Implement portfolio reset
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Portfolios reset successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _resetAchievements() async {
    // TODO: Implement achievements reset
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Achievements reset successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
