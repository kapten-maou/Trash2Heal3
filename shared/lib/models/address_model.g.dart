// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AddressModelImpl _$$AddressModelImplFromJson(Map<String, dynamic> json) =>
    _$AddressModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      label: json['label'] as String,
      recipientName: json['recipientName'] as String,
      phone: json['phone'] as String,
      fullAddress: json['fullAddress'] as String,
      city: json['city'] as String,
      postalCode: json['postalCode'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      buildingDetails: json['buildingDetails'] as String?,
      isPrimary: json['isPrimary'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: _timestampFromJson(json['createdAt']),
      updatedAt: _timestampFromJson(json['updatedAt']),
    );

Map<String, dynamic> _$$AddressModelImplToJson(_$AddressModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'label': instance.label,
      'recipientName': instance.recipientName,
      'phone': instance.phone,
      'fullAddress': instance.fullAddress,
      'city': instance.city,
      'postalCode': instance.postalCode,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'notes': instance.notes,
      'buildingDetails': instance.buildingDetails,
      'isPrimary': instance.isPrimary,
      'isActive': instance.isActive,
      'createdAt': _timestampToJson(instance.createdAt),
      'updatedAt': _timestampToJson(instance.updatedAt),
    };
