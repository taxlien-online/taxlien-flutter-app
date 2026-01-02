import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Radar Chart Widget (Simplified)
class RadarChartWidget extends StatelessWidget {
  final Map<String, int> riskScores;

  const RadarChartWidget({
    super.key,
    required this.riskScores,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(300, 300),
      painter: RadarChartPainter(riskScores),
    );
  }
}

class RadarChartPainter extends CustomPainter {
  final Map<String, int> riskScores;

  RadarChartPainter(this.riskScores);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 * 0.8;

    _drawGrid(canvas, center, radius);
    _drawData(canvas, center, radius);
    _drawLabels(canvas, center, radius);
  }

  void _drawGrid(Canvas canvas, Offset center, double radius) {
    final gridPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw concentric circles
    for (int i = 1; i <= 5; i++) {
      canvas.drawCircle(center, radius * (i / 5), gridPaint);
    }

    // Draw axes
    final points = riskScores.length;
    for (int i = 0; i < points; i++) {
      final angle = (2 * math.pi / points) * i - math.pi / 2;
      final end = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      canvas.drawLine(center, end, gridPaint);
    }
  }

  void _drawData(Canvas canvas, Offset center, double radius) {
    final dataPaint = Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final points = <Offset>[];
    final entries = riskScores.entries.toList();

    for (int i = 0; i < entries.length; i++) {
      final angle = (2 * math.pi / entries.length) * i - math.pi / 2;
      final value = entries[i].value / 100;
      final point = Offset(
        center.dx + radius * value * math.cos(angle),
        center.dy + radius * value * math.sin(angle),
      );
      points.add(point);
    }

    // Draw filled area
    final path = Path()..addPolygon(points, true);
    canvas.drawPath(path, dataPaint);
    canvas.drawPath(path, linePaint);

    // Draw points
    final pointPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, 4, pointPaint);
    }
  }

  void _drawLabels(Canvas canvas, Offset center, double radius) {
    final entries = riskScores.entries.toList();
    final labelRadius = radius * 1.15;

    for (int i = 0; i < entries.length; i++) {
      final angle = (2 * math.pi / entries.length) * i - math.pi / 2;
      final point = Offset(
        center.dx + labelRadius * math.cos(angle),
        center.dy + labelRadius * math.sin(angle),
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: _getShortLabel(entries[i].key),
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          point.dx - textPainter.width / 2,
          point.dy - textPainter.height / 2,
        ),
      );
    }
  }

  String _getShortLabel(String key) {
    const labels = {
      'legal': 'Legal',
      'market': 'Market',
      'location': 'Location',
      'condition': 'Condition',
      'financial': 'Financial',
      'competition': 'Competition',
    };
    return labels[key] ?? key;
  }

  @override
  bool shouldRepaint(RadarChartPainter oldDelegate) => true;
}
