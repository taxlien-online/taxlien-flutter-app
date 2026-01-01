import 'package:flutter/material.dart';
import '../models/simulated_position.dart';
import '../models/simulation_outcome.dart';

/// Simple performance chart widget
///
/// Shows portfolio performance over time
class PerformanceChart extends StatelessWidget {
  final List<SimulatedPosition> positions;
  final List<SimulationOutcome> outcomes;

  const PerformanceChart({
    super.key,
    required this.positions,
    required this.outcomes,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate cumulative P/L over time
    final dataPoints = <_ChartDataPoint>[];
    double cumulativePL = 0;

    // Sort outcomes by timestamp (using position purchase time as proxy)
    final sortedOutcomes = List<SimulationOutcome>.from(outcomes);
    // TODO: Sort by actual completion timestamp when available

    for (final outcome in sortedOutcomes) {
      cumulativePL += outcome.profitLoss;
      dataPoints.add(_ChartDataPoint(
        index: dataPoints.length,
        value: cumulativePL,
      ));
    }

    if (dataPoints.isEmpty) {
      return Center(
        child: Text(
          'No performance data yet',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    return CustomPaint(
      size: const Size(double.infinity, 200),
      painter: _ChartPainter(dataPoints),
    );
  }
}

class _ChartDataPoint {
  final int index;
  final double value;

  _ChartDataPoint({required this.index, required this.value});
}

class _ChartPainter extends CustomPainter {
  final List<_ChartDataPoint> dataPoints;

  _ChartPainter(this.dataPoints);

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.isEmpty) return;

    // Find min/max values
    final values = dataPoints.map((p) => p.value).toList();
    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final range = (maxValue - minValue).abs();

    // Padding
    const padding = 40.0;
    final chartWidth = size.width - (padding * 2);
    final chartHeight = size.height - (padding * 2);

    // Draw axes
    final axisPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(padding, size.height - padding),
      Offset(size.width - padding, size.height - padding),
      axisPaint,
    );

    canvas.drawLine(
      Offset(padding, padding),
      Offset(padding, size.height - padding),
      axisPaint,
    );

    // Draw zero line (if in range)
    if (minValue < 0 && maxValue > 0) {
      final zeroY = size.height -
          padding -
          ((-minValue / range) * chartHeight);
      final zeroPaint = Paint()
        ..color = Colors.grey[400]!
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke;

      canvas.drawLine(
        Offset(padding, zeroY),
        Offset(size.width - padding, zeroY),
        zeroPaint,
      );
    }

    // Draw line chart
    if (dataPoints.length > 1) {
      final linePaint = Paint()
        ..color = Colors.blue
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      final path = Path();
      for (int i = 0; i < dataPoints.length; i++) {
        final point = dataPoints[i];
        final x =
            padding + (i / (dataPoints.length - 1)) * chartWidth;
        final normalizedValue = range == 0
            ? 0.5
            : (point.value - minValue) / range;
        final y = size.height - padding - (normalizedValue * chartHeight);

        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      canvas.drawPath(path, linePaint);

      // Draw data points
      final pointPaint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.fill;

      for (int i = 0; i < dataPoints.length; i++) {
        final point = dataPoints[i];
        final x =
            padding + (i / (dataPoints.length - 1)) * chartWidth;
        final normalizedValue = range == 0
            ? 0.5
            : (point.value - minValue) / range;
        final y = size.height - padding - (normalizedValue * chartHeight);

        canvas.drawCircle(Offset(x, y), 4, pointPaint);
      }
    }

    // Draw labels
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Min value label
    textPainter.text = TextSpan(
      text: '\$${minValue.toStringAsFixed(0)}',
      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
    );
    textPainter.layout();
    textPainter.paint(
        canvas, Offset(5, size.height - padding - textPainter.height / 2));

    // Max value label
    textPainter.text = TextSpan(
      text: '\$${maxValue.toStringAsFixed(0)}',
      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(5, padding - textPainter.height / 2));
  }

  @override
  bool shouldRepaint(_ChartPainter oldDelegate) {
    return oldDelegate.dataPoints != dataPoints;
  }
}
