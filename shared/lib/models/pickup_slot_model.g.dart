// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pickup_slot_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PickupSlotModelImpl _$$PickupSlotModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PickupSlotModelImpl(
      id: json['id'] as String,
      date: _requiredTimestampFromJson(json['date']),
      timeRange: json['timeRange'] as String,
      zone: json['zone'] as String,
      capacityWeightKg: (json['capacityWeightKg'] as num).toInt(),
      usedWeightKg: (json['usedWeightKg'] as num?)?.toInt() ?? 0,
      courierId: json['courierId'] as String?,
      courierName: json['courierName'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: _timestampFromJson(json['createdAt']),
      updatedAt: _timestampFromJson(json['updatedAt']),
    );

Map<String, dynamic> _$$PickupSlotModelImplToJson(
        _$PickupSlotModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': _timestampToJson(instance.date),
      'timeRange': instance.timeRange,
      'zone': instance.zone,
      'capacityWeightKg': instance.capacityWeightKg,
      'usedWeightKg': instance.usedWeightKg,
      'courierId': instance.courierId,
      'courierName': instance.courierName,
      'isActive': instance.isActive,
      'createdAt': _timestampToJson(instance.createdAt),
      'updatedAt': _timestampToJson(instance.updatedAt),
    };
