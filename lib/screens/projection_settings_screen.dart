import 'dart:async';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/server_connection_service.dart';
import '../theme/app_colors.dart';

class ProjectionSettingsScreen extends StatefulWidget {
  final ServerConnectionService serverConnectionService;
  
  const ProjectionSettingsScreen({
    super.key, 
    required this.serverConnectionService,
  });

  @override
  State<ProjectionSettingsScreen> createState() => _ProjectionSettingsScreenState();
}

class _ProjectionSettingsScreenState extends State<ProjectionSettingsScreen> {
  Map<String, dynamic> domeState = {};
  StreamSubscription? _stateSubscription;
  StreamSubscription? _connectionSubscription;

  // Настройки по умолчанию
  double _brightness = 100.0;
  double _volume = 50.0;
  double _rotation = 0.0;
  double _zoom = 1.0;
  double _contrast = 1.0;
  double _saturation = 1.0;

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
            _brightness = (state['brightness'] ?? 100).toDouble();
            _volume = (state['volume'] ?? 50).toDouble();
            _rotation = (state['rotation'] ?? 0).toDouble();
            _zoom = (state['zoom'] ?? 1.0).toDouble();
            _contrast = (state['contrast'] ?? 1.0).toDouble();
            _saturation = (state['saturation'] ?? 1.0).toDouble();
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
          // Заголовок
          _buildHeader(l10n),
          const SizedBox(height: 16),
          
          // Основные настройки
          _buildBasicSettings(l10n),
          const SizedBox(height: 16),
          
          // Расширенные настройки
          _buildAdvancedSettings(l10n),
          const SizedBox(height: 16),
          
          // Пресеты
          _buildPresets(l10n),
        ],
      ),
    );
  }

  Widget _buildHeader(AppLocalizations? l10n) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.settings,
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
                    l10n?.projectionSettings ?? 'Projection Settings',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Configure projection parameters',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
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

  Widget _buildBasicSettings(AppLocalizations? l10n) {
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
                  'Basic Settings',
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
              value: _brightness,
              min: 0,
              max: 100,
              divisions: 100,
              onChanged: (value) {
                setState(() {
                  _brightness = value;
                });
                widget.serverConnectionService.setBrightness(value.toInt());
              },
              valueText: '${_brightness.toInt()}%',
            ),
            
            const SizedBox(height: 20),
            
            // Громкость
            _buildSliderControl(
              icon: Icons.volume_up,
              label: l10n?.volume ?? 'Volume',
              value: _volume,
              min: 0,
              max: 100,
              divisions: 100,
              onChanged: (value) {
                setState(() {
                  _volume = value;
                });
                widget.serverConnectionService.setVolume(value.toInt());
              },
              valueText: '${_volume.toInt()}%',
            ),
            
            const SizedBox(height: 20),
            
            // Поворот
            _buildSliderControl(
              icon: Icons.rotate_right,
              label: l10n?.rotation ?? 'Rotation',
              value: _rotation,
              min: -180,
              max: 180,
              divisions: 360,
              onChanged: (value) {
                setState(() {
                  _rotation = value;
                });
                widget.serverConnectionService.setRotation(value);
              },
              valueText: '${_rotation.toInt()}°',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedSettings(AppLocalizations? l10n) {
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
                  Icons.tune_outlined,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Advanced Settings',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Масштаб
            _buildSliderControl(
              icon: Icons.zoom_in,
              label: 'Zoom',
              value: _zoom,
              min: 0.5,
              max: 2.0,
              divisions: 30,
              onChanged: (value) {
                setState(() {
                  _zoom = value;
                });
                // TODO: Implement zoom setting
              },
              valueText: '${_zoom.toStringAsFixed(1)}x',
            ),
            
            const SizedBox(height: 20),
            
            // Контрастность
            _buildSliderControl(
              icon: Icons.contrast,
              label: 'Contrast',
              value: _contrast,
              min: 0.5,
              max: 2.0,
              divisions: 30,
              onChanged: (value) {
                setState(() {
                  _contrast = value;
                });
                // TODO: Implement contrast setting
              },
              valueText: '${_contrast.toStringAsFixed(1)}',
            ),
            
            const SizedBox(height: 20),
            
            // Насыщенность
            _buildSliderControl(
              icon: Icons.color_lens,
              label: 'Saturation',
              value: _saturation,
              min: 0.0,
              max: 2.0,
              divisions: 40,
              onChanged: (value) {
                setState(() {
                  _saturation = value;
                });
                // TODO: Implement saturation setting
              },
              valueText: '${_saturation.toStringAsFixed(1)}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresets(AppLocalizations? l10n) {
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
                  Icons.bookmark,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Presets',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildPresetButton(
                  label: 'Cinema',
                  icon: Icons.movie,
                  onTap: () => _applyPreset('cinema'),
                ),
                _buildPresetButton(
                  label: 'Presentation',
                  icon: Icons.slideshow,
                  onTap: () => _applyPreset('presentation'),
                ),
                _buildPresetButton(
                  label: 'Gaming',
                  icon: Icons.games,
                  onTap: () => _applyPreset('gaming'),
                ),
                _buildPresetButton(
                  label: 'Photo',
                  icon: Icons.photo,
                  onTap: () => _applyPreset('photo'),
                ),
                _buildPresetButton(
                  label: 'Night',
                  icon: Icons.nightlight,
                  onTap: () => _applyPreset('night'),
                ),
                _buildPresetButton(
                  label: 'Vivid',
                  icon: Icons.color_lens,
                  onTap: () => _applyPreset('vivid'),
                ),
              ],
            ),
          ],
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

  Widget _buildPresetButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }

  void _applyPreset(String presetName) {
    Map<String, Map<String, double>> presets = {
      'cinema': {
        'brightness': 80.0,
        'volume': 70.0,
        'contrast': 1.2,
        'saturation': 0.9,
      },
      'presentation': {
        'brightness': 100.0,
        'volume': 60.0,
        'contrast': 1.1,
        'saturation': 1.0,
      },
      'gaming': {
        'brightness': 90.0,
        'volume': 80.0,
        'contrast': 1.3,
        'saturation': 1.2,
      },
      'photo': {
        'brightness': 85.0,
        'volume': 50.0,
        'contrast': 1.0,
        'saturation': 1.1,
      },
      'night': {
        'brightness': 60.0,
        'volume': 40.0,
        'contrast': 0.9,
        'saturation': 0.8,
      },
      'vivid': {
        'brightness': 95.0,
        'volume': 70.0,
        'contrast': 1.4,
        'saturation': 1.5,
      },
    };

    final preset = presets[presetName];
    if (preset != null) {
      setState(() {
        _brightness = preset['brightness']!;
        _volume = preset['volume']!;
        _contrast = preset['contrast']!;
        _saturation = preset['saturation']!;
      });

      // Применяем настройки
      widget.serverConnectionService.setBrightness(_brightness.toInt());
      widget.serverConnectionService.setVolume(_volume.toInt());
      // TODO: Apply contrast and saturation

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Applied $presetName preset'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
} 