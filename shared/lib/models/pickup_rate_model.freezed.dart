// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pickup_rate_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PickupRateModel _$PickupRateModelFromJson(Map<String, dynamic> json) {
  return _PickupRateModel.fromJson(json);
}

/// @nodoc
mixin _$PickupRateModel {
  String get id => throw _privateConstructorUsedError; // Category Info
  String get category =>
      throw _privateConstructorUsedError; // 'Plastik', 'Kaca', 'Kaleng', 'Kardus', 'Kain', 'Keramik'
  String get displayName => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get iconUrl => throw _privateConstructorUsedError; // Rate Calculation
  double get pointsPerKg =>
      throw _privateConstructorUsedError; // Points earned per kilogram
  double get avgWeightPerUnit =>
      throw _privateConstructorUsedError; // Average weight in kg (e.g., 1 plastic bottle = 0.05kg)
// Limits
  int? get minQuantity => throw _privateConstructorUsedError;
  int? get maxQuantity => throw _privateConstructorUsedError; // Status
  bool get isActive => throw _privateConstructorUsedError; // Display Order
  int get sortOrder => throw _privateConstructorUsedError; // Timestamps
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PickupRateModelCopyWith<PickupRateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PickupRateModelCopyWith<$Res> {
  factory $PickupRateModelCopyWith(
          PickupRateModel value, $Res Function(PickupRateModel) then) =
      _$PickupRateModelCopyWithImpl<$Res, PickupRateModel>;
  @useResult
  $Res call(
      {String id,
      String category,
      String displayName,
      String? description,
      String? iconUrl,
      double pointsPerKg,
      double avgWeightPerUnit,
      int? minQuantity,
      int? maxQuantity,
      bool isActive,
      int sortOrder,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? updatedAt});
}

/// @nodoc
class _$PickupRateModelCopyWithImpl<$Res, $Val extends PickupRateModel>
    implements $PickupRateModelCopyWith<$Res> {
  _$PickupRateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = null,
    Object? displayName = null,
    Object? description = freezed,
    Object? iconUrl = freezed,
    Object? pointsPerKg = null,
    Object? avgWeightPerUnit = null,
    Object? minQuantity = freezed,
    Object? maxQuantity = freezed,
    Object? isActive = null,
    Object? sortOrder = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      iconUrl: freezed == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      pointsPerKg: null == pointsPerKg
          ? _value.pointsPerKg
          : pointsPerKg // ignore: cast_nullable_to_non_nullable
              as double,
      avgWeightPerUnit: null == avgWeightPerUnit
          ? _value.avgWeightPerUnit
          : avgWeightPerUnit // ignore: cast_nullable_to_non_nullable
              as double,
      minQuantity: freezed == minQuantity
          ? _value.minQuantity
          : minQuantity // ignore: cast_nullable_to_non_nullable
              as int?,
      maxQuantity: freezed == maxQuantity
          ? _value.maxQuantity
          : maxQuantity // ignore: cast_nullable_to_non_nullable
              as int?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
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
abstract class _$$PickupRateModelImplCopyWith<$Res>
    implements $PickupRateModelCopyWith<$Res> {
  factory _$$PickupRateModelImplCopyWith(_$PickupRateModelImpl value,
          $Res Function(_$PickupRateModelImpl) then) =
      __$$PickupRateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String category,
      String displayName,
      String? description,
      String? iconUrl,
      double pointsPerKg,
      double avgWeightPerUnit,
      int? minQuantity,
      int? maxQuantity,
      bool isActive,
      int sortOrder,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? updatedAt});
}

/// @nodoc
class __$$PickupRateModelImplCopyWithImpl<$Res>
    extends _$PickupRateModelCopyWithImpl<$Res, _$PickupRateModelImpl>
    implements _$$PickupRateModelImplCopyWith<$Res> {
  __$$PickupRateModelImplCopyWithImpl(
      _$PickupRateModelImpl _value, $Res Function(_$PickupRateModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = null,
    Object? displayName = null,
    Object? description = freezed,
    Object? iconUrl = freezed,
    Object? pointsPerKg = null,
    Object? avgWeightPerUnit = null,
    Object? minQuantity = freezed,
    Object? maxQuantity = freezed,
    Object? isActive = null,
    Object? sortOrder = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$PickupRateModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      iconUrl: freezed == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      pointsPerKg: null == pointsPerKg
          ? _value.pointsPerKg
          : pointsPerKg // ignore: cast_nullable_to_non_nullable
              as double,
      avgWeightPerUnit: null == avgWeightPerUnit
          ? _value.avgWeightPerUnit
          : avgWeightPerUnit // ignore: cast_nullable_to_non_nullable
              as double,
      minQuantity: freezed == minQuantity
          ? _value.minQuantity
          : minQuantity // ignore: cast_nullable_to_non_nullable
              as int?,
      maxQuantity: freezed == maxQuantity
          ? _value.maxQuantity
          : maxQuantity // ignore: cast_nullable_to_non_nullable
              as int?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
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
class _$PickupRateModelImpl implements _PickupRateModel {
  const _$PickupRateModelImpl(
      {required this.id,
      required this.category,
      required this.displayName,
      this.description,
      this.iconUrl,
      required this.pointsPerKg,
      required this.avgWeightPerUnit,
      this.minQuantity,
      this.maxQuantity,
      this.isActive = true,
      this.sortOrder = 0,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.updatedAt});

  factory _$PickupRateModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PickupRateModelImplFromJson(json);

  @override
  final String id;
// Category Info
  @override
  final String category;
// 'Plastik', 'Kaca', 'Kaleng', 'Kardus', 'Kain', 'Keramik'
  @override
  final String displayName;
  @override
  final String? description;
  @override
  final String? iconUrl;
// Rate Calculation
  @override
  final double pointsPerKg;
// Points earned per kilogram
  @override
  final double avgWeightPerUnit;
// Average weight in kg (e.g., 1 plastic bottle = 0.05kg)
// Limits
  @override
  final int? minQuantity;
  @override
  final int? maxQuantity;
// Status
  @override
  @JsonKey()
  final bool isActive;
// Display Order
  @override
  @JsonKey()
  final int sortOrder;
// Timestamps
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? createdAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'PickupRateModel(id: $id, category: $category, displayName: $displayName, description: $description, iconUrl: $iconUrl, pointsPerKg: $pointsPerKg, avgWeightPerUnit: $avgWeightPerUnit, minQuantity: $minQuantity, maxQuantity: $maxQuantity, isActive: $isActive, sortOrder: $sortOrder, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PickupRateModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.pointsPerKg, pointsPerKg) ||
                other.pointsPerKg == pointsPerKg) &&
            (identical(other.avgWeightPerUnit, avgWeightPerUnit) ||
                other.avgWeightPerUnit == avgWeightPerUnit) &&
            (identical(other.minQuantity, minQuantity) ||
                other.minQuantity == minQuantity) &&
            (identical(other.maxQuantity, maxQuantity) ||
                other.maxQuantity == maxQuantity) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
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
      category,
      displayName,
      description,
      iconUrl,
      pointsPerKg,
      avgWeightPerUnit,
      minQuantity,
      maxQuantity,
      isActive,
      sortOrder,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PickupRateModelImplCopyWith<_$PickupRateModelImpl> get copyWith =>
      __$$PickupRateModelImplCopyWithImpl<_$PickupRateModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PickupRateModelImplToJson(
      this,
    );
  }
}

abstract class _PickupRateModel implements PickupRateModel {
  const factory _PickupRateModel(
      {required final String id,
      required final String category,
      required final String displayName,
      final String? description,
      final String? iconUrl,
      required final double pointsPerKg,
      required final double avgWeightPerUnit,
      final int? minQuantity,
      final int? maxQuantity,
      final bool isActive,
      final int sortOrder,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? updatedAt}) = _$PickupRateModelImpl;

  factory _PickupRateModel.fromJson(Map<String, dynamic> json) =
      _$PickupRateModelImpl.fromJson;

  @override
  String get id;
  @override // Category Info
  String get category;
  @override // 'Plastik', 'Kaca', 'Kaleng', 'Kardus', 'Kain', 'Keramik'
  String get displayName;
  @override
  String? get description;
  @override
  String? get iconUrl;
  @override // Rate Calculation
  double get pointsPerKg;
  @override // Points earned per kilogram
  double get avgWeightPerUnit;
  @override // Average weight in kg (e.g., 1 plastic bottle = 0.05kg)
// Limits
  int? get minQuantity;
  @override
  int? get maxQuantity;
  @override // Status
  bool get isActive;
  @override // Display Order
  int get sortOrder;
  @override // Timestamps
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get createdAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$PickupRateModelImplCopyWith<_$PickupRateModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
