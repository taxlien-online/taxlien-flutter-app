// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simulated_position.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SimulatedPosition _$SimulatedPositionFromJson(Map<String, dynamic> json) =>
    SimulatedPosition(
      id: json['id'] as String,
      portfolioId: json['portfolioId'] as String,
      propertyId: json['propertyId'] as String,
      propertyAddress: json['propertyAddress'] as String,
      county: json['county'] as String,
      state: json['state'] as String,
      purchasePrice: (json['purchasePrice'] as num).toDouble(),
      transactionFees: (json['transactionFees'] as num).toDouble(),
      status: $enumDecode(_$PositionStatusEnumMap, json['status'],
          unknownValue: PositionStatus.purchased),
      purchasedAt: DateTime.parse(json['purchasedAt'] as String),
      expectedOutcomeAt: DateTime.parse(json['expectedOutcomeAt'] as String),
      simulationSpeed: (json['simulationSpeed'] as num).toDouble(),
      outcomeAt: json['outcomeAt'] == null
          ? null
          : DateTime.parse(json['outcomeAt'] as String),
      outcomeId: json['outcomeId'] as String?,
    );

Map<String, dynamic> _$SimulatedPositionToJson(SimulatedPosition instance) =>
    <String, dynamic>{
      'id': instance.id,
      'portfolioId': instance.portfolioId,
      'propertyId': instance.propertyId,
      'propertyAddress': instance.propertyAddress,
      'county': instance.county,
      'state': instance.state,
      'purchasePrice': instance.purchasePrice,
      'transactionFees': instance.transactionFees,
      'status': _$PositionStatusEnumMap[instance.status]!,
      'purchasedAt': instance.purchasedAt.toIso8601String(),
      'expectedOutcomeAt': instance.expectedOutcomeAt.toIso8601String(),
      'outcomeAt': instance.outcomeAt?.toIso8601String(),
      'outcomeId': instance.outcomeId,
      'simulationSpeed': instance.simulationSpeed,
    };

const _$PositionStatusEnumMap = {
  PositionStatus.purchased: 'purchased',
  PositionStatus.simulating: 'simulating',
  PositionStatus.outcomeReady: 'outcomeReady',
  PositionStatus.completed: 'completed',
  PositionStatus.closed: 'closed',
};
