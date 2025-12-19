// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pickup_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PickupRequestModel _$PickupRequestModelFromJson(Map<String, dynamic> json) {
  return _PickupRequestModel.fromJson(json);
}

/// @nodoc
mixin _$PickupRequestModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get courierId => throw _privateConstructorUsedError;
  Map<String, int> get quantities => throw _privateConstructorUsedError;
  double get estimatedWeight => throw _privateConstructorUsedError;
  double? get actualWeight => throw _privateConstructorUsedError;
  int get estimatedPoints => throw _privateConstructorUsedError;
  int? get actualPoints => throw _privateConstructorUsedError;
  Map<String, dynamic> get addressSnapshot =>
      throw _privateConstructorUsedError;
  @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
  DateTime get pickupDate => throw _privateConstructorUsedError;
  String get timeRange => throw _privateConstructorUsedError;
  String get zone => throw _privateConstructorUsedError;
  PickupStatus get status => throw _privateConstructorUsedError;
  String? get otp => throw _privateConstructorUsedError;
  List<String>? get proofPhotos => throw _privateConstructorUsedError;
  String? get cancelReason => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get assignedAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get onTheWayAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get arrivedAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get pickedUpAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get completedAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get cancelledAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PickupRequestModelCopyWith<PickupRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PickupRequestModelCopyWith<$Res> {
  factory $PickupRequestModelCopyWith(
          PickupRequestModel value, $Res Function(PickupRequestModel) then) =
      _$PickupRequestModelCopyWithImpl<$Res, PickupRequestModel>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String? courierId,
      Map<String, int> quantities,
      double estimatedWeight,
      double? actualWeight,
      int estimatedPoints,
      int? actualPoints,
      Map<String, dynamic> addressSnapshot,
      @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
      DateTime pickupDate,
      String timeRange,
      String zone,
      PickupStatus status,
      String? otp,
      List<String>? proofPhotos,
      String? cancelReason,
      String? notes,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? updatedAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? assignedAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? onTheWayAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? arrivedAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? pickedUpAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? completedAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? cancelledAt});
}

/// @nodoc
class _$PickupRequestModelCopyWithImpl<$Res, $Val extends PickupRequestModel>
    implements $PickupRequestModelCopyWith<$Res> {
  _$PickupRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? courierId = freezed,
    Object? quantities = null,
    Object? estimatedWeight = null,
    Object? actualWeight = freezed,
    Object? estimatedPoints = null,
    Object? actualPoints = freezed,
    Object? addressSnapshot = null,
    Object? pickupDate = null,
    Object? timeRange = null,
    Object? zone = null,
    Object? status = null,
    Object? otp = freezed,
    Object? proofPhotos = freezed,
    Object? cancelReason = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? assignedAt = freezed,
    Object? onTheWayAt = freezed,
    Object? arrivedAt = freezed,
    Object? pickedUpAt = freezed,
    Object? completedAt = freezed,
    Object? cancelledAt = freezed,
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
      courierId: freezed == courierId
          ? _value.courierId
          : courierId // ignore: cast_nullable_to_non_nullable
              as String?,
      quantities: null == quantities
          ? _value.quantities
          : quantities // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      estimatedWeight: null == estimatedWeight
          ? _value.estimatedWeight
          : estimatedWeight // ignore: cast_nullable_to_non_nullable
              as double,
      actualWeight: freezed == actualWeight
          ? _value.actualWeight
          : actualWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      estimatedPoints: null == estimatedPoints
          ? _value.estimatedPoints
          : estimatedPoints // ignore: cast_nullable_to_non_nullable
              as int,
      actualPoints: freezed == actualPoints
          ? _value.actualPoints
          : actualPoints // ignore: cast_nullable_to_non_nullable
              as int?,
      addressSnapshot: null == addressSnapshot
          ? _value.addressSnapshot
          : addressSnapshot // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      pickupDate: null == pickupDate
          ? _value.pickupDate
          : pickupDate // ignore: cast_nullable_to_non_nullable
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
              as PickupStatus,
      otp: freezed == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String?,
      proofPhotos: freezed == proofPhotos
          ? _value.proofPhotos
          : proofPhotos // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      cancelReason: freezed == cancelReason
          ? _value.cancelReason
          : cancelReason // ignore: cast_nullable_to_non_nullable
              as String?,
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
      assignedAt: freezed == assignedAt
          ? _value.assignedAt
          : assignedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      onTheWayAt: freezed == onTheWayAt
          ? _value.onTheWayAt
          : onTheWayAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      arrivedAt: freezed == arrivedAt
          ? _value.arrivedAt
          : arrivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      pickedUpAt: freezed == pickedUpAt
          ? _value.pickedUpAt
          : pickedUpAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      cancelledAt: freezed == cancelledAt
          ? _value.cancelledAt
          : cancelledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PickupRequestModelImplCopyWith<$Res>
    implements $PickupRequestModelCopyWith<$Res> {
  factory _$$PickupRequestModelImplCopyWith(_$PickupRequestModelImpl value,
          $Res Function(_$PickupRequestModelImpl) then) =
      __$$PickupRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String? courierId,
      Map<String, int> quantities,
      double estimatedWeight,
      double? actualWeight,
      int estimatedPoints,
      int? actualPoints,
      Map<String, dynamic> addressSnapshot,
      @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
      DateTime pickupDate,
      String timeRange,
      String zone,
      PickupStatus status,
      String? otp,
      List<String>? proofPhotos,
      String? cancelReason,
      String? notes,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? updatedAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? assignedAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? onTheWayAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? arrivedAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? pickedUpAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? completedAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? cancelledAt});
}

/// @nodoc
class __$$PickupRequestModelImplCopyWithImpl<$Res>
    extends _$PickupRequestModelCopyWithImpl<$Res, _$PickupRequestModelImpl>
    implements _$$PickupRequestModelImplCopyWith<$Res> {
  __$$PickupRequestModelImplCopyWithImpl(_$PickupRequestModelImpl _value,
      $Res Function(_$PickupRequestModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? courierId = freezed,
    Object? quantities = null,
    Object? estimatedWeight = null,
    Object? actualWeight = freezed,
    Object? estimatedPoints = null,
    Object? actualPoints = freezed,
    Object? addressSnapshot = null,
    Object? pickupDate = null,
    Object? timeRange = null,
    Object? zone = null,
    Object? status = null,
    Object? otp = freezed,
    Object? proofPhotos = freezed,
    Object? cancelReason = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? assignedAt = freezed,
    Object? onTheWayAt = freezed,
    Object? arrivedAt = freezed,
    Object? pickedUpAt = freezed,
    Object? completedAt = freezed,
    Object? cancelledAt = freezed,
  }) {
    return _then(_$PickupRequestModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      courierId: freezed == courierId
          ? _value.courierId
          : courierId // ignore: cast_nullable_to_non_nullable
              as String?,
      quantities: null == quantities
          ? _value._quantities
          : quantities // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      estimatedWeight: null == estimatedWeight
          ? _value.estimatedWeight
          : estimatedWeight // ignore: cast_nullable_to_non_nullable
              as double,
      actualWeight: freezed == actualWeight
          ? _value.actualWeight
          : actualWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      estimatedPoints: null == estimatedPoints
          ? _value.estimatedPoints
          : estimatedPoints // ignore: cast_nullable_to_non_nullable
              as int,
      actualPoints: freezed == actualPoints
          ? _value.actualPoints
          : actualPoints // ignore: cast_nullable_to_non_nullable
              as int?,
      addressSnapshot: null == addressSnapshot
          ? _value._addressSnapshot
          : addressSnapshot // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      pickupDate: null == pickupDate
          ? _value.pickupDate
          : pickupDate // ignore: cast_nullable_to_non_nullable
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
              as PickupStatus,
      otp: freezed == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String?,
      proofPhotos: freezed == proofPhotos
          ? _value._proofPhotos
          : proofPhotos // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      cancelReason: freezed == cancelReason
          ? _value.cancelReason
          : cancelReason // ignore: cast_nullable_to_non_nullable
              as String?,
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
      assignedAt: freezed == assignedAt
          ? _value.assignedAt
          : assignedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      onTheWayAt: freezed == onTheWayAt
          ? _value.onTheWayAt
          : onTheWayAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      arrivedAt: freezed == arrivedAt
          ? _value.arrivedAt
          : arrivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      pickedUpAt: freezed == pickedUpAt
          ? _value.pickedUpAt
          : pickedUpAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      cancelledAt: freezed == cancelledAt
          ? _value.cancelledAt
          : cancelledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PickupRequestModelImpl extends _PickupRequestModel {
  const _$PickupRequestModelImpl(
      {required this.id,
      required this.userId,
      this.courierId,
      required final Map<String, int> quantities,
      required this.estimatedWeight,
      this.actualWeight,
      required this.estimatedPoints,
      this.actualPoints,
      required final Map<String, dynamic> addressSnapshot,
      @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
      required this.pickupDate,
      required this.timeRange,
      required this.zone,
      required this.status,
      this.otp,
      final List<String>? proofPhotos,
      this.cancelReason,
      this.notes,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.updatedAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.assignedAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.onTheWayAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.arrivedAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.pickedUpAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.completedAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.cancelledAt})
      : _quantities = quantities,
        _addressSnapshot = addressSnapshot,
        _proofPhotos = proofPhotos,
        super._();

  factory _$PickupRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PickupRequestModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String? courierId;
  final Map<String, int> _quantities;
  @override
  Map<String, int> get quantities {
    if (_quantities is EqualUnmodifiableMapView) return _quantities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_quantities);
  }

  @override
  final double estimatedWeight;
  @override
  final double? actualWeight;
  @override
  final int estimatedPoints;
  @override
  final int? actualPoints;
  final Map<String, dynamic> _addressSnapshot;
  @override
  Map<String, dynamic> get addressSnapshot {
    if (_addressSnapshot is EqualUnmodifiableMapView) return _addressSnapshot;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_addressSnapshot);
  }

  @override
  @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
  final DateTime pickupDate;
  @override
  final String timeRange;
  @override
  final String zone;
  @override
  final PickupStatus status;
  @override
  final String? otp;
  final List<String>? _proofPhotos;
  @override
  List<String>? get proofPhotos {
    final value = _proofPhotos;
    if (value == null) return null;
    if (_proofPhotos is EqualUnmodifiableListView) return _proofPhotos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? cancelReason;
  @override
  final String? notes;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? createdAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? updatedAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? assignedAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? onTheWayAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? arrivedAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? pickedUpAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? completedAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? cancelledAt;

  @override
  String toString() {
    return 'PickupRequestModel(id: $id, userId: $userId, courierId: $courierId, quantities: $quantities, estimatedWeight: $estimatedWeight, actualWeight: $actualWeight, estimatedPoints: $estimatedPoints, actualPoints: $actualPoints, addressSnapshot: $addressSnapshot, pickupDate: $pickupDate, timeRange: $timeRange, zone: $zone, status: $status, otp: $otp, proofPhotos: $proofPhotos, cancelReason: $cancelReason, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, assignedAt: $assignedAt, onTheWayAt: $onTheWayAt, arrivedAt: $arrivedAt, pickedUpAt: $pickedUpAt, completedAt: $completedAt, cancelledAt: $cancelledAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PickupRequestModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.courierId, courierId) ||
                other.courierId == courierId) &&
            const DeepCollectionEquality()
                .equals(other._quantities, _quantities) &&
            (identical(other.estimatedWeight, estimatedWeight) ||
                other.estimatedWeight == estimatedWeight) &&
            (identical(other.actualWeight, actualWeight) ||
                other.actualWeight == actualWeight) &&
            (identical(other.estimatedPoints, estimatedPoints) ||
                other.estimatedPoints == estimatedPoints) &&
            (identical(other.actualPoints, actualPoints) ||
                other.actualPoints == actualPoints) &&
            const DeepCollectionEquality()
                .equals(other._addressSnapshot, _addressSnapshot) &&
            (identical(other.pickupDate, pickupDate) ||
                other.pickupDate == pickupDate) &&
            (identical(other.timeRange, timeRange) ||
                other.timeRange == timeRange) &&
            (identical(other.zone, zone) || other.zone == zone) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.otp, otp) || other.otp == otp) &&
            const DeepCollectionEquality()
                .equals(other._proofPhotos, _proofPhotos) &&
            (identical(other.cancelReason, cancelReason) ||
                other.cancelReason == cancelReason) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.assignedAt, assignedAt) ||
                other.assignedAt == assignedAt) &&
            (identical(other.onTheWayAt, onTheWayAt) ||
                other.onTheWayAt == onTheWayAt) &&
            (identical(other.arrivedAt, arrivedAt) ||
                other.arrivedAt == arrivedAt) &&
            (identical(other.pickedUpAt, pickedUpAt) ||
                other.pickedUpAt == pickedUpAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.cancelledAt, cancelledAt) ||
                other.cancelledAt == cancelledAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        courierId,
        const DeepCollectionEquality().hash(_quantities),
        estimatedWeight,
        actualWeight,
        estimatedPoints,
        actualPoints,
        const DeepCollectionEquality().hash(_addressSnapshot),
        pickupDate,
        timeRange,
        zone,
        status,
        otp,
        const DeepCollectionEquality().hash(_proofPhotos),
        cancelReason,
        notes,
        createdAt,
        updatedAt,
        assignedAt,
        onTheWayAt,
        arrivedAt,
        pickedUpAt,
        completedAt,
        cancelledAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PickupRequestModelImplCopyWith<_$PickupRequestModelImpl> get copyWith =>
      __$$PickupRequestModelImplCopyWithImpl<_$PickupRequestModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PickupRequestModelImplToJson(
      this,
    );
  }
}

abstract class _PickupRequestModel extends PickupRequestModel {
  const factory _PickupRequestModel(
      {required final String id,
      required final String userId,
      final String? courierId,
      required final Map<String, int> quantities,
      required final double estimatedWeight,
      final double? actualWeight,
      required final int estimatedPoints,
      final int? actualPoints,
      required final Map<String, dynamic> addressSnapshot,
      @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
      required final DateTime pickupDate,
      required final String timeRange,
      required final String zone,
      required final PickupStatus status,
      final String? otp,
      final List<String>? proofPhotos,
      final String? cancelReason,
      final String? notes,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? updatedAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? assignedAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? onTheWayAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? arrivedAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? pickedUpAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? completedAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? cancelledAt}) = _$PickupRequestModelImpl;
  const _PickupRequestModel._() : super._();

  factory _PickupRequestModel.fromJson(Map<String, dynamic> json) =
      _$PickupRequestModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String? get courierId;
  @override
  Map<String, int> get quantities;
  @override
  double get estimatedWeight;
  @override
  double? get actualWeight;
  @override
  int get estimatedPoints;
  @override
  int? get actualPoints;
  @override
  Map<String, dynamic> get addressSnapshot;
  @override
  @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
  DateTime get pickupDate;
  @override
  String get timeRange;
  @override
  String get zone;
  @override
  PickupStatus get status;
  @override
  String? get otp;
  @override
  List<String>? get proofPhotos;
  @override
  String? get cancelReason;
  @override
  String? get notes;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get createdAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get updatedAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get assignedAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get onTheWayAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get arrivedAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get pickedUpAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get completedAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get cancelledAt;
  @override
  @JsonKey(ignore: true)
  _$$PickupRequestModelImplCopyWith<_$PickupRequestModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
