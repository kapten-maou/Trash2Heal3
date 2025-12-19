// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'redeem_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RedeemRequestModel _$RedeemRequestModelFromJson(Map<String, dynamic> json) {
  return _RedeemRequestModel.fromJson(json);
}

/// @nodoc
mixin _$RedeemRequestModel {
  /// Unique request ID
  String get id => throw _privateConstructorUsedError;

  /// User requesting redemption
  String get userId => throw _privateConstructorUsedError;

  /// User's name (snapshot for display)
  String get userName => throw _privateConstructorUsedError;

  /// User's email (snapshot for display)
  String get userEmail => throw _privateConstructorUsedError;

  /// User's phone (snapshot for delivery/notification)
  String get userPhone => throw _privateConstructorUsedError;

  /// Type: voucher or balance
  String get type =>
      throw _privateConstructorUsedError; // 'voucher' or 'balance'
  /// Points to redeem
  int get points => throw _privateConstructorUsedError;

  /// Value in IDR
  int get amount => throw _privateConstructorUsedError;

  /// Current status
  RedeemStatus get status => throw _privateConstructorUsedError;

  /// Voucher details (if type = voucher)
  String? get voucherName => throw _privateConstructorUsedError;
  String? get voucherProvider => throw _privateConstructorUsedError;
  String? get voucherCategory => throw _privateConstructorUsedError;
  int? get voucherValue => throw _privateConstructorUsedError;

  /// Balance details (if type = balance)
  String? get bankName => throw _privateConstructorUsedError;
  String? get accountNumber => throw _privateConstructorUsedError;
  String? get accountHolderName => throw _privateConstructorUsedError;

  /// Generated coupon ID (after approval)
  String? get couponId => throw _privateConstructorUsedError;

  /// Admin notes
  String? get adminNotes => throw _privateConstructorUsedError;

  /// Processed by admin ID
  String? get processedBy => throw _privateConstructorUsedError;

  /// Processing timestamp
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get processedAt => throw _privateConstructorUsedError;

  /// Rejection reason
  String? get rejectionReason => throw _privateConstructorUsedError;

  /// Additional metadata
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Created timestamp
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Updated timestamp
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RedeemRequestModelCopyWith<RedeemRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RedeemRequestModelCopyWith<$Res> {
  factory $RedeemRequestModelCopyWith(
          RedeemRequestModel value, $Res Function(RedeemRequestModel) then) =
      _$RedeemRequestModelCopyWithImpl<$Res, RedeemRequestModel>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String userName,
      String userEmail,
      String userPhone,
      String type,
      int points,
      int amount,
      RedeemStatus status,
      String? voucherName,
      String? voucherProvider,
      String? voucherCategory,
      int? voucherValue,
      String? bankName,
      String? accountNumber,
      String? accountHolderName,
      String? couponId,
      String? adminNotes,
      String? processedBy,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? processedAt,
      String? rejectionReason,
      Map<String, dynamic>? metadata,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? updatedAt});
}

/// @nodoc
class _$RedeemRequestModelCopyWithImpl<$Res, $Val extends RedeemRequestModel>
    implements $RedeemRequestModelCopyWith<$Res> {
  _$RedeemRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userName = null,
    Object? userEmail = null,
    Object? userPhone = null,
    Object? type = null,
    Object? points = null,
    Object? amount = null,
    Object? status = null,
    Object? voucherName = freezed,
    Object? voucherProvider = freezed,
    Object? voucherCategory = freezed,
    Object? voucherValue = freezed,
    Object? bankName = freezed,
    Object? accountNumber = freezed,
    Object? accountHolderName = freezed,
    Object? couponId = freezed,
    Object? adminNotes = freezed,
    Object? processedBy = freezed,
    Object? processedAt = freezed,
    Object? rejectionReason = freezed,
    Object? metadata = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userEmail: null == userEmail
          ? _value.userEmail
          : userEmail // ignore: cast_nullable_to_non_nullable
              as String,
      userPhone: null == userPhone
          ? _value.userPhone
          : userPhone // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RedeemStatus,
      voucherName: freezed == voucherName
          ? _value.voucherName
          : voucherName // ignore: cast_nullable_to_non_nullable
              as String?,
      voucherProvider: freezed == voucherProvider
          ? _value.voucherProvider
          : voucherProvider // ignore: cast_nullable_to_non_nullable
              as String?,
      voucherCategory: freezed == voucherCategory
          ? _value.voucherCategory
          : voucherCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      voucherValue: freezed == voucherValue
          ? _value.voucherValue
          : voucherValue // ignore: cast_nullable_to_non_nullable
              as int?,
      bankName: freezed == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      accountNumber: freezed == accountNumber
          ? _value.accountNumber
          : accountNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      accountHolderName: freezed == accountHolderName
          ? _value.accountHolderName
          : accountHolderName // ignore: cast_nullable_to_non_nullable
              as String?,
      couponId: freezed == couponId
          ? _value.couponId
          : couponId // ignore: cast_nullable_to_non_nullable
              as String?,
      adminNotes: freezed == adminNotes
          ? _value.adminNotes
          : adminNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      processedBy: freezed == processedBy
          ? _value.processedBy
          : processedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      processedAt: freezed == processedAt
          ? _value.processedAt
          : processedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
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
abstract class _$$RedeemRequestModelImplCopyWith<$Res>
    implements $RedeemRequestModelCopyWith<$Res> {
  factory _$$RedeemRequestModelImplCopyWith(_$RedeemRequestModelImpl value,
          $Res Function(_$RedeemRequestModelImpl) then) =
      __$$RedeemRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String userName,
      String userEmail,
      String userPhone,
      String type,
      int points,
      int amount,
      RedeemStatus status,
      String? voucherName,
      String? voucherProvider,
      String? voucherCategory,
      int? voucherValue,
      String? bankName,
      String? accountNumber,
      String? accountHolderName,
      String? couponId,
      String? adminNotes,
      String? processedBy,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? processedAt,
      String? rejectionReason,
      Map<String, dynamic>? metadata,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? updatedAt});
}

/// @nodoc
class __$$RedeemRequestModelImplCopyWithImpl<$Res>
    extends _$RedeemRequestModelCopyWithImpl<$Res, _$RedeemRequestModelImpl>
    implements _$$RedeemRequestModelImplCopyWith<$Res> {
  __$$RedeemRequestModelImplCopyWithImpl(_$RedeemRequestModelImpl _value,
      $Res Function(_$RedeemRequestModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userName = null,
    Object? userEmail = null,
    Object? userPhone = null,
    Object? type = null,
    Object? points = null,
    Object? amount = null,
    Object? status = null,
    Object? voucherName = freezed,
    Object? voucherProvider = freezed,
    Object? voucherCategory = freezed,
    Object? voucherValue = freezed,
    Object? bankName = freezed,
    Object? accountNumber = freezed,
    Object? accountHolderName = freezed,
    Object? couponId = freezed,
    Object? adminNotes = freezed,
    Object? processedBy = freezed,
    Object? processedAt = freezed,
    Object? rejectionReason = freezed,
    Object? metadata = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$RedeemRequestModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userEmail: null == userEmail
          ? _value.userEmail
          : userEmail // ignore: cast_nullable_to_non_nullable
              as String,
      userPhone: null == userPhone
          ? _value.userPhone
          : userPhone // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RedeemStatus,
      voucherName: freezed == voucherName
          ? _value.voucherName
          : voucherName // ignore: cast_nullable_to_non_nullable
              as String?,
      voucherProvider: freezed == voucherProvider
          ? _value.voucherProvider
          : voucherProvider // ignore: cast_nullable_to_non_nullable
              as String?,
      voucherCategory: freezed == voucherCategory
          ? _value.voucherCategory
          : voucherCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      voucherValue: freezed == voucherValue
          ? _value.voucherValue
          : voucherValue // ignore: cast_nullable_to_non_nullable
              as int?,
      bankName: freezed == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      accountNumber: freezed == accountNumber
          ? _value.accountNumber
          : accountNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      accountHolderName: freezed == accountHolderName
          ? _value.accountHolderName
          : accountHolderName // ignore: cast_nullable_to_non_nullable
              as String?,
      couponId: freezed == couponId
          ? _value.couponId
          : couponId // ignore: cast_nullable_to_non_nullable
              as String?,
      adminNotes: freezed == adminNotes
          ? _value.adminNotes
          : adminNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      processedBy: freezed == processedBy
          ? _value.processedBy
          : processedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      processedAt: freezed == processedAt
          ? _value.processedAt
          : processedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
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
class _$RedeemRequestModelImpl extends _RedeemRequestModel {
  const _$RedeemRequestModelImpl(
      {required this.id,
      required this.userId,
      required this.userName,
      required this.userEmail,
      required this.userPhone,
      required this.type,
      required this.points,
      required this.amount,
      required this.status,
      this.voucherName,
      this.voucherProvider,
      this.voucherCategory,
      this.voucherValue,
      this.bankName,
      this.accountNumber,
      this.accountHolderName,
      this.couponId,
      this.adminNotes,
      this.processedBy,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.processedAt,
      this.rejectionReason,
      final Map<String, dynamic>? metadata,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.updatedAt})
      : _metadata = metadata,
        super._();

  factory _$RedeemRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RedeemRequestModelImplFromJson(json);

  /// Unique request ID
  @override
  final String id;

  /// User requesting redemption
  @override
  final String userId;

  /// User's name (snapshot for display)
  @override
  final String userName;

  /// User's email (snapshot for display)
  @override
  final String userEmail;

  /// User's phone (snapshot for delivery/notification)
  @override
  final String userPhone;

  /// Type: voucher or balance
  @override
  final String type;
// 'voucher' or 'balance'
  /// Points to redeem
  @override
  final int points;

  /// Value in IDR
  @override
  final int amount;

  /// Current status
  @override
  final RedeemStatus status;

  /// Voucher details (if type = voucher)
  @override
  final String? voucherName;
  @override
  final String? voucherProvider;
  @override
  final String? voucherCategory;
  @override
  final int? voucherValue;

  /// Balance details (if type = balance)
  @override
  final String? bankName;
  @override
  final String? accountNumber;
  @override
  final String? accountHolderName;

  /// Generated coupon ID (after approval)
  @override
  final String? couponId;

  /// Admin notes
  @override
  final String? adminNotes;

  /// Processed by admin ID
  @override
  final String? processedBy;

  /// Processing timestamp
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? processedAt;

  /// Rejection reason
  @override
  final String? rejectionReason;

  /// Additional metadata
  final Map<String, dynamic>? _metadata;

  /// Additional metadata
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Created timestamp
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? createdAt;

  /// Updated timestamp
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'RedeemRequestModel(id: $id, userId: $userId, userName: $userName, userEmail: $userEmail, userPhone: $userPhone, type: $type, points: $points, amount: $amount, status: $status, voucherName: $voucherName, voucherProvider: $voucherProvider, voucherCategory: $voucherCategory, voucherValue: $voucherValue, bankName: $bankName, accountNumber: $accountNumber, accountHolderName: $accountHolderName, couponId: $couponId, adminNotes: $adminNotes, processedBy: $processedBy, processedAt: $processedAt, rejectionReason: $rejectionReason, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RedeemRequestModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userEmail, userEmail) ||
                other.userEmail == userEmail) &&
            (identical(other.userPhone, userPhone) ||
                other.userPhone == userPhone) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.points, points) || other.points == points) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.voucherName, voucherName) ||
                other.voucherName == voucherName) &&
            (identical(other.voucherProvider, voucherProvider) ||
                other.voucherProvider == voucherProvider) &&
            (identical(other.voucherCategory, voucherCategory) ||
                other.voucherCategory == voucherCategory) &&
            (identical(other.voucherValue, voucherValue) ||
                other.voucherValue == voucherValue) &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.accountNumber, accountNumber) ||
                other.accountNumber == accountNumber) &&
            (identical(other.accountHolderName, accountHolderName) ||
                other.accountHolderName == accountHolderName) &&
            (identical(other.couponId, couponId) ||
                other.couponId == couponId) &&
            (identical(other.adminNotes, adminNotes) ||
                other.adminNotes == adminNotes) &&
            (identical(other.processedBy, processedBy) ||
                other.processedBy == processedBy) &&
            (identical(other.processedAt, processedAt) ||
                other.processedAt == processedAt) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        userName,
        userEmail,
        userPhone,
        type,
        points,
        amount,
        status,
        voucherName,
        voucherProvider,
        voucherCategory,
        voucherValue,
        bankName,
        accountNumber,
        accountHolderName,
        couponId,
        adminNotes,
        processedBy,
        processedAt,
        rejectionReason,
        const DeepCollectionEquality().hash(_metadata),
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RedeemRequestModelImplCopyWith<_$RedeemRequestModelImpl> get copyWith =>
      __$$RedeemRequestModelImplCopyWithImpl<_$RedeemRequestModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RedeemRequestModelImplToJson(
      this,
    );
  }
}

abstract class _RedeemRequestModel extends RedeemRequestModel {
  const factory _RedeemRequestModel(
      {required final String id,
      required final String userId,
      required final String userName,
      required final String userEmail,
      required final String userPhone,
      required final String type,
      required final int points,
      required final int amount,
      required final RedeemStatus status,
      final String? voucherName,
      final String? voucherProvider,
      final String? voucherCategory,
      final int? voucherValue,
      final String? bankName,
      final String? accountNumber,
      final String? accountHolderName,
      final String? couponId,
      final String? adminNotes,
      final String? processedBy,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? processedAt,
      final String? rejectionReason,
      final Map<String, dynamic>? metadata,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? updatedAt}) = _$RedeemRequestModelImpl;
  const _RedeemRequestModel._() : super._();

  factory _RedeemRequestModel.fromJson(Map<String, dynamic> json) =
      _$RedeemRequestModelImpl.fromJson;

  @override

  /// Unique request ID
  String get id;
  @override

  /// User requesting redemption
  String get userId;
  @override

  /// User's name (snapshot for display)
  String get userName;
  @override

  /// User's email (snapshot for display)
  String get userEmail;
  @override

  /// User's phone (snapshot for delivery/notification)
  String get userPhone;
  @override

  /// Type: voucher or balance
  String get type;
  @override // 'voucher' or 'balance'
  /// Points to redeem
  int get points;
  @override

  /// Value in IDR
  int get amount;
  @override

  /// Current status
  RedeemStatus get status;
  @override

  /// Voucher details (if type = voucher)
  String? get voucherName;
  @override
  String? get voucherProvider;
  @override
  String? get voucherCategory;
  @override
  int? get voucherValue;
  @override

  /// Balance details (if type = balance)
  String? get bankName;
  @override
  String? get accountNumber;
  @override
  String? get accountHolderName;
  @override

  /// Generated coupon ID (after approval)
  String? get couponId;
  @override

  /// Admin notes
  String? get adminNotes;
  @override

  /// Processed by admin ID
  String? get processedBy;
  @override

  /// Processing timestamp
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get processedAt;
  @override

  /// Rejection reason
  String? get rejectionReason;
  @override

  /// Additional metadata
  Map<String, dynamic>? get metadata;
  @override

  /// Created timestamp
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get createdAt;
  @override

  /// Updated timestamp
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$RedeemRequestModelImplCopyWith<_$RedeemRequestModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
