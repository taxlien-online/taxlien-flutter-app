import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/localization_service.dart';
import '../services/theme_service.dart';
import '../services/onboarding_service.dart';
import '../services/server_connection_service.dart';
import '../theme/app_colors.dart';
import 'connection_status_screen.dart';
import 'language_settings_screen.dart';
import 'settings_screen.dart';
import 'server_settings_screen.dart';
import 'tax_lien_content_manager_screen.dart';

class MainMenuScreen extends StatefulWidget {
  final LocalizationService localizationService;
  final ThemeService themeService;
  final OnboardingService onboardingService;
  final ServerConnectionService serverConnectionService;
  
  const MainMenuScreen({
    super.key, 
    required this.localizationService,
    required this.themeService,
    required this.onboardingService,
    required this.serverConnectionService,
  });

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  
  Map<String, dynamic> domeState = {};
  StreamSubscription? _stateSubscription;
  StreamSubscription? _connectionSubscription;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _setupStreams();
    _loadInitialData();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));
    
    // Start animations with delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _fadeController.forward();
        _slideController.forward();
        _scaleController.forward();
      }
    });
  }

  void _setupStreams() {
    _stateSubscription = widget.serverConnectionService.stateStream.listen(
      (state) {
        if (mounted) {
          setState(() {
            domeState = state;
          });
        }
      },
    );
    
    _connectionSubscription = widget.serverConnectionService.connectionStream.listen(
      (connected) {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  Future<void> _loadInitialData() async {
    // Load initial data
    try {
      // Here you can load initial data
    } catch (e) {
      print('Error loading initial data: $e');
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _stateSubscription?.cancel();
    _connectionSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: Listenable.merge([_fadeController, _slideController, _scaleController]),
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: _buildMainContent(l10n),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMainContent(AppLocalizations? l10n) {
    return Column(
      children: [
        // Header and status
        _buildHeader(l10n),
        
        // Main menu
        Expanded(
          child: _buildMenuGrid(l10n),
        ),
        
        // Bottom panel
        _buildBottomPanel(l10n),
      ],
    );
  }

  Widget _buildHeader(AppLocalizations? l10n) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n?.appTitle ?? 'FreeDome Manager',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    Text(
                      'Digital Freedom Gateway',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              // Connection status
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: widget.serverConnectionService.isConnected 
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: widget.serverConnectionService.isConnected 
                        ? Colors.green 
                        : Colors.red,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: widget.serverConnectionService.isConnected 
                            ? Colors.green 
                            : Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.serverConnectionService.isConnected 
                          ? (l10n?.online ?? 'ONLINE')
                          : (l10n?.offline ?? 'OFFLINE'),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: widget.serverConnectionService.isConnected 
                            ? Colors.green 
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // System status
          _buildSystemStatus(l10n),
        ],
      ),
    );
  }

  Widget _buildSystemStatus(AppLocalizations? l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            domeState['isRunning'] == true ? Icons.play_circle : Icons.stop_circle,
            color: domeState['isRunning'] == true ? Colors.green : Colors.red,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n?.systemStatus ?? 'System Status',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  domeState['isRunning'] == true 
                      ? (l10n?.playback ?? 'Playback')
                      : (l10n?.stopped ?? 'Stopped'),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          if (domeState['media']?['currentFile'] != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                domeState['media']['currentFile'],
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid(AppLocalizations? l10n) {
    final menuItems = [
      MenuItem(
        title: 'Dome Control',
        subtitle: 'Control Projection',
        icon: Icons.control_camera,
        color: AppColors.primary,
        onTap: () => _navigateToDomeControl(),
      ),

      MenuItem(
        title: 'Calibration',
        subtitle: 'Adjust Settings',
        icon: Icons.tune,
        color: AppColors.spiritual,
        onTap: () => _navigateToCalibration(),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          return _buildMenuItem(menuItems[index]);
        },
      ),
    );
  }

  Widget _buildMenuItem(MenuItem item) {
    return AnimatedBuilder(
      animation: _scaleController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: item.onTap,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: item.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        item.icon,
                        color: item.color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Flexible(
                      child: Text(
                        item.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Flexible(
                      child: Text(
                        item.subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomPanel(AppLocalizations? l10n) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          // Settings button
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _navigateToSettings(),
              icon: const Icon(Icons.settings),
              label: const Text('Settings'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Connection status button
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _navigateToConnectionStatus(),
              icon: const Icon(Icons.wifi),
              label: const Text('Connection'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Navigation methods
  void _navigateToPlayback() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DomeControlScreen(
          localizationService: widget.localizationService,
          themeService: widget.themeService,
          onboardingService: widget.onboardingService,
          serverConnectionService: widget.serverConnectionService,
        ),
      ),
    );
  }

  void _navigateToCalibration() {
    // TODO: Implement calibration screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Calibration screen coming soon')),
    );
  }

  void _navigateToMedia() {
    // TODO: Create media management screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Media management coming soon')),
    );
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(
          themeService: widget.themeService,
          localizationService: widget.localizationService,
        ),
      ),
    );
  }

  void _navigateToLanguageSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LanguageSettingsScreen(
          localizationService: widget.localizationService,
        ),
      ),
    );
  }

  void _navigateToConnectionStatus() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConnectionStatusScreen(
          serverService: widget.serverConnectionService,
        ),
      ),
    );
  }

  void _navigateToServerSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServerSettingsScreen(
          serverService: widget.serverConnectionService,
        ),
      ),
    );
  }

  // Navigation methods for main functions
  void _navigateToDomeControl() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DomeControlScreen(
          localizationService: widget.localizationService,
          themeService: widget.themeService,
          onboardingService: widget.onboardingService,
          serverConnectionService: widget.serverConnectionService,
        ),
      ),
    );
  }


}

class MenuItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const MenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

// Import DomeControlScreen from main.dart
class DomeControlScreen extends StatefulWidget {
  final LocalizationService localizationService;
  final ThemeService themeService;
  final OnboardingService onboardingService;
  final ServerConnectionService serverConnectionService;
  
  const DomeControlScreen({
    super.key, 
    required this.localizationService,
    required this.themeService,
    required this.onboardingService,
    required this.serverConnectionService,
  });

  @override
  State<DomeControlScreen> createState() => _DomeControlScreenState();
}

class _DomeControlScreenState extends State<DomeControlScreen> {
  Map<String, dynamic> domeState = {};

  StreamSubscription? _stateSubscription;
  StreamSubscription? _connectionSubscription;

  @override
  void initState() {
    super.initState();
    _setupStreams();

  }

  void _setupStreams() {
    _stateSubscription = widget.serverConnectionService.stateStream.listen(
      (state) {
        setState(() {
          domeState = state;
        });
      },
    );
    
    _connectionSubscription = widget.serverConnectionService.connectionStream.listen(
      (connected) {
        setState(() {});
      },
    );
  }



  void _playMedia(String fileName) {
    widget.serverConnectionService.play();
  }

  void _pauseMedia() {
    widget.serverConnectionService.pause();
  }

  void _stopMedia() {
    widget.serverConnectionService.stop();
  }

  void _setBrightness(double value) {
    widget.serverConnectionService.setBrightness(value.toInt());
  }

  void _setVolume(double value) {
    widget.serverConnectionService.setVolume(value.toInt());
  }

  void _setRotation(double value) {
    widget.serverConnectionService.setRotation(value);
  }

  void _setPosition(double value) {
    // TODO: Implement position setting
  }

  @override
  void dispose() {
    _stateSubscription?.cancel();
    _connectionSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: widget.serverConnectionService.isConnected ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.serverConnectionService.isConnected ? l10n.online : l10n.offline,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ServerSettingsScreen(
                    serverService: widget.serverConnectionService,
                  ),
                ),
              );
            },
            icon: Icon(
              widget.serverConnectionService.isConnected ? Icons.wifi : Icons.wifi_off,
              color: widget.serverConnectionService.isConnected ? Colors.green : Colors.red,
            ),
            tooltip: 'Server Settings',
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConnectionStatusScreen(
                    serverService: widget.serverConnectionService,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.info),
            tooltip: 'Connection Status',
          ),
          IconButton(
            onPressed: () {
              // TODO: Implement calibration screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Calibration screen coming soon')),
              );
            },
            icon: const Icon(Icons.tune),
            tooltip: l10n.calibration,
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LanguageSettingsScreen(
                    localizationService: widget.localizationService,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.language),
            tooltip: l10n.languageSettings,
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    themeService: widget.themeService,
                    localizationService: widget.localizationService,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // System status
            _buildStatusCard(),
            const SizedBox(height: 16),
            
            // Playback controls
            _buildPlaybackControls(),
            const SizedBox(height: 16),
            
            // Projection settings
            _buildProjectionSettings(),
            const SizedBox(height: 16),
            

          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.systemStatus,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  domeState['isRunning'] == true ? Icons.play_circle : Icons.stop_circle,
                  color: domeState['isRunning'] == true ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  domeState['isRunning'] == true ? l10n.playback : l10n.stopped,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            if (domeState['media']?['currentFile'] != null) ...[
              const SizedBox(height: 8),
              Text('${l10n.file}: ${domeState['media']['currentFile']}'),
              if (domeState['media']?['duration'] != null) ...[
                const SizedBox(height: 4),
                Text('${l10n.position}: ${domeState['media']['position'] ?? 0} / ${domeState['media']['duration']} ${l10n.seconds}'),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlaybackControls() {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.playbackControls,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _playMedia('test_video.mp4'),
                  icon: const Icon(Icons.play_arrow),
                  label: Text(l10n.play),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _pauseMedia,
                  icon: const Icon(Icons.pause),
                  label: Text(l10n.pause),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _stopMedia,
                  icon: const Icon(Icons.stop),
                  label: Text(l10n.stop),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Playback position slider
            Row(
              children: [
                const Icon(Icons.timeline),
                const SizedBox(width: 8),
                Text(l10n.position),
                const Spacer(),
                Text('${domeState['media']?['position'] ?? 0} ${l10n.seconds}'),
              ],
            ),
            Slider(
              value: (domeState['media']?['position'] ?? 0).toDouble(),
              min: 0,
              max: (domeState['media']?['duration'] ?? 100).toDouble(),
              divisions: 100,
              onChanged: _setPosition,
            ),
            
            const SizedBox(height: 16),
            
            // Volume slider
            Row(
              children: [
                const Icon(Icons.volume_up),
                const SizedBox(width: 8),
                Text(l10n.volume),
                const Spacer(),
                Text('${domeState['volume'] ?? 50}%'),
              ],
            ),
            Slider(
              value: (domeState['volume'] ?? 50).toDouble(),
              min: 0,
              max: 100,
              divisions: 100,
              onChanged: _setVolume,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectionSettings() {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.projectionSettings,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Brightness
            Row(
              children: [
                const Icon(Icons.brightness_6),
                const SizedBox(width: 8),
                Text(l10n.brightness),
                const Spacer(),
                Text('${domeState['brightness'] ?? 100}%'),
              ],
            ),
            Slider(
              value: (domeState['brightness'] ?? 100).toDouble(),
              min: 0,
              max: 100,
              divisions: 100,
              onChanged: _setBrightness,
            ),
            
            const SizedBox(height: 16),
            
            // Rotation
            Row(
              children: [
                const Icon(Icons.rotate_right),
                const SizedBox(width: 8),
                Text(l10n.rotation),
                const Spacer(),
                Text('${domeState['rotation'] ?? 0}°'),
              ],
            ),
            Slider(
              value: (domeState['rotation'] ?? 0).toDouble(),
              min: -180,
              max: 180,
              divisions: 360,
              onChanged: _setRotation,
            ),
          ],
        ),
      ),
    );
  }


} 