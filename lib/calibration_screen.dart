import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'services/server_connection_service.dart';

class CalibrationScreen extends StatefulWidget {
  final ServerConnectionService serverConnectionService;

  const CalibrationScreen({super.key, required this.serverConnectionService});

  @override
  State<CalibrationScreen> createState() => _CalibrationScreenState();
}

class _CalibrationScreenState extends State<CalibrationScreen> {
  double xOffset = 0.0;
  double yOffset = 0.0;
  double scale = 1.0;
  double rotation = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCurrentCalibration();
  }

  void _loadCurrentCalibration() {
    // В реальном приложении здесь будет загрузка текущих настроек
    setState(() {
      xOffset = 0.0;
      yOffset = 0.0;
      scale = 1.0;
      rotation = 0.0;
    });
  }

  void _applyCalibration() async {
    final l10n = AppLocalizations.of(context)!;
    
    try {
      await widget.serverConnectionService.setCalibration(
        x: xOffset,
        y: yOffset,
        scale: scale,
        rotation: rotation,
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.calibrationApplied),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to apply calibration: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _resetCalibration() {
    setState(() {
      xOffset = 0.0;
      yOffset = 0.0;
      scale = 1.0;
      rotation = 0.0;
    });
    
    _applyCalibration();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.calibrationTitle),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Предварительный просмотр
            _buildPreviewCard(),
            const SizedBox(height: 16),
            
            // Настройки смещения
            _buildOffsetControls(),
            const SizedBox(height: 16),
            
            // Настройки масштаба и поворота
            _buildScaleRotationControls(),
            const SizedBox(height: 16),
            
            // Кнопки управления
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewCard() {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.preview,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Transform(
                  transform: Matrix4.identity()
                    ..translate(xOffset, yOffset)
                    ..scale(scale)
                    ..rotateZ(rotation * 3.14159 / 180),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.circle,
                      color: Colors.white,
                      size: 50,
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

  Widget _buildOffsetControls() {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.offset,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // X смещение
            Row(
              children: [
                const Icon(Icons.arrow_forward),
                const SizedBox(width: 8),
                Text(l10n.xOffset),
                const Spacer(),
                Text('${xOffset.toStringAsFixed(1)}'),
              ],
            ),
            Slider(
              value: xOffset,
              min: -100,
              max: 100,
              divisions: 200,
              onChanged: (value) {
                setState(() {
                  xOffset = value;
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Y смещение
            Row(
              children: [
                const Icon(Icons.arrow_downward),
                const SizedBox(width: 8),
                Text(l10n.yOffset),
                const Spacer(),
                Text('${yOffset.toStringAsFixed(1)}'),
              ],
            ),
            Slider(
              value: yOffset,
              min: -100,
              max: 100,
              divisions: 200,
              onChanged: (value) {
                setState(() {
                  yOffset = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScaleRotationControls() {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.scaleRotation,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Масштаб
            Row(
              children: [
                const Icon(Icons.zoom_in),
                const SizedBox(width: 8),
                Text(l10n.scale),
                const Spacer(),
                Text('${scale.toStringAsFixed(2)}x'),
              ],
            ),
            Slider(
              value: scale,
              min: 0.5,
              max: 2.0,
              divisions: 150,
              onChanged: (value) {
                setState(() {
                  scale = value;
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Поворот
            Row(
              children: [
                const Icon(Icons.rotate_right),
                const SizedBox(width: 8),
                Text(l10n.rotation),
                const Spacer(),
                Text('${rotation.toStringAsFixed(1)}°'),
              ],
            ),
            Slider(
              value: rotation,
              min: -180,
              max: 180,
              divisions: 360,
              onChanged: (value) {
                setState(() {
                  rotation = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _applyCalibration,
            icon: const Icon(Icons.check),
            label: Text(l10n.apply),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _resetCalibration,
            icon: const Icon(Icons.refresh),
            label: Text(l10n.reset),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
} 