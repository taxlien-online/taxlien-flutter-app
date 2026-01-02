import 'package:flutter/material.dart';
import '../../../core/models/tax_lien_models.dart';
import '../models/risk_assessment.dart';
import '../services/risk_assessment_service.dart';
import '../widgets/radar_chart_widget.dart';

/// Risk Radar Screen
///
/// Visual risk assessment with radar charts
class RiskRadarScreen extends StatefulWidget {
  final TaxLien property;

  const RiskRadarScreen({
    super.key,
    required this.property,
  });

  @override
  State<RiskRadarScreen> createState() => _RiskRadarScreenState();
}

class _RiskRadarScreenState extends State<RiskRadarScreen> {
  late Future<RiskAssessment> _assessmentFuture;

  @override
  void initState() {
    super.initState();
    _assessmentFuture = RiskAssessmentService.instance.assessProperty(widget.property);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Risk Radar'),
      ),
      body: FutureBuilder<RiskAssessment>(
        future: _assessmentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final assessment = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Property Header
              Text(
                widget.property.propertyAddress,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${widget.property.county}, ${widget.property.state}',
                style: const TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 24),

              // Overall Risk Score
              _buildOverallRiskCard(assessment),

              const SizedBox(height: 24),

              // Radar Chart
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        'Risk Analysis',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 300,
                        child: RadarChartWidget(
                          riskScores: assessment.riskScores,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Risk Factors Breakdown
              _buildFactorsBreakdown(assessment),

              const SizedBox(height: 24),

              // Warnings
              if (assessment.warnings.isNotEmpty) ...[
                _buildWarningsCard(assessment.warnings),
                const SizedBox(height: 16),
              ],

              // Strengths
              if (assessment.strengths.isNotEmpty)
                _buildStrengthsCard(assessment.strengths),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOverallRiskCard(RiskAssessment assessment) {
    return Card(
      color: Color(assessment.riskColor).withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              '${assessment.overallRiskScore}',
              style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: Color(assessment.riskColor),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              assessment.riskLevelDisplay,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(assessment.riskColor),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Overall Risk Score',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFactorsBreakdown(RiskAssessment assessment) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Risk Factors',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...assessment.riskScores.entries.map((entry) {
              return _buildFactorRow(entry.key, entry.value);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFactorRow(String factor, int score) {
    Color color;
    if (score < 30) {
      color = Colors.green;
    } else if (score < 60) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getFactorLabel(factor),
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                '$score/100',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: score / 100,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningsCard(List<String> warnings) {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning, color: Colors.red.shade700),
                const SizedBox(width: 8),
                const Text(
                  'Warnings',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...warnings.map((warning) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.circle, size: 8, color: Colors.red.shade700),
                    const SizedBox(width: 8),
                    Expanded(child: Text(warning)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStrengthsCard(List<String> strengths) {
    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green.shade700),
                const SizedBox(width: 8),
                const Text(
                  'Strengths',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...strengths.map((strength) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.circle, size: 8, color: Colors.green.shade700),
                    const SizedBox(width: 8),
                    Expanded(child: Text(strength)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  String _getFactorLabel(String factor) {
    const labels = {
      'legal': 'Legal/Title Risk',
      'market': 'Market Risk',
      'location': 'Location Risk',
      'condition': 'Property Condition',
      'financial': 'Financial Risk',
      'competition': 'Competition Risk',
    };
    return labels[factor] ?? factor;
  }
}
