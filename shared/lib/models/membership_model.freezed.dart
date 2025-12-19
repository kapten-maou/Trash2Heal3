// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'membership_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MembershipModel _$MembershipModelFromJson(Map<String, dynamic> json) {
  return _MembershipModel.fromJson(json);
}

/// @nodoc
mixin _$MembershipModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String get userEmail => throw _privateConstructorUsedError;
  MembershipTier get tier => throw _privateConstructorUsedError;
  MembershipStatus get status => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
  DateTime get startDate => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
  DateTime get endDate => throw _privateConstructorUsedError;
  int get durationMonths => throw _privateConstructorUsedError;
  int get price => throw _privateConstructorUsedError;
  String? get paymentId => throw _privateConstructorUsedError;
  String? get previousTier => throw _privateConstructorUsedError;
  bool get autoRenew => throw _privateConstructorUsedError;
  bool get isLifetime => throw _privateConstructorUsedError;
  Map<String, dynamic> get benefits => throw _privateConstructorUsedError;
  Map<String, dynamic>? get usageStats => throw _privateConstructorUsedError;
  String? get cancellationReason => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get cancelledAt => throw _privateConstructorUsedError;
  String? get cancelledBy => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get renewalDate => throw _privateConstructorUsedError;
  String? get renewalPaymentId => throw _privateConstructorUsedError;
  int get renewalCount => throw _privateConstructorUsedError;
  String? get promoCode => throw _privateConstructorUsedError;
  int? get discount => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  String? get updatedBy => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MembershipModelCopyWith<MembershipModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MembershipModelCopyWith<$Res> {
  factory $MembershipModelCopyWith(
          MembershipModel value, $Res Function(MembershipModel) then) =
      _$MembershipModelCopyWithImpl<$Res, MembershipModel>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String userName,
      String userEmail,
      MembershipTier tier,
      MembershipStatus status,
      @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
      DateTime startDate,
      @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
      DateTime endDate,
      int durationMonths,
      int price,
      String? paymentId,
      String? previousTier,
      bool autoRenew,
      bool isLifetime,
      Map<String, dynamic> benefits,
      Map<String, dynamic>? usageStats,
      String? cancellationReason,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? cancelledAt,
      String? cancelledBy,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? renewalDate,
      String? renewalPaymentId,
      int renewalCount,
      String? promoCode,
      int? discount,
      String? notes,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? updatedAt,
      String? createdBy,
      String? updatedBy});
}

/// @nodoc
class _$MembershipModelCopyWithImpl<$Res, $Val extends MembershipModel>
    implements $MembershipModelCopyWith<$Res> {
  _$MembershipModelCopyWithImpl(this._value, this._then);

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
    Object? tier = null,
    Object? status = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? durationMonths = null,
    Object? price = null,
    Object? paymentId = freezed,
    Object? previousTier = freezed,
    Object? autoRenew = null,
    Object? isLifetime = null,
    Object? benefits = null,
    Object? usageStats = freezed,
    Object? cancellationReason = freezed,
    Object? cancelledAt = freezed,
    Object? cancelledBy = freezed,
    Object? renewalDate = freezed,
    Object? renewalPaymentId = freezed,
    Object? renewalCount = null,
    Object? promoCode = freezed,
    Object? discount = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
    Object? updatedBy = freezed,
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
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as MembershipTier,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MembershipStatus,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      durationMonths: null == durationMonths
          ? _value.durationMonths
          : durationMonths // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
      paymentId: freezed == paymentId
          ? _value.paymentId
          : paymentId // ignore: cast_nullable_to_non_nullable
              as String?,
      previousTier: freezed == previousTier
          ? _value.previousTier
          : previousTier // ignore: cast_nullable_to_non_nullable
              as String?,
      autoRenew: null == autoRenew
          ? _value.autoRenew
          : autoRenew // ignore: cast_nullable_to_non_nullable
              as bool,
      isLifetime: null == isLifetime
          ? _value.isLifetime
          : isLifetime // ignore: cast_nullable_to_non_nullable
              as bool,
      benefits: null == benefits
          ? _value.benefits
          : benefits // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      usageStats: freezed == usageStats
          ? _value.usageStats
          : usageStats // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      cancellationReason: freezed == cancellationReason
          ? _value.cancellationReason
          : cancellationReason // ignore: cast_nullable_to_non_nullable
              as String?,
      cancelledAt: freezed == cancelledAt
          ? _value.cancelledAt
          : cancelledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      cancelledBy: freezed == cancelledBy
          ? _value.cancelledBy
          : cancelledBy // ignore: cast_nullable_to_non_nullable
              as String?,
      renewalDate: freezed == renewalDate
          ? _value.renewalDate
          : renewalDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      renewalPaymentId: freezed == renewalPaymentId
          ? _value.renewalPaymentId
          : renewalPaymentId // ignore: cast_nullable_to_non_nullable
              as String?,
      renewalCount: null == renewalCount
          ? _value.renewalCount
          : renewalCount // ignore: cast_nullable_to_non_nullable
              as int,
      promoCode: freezed == promoCode
          ? _value.promoCode
          : promoCode // ignore: cast_nullable_to_non_nullable
              as String?,
      discount: freezed == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as int?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedBy: freezed == updatedBy
          ? _value.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MembershipModelImplCopyWith<$Res>
    implements $MembershipModelCopyWith<$Res> {
  factory _$$MembershipModelImplCopyWith(_$MembershipModelImpl value,
          $Res Function(_$MembershipModelImpl) then) =
      __$$MembershipModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String userName,
      String userEmail,
      MembershipTier tier,
      MembershipStatus status,
      @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
      DateTime startDate,
      @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
      DateTime endDate,
      int durationMonths,
      int price,
      String? paymentId,
      String? previousTier,
      bool autoRenew,
      bool isLifetime,
      Map<String, dynamic> benefits,
      Map<String, dynamic>? usageStats,
      String? cancellationReason,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? cancelledAt,
      String? cancelledBy,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? renewalDate,
      String? renewalPaymentId,
      int renewalCount,
      String? promoCode,
      int? discount,
      String? notes,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? updatedAt,
      String? createdBy,
      String? updatedBy});
}

/// @nodoc
class __$$MembershipModelImplCopyWithImpl<$Res>
    extends _$MembershipModelCopyWithImpl<$Res, _$MembershipModelImpl>
    implements _$$MembershipModelImplCopyWith<$Res> {
  __$$MembershipModelImplCopyWithImpl(
      _$MembershipModelImpl _value, $Res Function(_$MembershipModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userName = null,
    Object? userEmail = null,
    Object? tier = null,
    Object? status = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? durationMonths = null,
    Object? price = null,
    Object? paymentId = freezed,
    Object? previousTier = freezed,
    Object? autoRenew = null,
    Object? isLifetime = null,
    Object? benefits = null,
    Object? usageStats = freezed,
    Object? cancellationReason = freezed,
    Object? cancelledAt = freezed,
    Object? cancelledBy = freezed,
    Object? renewalDate = freezed,
    Object? renewalPaymentId = freezed,
    Object? renewalCount = null,
    Object? promoCode = freezed,
    Object? discount = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
    Object? updatedBy = freezed,
  }) {
    return _then(_$MembershipModelImpl(
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
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as MembershipTier,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MembershipStatus,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      durationMonths: null == durationMonths
          ? _value.durationMonths
          : durationMonths // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
      paymentId: freezed == paymentId
          ? _value.paymentId
          : paymentId // ignore: cast_nullable_to_non_nullable
              as String?,
      previousTier: freezed == previousTier
          ? _value.previousTier
          : previousTier // ignore: cast_nullable_to_non_nullable
              as String?,
      autoRenew: null == autoRenew
          ? _value.autoRenew
          : autoRenew // ignore: cast_nullable_to_non_nullable
              as bool,
      isLifetime: null == isLifetime
          ? _value.isLifetime
          : isLifetime // ignore: cast_nullable_to_non_nullable
              as bool,
      benefits: null == benefits
          ? _value._benefits
          : benefits // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      usageStats: freezed == usageStats
          ? _value._usageStats
          : usageStats // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      cancellationReason: freezed == cancellationReason
          ? _value.cancellationReason
          : cancellationReason // ignore: cast_nullable_to_non_nullable
              as String?,
      cancelledAt: freezed == cancelledAt
          ? _value.cancelledAt
          : cancelledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      cancelledBy: freezed == cancelledBy
          ? _value.cancelledBy
          : cancelledBy // ignore: cast_nullable_to_non_nullable
              as String?,
      renewalDate: freezed == renewalDate
          ? _value.renewalDate
          : renewalDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      renewalPaymentId: freezed == renewalPaymentId
          ? _value.renewalPaymentId
          : renewalPaymentId // ignore: cast_nullable_to_non_nullable
              as String?,
      renewalCount: null == renewalCount
          ? _value.renewalCount
          : renewalCount // ignore: cast_nullable_to_non_nullable
              as int,
      promoCode: freezed == promoCode
          ? _value.promoCode
          : promoCode // ignore: cast_nullable_to_non_nullable
              as String?,
      discount: freezed == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as int?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedBy: freezed == updatedBy
          ? _value.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MembershipModelImpl extends _MembershipModel {
  const _$MembershipModelImpl(
      {required this.id,
      required this.userId,
      required this.userName,
      required this.userEmail,
      required this.tier,
      required this.status,
      @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
      required this.startDate,
      @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
      required this.endDate,
      required this.durationMonths,
      required this.price,
      this.paymentId,
      this.previousTier,
      this.autoRenew = false,
      this.isLifetime = false,
      required final Map<String, dynamic> benefits,
      final Map<String, dynamic>? usageStats,
      this.cancellationReason,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.cancelledAt,
      this.cancelledBy,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.renewalDate,
      this.renewalPaymentId,
      this.renewalCount = 0,
      this.promoCode,
      this.discount,
      this.notes,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.updatedAt,
      this.createdBy,
      this.updatedBy})
      : _benefits = benefits,
        _usageStats = usageStats,
        super._();

  factory _$MembershipModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MembershipModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String userName;
  @override
  final String userEmail;
  @override
  final MembershipTier tier;
  @override
  final MembershipStatus status;
  @override
  @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
  final DateTime startDate;
  @override
  @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
  final DateTime endDate;
  @override
  final int durationMonths;
  @override
  final int price;
  @override
  final String? paymentId;
  @override
  final String? previousTier;
  @override
  @JsonKey()
  final bool autoRenew;
  @override
  @JsonKey()
  final bool isLifetime;
  final Map<String, dynamic> _benefits;
  @override
  Map<String, dynamic> get benefits {
    if (_benefits is EqualUnmodifiableMapView) return _benefits;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_benefits);
  }

  final Map<String, dynamic>? _usageStats;
  @override
  Map<String, dynamic>? get usageStats {
    final value = _usageStats;
    if (value == null) return null;
    if (_usageStats is EqualUnmodifiableMapView) return _usageStats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? cancellationReason;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? cancelledAt;
  @override
  final String? cancelledBy;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? renewalDate;
  @override
  final String? renewalPaymentId;
  @override
  @JsonKey()
  final int renewalCount;
  @override
  final String? promoCode;
  @override
  final int? discount;
  @override
  final String? notes;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? createdAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? updatedAt;
  @override
  final String? createdBy;
  @override
  final String? updatedBy;

  @override
  String toString() {
    return 'MembershipModel(id: $id, userId: $userId, userName: $userName, userEmail: $userEmail, tier: $tier, status: $status, startDate: $startDate, endDate: $endDate, durationMonths: $durationMonths, price: $price, paymentId: $paymentId, previousTier: $previousTier, autoRenew: $autoRenew, isLifetime: $isLifetime, benefits: $benefits, usageStats: $usageStats, cancellationReason: $cancellationReason, cancelledAt: $cancelledAt, cancelledBy: $cancelledBy, renewalDate: $renewalDate, renewalPaymentId: $renewalPaymentId, renewalCount: $renewalCount, promoCode: $promoCode, discount: $discount, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, updatedBy: $updatedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MembershipModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userEmail, userEmail) ||
                other.userEmail == userEmail) &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.durationMonths, durationMonths) ||
                other.durationMonths == durationMonths) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.paymentId, paymentId) ||
                other.paymentId == paymentId) &&
            (identical(other.previousTier, previousTier) ||
                other.previousTier == previousTier) &&
            (identical(other.autoRenew, autoRenew) ||
                other.autoRenew == autoRenew) &&
            (identical(other.isLifetime, isLifetime) ||
                other.isLifetime == isLifetime) &&
            const DeepCollectionEquality().equals(other._benefits, _benefits) &&
            const DeepCollectionEquality()
                .equals(other._usageStats, _usageStats) &&
            (identical(other.cancellationReason, cancellationReason) ||
                other.cancellationReason == cancellationReason) &&
            (identical(other.cancelledAt, cancelledAt) ||
                other.cancelledAt == cancelledAt) &&
            (identical(other.cancelledBy, cancelledBy) ||
                other.cancelledBy == cancelledBy) &&
            (identical(other.renewalDate, renewalDate) ||
                other.renewalDate == renewalDate) &&
            (identical(other.renewalPaymentId, renewalPaymentId) ||
                other.renewalPaymentId == renewalPaymentId) &&
            (identical(other.renewalCount, renewalCount) ||
                other.renewalCount == renewalCount) &&
            (identical(other.promoCode, promoCode) ||
                other.promoCode == promoCode) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        userName,
        userEmail,
        tier,
        status,
        startDate,
        endDate,
        durationMonths,
        price,
        paymentId,
        previousTier,
        autoRenew,
        isLifetime,
        const DeepCollectionEquality().hash(_benefits),
        const DeepCollectionEquality().hash(_usageStats),
        cancellationReason,
        cancelledAt,
        cancelledBy,
        renewalDate,
        renewalPaymentId,
        renewalCount,
        promoCode,
        discount,
        notes,
        createdAt,
        updatedAt,
        createdBy,
        updatedBy
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MembershipModelImplCopyWith<_$MembershipModelImpl> get copyWith =>
      __$$MembershipModelImplCopyWithImpl<_$MembershipModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MembershipModelImplToJson(
      this,
    );
  }
}

abstract class _MembershipModel extends MembershipModel {
  const factory _MembershipModel(
      {required final String id,
      required final String userId,
      required final String userName,
      required final String userEmail,
      required final MembershipTier tier,
      required final MembershipStatus status,
      @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
      required final DateTime startDate,
      @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
      required final DateTime endDate,
      required final int durationMonths,
      required final int price,
      final String? paymentId,
      final String? previousTier,
      final bool autoRenew,
      final bool isLifetime,
      required final Map<String, dynamic> benefits,
      final Map<String, dynamic>? usageStats,
      final String? cancellationReason,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? cancelledAt,
      final String? cancelledBy,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? renewalDate,
      final String? renewalPaymentId,
      final int renewalCount,
      final String? promoCode,
      final int? discount,
      final String? notes,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? updatedAt,
      final String? createdBy,
      final String? updatedBy}) = _$MembershipModelImpl;
  const _MembershipModel._() : super._();

  factory _MembershipModel.fromJson(Map<String, dynamic> json) =
      _$MembershipModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get userName;
  @override
  String get userEmail;
  @override
  MembershipTier get tier;
  @override
  MembershipStatus get status;
  @override
  @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
  DateTime get startDate;
  @override
  @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
  DateTime get endDate;
  @override
  int get durationMonths;
  @override
  int get price;
  @override
  String? get paymentId;
  @override
  String? get previousTier;
  @override
  bool get autoRenew;
  @override
  bool get isLifetime;
  @override
  Map<String, dynamic> get benefits;
  @override
  Map<String, dynamic>? get usageStats;
  @override
  String? get cancellationReason;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get cancelledAt;
  @override
  String? get cancelledBy;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get renewalDate;
  @override
  String? get renewalPaymentId;
  @override
  int get renewalCount;
  @override
  String? get promoCode;
  @override
  int? get discount;
  @override
  String? get notes;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get createdAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get updatedAt;
  @override
  String? get createdBy;
  @override
  String? get updatedBy;
  @override
  @JsonKey(ignore: true)
  _$$MembershipModelImplCopyWith<_$MembershipModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
