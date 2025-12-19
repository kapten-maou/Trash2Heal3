// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coupon_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CouponModel _$CouponModelFromJson(Map<String, dynamic> json) {
  return _CouponModel.fromJson(json);
}

/// @nodoc
mixin _$CouponModel {
  /// Unique coupon ID
  String get id => throw _privateConstructorUsedError;

  /// User who owns this coupon
  String get userId => throw _privateConstructorUsedError;

  /// Unique redemption code (QR/barcode scannable)
  String get code => throw _privateConstructorUsedError;

  /// Coupon name/title
  String get name => throw _privateConstructorUsedError;

  /// Type: voucher or balance
  CouponType get type => throw _privateConstructorUsedError;

  /// Coupon value in IDR
  int get value => throw _privateConstructorUsedError;

  /// Points spent to redeem
  int get pointsSpent => throw _privateConstructorUsedError;

  /// Current status
  CouponStatus get status => throw _privateConstructorUsedError;

  /// Related redeem request ID
  String? get redeemRequestId => throw _privateConstructorUsedError;

  /// Voucher provider (e.g., "Indomaret", "Alfamart", "Shopee")
  String? get provider => throw _privateConstructorUsedError;

  /// Voucher category (e.g., "Gift Card", "Discount")
  String? get category => throw _privateConstructorUsedError;

  /// Voucher image URL
  String? get imageUrl => throw _privateConstructorUsedError;

  /// Terms and conditions
  String? get terms => throw _privateConstructorUsedError;

  /// Instructions to use
  String? get instructions => throw _privateConstructorUsedError;

  /// Expiry date (if applicable)
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get expiryDate => throw _privateConstructorUsedError;

  /// When coupon was used
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get usedAt => throw _privateConstructorUsedError;

  /// Where coupon was used (store location, event ID, etc.)
  String? get usedLocation => throw _privateConstructorUsedError;

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
  $CouponModelCopyWith<CouponModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CouponModelCopyWith<$Res> {
  factory $CouponModelCopyWith(
          CouponModel value, $Res Function(CouponModel) then) =
      _$CouponModelCopyWithImpl<$Res, CouponModel>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String code,
      String name,
      CouponType type,
      int value,
      int pointsSpent,
      CouponStatus status,
      String? redeemRequestId,
      String? provider,
      String? category,
      String? imageUrl,
      String? terms,
      String? instructions,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? expiryDate,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? usedAt,
      String? usedLocation,
      Map<String, dynamic>? metadata,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? updatedAt});
}

/// @nodoc
class _$CouponModelCopyWithImpl<$Res, $Val extends CouponModel>
    implements $CouponModelCopyWith<$Res> {
  _$CouponModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? code = null,
    Object? name = null,
    Object? type = null,
    Object? value = null,
    Object? pointsSpent = null,
    Object? status = null,
    Object? redeemRequestId = freezed,
    Object? provider = freezed,
    Object? category = freezed,
    Object? imageUrl = freezed,
    Object? terms = freezed,
    Object? instructions = freezed,
    Object? expiryDate = freezed,
    Object? usedAt = freezed,
    Object? usedLocation = freezed,
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
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as CouponType,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
      pointsSpent: null == pointsSpent
          ? _value.pointsSpent
          : pointsSpent // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as CouponStatus,
      redeemRequestId: freezed == redeemRequestId
          ? _value.redeemRequestId
          : redeemRequestId // ignore: cast_nullable_to_non_nullable
              as String?,
      provider: freezed == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      terms: freezed == terms
          ? _value.terms
          : terms // ignore: cast_nullable_to_non_nullable
              as String?,
      instructions: freezed == instructions
          ? _value.instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as String?,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      usedAt: freezed == usedAt
          ? _value.usedAt
          : usedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      usedLocation: freezed == usedLocation
          ? _value.usedLocation
          : usedLocation // ignore: cast_nullable_to_non_nullable
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
abstract class _$$CouponModelImplCopyWith<$Res>
    implements $CouponModelCopyWith<$Res> {
  factory _$$CouponModelImplCopyWith(
          _$CouponModelImpl value, $Res Function(_$CouponModelImpl) then) =
      __$$CouponModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String code,
      String name,
      CouponType type,
      int value,
      int pointsSpent,
      CouponStatus status,
      String? redeemRequestId,
      String? provider,
      String? category,
      String? imageUrl,
      String? terms,
      String? instructions,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? expiryDate,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? usedAt,
      String? usedLocation,
      Map<String, dynamic>? metadata,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? updatedAt});
}

/// @nodoc
class __$$CouponModelImplCopyWithImpl<$Res>
    extends _$CouponModelCopyWithImpl<$Res, _$CouponModelImpl>
    implements _$$CouponModelImplCopyWith<$Res> {
  __$$CouponModelImplCopyWithImpl(
      _$CouponModelImpl _value, $Res Function(_$CouponModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? code = null,
    Object? name = null,
    Object? type = null,
    Object? value = null,
    Object? pointsSpent = null,
    Object? status = null,
    Object? redeemRequestId = freezed,
    Object? provider = freezed,
    Object? category = freezed,
    Object? imageUrl = freezed,
    Object? terms = freezed,
    Object? instructions = freezed,
    Object? expiryDate = freezed,
    Object? usedAt = freezed,
    Object? usedLocation = freezed,
    Object? metadata = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$CouponModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as CouponType,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
      pointsSpent: null == pointsSpent
          ? _value.pointsSpent
          : pointsSpent // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as CouponStatus,
      redeemRequestId: freezed == redeemRequestId
          ? _value.redeemRequestId
          : redeemRequestId // ignore: cast_nullable_to_non_nullable
              as String?,
      provider: freezed == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      terms: freezed == terms
          ? _value.terms
          : terms // ignore: cast_nullable_to_non_nullable
              as String?,
      instructions: freezed == instructions
          ? _value.instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as String?,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      usedAt: freezed == usedAt
          ? _value.usedAt
          : usedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      usedLocation: freezed == usedLocation
          ? _value.usedLocation
          : usedLocation // ignore: cast_nullable_to_non_nullable
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
class _$CouponModelImpl extends _CouponModel {
  const _$CouponModelImpl(
      {required this.id,
      required this.userId,
      required this.code,
      required this.name,
      required this.type,
      required this.value,
      required this.pointsSpent,
      required this.status,
      this.redeemRequestId,
      this.provider,
      this.category,
      this.imageUrl,
      this.terms,
      this.instructions,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.expiryDate,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.usedAt,
      this.usedLocation,
      final Map<String, dynamic>? metadata,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.updatedAt})
      : _metadata = metadata,
        super._();

  factory _$CouponModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CouponModelImplFromJson(json);

  /// Unique coupon ID
  @override
  final String id;

  /// User who owns this coupon
  @override
  final String userId;

  /// Unique redemption code (QR/barcode scannable)
  @override
  final String code;

  /// Coupon name/title
  @override
  final String name;

  /// Type: voucher or balance
  @override
  final CouponType type;

  /// Coupon value in IDR
  @override
  final int value;

  /// Points spent to redeem
  @override
  final int pointsSpent;

  /// Current status
  @override
  final CouponStatus status;

  /// Related redeem request ID
  @override
  final String? redeemRequestId;

  /// Voucher provider (e.g., "Indomaret", "Alfamart", "Shopee")
  @override
  final String? provider;

  /// Voucher category (e.g., "Gift Card", "Discount")
  @override
  final String? category;

  /// Voucher image URL
  @override
  final String? imageUrl;

  /// Terms and conditions
  @override
  final String? terms;

  /// Instructions to use
  @override
  final String? instructions;

  /// Expiry date (if applicable)
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? expiryDate;

  /// When coupon was used
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? usedAt;

  /// Where coupon was used (store location, event ID, etc.)
  @override
  final String? usedLocation;

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
    return 'CouponModel(id: $id, userId: $userId, code: $code, name: $name, type: $type, value: $value, pointsSpent: $pointsSpent, status: $status, redeemRequestId: $redeemRequestId, provider: $provider, category: $category, imageUrl: $imageUrl, terms: $terms, instructions: $instructions, expiryDate: $expiryDate, usedAt: $usedAt, usedLocation: $usedLocation, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CouponModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.pointsSpent, pointsSpent) ||
                other.pointsSpent == pointsSpent) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.redeemRequestId, redeemRequestId) ||
                other.redeemRequestId == redeemRequestId) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.terms, terms) || other.terms == terms) &&
            (identical(other.instructions, instructions) ||
                other.instructions == instructions) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.usedAt, usedAt) || other.usedAt == usedAt) &&
            (identical(other.usedLocation, usedLocation) ||
                other.usedLocation == usedLocation) &&
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
        code,
        name,
        type,
        value,
        pointsSpent,
        status,
        redeemRequestId,
        provider,
        category,
        imageUrl,
        terms,
        instructions,
        expiryDate,
        usedAt,
        usedLocation,
        const DeepCollectionEquality().hash(_metadata),
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CouponModelImplCopyWith<_$CouponModelImpl> get copyWith =>
      __$$CouponModelImplCopyWithImpl<_$CouponModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CouponModelImplToJson(
      this,
    );
  }
}

abstract class _CouponModel extends CouponModel {
  const factory _CouponModel(
      {required final String id,
      required final String userId,
      required final String code,
      required final String name,
      required final CouponType type,
      required final int value,
      required final int pointsSpent,
      required final CouponStatus status,
      final String? redeemRequestId,
      final String? provider,
      final String? category,
      final String? imageUrl,
      final String? terms,
      final String? instructions,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? expiryDate,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? usedAt,
      final String? usedLocation,
      final Map<String, dynamic>? metadata,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? updatedAt}) = _$CouponModelImpl;
  const _CouponModel._() : super._();

  factory _CouponModel.fromJson(Map<String, dynamic> json) =
      _$CouponModelImpl.fromJson;

  @override

  /// Unique coupon ID
  String get id;
  @override

  /// User who owns this coupon
  String get userId;
  @override

  /// Unique redemption code (QR/barcode scannable)
  String get code;
  @override

  /// Coupon name/title
  String get name;
  @override

  /// Type: voucher or balance
  CouponType get type;
  @override

  /// Coupon value in IDR
  int get value;
  @override

  /// Points spent to redeem
  int get pointsSpent;
  @override

  /// Current status
  CouponStatus get status;
  @override

  /// Related redeem request ID
  String? get redeemRequestId;
  @override

  /// Voucher provider (e.g., "Indomaret", "Alfamart", "Shopee")
  String? get provider;
  @override

  /// Voucher category (e.g., "Gift Card", "Discount")
  String? get category;
  @override

  /// Voucher image URL
  String? get imageUrl;
  @override

  /// Terms and conditions
  String? get terms;
  @override

  /// Instructions to use
  String? get instructions;
  @override

  /// Expiry date (if applicable)
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get expiryDate;
  @override

  /// When coupon was used
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get usedAt;
  @override

  /// Where coupon was used (store location, event ID, etc.)
  String? get usedLocation;
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
  _$$CouponModelImplCopyWith<_$CouponModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
