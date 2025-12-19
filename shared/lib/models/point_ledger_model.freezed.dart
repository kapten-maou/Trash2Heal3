// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'point_ledger_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PointLedgerModel _$PointLedgerModelFromJson(Map<String, dynamic> json) {
  return _PointLedgerModel.fromJson(json);
}

/// @nodoc
mixin _$PointLedgerModel {
  /// Unique ledger entry ID
  String get id => throw _privateConstructorUsedError;

  /// User who owns this transaction
  String get userId => throw _privateConstructorUsedError;

  /// Type of transaction (earn/redeem/refund/bonus/penalty)
  PointTransactionType get type => throw _privateConstructorUsedError;

  /// Point amount (positive for earn/refund/bonus, negative for redeem/penalty)
  int get amount => throw _privateConstructorUsedError;

  /// Human-readable description of transaction
  String get description => throw _privateConstructorUsedError;

  /// Related document ID (pickupRequestId, couponId, eventId, etc.)
  String? get relatedId => throw _privateConstructorUsedError;

  /// Related collection name for reference
  String? get relatedCollection => throw _privateConstructorUsedError;

  /// Running balance after this transaction
  int? get balanceAfter => throw _privateConstructorUsedError;

  /// Additional metadata (JSON)
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Transaction timestamp (server-side)
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PointLedgerModelCopyWith<PointLedgerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PointLedgerModelCopyWith<$Res> {
  factory $PointLedgerModelCopyWith(
          PointLedgerModel value, $Res Function(PointLedgerModel) then) =
      _$PointLedgerModelCopyWithImpl<$Res, PointLedgerModel>;
  @useResult
  $Res call(
      {String id,
      String userId,
      PointTransactionType type,
      int amount,
      String description,
      String? relatedId,
      String? relatedCollection,
      int? balanceAfter,
      Map<String, dynamic>? metadata,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? createdAt});
}

/// @nodoc
class _$PointLedgerModelCopyWithImpl<$Res, $Val extends PointLedgerModel>
    implements $PointLedgerModelCopyWith<$Res> {
  _$PointLedgerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? amount = null,
    Object? description = null,
    Object? relatedId = freezed,
    Object? relatedCollection = freezed,
    Object? balanceAfter = freezed,
    Object? metadata = freezed,
    Object? createdAt = freezed,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PointTransactionType,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      relatedId: freezed == relatedId
          ? _value.relatedId
          : relatedId // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedCollection: freezed == relatedCollection
          ? _value.relatedCollection
          : relatedCollection // ignore: cast_nullable_to_non_nullable
              as String?,
      balanceAfter: freezed == balanceAfter
          ? _value.balanceAfter
          : balanceAfter // ignore: cast_nullable_to_non_nullable
              as int?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PointLedgerModelImplCopyWith<$Res>
    implements $PointLedgerModelCopyWith<$Res> {
  factory _$$PointLedgerModelImplCopyWith(_$PointLedgerModelImpl value,
          $Res Function(_$PointLedgerModelImpl) then) =
      __$$PointLedgerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      PointTransactionType type,
      int amount,
      String description,
      String? relatedId,
      String? relatedCollection,
      int? balanceAfter,
      Map<String, dynamic>? metadata,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? createdAt});
}

/// @nodoc
class __$$PointLedgerModelImplCopyWithImpl<$Res>
    extends _$PointLedgerModelCopyWithImpl<$Res, _$PointLedgerModelImpl>
    implements _$$PointLedgerModelImplCopyWith<$Res> {
  __$$PointLedgerModelImplCopyWithImpl(_$PointLedgerModelImpl _value,
      $Res Function(_$PointLedgerModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? amount = null,
    Object? description = null,
    Object? relatedId = freezed,
    Object? relatedCollection = freezed,
    Object? balanceAfter = freezed,
    Object? metadata = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$PointLedgerModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PointTransactionType,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      relatedId: freezed == relatedId
          ? _value.relatedId
          : relatedId // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedCollection: freezed == relatedCollection
          ? _value.relatedCollection
          : relatedCollection // ignore: cast_nullable_to_non_nullable
              as String?,
      balanceAfter: freezed == balanceAfter
          ? _value.balanceAfter
          : balanceAfter // ignore: cast_nullable_to_non_nullable
              as int?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PointLedgerModelImpl extends _PointLedgerModel {
  const _$PointLedgerModelImpl(
      {required this.id,
      required this.userId,
      required this.type,
      required this.amount,
      required this.description,
      this.relatedId,
      this.relatedCollection,
      this.balanceAfter,
      final Map<String, dynamic>? metadata,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.createdAt})
      : _metadata = metadata,
        super._();

  factory _$PointLedgerModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PointLedgerModelImplFromJson(json);

  /// Unique ledger entry ID
  @override
  final String id;

  /// User who owns this transaction
  @override
  final String userId;

  /// Type of transaction (earn/redeem/refund/bonus/penalty)
  @override
  final PointTransactionType type;

  /// Point amount (positive for earn/refund/bonus, negative for redeem/penalty)
  @override
  final int amount;

  /// Human-readable description of transaction
  @override
  final String description;

  /// Related document ID (pickupRequestId, couponId, eventId, etc.)
  @override
  final String? relatedId;

  /// Related collection name for reference
  @override
  final String? relatedCollection;

  /// Running balance after this transaction
  @override
  final int? balanceAfter;

  /// Additional metadata (JSON)
  final Map<String, dynamic>? _metadata;

  /// Additional metadata (JSON)
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Transaction timestamp (server-side)
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? createdAt;

  @override
  String toString() {
    return 'PointLedgerModel(id: $id, userId: $userId, type: $type, amount: $amount, description: $description, relatedId: $relatedId, relatedCollection: $relatedCollection, balanceAfter: $balanceAfter, metadata: $metadata, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PointLedgerModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.relatedId, relatedId) ||
                other.relatedId == relatedId) &&
            (identical(other.relatedCollection, relatedCollection) ||
                other.relatedCollection == relatedCollection) &&
            (identical(other.balanceAfter, balanceAfter) ||
                other.balanceAfter == balanceAfter) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      type,
      amount,
      description,
      relatedId,
      relatedCollection,
      balanceAfter,
      const DeepCollectionEquality().hash(_metadata),
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PointLedgerModelImplCopyWith<_$PointLedgerModelImpl> get copyWith =>
      __$$PointLedgerModelImplCopyWithImpl<_$PointLedgerModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PointLedgerModelImplToJson(
      this,
    );
  }
}

abstract class _PointLedgerModel extends PointLedgerModel {
  const factory _PointLedgerModel(
      {required final String id,
      required final String userId,
      required final PointTransactionType type,
      required final int amount,
      required final String description,
      final String? relatedId,
      final String? relatedCollection,
      final int? balanceAfter,
      final Map<String, dynamic>? metadata,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? createdAt}) = _$PointLedgerModelImpl;
  const _PointLedgerModel._() : super._();

  factory _PointLedgerModel.fromJson(Map<String, dynamic> json) =
      _$PointLedgerModelImpl.fromJson;

  @override

  /// Unique ledger entry ID
  String get id;
  @override

  /// User who owns this transaction
  String get userId;
  @override

  /// Type of transaction (earn/redeem/refund/bonus/penalty)
  PointTransactionType get type;
  @override

  /// Point amount (positive for earn/refund/bonus, negative for redeem/penalty)
  int get amount;
  @override

  /// Human-readable description of transaction
  String get description;
  @override

  /// Related document ID (pickupRequestId, couponId, eventId, etc.)
  String? get relatedId;
  @override

  /// Related collection name for reference
  String? get relatedCollection;
  @override

  /// Running balance after this transaction
  int? get balanceAfter;
  @override

  /// Additional metadata (JSON)
  Map<String, dynamic>? get metadata;
  @override

  /// Transaction timestamp (server-side)
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$PointLedgerModelImplCopyWith<_$PointLedgerModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
