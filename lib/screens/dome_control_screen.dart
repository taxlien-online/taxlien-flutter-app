import 'dart:async';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/server_connection_service.dart';
import '../theme/app_colors.dart';

class DomeControlScreen extends StatefulWidget {
  final ServerConnectionService serverConnectionService;
  
  const DomeControlScreen({
    super.key, 
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

  @override
  void dispose() {
    _stateSubscription?.cancel();
    _connectionSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Быстрые настройки для кинотеатров
          _buildQuickSettings(l10n),
          const SizedBox(height: 16),
          
          // Статус системы
          _buildStatusCard(l10n),
          const SizedBox(height: 16),
          
          // Управление воспроизведением
          _buildPlaybackControls(l10n),
          const SizedBox(height: 16),
          
          // Настройки проекции
          _buildProjectionSettings(l10n),
        ],
      ),
    );
  }

  Widget _buildQuickSettings(AppLocalizations? l10n) {
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
                  Icons.tune,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Quick Settings',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Essential controls for cinema operators',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 20),
            
            // Быстрые кнопки настроек
            Row(
              children: [
                Expanded(
                  child: _buildQuickSettingButton(
                    icon: Icons.brightness_6,
                    label: l10n?.brightness ?? 'Brightness',
                    value: '${domeState['brightness'] ?? 100}%',
                    onTap: () => _showBrightnessQuickControl(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickSettingButton(
                    icon: Icons.volume_up,
                    label: l10n?.volume ?? 'Volume',
                    value: '${domeState['volume'] ?? 50}%',
                    onTap: () => _showVolumeQuickControl(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildQuickSettingButton(
                    icon: Icons.rotate_right,
                    label: l10n?.rotation ?? 'Rotation',
                    value: '${domeState['rotation'] ?? 0}°',
                    onTap: () => _showRotationQuickControl(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickSettingButton(
                    icon: Icons.zoom_in,
                    label: 'Zoom',
                    value: '${(domeState['zoom'] ?? 1.0).toStringAsFixed(1)}x',
                    onTap: () => _showZoomQuickControl(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickSettingButton({
    required IconData icon,
    required String label,
    required String value,
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
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(AppLocalizations? l10n) {
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
                  Icons.info_outline,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  l10n?.systemStatus ?? 'System Status',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: domeState['isRunning'] == true ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  domeState['isRunning'] == true 
                      ? (l10n?.playback ?? 'Playback Active')
                      : (l10n?.stopped ?? 'Stopped'),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            if (domeState['media']?['currentFile'] != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${l10n?.file ?? 'File'}: ${domeState['media']['currentFile']}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    if (domeState['media']?['duration'] != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${l10n?.position ?? 'Position'}: ${domeState['media']['position'] ?? 0} / ${domeState['media']['duration']} ${l10n?.seconds ?? 'seconds'}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlaybackControls(AppLocalizations? l10n) {
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
                  Icons.play_circle_outline,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  l10n?.playbackControls ?? 'Playback Controls',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Кнопки управления
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildControlButton(
                  icon: Icons.play_arrow,
                  label: l10n?.play ?? 'Play',
                  color: Colors.green,
                  onPressed: () => widget.serverConnectionService.play(),
                ),
                _buildControlButton(
                  icon: Icons.pause,
                  label: l10n?.pause ?? 'Pause',
                  color: Colors.orange,
                  onPressed: () => widget.serverConnectionService.pause(),
                ),
                _buildControlButton(
                  icon: Icons.stop,
                  label: l10n?.stop ?? 'Stop',
                  color: Colors.red,
                  onPressed: () => widget.serverConnectionService.stop(),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Ползунок позиции воспроизведения
            _buildSliderControl(
              icon: Icons.timeline,
              label: l10n?.position ?? 'Position',
              value: (domeState['media']?['position'] ?? 0).toDouble(),
              min: 0,
              max: (domeState['media']?['duration'] ?? 100).toDouble(),
              divisions: 100,
              onChanged: (value) {
                // TODO: Implement position setting
              },
              valueText: '${domeState['media']?['position'] ?? 0} ${l10n?.seconds ?? 'seconds'}',
            ),
            
            const SizedBox(height: 20),
            
            // Ползунок громкости
            _buildSliderControl(
              icon: Icons.volume_up,
              label: l10n?.volume ?? 'Volume',
              value: (domeState['volume'] ?? 50).toDouble(),
              min: 0,
              max: 100,
              divisions: 100,
              onChanged: (value) => widget.serverConnectionService.setVolume(value.toInt()),
              valueText: '${domeState['volume'] ?? 50}%',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectionSettings(AppLocalizations? l10n) {
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
                  Icons.settings,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  l10n?.projectionSettings ?? 'Projection Settings',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Яркость
            _buildSliderControl(
              icon: Icons.brightness_6,
              label: l10n?.brightness ?? 'Brightness',
              value: (domeState['brightness'] ?? 100).toDouble(),
              min: 0,
              max: 100,
              divisions: 100,
              onChanged: (value) => widget.serverConnectionService.setBrightness(value.toInt()),
              valueText: '${domeState['brightness'] ?? 100}%',
            ),
            
            const SizedBox(height: 20),
            
            // Поворот
            _buildSliderControl(
              icon: Icons.rotate_right,
              label: l10n?.rotation ?? 'Rotation',
              value: (domeState['rotation'] ?? 0).toDouble(),
              min: -180,
              max: 180,
              divisions: 360,
              onChanged: (value) => widget.serverConnectionService.setRotation(value),
              valueText: '${domeState['rotation'] ?? 0}°',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 24),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliderControl({
    required IconData icon,
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
    required String valueText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            Text(
              valueText,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
          activeColor: AppColors.primary,
          inactiveColor: AppColors.primary.withOpacity(0.3),
        ),
      ],
    );
  }

  void _showBrightnessQuickControl() {
    double brightness = (domeState['brightness'] ?? 100).toDouble();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.brightness_6),
                  const SizedBox(width: 12),
                  const Text(
                    'Brightness',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${brightness.toInt()}%',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Slider(
                value: brightness,
                min: 0,
                max: 100,
                divisions: 100,
                onChanged: (value) {
                  setState(() {
                    brightness = value;
                  });
                  widget.serverConnectionService.setBrightness(value.toInt());
                },
                activeColor: AppColors.primary,
                inactiveColor: AppColors.primary.withOpacity(0.3),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
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

  void _showVolumeQuickControl() {
    double volume = (domeState['volume'] ?? 50).toDouble();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.volume_up),
                  const SizedBox(width: 12),
                  const Text(
                    'Volume',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${volume.toInt()}%',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Slider(
                value: volume,
                min: 0,
                max: 100,
                divisions: 100,
                onChanged: (value) {
                  setState(() {
                    volume = value;
                  });
                  widget.serverConnectionService.setVolume(value.toInt());
                },
                activeColor: AppColors.primary,
                inactiveColor: AppColors.primary.withOpacity(0.3),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
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

  void _showRotationQuickControl() {
    double rotation = (domeState['rotation'] ?? 0).toDouble();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.rotate_right),
                  const SizedBox(width: 12),
                  const Text(
                    'Rotation',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${rotation.toInt()}°',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Slider(
                value: rotation,
                min: -180,
                max: 180,
                divisions: 360,
                onChanged: (value) {
                  setState(() {
                    rotation = value;
                  });
                  widget.serverConnectionService.setRotation(value);
                },
                activeColor: AppColors.primary,
                inactiveColor: AppColors.primary.withOpacity(0.3),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
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

  void _showZoomQuickControl() {
    double zoom = (domeState['zoom'] ?? 1.0).toDouble();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.zoom_in),
                  const SizedBox(width: 12),
                  const Text(
                    'Zoom',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${zoom.toStringAsFixed(1)}x',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Slider(
                value: zoom,
                min: 0.5,
                max: 2.0,
                divisions: 30,
                onChanged: (value) {
                  setState(() {
                    zoom = value;
                  });
                  // TODO: Implement zoom setting
                },
                activeColor: AppColors.primary,
                inactiveColor: AppColors.primary.withOpacity(0.3),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
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
} 