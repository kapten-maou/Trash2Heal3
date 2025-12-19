import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const UserModel._();
  const factory UserModel({
    required String uid,
    required String email,
    required String name,
    required String phone,
    required String role, // 'user', 'courier', 'admin'

    // Points & Membership
    @Default(0) int pointBalance,
    @Default('silver') String membershipTier, // 'silver', 'gold', 'platinum'

    // Profile
    String? photoUrl,
    String? bio,
    DateTime? dateOfBirth,
    String? gender, // 'male', 'female', 'other'

    // Address (primary address ID)
    String? primaryAddressId,

    // Status
    @Default(true) bool isActive,
    @Default(false) bool isVerified,

    // FCM Token for push notifications
    String? fcmToken,

    // Timestamps
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? createdAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>?) ?? {};
    return UserModel(
      uid: data['uid'] ?? doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? (data['email'] ?? ''),
      phone: data['phone'] ?? '',
      role: data['role'] ?? 'user',
      pointBalance: data['pointBalance'] ?? 0,
      membershipTier: data['membershipTier'] ?? 'silver',
      photoUrl: data['photoUrl'],
      bio: data['bio'],
      dateOfBirth: _timestampFromJson(data['dateOfBirth']),
      gender: data['gender'],
      primaryAddressId: data['primaryAddressId'],
      isActive: data['isActive'] ?? true,
      isVerified: data['isVerified'] ?? false,
      fcmToken: data['fcmToken'],
      createdAt: _timestampFromJson(data['createdAt']),
      updatedAt: _timestampFromJson(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() => toJson();
}

// Timestamp converters
DateTime? _timestampFromJson(dynamic timestamp) {
  if (timestamp == null) return null;
  if (timestamp is Timestamp) return timestamp.toDate();
  if (timestamp is String) return DateTime.parse(timestamp);
  return null;
}

dynamic _timestampToJson(DateTime? dateTime) {
  if (dateTime == null) return null;
  return Timestamp.fromDate(dateTime);
}
