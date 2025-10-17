import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../core/services/dome_service.dart';

class CalibrationScreen extends StatefulWidget {
  final dynamic domeService; // Using dynamic for flexibility

  const CalibrationScreen({
    super.key,
    required this.domeService,
  });

  @override
  State<CalibrationScreen> createState() => _CalibrationScreenState();
}

class _CalibrationScreenState extends State<CalibrationScreen> {
  double _brightness = 100.0;
  double _rotation = 0.0;
  double _zoom = 1.0;
  double _horizontalOffset = 0.0;
  double _verticalOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCurrentSettings();
  }

  Future<void> _loadCurrentSettings() async {
    // Load settings if domeService is DomeService
    if (widget.domeService is DomeService) {
      final domeService = widget.domeService as DomeService;
      setState(() {
        _brightness = domeService.brightness;
        _rotation = domeService.rotation;
        _zoom = domeService.zoom;
        _horizontalOffset = domeService.horizontalOffset;
        _verticalOffset = domeService.verticalOffset;
      });
    }
  }

  Future<void> _applySettings() async {
    if (widget.domeService is DomeService) {
      final domeService = widget.domeService as DomeService;
      await domeService.setBrightness(_brightness);
      await domeService.setRotation(_rotation);
      await domeService.setZoom(_zoom);
      await domeService.setHorizontalOffset(_horizontalOffset);
      await domeService.setVerticalOffset(_verticalOffset);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings applied successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<void> _resetSettings() async {
    setState(() {
      _brightness = 100.0;
      _rotation = 0.0;
      _zoom = 1.0;
      _horizontalOffset = 0.0;
      _verticalOffset = 0.0;
    });

    if (widget.domeService is DomeService) {
      final domeService = widget.domeService as DomeService;
      await domeService.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.calibration ?? 'Calibration'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetSettings,
            tooltip: 'Reset',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Brightness
            _buildSliderCard(
              title: l10n?.brightness ?? 'Brightness',
              value: _brightness,
              min: 0,
              max: 100,
              icon: Icons.brightness_6,
              onChanged: (value) => setState(() => _brightness = value),
            ),

            const SizedBox(height: 16),

            // Rotation
            _buildSliderCard(
              title: l10n?.rotation ?? 'Rotation',
              value: _rotation,
              min: -180,
              max: 180,
              icon: Icons.rotate_right,
              onChanged: (value) => setState(() => _rotation = value),
            ),

            const SizedBox(height: 16),

            // Zoom
            _buildSliderCard(
              title: 'Zoom',
              value: _zoom,
              min: 0.5,
              max: 2.0,
              icon: Icons.zoom_in,
              onChanged: (value) => setState(() => _zoom = value),
            ),

            const SizedBox(height: 16),

            // Horizontal Offset
            _buildSliderCard(
              title: 'Horizontal Offset',
              value: _horizontalOffset,
              min: -100,
              max: 100,
              icon: Icons.swap_horiz,
              onChanged: (value) => setState(() => _horizontalOffset = value),
            ),

            const SizedBox(height: 16),

            // Vertical Offset
            _buildSliderCard(
              title: 'Vertical Offset',
              value: _verticalOffset,
              min: -100,
              max: 100,
              icon: Icons.swap_vert,
              onChanged: (value) => setState(() => _verticalOffset = value),
            ),

            const SizedBox(height: 32),

            // Apply button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _applySettings,
                icon: const Icon(Icons.check),
                label: Text(l10n?.apply ?? 'Apply Settings'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Reset button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _resetSettings,
                icon: const Icon(Icons.restore),
                label: const Text('Reset to Default'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderCard({
    required String title,
    required double value,
    required double min,
    required double max,
    required IconData icon,
    required ValueChanged<double> onChanged,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                Text(
                  value.toStringAsFixed(1),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Slider(
              value: value,
              min: min,
              max: max,
              divisions: ((max - min) * 10).toInt(),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
