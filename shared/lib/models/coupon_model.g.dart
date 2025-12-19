// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CouponModelImpl _$$CouponModelImplFromJson(Map<String, dynamic> json) =>
    _$CouponModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$CouponTypeEnumMap, json['type']),
      value: (json['value'] as num).toInt(),
      pointsSpent: (json['pointsSpent'] as num).toInt(),
      status: $enumDecode(_$CouponStatusEnumMap, json['status']),
      redeemRequestId: json['redeemRequestId'] as String?,
      provider: json['provider'] as String?,
      category: json['category'] as String?,
      imageUrl: json['imageUrl'] as String?,
      terms: json['terms'] as String?,
      instructions: json['instructions'] as String?,
      expiryDate: _timestampFromJson(json['expiryDate']),
      usedAt: _timestampFromJson(json['usedAt']),
      usedLocation: json['usedLocation'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: _timestampFromJson(json['createdAt']),
      updatedAt: _timestampFromJson(json['updatedAt']),
    );

Map<String, dynamic> _$$CouponModelImplToJson(_$CouponModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'code': instance.code,
      'name': instance.name,
      'type': _$CouponTypeEnumMap[instance.type]!,
      'value': instance.value,
      'pointsSpent': instance.pointsSpent,
      'status': _$CouponStatusEnumMap[instance.status]!,
      'redeemRequestId': instance.redeemRequestId,
      'provider': instance.provider,
      'category': instance.category,
      'imageUrl': instance.imageUrl,
      'terms': instance.terms,
      'instructions': instance.instructions,
      'expiryDate': _timestampToJson(instance.expiryDate),
      'usedAt': _timestampToJson(instance.usedAt),
      'usedLocation': instance.usedLocation,
      'metadata': instance.metadata,
      'createdAt': _timestampToJson(instance.createdAt),
      'updatedAt': _timestampToJson(instance.updatedAt),
    };

const _$CouponTypeEnumMap = {
  CouponType.voucher: 'voucher',
  CouponType.balance: 'balance',
};

const _$CouponStatusEnumMap = {
  CouponStatus.active: 'active',
  CouponStatus.used: 'used',
  CouponStatus.expired: 'expired',
  CouponStatus.cancelled: 'cancelled',
};
