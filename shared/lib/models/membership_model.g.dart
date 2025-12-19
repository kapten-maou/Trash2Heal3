// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MembershipModelImpl _$$MembershipModelImplFromJson(
        Map<String, dynamic> json) =>
    _$MembershipModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userEmail: json['userEmail'] as String,
      tier: $enumDecode(_$MembershipTierEnumMap, json['tier']),
      status: $enumDecode(_$MembershipStatusEnumMap, json['status']),
      startDate: _requiredTimestampFromJson(json['startDate']),
      endDate: _requiredTimestampFromJson(json['endDate']),
      durationMonths: (json['durationMonths'] as num).toInt(),
      price: (json['price'] as num).toInt(),
      paymentId: json['paymentId'] as String?,
      previousTier: json['previousTier'] as String?,
      autoRenew: json['autoRenew'] as bool? ?? false,
      isLifetime: json['isLifetime'] as bool? ?? false,
      benefits: json['benefits'] as Map<String, dynamic>,
      usageStats: json['usageStats'] as Map<String, dynamic>?,
      cancellationReason: json['cancellationReason'] as String?,
      cancelledAt: _timestampFromJson(json['cancelledAt']),
      cancelledBy: json['cancelledBy'] as String?,
      renewalDate: _timestampFromJson(json['renewalDate']),
      renewalPaymentId: json['renewalPaymentId'] as String?,
      renewalCount: (json['renewalCount'] as num?)?.toInt() ?? 0,
      promoCode: json['promoCode'] as String?,
      discount: (json['discount'] as num?)?.toInt(),
      notes: json['notes'] as String?,
      createdAt: _timestampFromJson(json['createdAt']),
      updatedAt: _timestampFromJson(json['updatedAt']),
      createdBy: json['createdBy'] as String?,
      updatedBy: json['updatedBy'] as String?,
    );

Map<String, dynamic> _$$MembershipModelImplToJson(
        _$MembershipModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userName': instance.userName,
      'userEmail': instance.userEmail,
      'tier': _$MembershipTierEnumMap[instance.tier]!,
      'status': _$MembershipStatusEnumMap[instance.status]!,
      'startDate': _timestampToJson(instance.startDate),
      'endDate': _timestampToJson(instance.endDate),
      'durationMonths': instance.durationMonths,
      'price': instance.price,
      'paymentId': instance.paymentId,
      'previousTier': instance.previousTier,
      'autoRenew': instance.autoRenew,
      'isLifetime': instance.isLifetime,
      'benefits': instance.benefits,
      'usageStats': instance.usageStats,
      'cancellationReason': instance.cancellationReason,
      'cancelledAt': _timestampToJson(instance.cancelledAt),
      'cancelledBy': instance.cancelledBy,
      'renewalDate': _timestampToJson(instance.renewalDate),
      'renewalPaymentId': instance.renewalPaymentId,
      'renewalCount': instance.renewalCount,
      'promoCode': instance.promoCode,
      'discount': instance.discount,
      'notes': instance.notes,
      'createdAt': _timestampToJson(instance.createdAt),
      'updatedAt': _timestampToJson(instance.updatedAt),
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
    };

const _$MembershipTierEnumMap = {
  MembershipTier.basic: 'basic',
  MembershipTier.gold: 'gold',
  MembershipTier.platinum: 'platinum',
};

const _$MembershipStatusEnumMap = {
  MembershipStatus.active: 'active',
  MembershipStatus.expired: 'expired',
  MembershipStatus.cancelled: 'cancelled',
  MembershipStatus.pending: 'pending',
};
