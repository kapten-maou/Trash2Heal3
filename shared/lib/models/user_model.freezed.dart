// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get uid => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get role =>
      throw _privateConstructorUsedError; // 'user', 'courier', 'admin'
// Points & Membership
  int get pointBalance => throw _privateConstructorUsedError;
  String get membershipTier =>
      throw _privateConstructorUsedError; // 'silver', 'gold', 'platinum'
// Profile
  String? get photoUrl => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  DateTime? get dateOfBirth => throw _privateConstructorUsedError;
  String? get gender =>
      throw _privateConstructorUsedError; // 'male', 'female', 'other'
// Address (primary address ID)
  String? get primaryAddressId => throw _privateConstructorUsedError; // Status
  bool get isActive => throw _privateConstructorUsedError;
  bool get isVerified =>
      throw _privateConstructorUsedError; // FCM Token for push notifications
  String? get fcmToken => throw _privateConstructorUsedError; // Timestamps
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call(
      {String uid,
      String email,
      String name,
      String phone,
      String role,
      int pointBalance,
      String membershipTier,
      String? photoUrl,
      String? bio,
      DateTime? dateOfBirth,
      String? gender,
      String? primaryAddressId,
      bool isActive,
      bool isVerified,
      String? fcmToken,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? updatedAt});
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = null,
    Object? name = null,
    Object? phone = null,
    Object? role = null,
    Object? pointBalance = null,
    Object? membershipTier = null,
    Object? photoUrl = freezed,
    Object? bio = freezed,
    Object? dateOfBirth = freezed,
    Object? gender = freezed,
    Object? primaryAddressId = freezed,
    Object? isActive = null,
    Object? isVerified = null,
    Object? fcmToken = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      pointBalance: null == pointBalance
          ? _value.pointBalance
          : pointBalance // ignore: cast_nullable_to_non_nullable
              as int,
      membershipTier: null == membershipTier
          ? _value.membershipTier
          : membershipTier // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      dateOfBirth: freezed == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryAddressId: freezed == primaryAddressId
          ? _value.primaryAddressId
          : primaryAddressId // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      fcmToken: freezed == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
          _$UserModelImpl value, $Res Function(_$UserModelImpl) then) =
      __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      String email,
      String name,
      String phone,
      String role,
      int pointBalance,
      String membershipTier,
      String? photoUrl,
      String? bio,
      DateTime? dateOfBirth,
      String? gender,
      String? primaryAddressId,
      bool isActive,
      bool isVerified,
      String? fcmToken,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? updatedAt});
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
      _$UserModelImpl _value, $Res Function(_$UserModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = null,
    Object? name = null,
    Object? phone = null,
    Object? role = null,
    Object? pointBalance = null,
    Object? membershipTier = null,
    Object? photoUrl = freezed,
    Object? bio = freezed,
    Object? dateOfBirth = freezed,
    Object? gender = freezed,
    Object? primaryAddressId = freezed,
    Object? isActive = null,
    Object? isVerified = null,
    Object? fcmToken = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$UserModelImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      pointBalance: null == pointBalance
          ? _value.pointBalance
          : pointBalance // ignore: cast_nullable_to_non_nullable
              as int,
      membershipTier: null == membershipTier
          ? _value.membershipTier
          : membershipTier // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      dateOfBirth: freezed == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryAddressId: freezed == primaryAddressId
          ? _value.primaryAddressId
          : primaryAddressId // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      fcmToken: freezed == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl extends _UserModel {
  const _$UserModelImpl(
      {required this.uid,
      required this.email,
      required this.name,
      required this.phone,
      required this.role,
      this.pointBalance = 0,
      this.membershipTier = 'silver',
      this.photoUrl,
      this.bio,
      this.dateOfBirth,
      this.gender,
      this.primaryAddressId,
      this.isActive = true,
      this.isVerified = false,
      this.fcmToken,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.updatedAt})
      : super._();

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String uid;
  @override
  final String email;
  @override
  final String name;
  @override
  final String phone;
  @override
  final String role;
// 'user', 'courier', 'admin'
// Points & Membership
  @override
  @JsonKey()
  final int pointBalance;
  @override
  @JsonKey()
  final String membershipTier;
// 'silver', 'gold', 'platinum'
// Profile
  @override
  final String? photoUrl;
  @override
  final String? bio;
  @override
  final DateTime? dateOfBirth;
  @override
  final String? gender;
// 'male', 'female', 'other'
// Address (primary address ID)
  @override
  final String? primaryAddressId;
// Status
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool isVerified;
// FCM Token for push notifications
  @override
  final String? fcmToken;
// Timestamps
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? createdAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, name: $name, phone: $phone, role: $role, pointBalance: $pointBalance, membershipTier: $membershipTier, photoUrl: $photoUrl, bio: $bio, dateOfBirth: $dateOfBirth, gender: $gender, primaryAddressId: $primaryAddressId, isActive: $isActive, isVerified: $isVerified, fcmToken: $fcmToken, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.pointBalance, pointBalance) ||
                other.pointBalance == pointBalance) &&
            (identical(other.membershipTier, membershipTier) ||
                other.membershipTier == membershipTier) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.primaryAddressId, primaryAddressId) ||
                other.primaryAddressId == primaryAddressId) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.fcmToken, fcmToken) ||
                other.fcmToken == fcmToken) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      email,
      name,
      phone,
      role,
      pointBalance,
      membershipTier,
      photoUrl,
      bio,
      dateOfBirth,
      gender,
      primaryAddressId,
      isActive,
      isVerified,
      fcmToken,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(
      this,
    );
  }
}

abstract class _UserModel extends UserModel {
  const factory _UserModel(
      {required final String uid,
      required final String email,
      required final String name,
      required final String phone,
      required final String role,
      final int pointBalance,
      final String membershipTier,
      final String? photoUrl,
      final String? bio,
      final DateTime? dateOfBirth,
      final String? gender,
      final String? primaryAddressId,
      final bool isActive,
      final bool isVerified,
      final String? fcmToken,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? updatedAt}) = _$UserModelImpl;
  const _UserModel._() : super._();

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String get uid;
  @override
  String get email;
  @override
  String get name;
  @override
  String get phone;
  @override
  String get role;
  @override // 'user', 'courier', 'admin'
// Points & Membership
  int get pointBalance;
  @override
  String get membershipTier;
  @override // 'silver', 'gold', 'platinum'
// Profile
  String? get photoUrl;
  @override
  String? get bio;
  @override
  DateTime? get dateOfBirth;
  @override
  String? get gender;
  @override // 'male', 'female', 'other'
// Address (primary address ID)
  String? get primaryAddressId;
  @override // Status
  bool get isActive;
  @override
  bool get isVerified;
  @override // FCM Token for push notifications
  String? get fcmToken;
  @override // Timestamps
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get createdAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
