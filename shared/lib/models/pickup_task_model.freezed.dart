// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pickup_task_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PickupTaskModel _$PickupTaskModelFromJson(Map<String, dynamic> json) {
  return _PickupTaskModel.fromJson(json);
}

/// @nodoc
mixin _$PickupTaskModel {
  String get id => throw _privateConstructorUsedError;
  String get requestId => throw _privateConstructorUsedError;
  String get courierId => throw _privateConstructorUsedError;
  String get customerId => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
  DateTime get scheduledDate => throw _privateConstructorUsedError;
  String get timeRange => throw _privateConstructorUsedError;
  String get zone => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  int? get sequenceNumber => throw _privateConstructorUsedError;
  bool get isPriority => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PickupTaskModelCopyWith<PickupTaskModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PickupTaskModelCopyWith<$Res> {
  factory $PickupTaskModelCopyWith(
          PickupTaskModel value, $Res Function(PickupTaskModel) then) =
      _$PickupTaskModelCopyWithImpl<$Res, PickupTaskModel>;
  @useResult
  $Res call(
      {String id,
      String requestId,
      String courierId,
      String customerId,
      @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
      DateTime scheduledDate,
      String timeRange,
      String zone,
      String status,
      int? sequenceNumber,
      bool isPriority,
      String? notes,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? updatedAt});
}

/// @nodoc
class _$PickupTaskModelCopyWithImpl<$Res, $Val extends PickupTaskModel>
    implements $PickupTaskModelCopyWith<$Res> {
  _$PickupTaskModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requestId = null,
    Object? courierId = null,
    Object? customerId = null,
    Object? scheduledDate = null,
    Object? timeRange = null,
    Object? zone = null,
    Object? status = null,
    Object? sequenceNumber = freezed,
    Object? isPriority = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      requestId: null == requestId
          ? _value.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String,
      courierId: null == courierId
          ? _value.courierId
          : courierId // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledDate: null == scheduledDate
          ? _value.scheduledDate
          : scheduledDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      timeRange: null == timeRange
          ? _value.timeRange
          : timeRange // ignore: cast_nullable_to_non_nullable
              as String,
      zone: null == zone
          ? _value.zone
          : zone // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      sequenceNumber: freezed == sequenceNumber
          ? _value.sequenceNumber
          : sequenceNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      isPriority: null == isPriority
          ? _value.isPriority
          : isPriority // ignore: cast_nullable_to_non_nullable
              as bool,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PickupTaskModelImplCopyWith<$Res>
    implements $PickupTaskModelCopyWith<$Res> {
  factory _$$PickupTaskModelImplCopyWith(_$PickupTaskModelImpl value,
          $Res Function(_$PickupTaskModelImpl) then) =
      __$$PickupTaskModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String requestId,
      String courierId,
      String customerId,
      @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
      DateTime scheduledDate,
      String timeRange,
      String zone,
      String status,
      int? sequenceNumber,
      bool isPriority,
      String? notes,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? updatedAt});
}

/// @nodoc
class __$$PickupTaskModelImplCopyWithImpl<$Res>
    extends _$PickupTaskModelCopyWithImpl<$Res, _$PickupTaskModelImpl>
    implements _$$PickupTaskModelImplCopyWith<$Res> {
  __$$PickupTaskModelImplCopyWithImpl(
      _$PickupTaskModelImpl _value, $Res Function(_$PickupTaskModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requestId = null,
    Object? courierId = null,
    Object? customerId = null,
    Object? scheduledDate = null,
    Object? timeRange = null,
    Object? zone = null,
    Object? status = null,
    Object? sequenceNumber = freezed,
    Object? isPriority = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$PickupTaskModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      requestId: null == requestId
          ? _value.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String,
      courierId: null == courierId
          ? _value.courierId
          : courierId // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledDate: null == scheduledDate
          ? _value.scheduledDate
          : scheduledDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      timeRange: null == timeRange
          ? _value.timeRange
          : timeRange // ignore: cast_nullable_to_non_nullable
              as String,
      zone: null == zone
          ? _value.zone
          : zone // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      sequenceNumber: freezed == sequenceNumber
          ? _value.sequenceNumber
          : sequenceNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      isPriority: null == isPriority
          ? _value.isPriority
          : isPriority // ignore: cast_nullable_to_non_nullable
              as bool,
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PickupTaskModelImpl extends _PickupTaskModel {
  const _$PickupTaskModelImpl(
      {required this.id,
      required this.requestId,
      required this.courierId,
      required this.customerId,
      @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
      required this.scheduledDate,
      required this.timeRange,
      required this.zone,
      required this.status,
      this.sequenceNumber,
      this.isPriority = false,
      this.notes,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.updatedAt})
      : super._();

  factory _$PickupTaskModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PickupTaskModelImplFromJson(json);

  @override
  final String id;
  @override
  final String requestId;
  @override
  final String courierId;
  @override
  final String customerId;
  @override
  @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
  final DateTime scheduledDate;
  @override
  final String timeRange;
  @override
  final String zone;
  @override
  final String status;
  @override
  final int? sequenceNumber;
  @override
  @JsonKey()
  final bool isPriority;
  @override
  final String? notes;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? createdAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'PickupTaskModel(id: $id, requestId: $requestId, courierId: $courierId, customerId: $customerId, scheduledDate: $scheduledDate, timeRange: $timeRange, zone: $zone, status: $status, sequenceNumber: $sequenceNumber, isPriority: $isPriority, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PickupTaskModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.courierId, courierId) ||
                other.courierId == courierId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.scheduledDate, scheduledDate) ||
                other.scheduledDate == scheduledDate) &&
            (identical(other.timeRange, timeRange) ||
                other.timeRange == timeRange) &&
            (identical(other.zone, zone) || other.zone == zone) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.sequenceNumber, sequenceNumber) ||
                other.sequenceNumber == sequenceNumber) &&
            (identical(other.isPriority, isPriority) ||
                other.isPriority == isPriority) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      requestId,
      courierId,
      customerId,
      scheduledDate,
      timeRange,
      zone,
      status,
      sequenceNumber,
      isPriority,
      notes,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PickupTaskModelImplCopyWith<_$PickupTaskModelImpl> get copyWith =>
      __$$PickupTaskModelImplCopyWithImpl<_$PickupTaskModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PickupTaskModelImplToJson(
      this,
    );
  }
}

abstract class _PickupTaskModel extends PickupTaskModel {
  const factory _PickupTaskModel(
      {required final String id,
      required final String requestId,
      required final String courierId,
      required final String customerId,
      @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
      required final DateTime scheduledDate,
      required final String timeRange,
      required final String zone,
      required final String status,
      final int? sequenceNumber,
      final bool isPriority,
      final String? notes,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? updatedAt}) = _$PickupTaskModelImpl;
  const _PickupTaskModel._() : super._();

  factory _PickupTaskModel.fromJson(Map<String, dynamic> json) =
      _$PickupTaskModelImpl.fromJson;

  @override
  String get id;
  @override
  String get requestId;
  @override
  String get courierId;
  @override
  String get customerId;
  @override
  @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
  DateTime get scheduledDate;
  @override
  String get timeRange;
  @override
  String get zone;
  @override
  String get status;
  @override
  int? get sequenceNumber;
  @override
  bool get isPriority;
  @override
  String? get notes;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get createdAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$PickupTaskModelImplCopyWith<_$PickupTaskModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
