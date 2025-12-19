// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentModelImpl _$$PaymentModelImplFromJson(Map<String, dynamic> json) =>
    _$PaymentModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userEmail: json['userEmail'] as String,
      membershipId: json['membershipId'] as String?,
      type: $enumDecode(_$PaymentTypeEnumMap, json['type']),
      method: $enumDecode(_$PaymentMethodEnumMap, json['method']),
      status: $enumDecode(_$PaymentStatusEnumMap, json['status']),
      amount: (json['amount'] as num).toInt(),
      discount: (json['discount'] as num?)?.toInt() ?? 0,
      tax: (json['tax'] as num?)?.toInt() ?? 0,
      totalAmount: (json['totalAmount'] as num).toInt(),
      currency: json['currency'] as String?,
      orderId: json['orderId'] as String?,
      transactionId: json['transactionId'] as String?,
      invoiceNumber: json['invoiceNumber'] as String?,
      paymentDetails: json['paymentDetails'] as Map<String, dynamic>?,
      provider: json['provider'] as String?,
      providerReference: json['providerReference'] as String?,
      vaNumber: json['vaNumber'] as String?,
      qrCode: json['qrCode'] as String?,
      paymentUrl: json['paymentUrl'] as String?,
      promoCode: json['promoCode'] as String?,
      itemDetails: json['itemDetails'] as Map<String, dynamic>?,
      paidAt: _timestampFromJson(json['paidAt']),
      expiryDate: _timestampFromJson(json['expiryDate']),
      failureReason: json['failureReason'] as String?,
      refundReason: json['refundReason'] as String?,
      refundAmount: (json['refundAmount'] as num?)?.toInt(),
      refundedAt: _timestampFromJson(json['refundedAt']),
      refundedBy: json['refundedBy'] as String?,
      cancelReason: json['cancelReason'] as String?,
      cancelledAt: _timestampFromJson(json['cancelledAt']),
      metadata: json['metadata'] as Map<String, dynamic>?,
      notes: json['notes'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      verifiedBy: json['verifiedBy'] as String?,
      verifiedAt: _timestampFromJson(json['verifiedAt']),
      createdAt: _timestampFromJson(json['createdAt']),
      updatedAt: _timestampFromJson(json['updatedAt']),
    );

Map<String, dynamic> _$$PaymentModelImplToJson(_$PaymentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userName': instance.userName,
      'userEmail': instance.userEmail,
      'membershipId': instance.membershipId,
      'type': _$PaymentTypeEnumMap[instance.type]!,
      'method': _$PaymentMethodEnumMap[instance.method]!,
      'status': _$PaymentStatusEnumMap[instance.status]!,
      'amount': instance.amount,
      'discount': instance.discount,
      'tax': instance.tax,
      'totalAmount': instance.totalAmount,
      'currency': instance.currency,
      'orderId': instance.orderId,
      'transactionId': instance.transactionId,
      'invoiceNumber': instance.invoiceNumber,
      'paymentDetails': instance.paymentDetails,
      'provider': instance.provider,
      'providerReference': instance.providerReference,
      'vaNumber': instance.vaNumber,
      'qrCode': instance.qrCode,
      'paymentUrl': instance.paymentUrl,
      'promoCode': instance.promoCode,
      'itemDetails': instance.itemDetails,
      'paidAt': _timestampToJson(instance.paidAt),
      'expiryDate': _timestampToJson(instance.expiryDate),
      'failureReason': instance.failureReason,
      'refundReason': instance.refundReason,
      'refundAmount': instance.refundAmount,
      'refundedAt': _timestampToJson(instance.refundedAt),
      'refundedBy': instance.refundedBy,
      'cancelReason': instance.cancelReason,
      'cancelledAt': _timestampToJson(instance.cancelledAt),
      'metadata': instance.metadata,
      'notes': instance.notes,
      'isVerified': instance.isVerified,
      'verifiedBy': instance.verifiedBy,
      'verifiedAt': _timestampToJson(instance.verifiedAt),
      'createdAt': _timestampToJson(instance.createdAt),
      'updatedAt': _timestampToJson(instance.updatedAt),
    };

const _$PaymentTypeEnumMap = {
  PaymentType.membership: 'membership',
  PaymentType.renewal: 'renewal',
  PaymentType.upgrade: 'upgrade',
};

const _$PaymentMethodEnumMap = {
  PaymentMethod.bankTransfer: 'bank_transfer',
  PaymentMethod.creditCard: 'credit_card',
  PaymentMethod.ewallet: 'ewallet',
  PaymentMethod.qris: 'qris',
  PaymentMethod.virtualAccount: 'virtual_account',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.processing: 'processing',
  PaymentStatus.paid: 'paid',
  PaymentStatus.failed: 'failed',
  PaymentStatus.expired: 'expired',
  PaymentStatus.refunded: 'refunded',
  PaymentStatus.cancelled: 'cancelled',
};
