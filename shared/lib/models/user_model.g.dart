// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      uid: json['uid'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      role: json['role'] as String,
      pointBalance: (json['pointBalance'] as num?)?.toInt() ?? 0,
      membershipTier: json['membershipTier'] as String? ?? 'silver',
      photoUrl: json['photoUrl'] as String?,
      bio: json['bio'] as String?,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      gender: json['gender'] as String?,
      primaryAddressId: json['primaryAddressId'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      isVerified: json['isVerified'] as bool? ?? false,
      fcmToken: json['fcmToken'] as String?,
      createdAt: _timestampFromJson(json['createdAt']),
      updatedAt: _timestampFromJson(json['updatedAt']),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'name': instance.name,
      'phone': instance.phone,
      'role': instance.role,
      'pointBalance': instance.pointBalance,
      'membershipTier': instance.membershipTier,
      'photoUrl': instance.photoUrl,
      'bio': instance.bio,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'gender': instance.gender,
      'primaryAddressId': instance.primaryAddressId,
      'isActive': instance.isActive,
      'isVerified': instance.isVerified,
      'fcmToken': instance.fcmToken,
      'createdAt': _timestampToJson(instance.createdAt),
      'updatedAt': _timestampToJson(instance.updatedAt),
    };
