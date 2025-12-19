// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pickup_slot_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PickupSlotModel _$PickupSlotModelFromJson(Map<String, dynamic> json) {
  return _PickupSlotModel.fromJson(json);
}

/// @nodoc
mixin _$PickupSlotModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
  DateTime get date => throw _privateConstructorUsedError;
  String get timeRange => throw _privateConstructorUsedError;
  String get zone => throw _privateConstructorUsedError;
  int get capacityWeightKg => throw _privateConstructorUsedError;
  int get usedWeightKg => throw _privateConstructorUsedError;
  String? get courierId => throw _privateConstructorUsedError;
  String? get courierName => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PickupSlotModelCopyWith<PickupSlotModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PickupSlotModelCopyWith<$Res> {
  factory $PickupSlotModelCopyWith(
          PickupSlotModel value, $Res Function(PickupSlotModel) then) =
      _$PickupSlotModelCopyWithImpl<$Res, PickupSlotModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
      DateTime date,
      String timeRange,
      String zone,
      int capacityWeightKg,
      int usedWeightKg,
      String? courierId,
      String? courierName,
      bool isActive,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? updatedAt});
}

/// @nodoc
class _$PickupSlotModelCopyWithImpl<$Res, $Val extends PickupSlotModel>
    implements $PickupSlotModelCopyWith<$Res> {
  _$PickupSlotModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? timeRange = null,
    Object? zone = null,
    Object? capacityWeightKg = null,
    Object? usedWeightKg = null,
    Object? courierId = freezed,
    Object? courierName = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      timeRange: null == timeRange
          ? _value.timeRange
          : timeRange // ignore: cast_nullable_to_non_nullable
              as String,
      zone: null == zone
          ? _value.zone
          : zone // ignore: cast_nullable_to_non_nullable
              as String,
      capacityWeightKg: null == capacityWeightKg
          ? _value.capacityWeightKg
          : capacityWeightKg // ignore: cast_nullable_to_non_nullable
              as int,
      usedWeightKg: null == usedWeightKg
          ? _value.usedWeightKg
          : usedWeightKg // ignore: cast_nullable_to_non_nullable
              as int,
      courierId: freezed == courierId
          ? _value.courierId
          : courierId // ignore: cast_nullable_to_non_nullable
              as String?,
      courierName: freezed == courierName
          ? _value.courierName
          : courierName // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
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
abstract class _$$PickupSlotModelImplCopyWith<$Res>
    implements $PickupSlotModelCopyWith<$Res> {
  factory _$$PickupSlotModelImplCopyWith(_$PickupSlotModelImpl value,
          $Res Function(_$PickupSlotModelImpl) then) =
      __$$PickupSlotModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
      DateTime date,
      String timeRange,
      String zone,
      int capacityWeightKg,
      int usedWeightKg,
      String? courierId,
      String? courierName,
      bool isActive,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? updatedAt});
}

/// @nodoc
class __$$PickupSlotModelImplCopyWithImpl<$Res>
    extends _$PickupSlotModelCopyWithImpl<$Res, _$PickupSlotModelImpl>
    implements _$$PickupSlotModelImplCopyWith<$Res> {
  __$$PickupSlotModelImplCopyWithImpl(
      _$PickupSlotModelImpl _value, $Res Function(_$PickupSlotModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? timeRange = null,
    Object? zone = null,
    Object? capacityWeightKg = null,
    Object? usedWeightKg = null,
    Object? courierId = freezed,
    Object? courierName = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$PickupSlotModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      timeRange: null == timeRange
          ? _value.timeRange
          : timeRange // ignore: cast_nullable_to_non_nullable
              as String,
      zone: null == zone
          ? _value.zone
          : zone // ignore: cast_nullable_to_non_nullable
              as String,
      capacityWeightKg: null == capacityWeightKg
          ? _value.capacityWeightKg
          : capacityWeightKg // ignore: cast_nullable_to_non_nullable
              as int,
      usedWeightKg: null == usedWeightKg
          ? _value.usedWeightKg
          : usedWeightKg // ignore: cast_nullable_to_non_nullable
              as int,
      courierId: freezed == courierId
          ? _value.courierId
          : courierId // ignore: cast_nullable_to_non_nullable
              as String?,
      courierName: freezed == courierName
          ? _value.courierName
          : courierName // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
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
class _$PickupSlotModelImpl extends _PickupSlotModel {
  const _$PickupSlotModelImpl(
      {required this.id,
      @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
      required this.date,
      required this.timeRange,
      required this.zone,
      required this.capacityWeightKg,
      this.usedWeightKg = 0,
      this.courierId,
      this.courierName,
      this.isActive = true,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.updatedAt})
      : super._();

  factory _$PickupSlotModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PickupSlotModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
  final DateTime date;
  @override
  final String timeRange;
  @override
  final String zone;
  @override
  final int capacityWeightKg;
  @override
  @JsonKey()
  final int usedWeightKg;
  @override
  final String? courierId;
  @override
  final String? courierName;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? createdAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'PickupSlotModel(id: $id, date: $date, timeRange: $timeRange, zone: $zone, capacityWeightKg: $capacityWeightKg, usedWeightKg: $usedWeightKg, courierId: $courierId, courierName: $courierName, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PickupSlotModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.timeRange, timeRange) ||
                other.timeRange == timeRange) &&
            (identical(other.zone, zone) || other.zone == zone) &&
            (identical(other.capacityWeightKg, capacityWeightKg) ||
                other.capacityWeightKg == capacityWeightKg) &&
            (identical(other.usedWeightKg, usedWeightKg) ||
                other.usedWeightKg == usedWeightKg) &&
            (identical(other.courierId, courierId) ||
                other.courierId == courierId) &&
            (identical(other.courierName, courierName) ||
                other.courierName == courierName) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
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
      date,
      timeRange,
      zone,
      capacityWeightKg,
      usedWeightKg,
      courierId,
      courierName,
      isActive,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PickupSlotModelImplCopyWith<_$PickupSlotModelImpl> get copyWith =>
      __$$PickupSlotModelImplCopyWithImpl<_$PickupSlotModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PickupSlotModelImplToJson(
      this,
    );
  }
}

abstract class _PickupSlotModel extends PickupSlotModel {
  const factory _PickupSlotModel(
      {required final String id,
      @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
      required final DateTime date,
      required final String timeRange,
      required final String zone,
      required final int capacityWeightKg,
      final int usedWeightKg,
      final String? courierId,
      final String? courierName,
      final bool isActive,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? updatedAt}) = _$PickupSlotModelImpl;
  const _PickupSlotModel._() : super._();

  factory _PickupSlotModel.fromJson(Map<String, dynamic> json) =
      _$PickupSlotModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
  DateTime get date;
  @override
  String get timeRange;
  @override
  String get zone;
  @override
  int get capacityWeightKg;
  @override
  int get usedWeightKg;
  @override
  String? get courierId;
  @override
  String? get courierName;
  @override
  bool get isActive;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get createdAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$PickupSlotModelImplCopyWith<_$PickupSlotModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
