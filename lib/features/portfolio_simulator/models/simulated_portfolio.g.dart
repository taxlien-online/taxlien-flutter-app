// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simulated_portfolio.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SimulatedPortfolio _$SimulatedPortfolioFromJson(Map<String, dynamic> json) =>
    SimulatedPortfolio(
      id: json['id'] as String,
      name: json['name'] as String,
      availableCapital: (json['availableCapital'] as num).toDouble(),
      investedValue: (json['investedValue'] as num).toDouble(),
      positionCount: (json['positionCount'] as num).toInt(),
      roi: (json['roi'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      userId: json['userId'] as String,
      isArchived: json['isArchived'] as bool? ?? false,
    );

Map<String, dynamic> _$SimulatedPortfolioToJson(SimulatedPortfolio instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'availableCapital': instance.availableCapital,
      'investedValue': instance.investedValue,
      'positionCount': instance.positionCount,
      'roi': instance.roi,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'userId': instance.userId,
      'isArchived': instance.isArchived,
    };
