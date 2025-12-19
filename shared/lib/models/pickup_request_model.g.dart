// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pickup_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PickupRequestModelImpl _$$PickupRequestModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PickupRequestModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      courierId: json['courierId'] as String?,
      quantities: Map<String, int>.from(json['quantities'] as Map),
      estimatedWeight: (json['estimatedWeight'] as num).toDouble(),
      actualWeight: (json['actualWeight'] as num?)?.toDouble(),
      estimatedPoints: (json['estimatedPoints'] as num).toInt(),
      actualPoints: (json['actualPoints'] as num?)?.toInt(),
      addressSnapshot: json['addressSnapshot'] as Map<String, dynamic>,
      pickupDate: _requiredTimestampFromJson(json['pickupDate']),
      timeRange: json['timeRange'] as String,
      zone: json['zone'] as String,
      status: $enumDecode(_$PickupStatusEnumMap, json['status']),
      otp: json['otp'] as String?,
      proofPhotos: (json['proofPhotos'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      cancelReason: json['cancelReason'] as String?,
      notes: json['notes'] as String?,
      createdAt: _timestampFromJson(json['createdAt']),
      updatedAt: _timestampFromJson(json['updatedAt']),
      assignedAt: _timestampFromJson(json['assignedAt']),
      onTheWayAt: _timestampFromJson(json['onTheWayAt']),
      arrivedAt: _timestampFromJson(json['arrivedAt']),
      pickedUpAt: _timestampFromJson(json['pickedUpAt']),
      completedAt: _timestampFromJson(json['completedAt']),
      cancelledAt: _timestampFromJson(json['cancelledAt']),
    );

Map<String, dynamic> _$$PickupRequestModelImplToJson(
        _$PickupRequestModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'courierId': instance.courierId,
      'quantities': instance.quantities,
      'estimatedWeight': instance.estimatedWeight,
      'actualWeight': instance.actualWeight,
      'estimatedPoints': instance.estimatedPoints,
      'actualPoints': instance.actualPoints,
      'addressSnapshot': instance.addressSnapshot,
      'pickupDate': _timestampToJson(instance.pickupDate),
      'timeRange': instance.timeRange,
      'zone': instance.zone,
      'status': _$PickupStatusEnumMap[instance.status]!,
      'otp': instance.otp,
      'proofPhotos': instance.proofPhotos,
      'cancelReason': instance.cancelReason,
      'notes': instance.notes,
      'createdAt': _timestampToJson(instance.createdAt),
      'updatedAt': _timestampToJson(instance.updatedAt),
      'assignedAt': _timestampToJson(instance.assignedAt),
      'onTheWayAt': _timestampToJson(instance.onTheWayAt),
      'arrivedAt': _timestampToJson(instance.arrivedAt),
      'pickedUpAt': _timestampToJson(instance.pickedUpAt),
      'completedAt': _timestampToJson(instance.completedAt),
      'cancelledAt': _timestampToJson(instance.cancelledAt),
    };

const _$PickupStatusEnumMap = {
  PickupStatus.pending: 'pending',
  PickupStatus.assigned: 'assigned',
  PickupStatus.onTheWay: 'on_the_way',
  PickupStatus.arrived: 'arrived',
  PickupStatus.pickedUp: 'picked_up',
  PickupStatus.completed: 'completed',
  PickupStatus.cancelled: 'cancelled',
};
