// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'voucher_scan_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VoucherScanModel _$VoucherScanModelFromJson(Map<String, dynamic> json) {
  return _VoucherScanModel.fromJson(json);
}

/// @nodoc
mixin _$VoucherScanModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String get eventId => throw _privateConstructorUsedError;
  String get eventName => throw _privateConstructorUsedError;
  String get itemId => throw _privateConstructorUsedError;
  String get itemName => throw _privateConstructorUsedError;
  String get voucherCode => throw _privateConstructorUsedError;
  ScanStatus get status => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
  DateTime get scannedAt => throw _privateConstructorUsedError;
  String get scannedBy => throw _privateConstructorUsedError;
  String? get scannedByName => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  String? get deviceId => throw _privateConstructorUsedError;
  String? get deviceInfo => throw _privateConstructorUsedError;
  String? get remarks => throw _privateConstructorUsedError;
  String? get invalidReason => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  bool get isFraudulent => throw _privateConstructorUsedError;
  String? get fraudReason => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get verifiedAt => throw _privateConstructorUsedError;
  String? get verifiedBy => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VoucherScanModelCopyWith<VoucherScanModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VoucherScanModelCopyWith<$Res> {
  factory $VoucherScanModelCopyWith(
          VoucherScanModel value, $Res Function(VoucherScanModel) then) =
      _$VoucherScanModelCopyWithImpl<$Res, VoucherScanModel>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String userName,
      String eventId,
      String eventName,
      String itemId,
      String itemName,
      String voucherCode,
      ScanStatus status,
      @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
      DateTime scannedAt,
      String scannedBy,
      String? scannedByName,
      String? location,
      double? latitude,
      double? longitude,
      String? deviceId,
      String? deviceInfo,
      String? remarks,
      String? invalidReason,
      Map<String, dynamic>? metadata,
      bool isFraudulent,
      String? fraudReason,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? verifiedAt,
      String? verifiedBy,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? updatedAt});
}

/// @nodoc
class _$VoucherScanModelCopyWithImpl<$Res, $Val extends VoucherScanModel>
    implements $VoucherScanModelCopyWith<$Res> {
  _$VoucherScanModelCopyWithImpl(this._value, this._then);

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
    Object? eventId = null,
    Object? eventName = null,
    Object? itemId = null,
    Object? itemName = null,
    Object? voucherCode = null,
    Object? status = null,
    Object? scannedAt = null,
    Object? scannedBy = null,
    Object? scannedByName = freezed,
    Object? location = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? deviceId = freezed,
    Object? deviceInfo = freezed,
    Object? remarks = freezed,
    Object? invalidReason = freezed,
    Object? metadata = freezed,
    Object? isFraudulent = null,
    Object? fraudReason = freezed,
    Object? verifiedAt = freezed,
    Object? verifiedBy = freezed,
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
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      eventName: null == eventName
          ? _value.eventName
          : eventName // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      itemName: null == itemName
          ? _value.itemName
          : itemName // ignore: cast_nullable_to_non_nullable
              as String,
      voucherCode: null == voucherCode
          ? _value.voucherCode
          : voucherCode // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ScanStatus,
      scannedAt: null == scannedAt
          ? _value.scannedAt
          : scannedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      scannedBy: null == scannedBy
          ? _value.scannedBy
          : scannedBy // ignore: cast_nullable_to_non_nullable
              as String,
      scannedByName: freezed == scannedByName
          ? _value.scannedByName
          : scannedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceInfo: freezed == deviceInfo
          ? _value.deviceInfo
          : deviceInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      remarks: freezed == remarks
          ? _value.remarks
          : remarks // ignore: cast_nullable_to_non_nullable
              as String?,
      invalidReason: freezed == invalidReason
          ? _value.invalidReason
          : invalidReason // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isFraudulent: null == isFraudulent
          ? _value.isFraudulent
          : isFraudulent // ignore: cast_nullable_to_non_nullable
              as bool,
      fraudReason: freezed == fraudReason
          ? _value.fraudReason
          : fraudReason // ignore: cast_nullable_to_non_nullable
              as String?,
      verifiedAt: freezed == verifiedAt
          ? _value.verifiedAt
          : verifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      verifiedBy: freezed == verifiedBy
          ? _value.verifiedBy
          : verifiedBy // ignore: cast_nullable_to_non_nullable
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
abstract class _$$VoucherScanModelImplCopyWith<$Res>
    implements $VoucherScanModelCopyWith<$Res> {
  factory _$$VoucherScanModelImplCopyWith(_$VoucherScanModelImpl value,
          $Res Function(_$VoucherScanModelImpl) then) =
      __$$VoucherScanModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String userName,
      String eventId,
      String eventName,
      String itemId,
      String itemName,
      String voucherCode,
      ScanStatus status,
      @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
      DateTime scannedAt,
      String scannedBy,
      String? scannedByName,
      String? location,
      double? latitude,
      double? longitude,
      String? deviceId,
      String? deviceInfo,
      String? remarks,
      String? invalidReason,
      Map<String, dynamic>? metadata,
      bool isFraudulent,
      String? fraudReason,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? verifiedAt,
      String? verifiedBy,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? updatedAt});
}

/// @nodoc
class __$$VoucherScanModelImplCopyWithImpl<$Res>
    extends _$VoucherScanModelCopyWithImpl<$Res, _$VoucherScanModelImpl>
    implements _$$VoucherScanModelImplCopyWith<$Res> {
  __$$VoucherScanModelImplCopyWithImpl(_$VoucherScanModelImpl _value,
      $Res Function(_$VoucherScanModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userName = null,
    Object? eventId = null,
    Object? eventName = null,
    Object? itemId = null,
    Object? itemName = null,
    Object? voucherCode = null,
    Object? status = null,
    Object? scannedAt = null,
    Object? scannedBy = null,
    Object? scannedByName = freezed,
    Object? location = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? deviceId = freezed,
    Object? deviceInfo = freezed,
    Object? remarks = freezed,
    Object? invalidReason = freezed,
    Object? metadata = freezed,
    Object? isFraudulent = null,
    Object? fraudReason = freezed,
    Object? verifiedAt = freezed,
    Object? verifiedBy = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$VoucherScanModelImpl(
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
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      eventName: null == eventName
          ? _value.eventName
          : eventName // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      itemName: null == itemName
          ? _value.itemName
          : itemName // ignore: cast_nullable_to_non_nullable
              as String,
      voucherCode: null == voucherCode
          ? _value.voucherCode
          : voucherCode // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ScanStatus,
      scannedAt: null == scannedAt
          ? _value.scannedAt
          : scannedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      scannedBy: null == scannedBy
          ? _value.scannedBy
          : scannedBy // ignore: cast_nullable_to_non_nullable
              as String,
      scannedByName: freezed == scannedByName
          ? _value.scannedByName
          : scannedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceInfo: freezed == deviceInfo
          ? _value.deviceInfo
          : deviceInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      remarks: freezed == remarks
          ? _value.remarks
          : remarks // ignore: cast_nullable_to_non_nullable
              as String?,
      invalidReason: freezed == invalidReason
          ? _value.invalidReason
          : invalidReason // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isFraudulent: null == isFraudulent
          ? _value.isFraudulent
          : isFraudulent // ignore: cast_nullable_to_non_nullable
              as bool,
      fraudReason: freezed == fraudReason
          ? _value.fraudReason
          : fraudReason // ignore: cast_nullable_to_non_nullable
              as String?,
      verifiedAt: freezed == verifiedAt
          ? _value.verifiedAt
          : verifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      verifiedBy: freezed == verifiedBy
          ? _value.verifiedBy
          : verifiedBy // ignore: cast_nullable_to_non_nullable
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
class _$VoucherScanModelImpl extends _VoucherScanModel {
  const _$VoucherScanModelImpl(
      {required this.id,
      required this.userId,
      required this.userName,
      required this.eventId,
      required this.eventName,
      required this.itemId,
      required this.itemName,
      required this.voucherCode,
      required this.status,
      @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
      required this.scannedAt,
      required this.scannedBy,
      this.scannedByName,
      this.location,
      this.latitude,
      this.longitude,
      this.deviceId,
      this.deviceInfo,
      this.remarks,
      this.invalidReason,
      final Map<String, dynamic>? metadata,
      this.isFraudulent = false,
      this.fraudReason,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.verifiedAt,
      this.verifiedBy,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.updatedAt})
      : _metadata = metadata,
        super._();

  factory _$VoucherScanModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VoucherScanModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String userName;
  @override
  final String eventId;
  @override
  final String eventName;
  @override
  final String itemId;
  @override
  final String itemName;
  @override
  final String voucherCode;
  @override
  final ScanStatus status;
  @override
  @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
  final DateTime scannedAt;
  @override
  final String scannedBy;
  @override
  final String? scannedByName;
  @override
  final String? location;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final String? deviceId;
  @override
  final String? deviceInfo;
  @override
  final String? remarks;
  @override
  final String? invalidReason;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final bool isFraudulent;
  @override
  final String? fraudReason;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? verifiedAt;
  @override
  final String? verifiedBy;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? createdAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'VoucherScanModel(id: $id, userId: $userId, userName: $userName, eventId: $eventId, eventName: $eventName, itemId: $itemId, itemName: $itemName, voucherCode: $voucherCode, status: $status, scannedAt: $scannedAt, scannedBy: $scannedBy, scannedByName: $scannedByName, location: $location, latitude: $latitude, longitude: $longitude, deviceId: $deviceId, deviceInfo: $deviceInfo, remarks: $remarks, invalidReason: $invalidReason, metadata: $metadata, isFraudulent: $isFraudulent, fraudReason: $fraudReason, verifiedAt: $verifiedAt, verifiedBy: $verifiedBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VoucherScanModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.eventName, eventName) ||
                other.eventName == eventName) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.voucherCode, voucherCode) ||
                other.voucherCode == voucherCode) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.scannedAt, scannedAt) ||
                other.scannedAt == scannedAt) &&
            (identical(other.scannedBy, scannedBy) ||
                other.scannedBy == scannedBy) &&
            (identical(other.scannedByName, scannedByName) ||
                other.scannedByName == scannedByName) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.deviceInfo, deviceInfo) ||
                other.deviceInfo == deviceInfo) &&
            (identical(other.remarks, remarks) || other.remarks == remarks) &&
            (identical(other.invalidReason, invalidReason) ||
                other.invalidReason == invalidReason) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.isFraudulent, isFraudulent) ||
                other.isFraudulent == isFraudulent) &&
            (identical(other.fraudReason, fraudReason) ||
                other.fraudReason == fraudReason) &&
            (identical(other.verifiedAt, verifiedAt) ||
                other.verifiedAt == verifiedAt) &&
            (identical(other.verifiedBy, verifiedBy) ||
                other.verifiedBy == verifiedBy) &&
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
        eventId,
        eventName,
        itemId,
        itemName,
        voucherCode,
        status,
        scannedAt,
        scannedBy,
        scannedByName,
        location,
        latitude,
        longitude,
        deviceId,
        deviceInfo,
        remarks,
        invalidReason,
        const DeepCollectionEquality().hash(_metadata),
        isFraudulent,
        fraudReason,
        verifiedAt,
        verifiedBy,
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VoucherScanModelImplCopyWith<_$VoucherScanModelImpl> get copyWith =>
      __$$VoucherScanModelImplCopyWithImpl<_$VoucherScanModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VoucherScanModelImplToJson(
      this,
    );
  }
}

abstract class _VoucherScanModel extends VoucherScanModel {
  const factory _VoucherScanModel(
      {required final String id,
      required final String userId,
      required final String userName,
      required final String eventId,
      required final String eventName,
      required final String itemId,
      required final String itemName,
      required final String voucherCode,
      required final ScanStatus status,
      @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
      required final DateTime scannedAt,
      required final String scannedBy,
      final String? scannedByName,
      final String? location,
      final double? latitude,
      final double? longitude,
      final String? deviceId,
      final String? deviceInfo,
      final String? remarks,
      final String? invalidReason,
      final Map<String, dynamic>? metadata,
      final bool isFraudulent,
      final String? fraudReason,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? verifiedAt,
      final String? verifiedBy,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? updatedAt}) = _$VoucherScanModelImpl;
  const _VoucherScanModel._() : super._();

  factory _VoucherScanModel.fromJson(Map<String, dynamic> json) =
      _$VoucherScanModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get userName;
  @override
  String get eventId;
  @override
  String get eventName;
  @override
  String get itemId;
  @override
  String get itemName;
  @override
  String get voucherCode;
  @override
  ScanStatus get status;
  @override
  @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
  DateTime get scannedAt;
  @override
  String get scannedBy;
  @override
  String? get scannedByName;
  @override
  String? get location;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  String? get deviceId;
  @override
  String? get deviceInfo;
  @override
  String? get remarks;
  @override
  String? get invalidReason;
  @override
  Map<String, dynamic>? get metadata;
  @override
  bool get isFraudulent;
  @override
  String? get fraudReason;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get verifiedAt;
  @override
  String? get verifiedBy;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get createdAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$VoucherScanModelImplCopyWith<_$VoucherScanModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
