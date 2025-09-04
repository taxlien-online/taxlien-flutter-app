import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class CalibrationScreen extends StatefulWidget {
  const CalibrationScreen({super.key});

  @override
  State<CalibrationScreen> createState() => _CalibrationScreenState();
}

class _CalibrationScreenState extends State<CalibrationScreen> {
  double _brightness = 50.0;
  double _contrast = 50.0;
  double _saturation = 50.0;
  double _hue = 0.0;
  bool _isCalibrating = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.calibration ?? 'Calibration'),
        backgroundColor: theme.colorScheme.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n?.calibrationInstructions ?? 'Adjust the following settings to calibrate your display:',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            
            // Brightness
            _buildCalibrationSlider(
              icon: Icons.brightness_6,
              label: l10n?.brightness ?? 'Brightness',
              value: _brightness,
              onChanged: (value) => setState(() => _brightness = value),
            ),
            
            // Contrast
            _buildCalibrationSlider(
              icon: Icons.contrast,
              label: l10n?.contrast ?? 'Contrast',
              value: _contrast,
              onChanged: (value) => setState(() => _contrast = value),
            ),
            
            // Saturation
            _buildCalibrationSlider(
              icon: Icons.color_lens,
              label: l10n?.saturation ?? 'Saturation',
              value: _saturation,
              onChanged: (value) => setState(() => _saturation = value),
            ),
            
            // Hue
            _buildCalibrationSlider(
              icon: Icons.palette,
              label: l10n?.hue ?? 'Hue',
              value: _hue,
              min: -180,
              max: 180,
              onChanged: (value) => setState(() => _hue = value),
            ),
            
            const Spacer(),
            
            // Calibration buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _resetToDefaults,
                    child: Text(l10n?.reset ?? 'Reset'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isCalibrating ? null : _startCalibration,
                    child: _isCalibrating
                        ? const CircularProgressIndicator()
                        : Text(l10n?.startCalibration ?? 'Start Calibration'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalibrationSlider({
    required IconData icon,
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
    double min = 0,
    double max = 100,
  }) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.titleMedium,
            ),
            const Spacer(),
            Text(
              '${value.round()}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).round(),
          onChanged: onChanged,
          activeColor: theme.colorScheme.primary,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _resetToDefaults() {
    setState(() {
      _brightness = 50.0;
      _contrast = 50.0;
      _saturation = 50.0;
      _hue = 0.0;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)?.resetToDefaults ?? 'Reset to defaults'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _startCalibration() async {
    setState(() {
      _isCalibrating = true;
    });

    // Simulate calibration process
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isCalibrating = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)?.calibrationComplete ?? 'Calibration complete!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
