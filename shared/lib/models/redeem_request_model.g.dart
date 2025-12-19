// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'redeem_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RedeemRequestModelImpl _$$RedeemRequestModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RedeemRequestModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userEmail: json['userEmail'] as String,
      userPhone: json['userPhone'] as String,
      type: json['type'] as String,
      points: (json['points'] as num).toInt(),
      amount: (json['amount'] as num).toInt(),
      status: $enumDecode(_$RedeemStatusEnumMap, json['status']),
      voucherName: json['voucherName'] as String?,
      voucherProvider: json['voucherProvider'] as String?,
      voucherCategory: json['voucherCategory'] as String?,
      voucherValue: (json['voucherValue'] as num?)?.toInt(),
      bankName: json['bankName'] as String?,
      accountNumber: json['accountNumber'] as String?,
      accountHolderName: json['accountHolderName'] as String?,
      couponId: json['couponId'] as String?,
      adminNotes: json['adminNotes'] as String?,
      processedBy: json['processedBy'] as String?,
      processedAt: _timestampFromJson(json['processedAt']),
      rejectionReason: json['rejectionReason'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: _timestampFromJson(json['createdAt']),
      updatedAt: _timestampFromJson(json['updatedAt']),
    );

Map<String, dynamic> _$$RedeemRequestModelImplToJson(
        _$RedeemRequestModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userName': instance.userName,
      'userEmail': instance.userEmail,
      'userPhone': instance.userPhone,
      'type': instance.type,
      'points': instance.points,
      'amount': instance.amount,
      'status': _$RedeemStatusEnumMap[instance.status]!,
      'voucherName': instance.voucherName,
      'voucherProvider': instance.voucherProvider,
      'voucherCategory': instance.voucherCategory,
      'voucherValue': instance.voucherValue,
      'bankName': instance.bankName,
      'accountNumber': instance.accountNumber,
      'accountHolderName': instance.accountHolderName,
      'couponId': instance.couponId,
      'adminNotes': instance.adminNotes,
      'processedBy': instance.processedBy,
      'processedAt': _timestampToJson(instance.processedAt),
      'rejectionReason': instance.rejectionReason,
      'metadata': instance.metadata,
      'createdAt': _timestampToJson(instance.createdAt),
      'updatedAt': _timestampToJson(instance.updatedAt),
    };

const _$RedeemStatusEnumMap = {
  RedeemStatus.pending: 'pending',
  RedeemStatus.processing: 'processing',
  RedeemStatus.approved: 'approved',
  RedeemStatus.rejected: 'rejected',
  RedeemStatus.cancelled: 'cancelled',
};
