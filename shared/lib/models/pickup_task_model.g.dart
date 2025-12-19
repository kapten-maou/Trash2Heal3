// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pickup_task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PickupTaskModelImpl _$$PickupTaskModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PickupTaskModelImpl(
      id: json['id'] as String,
      requestId: json['requestId'] as String,
      courierId: json['courierId'] as String,
      customerId: json['customerId'] as String,
      scheduledDate: _requiredTimestampFromJson(json['scheduledDate']),
      timeRange: json['timeRange'] as String,
      zone: json['zone'] as String,
      status: json['status'] as String,
      sequenceNumber: (json['sequenceNumber'] as num?)?.toInt(),
      isPriority: json['isPriority'] as bool? ?? false,
      notes: json['notes'] as String?,
      createdAt: _timestampFromJson(json['createdAt']),
      updatedAt: _timestampFromJson(json['updatedAt']),
    );

Map<String, dynamic> _$$PickupTaskModelImplToJson(
        _$PickupTaskModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requestId': instance.requestId,
      'courierId': instance.courierId,
      'customerId': instance.customerId,
      'scheduledDate': _timestampToJson(instance.scheduledDate),
      'timeRange': instance.timeRange,
      'zone': instance.zone,
      'status': instance.status,
      'sequenceNumber': instance.sequenceNumber,
      'isPriority': instance.isPriority,
      'notes': instance.notes,
      'createdAt': _timestampToJson(instance.createdAt),
      'updatedAt': _timestampToJson(instance.updatedAt),
    };
