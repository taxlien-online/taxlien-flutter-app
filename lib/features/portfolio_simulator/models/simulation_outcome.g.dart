// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simulation_outcome.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SimulationOutcome _$SimulationOutcomeFromJson(Map<String, dynamic> json) =>
    SimulationOutcome(
      id: json['id'] as String,
      positionId: json['positionId'] as String,
      type: $enumDecode(_$OutcomeTypeEnumMap, json['type'],
          unknownValue: OutcomeType.loss),
      finalValue: (json['finalValue'] as num).toDouble(),
      profitLoss: (json['profitLoss'] as num).toDouble(),
      roiPercentage: (json['roiPercentage'] as num).toDouble(),
      weeksToOutcome: (json['weeksToOutcome'] as num).toInt(),
      probability: (json['probability'] as num).toDouble(),
      isMlGenerated: json['isMlGenerated'] as bool,
      lessonLearned: json['lessonLearned'] as String,
      explanation: json['explanation'] as String,
      generatedAt: DateTime.parse(json['generatedAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$SimulationOutcomeToJson(SimulationOutcome instance) =>
    <String, dynamic>{
      'id': instance.id,
      'positionId': instance.positionId,
      'type': _$OutcomeTypeEnumMap[instance.type]!,
      'finalValue': instance.finalValue,
      'profitLoss': instance.profitLoss,
      'roiPercentage': instance.roiPercentage,
      'weeksToOutcome': instance.weeksToOutcome,
      'probability': instance.probability,
      'isMlGenerated': instance.isMlGenerated,
      'lessonLearned': instance.lessonLearned,
      'explanation': instance.explanation,
      'generatedAt': instance.generatedAt.toIso8601String(),
      'metadata': instance.metadata,
    };

const _$OutcomeTypeEnumMap = {
  OutcomeType.redeemed: 'redeemed',
  OutcomeType.foreclosed: 'foreclosed',
  OutcomeType.partialPayment: 'partialPayment',
  OutcomeType.loss: 'loss',
};
