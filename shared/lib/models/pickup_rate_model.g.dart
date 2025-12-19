// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pickup_rate_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PickupRateModelImpl _$$PickupRateModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PickupRateModelImpl(
      id: json['id'] as String,
      category: json['category'] as String,
      displayName: json['displayName'] as String,
      description: json['description'] as String?,
      iconUrl: json['iconUrl'] as String?,
      pointsPerKg: (json['pointsPerKg'] as num).toDouble(),
      avgWeightPerUnit: (json['avgWeightPerUnit'] as num).toDouble(),
      minQuantity: (json['minQuantity'] as num?)?.toInt(),
      maxQuantity: (json['maxQuantity'] as num?)?.toInt(),
      isActive: json['isActive'] as bool? ?? true,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      createdAt: _timestampFromJson(json['createdAt']),
      updatedAt: _timestampFromJson(json['updatedAt']),
    );

Map<String, dynamic> _$$PickupRateModelImplToJson(
        _$PickupRateModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': instance.category,
      'displayName': instance.displayName,
      'description': instance.description,
      'iconUrl': instance.iconUrl,
      'pointsPerKg': instance.pointsPerKg,
      'avgWeightPerUnit': instance.avgWeightPerUnit,
      'minQuantity': instance.minQuantity,
      'maxQuantity': instance.maxQuantity,
      'isActive': instance.isActive,
      'sortOrder': instance.sortOrder,
      'createdAt': _timestampToJson(instance.createdAt),
      'updatedAt': _timestampToJson(instance.updatedAt),
    };
