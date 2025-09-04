import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../core/services/dome_service.dart';

class CalibrationScreen extends StatefulWidget {
  final DomeService domeService;

  const CalibrationScreen({
    Key? key,
    required this.domeService,
  }) : super(key: key);

  @override
  State<CalibrationScreen> createState() => _CalibrationScreenState();
}

class _CalibrationScreenState extends State<CalibrationScreen> {
  bool _isCalibrating = false;
  String _calibrationStatus = 'Ready to calibrate';
  double _progress = 0.0;
  Map<String, dynamic> _calibrationResults = {};

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.calibration),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calibration Status',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(_calibrationStatus),
                    if (_isCalibrating) ...[
                      const SizedBox(height: 16),
                      LinearProgressIndicator(value: _progress),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Calibration Controls
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calibration Controls',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    
                    // Auto Calibration
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isCalibrating ? null : _startAutoCalibration,
                        icon: const Icon(Icons.auto_fix_high),
                        label: const Text('Auto Calibration'),
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Manual Calibration
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _isCalibrating ? null : _startManualCalibration,
                        icon: const Icon(Icons.tune),
                        label: const Text('Manual Calibration'),
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Reset Calibration
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _isCalibrating ? null : _resetCalibration,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reset Calibration'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Calibration Results
            if (_calibrationResults.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Calibration Results',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      ..._calibrationResults.entries.map((entry) => 
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(entry.key),
                              Text(
                                entry.value.toString(),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            
            const Spacer(),
            
            // Help Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calibration Help',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• Auto Calibration: Automatically calibrates all dome parameters\n'
                      '• Manual Calibration: Step-by-step calibration process\n'
                      '• Reset Calibration: Restores default calibration values\n'
                      '• Ensure dome is in a stable position before starting',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startAutoCalibration() async {
    setState(() {
      _isCalibrating = true;
      _calibrationStatus = 'Starting auto calibration...';
      _progress = 0.0;
    });

    try {
      // Simulate calibration steps
      final steps = [
        'Initializing dome position...',
        'Calibrating brightness sensor...',
        'Calibrating volume levels...',
        'Calibrating rotation sensors...',
        'Calibrating zoom controls...',
        'Finalizing calibration...',
      ];

      for (int i = 0; i < steps.length; i++) {
        setState(() {
          _calibrationStatus = steps[i];
          _progress = (i + 1) / steps.length;
        });
        
        // Simulate calibration time
        await Future.delayed(const Duration(seconds: 2));
      }

      // Set calibration results
      setState(() {
        _calibrationResults = {
          'Brightness Range': '0-100%',
          'Volume Range': '0-100%',
          'Rotation Range': '0-360°',
          'Zoom Range': '1x-10x',
          'Calibration Date': DateTime.now().toString().split(' ')[0],
          'Status': 'Success',
        };
        _calibrationStatus = 'Calibration completed successfully!';
        _isCalibrating = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Calibration completed successfully!'),
          backgroundColor: Colors.green,
        ),
      );

    } catch (e) {
      setState(() {
        _calibrationStatus = 'Calibration failed: $e';
        _isCalibrating = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Calibration failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _startManualCalibration() async {
    // Navigate to manual calibration steps
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ManualCalibrationScreen(
          domeService: widget.domeService,
        ),
      ),
    );
  }

  Future<void> _resetCalibration() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Calibration'),
        content: const Text(
          'Are you sure you want to reset all calibration settings? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Reset'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _calibrationResults.clear();
        _calibrationStatus = 'Calibration reset to defaults';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Calibration settings reset'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }
}

class ManualCalibrationScreen extends StatefulWidget {
  final DomeService domeService;

  const ManualCalibrationScreen({
    Key? key,
    required this.domeService,
  }) : super(key: key);

  @override
  State<ManualCalibrationScreen> createState() => _ManualCalibrationScreenState();
}

class _ManualCalibrationScreenState extends State<ManualCalibrationScreen> {
  int _currentStep = 0;
  final List<String> _steps = [
    'Position Calibration',
    'Brightness Calibration',
    'Volume Calibration',
    'Rotation Calibration',
    'Zoom Calibration',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manual Calibration'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: (_currentStep + 1) / _steps.length,
            ),
            
            const SizedBox(height: 16),
            
            // Current step
            Text(
              'Step ${_currentStep + 1} of ${_steps.length}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            
            const SizedBox(height: 8),
            
            Text(
              _steps[_currentStep],
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            
            const SizedBox(height: 32),
            
            // Step content
            Expanded(
              child: _buildStepContent(),
            ),
            
            // Navigation buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentStep > 0)
                  OutlinedButton(
                    onPressed: _previousStep,
                    child: const Text('Previous'),
                  )
                else
                  const SizedBox.shrink(),
                
                if (_currentStep < _steps.length - 1)
                  ElevatedButton(
                    onPressed: _nextStep,
                    child: const Text('Next'),
                  )
                else
                  ElevatedButton(
                    onPressed: _completeCalibration,
                    child: const Text('Complete'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildPositionCalibration();
      case 1:
        return _buildBrightnessCalibration();
      case 2:
        return _buildVolumeCalibration();
      case 3:
        return _buildRotationCalibration();
      case 4:
        return _buildZoomCalibration();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPositionCalibration() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.location_on, size: 64),
            SizedBox(height: 16),
            Text(
              'Position the dome to the center position and ensure it\'s stable.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Use the dome controls to move to the center position, then tap Next.',
              textAlign: TextAlign.center,
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrightnessCalibration() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.brightness_6, size: 64),
            SizedBox(height: 16),
            Text(
              'Calibrate brightness levels from minimum to maximum.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'The system will automatically detect the brightness range.',
              textAlign: TextAlign.center,
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVolumeCalibration() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.volume_up, size: 64),
            SizedBox(height: 16),
            Text(
              'Calibrate volume levels from minimum to maximum.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Test audio output at different volume levels.',
              textAlign: TextAlign.center,
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRotationCalibration() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.rotate_right, size: 64),
            SizedBox(height: 16),
            Text(
              'Calibrate rotation sensors for 360-degree movement.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Ensure smooth rotation in both directions.',
              textAlign: TextAlign.center,
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZoomCalibration() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.zoom_in, size: 64),
            SizedBox(height: 16),
            Text(
              'Calibrate zoom controls from minimum to maximum.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Test zoom functionality and focus quality.',
              textAlign: TextAlign.center,
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  void _previousStep() {
    setState(() {
      _currentStep--;
    });
  }

  void _nextStep() {
    setState(() {
      _currentStep++;
    });
  }

  void _completeCalibration() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Manual calibration completed!'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.of(context).pop();
  }
}