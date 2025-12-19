// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentMethodModelImpl _$$PaymentMethodModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PaymentMethodModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: json['type'] as String,
      provider: json['provider'] as String,
      accountName: json['accountName'] as String,
      accountNumber: json['accountNumber'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      cardNumber: json['cardNumber'] as String?,
      isPrimary: json['isPrimary'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: _timestampFromJson(json['createdAt']),
      updatedAt: _timestampFromJson(json['updatedAt']),
    );

Map<String, dynamic> _$$PaymentMethodModelImplToJson(
        _$PaymentMethodModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': instance.type,
      'provider': instance.provider,
      'accountName': instance.accountName,
      'accountNumber': instance.accountNumber,
      'phoneNumber': instance.phoneNumber,
      'cardNumber': instance.cardNumber,
      'isPrimary': instance.isPrimary,
      'isActive': instance.isActive,
      'createdAt': _timestampToJson(instance.createdAt),
      'updatedAt': _timestampToJson(instance.updatedAt),
    };
