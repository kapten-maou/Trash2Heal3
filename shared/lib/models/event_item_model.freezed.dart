// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventItemModel _$EventItemModelFromJson(Map<String, dynamic> json) {
  return _EventItemModel.fromJson(json);
}

/// @nodoc
mixin _$EventItemModel {
  String get id => throw _privateConstructorUsedError;
  String get eventId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  EventItemType get type => throw _privateConstructorUsedError;
  int get pointsRequired => throw _privateConstructorUsedError;
  int get stock => throw _privateConstructorUsedError;
  int get claimed => throw _privateConstructorUsedError;
  int get reserved => throw _privateConstructorUsedError;
  EventItemStatus get status => throw _privateConstructorUsedError;
  String? get provider => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  int? get value => throw _privateConstructorUsedError;
  String? get unit => throw _privateConstructorUsedError;
  List<String>? get imageUrls => throw _privateConstructorUsedError;
  Map<String, dynamic>? get specifications =>
      throw _privateConstructorUsedError;
  String? get terms => throw _privateConstructorUsedError;
  String? get instructions => throw _privateConstructorUsedError;
  int get maxClaimPerUser => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isFeatured => throw _privateConstructorUsedError;
  int? get displayOrder => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get availableFrom => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get availableUntil => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  String? get updatedBy => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventItemModelCopyWith<EventItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventItemModelCopyWith<$Res> {
  factory $EventItemModelCopyWith(
          EventItemModel value, $Res Function(EventItemModel) then) =
      _$EventItemModelCopyWithImpl<$Res, EventItemModel>;
  @useResult
  $Res call(
      {String id,
      String eventId,
      String name,
      String description,
      String? imageUrl,
      EventItemType type,
      int pointsRequired,
      int stock,
      int claimed,
      int reserved,
      EventItemStatus status,
      String? provider,
      String? category,
      int? value,
      String? unit,
      List<String>? imageUrls,
      Map<String, dynamic>? specifications,
      String? terms,
      String? instructions,
      int maxClaimPerUser,
      bool isActive,
      bool isFeatured,
      int? displayOrder,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? availableFrom,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? availableUntil,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? updatedAt,
      String? createdBy,
      String? updatedBy});
}

/// @nodoc
class _$EventItemModelCopyWithImpl<$Res, $Val extends EventItemModel>
    implements $EventItemModelCopyWith<$Res> {
  _$EventItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? name = null,
    Object? description = null,
    Object? imageUrl = freezed,
    Object? type = null,
    Object? pointsRequired = null,
    Object? stock = null,
    Object? claimed = null,
    Object? reserved = null,
    Object? status = null,
    Object? provider = freezed,
    Object? category = freezed,
    Object? value = freezed,
    Object? unit = freezed,
    Object? imageUrls = freezed,
    Object? specifications = freezed,
    Object? terms = freezed,
    Object? instructions = freezed,
    Object? maxClaimPerUser = null,
    Object? isActive = null,
    Object? isFeatured = null,
    Object? displayOrder = freezed,
    Object? availableFrom = freezed,
    Object? availableUntil = freezed,
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
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as EventItemType,
      pointsRequired: null == pointsRequired
          ? _value.pointsRequired
          : pointsRequired // ignore: cast_nullable_to_non_nullable
              as int,
      stock: null == stock
          ? _value.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as int,
      claimed: null == claimed
          ? _value.claimed
          : claimed // ignore: cast_nullable_to_non_nullable
              as int,
      reserved: null == reserved
          ? _value.reserved
          : reserved // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as EventItemStatus,
      provider: freezed == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrls: freezed == imageUrls
          ? _value.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      specifications: freezed == specifications
          ? _value.specifications
          : specifications // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      terms: freezed == terms
          ? _value.terms
          : terms // ignore: cast_nullable_to_non_nullable
              as String?,
      instructions: freezed == instructions
          ? _value.instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as String?,
      maxClaimPerUser: null == maxClaimPerUser
          ? _value.maxClaimPerUser
          : maxClaimPerUser // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      displayOrder: freezed == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int?,
      availableFrom: freezed == availableFrom
          ? _value.availableFrom
          : availableFrom // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      availableUntil: freezed == availableUntil
          ? _value.availableUntil
          : availableUntil // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
abstract class _$$EventItemModelImplCopyWith<$Res>
    implements $EventItemModelCopyWith<$Res> {
  factory _$$EventItemModelImplCopyWith(_$EventItemModelImpl value,
          $Res Function(_$EventItemModelImpl) then) =
      __$$EventItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String eventId,
      String name,
      String description,
      String? imageUrl,
      EventItemType type,
      int pointsRequired,
      int stock,
      int claimed,
      int reserved,
      EventItemStatus status,
      String? provider,
      String? category,
      int? value,
      String? unit,
      List<String>? imageUrls,
      Map<String, dynamic>? specifications,
      String? terms,
      String? instructions,
      int maxClaimPerUser,
      bool isActive,
      bool isFeatured,
      int? displayOrder,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? availableFrom,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? availableUntil,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? updatedAt,
      String? createdBy,
      String? updatedBy});
}

/// @nodoc
class __$$EventItemModelImplCopyWithImpl<$Res>
    extends _$EventItemModelCopyWithImpl<$Res, _$EventItemModelImpl>
    implements _$$EventItemModelImplCopyWith<$Res> {
  __$$EventItemModelImplCopyWithImpl(
      _$EventItemModelImpl _value, $Res Function(_$EventItemModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? name = null,
    Object? description = null,
    Object? imageUrl = freezed,
    Object? type = null,
    Object? pointsRequired = null,
    Object? stock = null,
    Object? claimed = null,
    Object? reserved = null,
    Object? status = null,
    Object? provider = freezed,
    Object? category = freezed,
    Object? value = freezed,
    Object? unit = freezed,
    Object? imageUrls = freezed,
    Object? specifications = freezed,
    Object? terms = freezed,
    Object? instructions = freezed,
    Object? maxClaimPerUser = null,
    Object? isActive = null,
    Object? isFeatured = null,
    Object? displayOrder = freezed,
    Object? availableFrom = freezed,
    Object? availableUntil = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
    Object? updatedBy = freezed,
  }) {
    return _then(_$EventItemModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as EventItemType,
      pointsRequired: null == pointsRequired
          ? _value.pointsRequired
          : pointsRequired // ignore: cast_nullable_to_non_nullable
              as int,
      stock: null == stock
          ? _value.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as int,
      claimed: null == claimed
          ? _value.claimed
          : claimed // ignore: cast_nullable_to_non_nullable
              as int,
      reserved: null == reserved
          ? _value.reserved
          : reserved // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as EventItemStatus,
      provider: freezed == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrls: freezed == imageUrls
          ? _value._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      specifications: freezed == specifications
          ? _value._specifications
          : specifications // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      terms: freezed == terms
          ? _value.terms
          : terms // ignore: cast_nullable_to_non_nullable
              as String?,
      instructions: freezed == instructions
          ? _value.instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as String?,
      maxClaimPerUser: null == maxClaimPerUser
          ? _value.maxClaimPerUser
          : maxClaimPerUser // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      displayOrder: freezed == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int?,
      availableFrom: freezed == availableFrom
          ? _value.availableFrom
          : availableFrom // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      availableUntil: freezed == availableUntil
          ? _value.availableUntil
          : availableUntil // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
class _$EventItemModelImpl extends _EventItemModel {
  const _$EventItemModelImpl(
      {required this.id,
      required this.eventId,
      required this.name,
      required this.description,
      this.imageUrl,
      required this.type,
      required this.pointsRequired,
      required this.stock,
      this.claimed = 0,
      this.reserved = 0,
      required this.status,
      this.provider,
      this.category,
      this.value,
      this.unit,
      final List<String>? imageUrls,
      final Map<String, dynamic>? specifications,
      this.terms,
      this.instructions,
      this.maxClaimPerUser = 1,
      this.isActive = true,
      this.isFeatured = false,
      this.displayOrder,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.availableFrom,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.availableUntil,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.updatedAt,
      this.createdBy,
      this.updatedBy})
      : _imageUrls = imageUrls,
        _specifications = specifications,
        super._();

  factory _$EventItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventItemModelImplFromJson(json);

  @override
  final String id;
  @override
  final String eventId;
  @override
  final String name;
  @override
  final String description;
  @override
  final String? imageUrl;
  @override
  final EventItemType type;
  @override
  final int pointsRequired;
  @override
  final int stock;
  @override
  @JsonKey()
  final int claimed;
  @override
  @JsonKey()
  final int reserved;
  @override
  final EventItemStatus status;
  @override
  final String? provider;
  @override
  final String? category;
  @override
  final int? value;
  @override
  final String? unit;
  final List<String>? _imageUrls;
  @override
  List<String>? get imageUrls {
    final value = _imageUrls;
    if (value == null) return null;
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, dynamic>? _specifications;
  @override
  Map<String, dynamic>? get specifications {
    final value = _specifications;
    if (value == null) return null;
    if (_specifications is EqualUnmodifiableMapView) return _specifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? terms;
  @override
  final String? instructions;
  @override
  @JsonKey()
  final int maxClaimPerUser;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool isFeatured;
  @override
  final int? displayOrder;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? availableFrom;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? availableUntil;
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
    return 'EventItemModel(id: $id, eventId: $eventId, name: $name, description: $description, imageUrl: $imageUrl, type: $type, pointsRequired: $pointsRequired, stock: $stock, claimed: $claimed, reserved: $reserved, status: $status, provider: $provider, category: $category, value: $value, unit: $unit, imageUrls: $imageUrls, specifications: $specifications, terms: $terms, instructions: $instructions, maxClaimPerUser: $maxClaimPerUser, isActive: $isActive, isFeatured: $isFeatured, displayOrder: $displayOrder, availableFrom: $availableFrom, availableUntil: $availableUntil, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, updatedBy: $updatedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventItemModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.pointsRequired, pointsRequired) ||
                other.pointsRequired == pointsRequired) &&
            (identical(other.stock, stock) || other.stock == stock) &&
            (identical(other.claimed, claimed) || other.claimed == claimed) &&
            (identical(other.reserved, reserved) ||
                other.reserved == reserved) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            const DeepCollectionEquality()
                .equals(other._imageUrls, _imageUrls) &&
            const DeepCollectionEquality()
                .equals(other._specifications, _specifications) &&
            (identical(other.terms, terms) || other.terms == terms) &&
            (identical(other.instructions, instructions) ||
                other.instructions == instructions) &&
            (identical(other.maxClaimPerUser, maxClaimPerUser) ||
                other.maxClaimPerUser == maxClaimPerUser) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            (identical(other.availableFrom, availableFrom) ||
                other.availableFrom == availableFrom) &&
            (identical(other.availableUntil, availableUntil) ||
                other.availableUntil == availableUntil) &&
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
        eventId,
        name,
        description,
        imageUrl,
        type,
        pointsRequired,
        stock,
        claimed,
        reserved,
        status,
        provider,
        category,
        value,
        unit,
        const DeepCollectionEquality().hash(_imageUrls),
        const DeepCollectionEquality().hash(_specifications),
        terms,
        instructions,
        maxClaimPerUser,
        isActive,
        isFeatured,
        displayOrder,
        availableFrom,
        availableUntil,
        createdAt,
        updatedAt,
        createdBy,
        updatedBy
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventItemModelImplCopyWith<_$EventItemModelImpl> get copyWith =>
      __$$EventItemModelImplCopyWithImpl<_$EventItemModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventItemModelImplToJson(
      this,
    );
  }
}

abstract class _EventItemModel extends EventItemModel {
  const factory _EventItemModel(
      {required final String id,
      required final String eventId,
      required final String name,
      required final String description,
      final String? imageUrl,
      required final EventItemType type,
      required final int pointsRequired,
      required final int stock,
      final int claimed,
      final int reserved,
      required final EventItemStatus status,
      final String? provider,
      final String? category,
      final int? value,
      final String? unit,
      final List<String>? imageUrls,
      final Map<String, dynamic>? specifications,
      final String? terms,
      final String? instructions,
      final int maxClaimPerUser,
      final bool isActive,
      final bool isFeatured,
      final int? displayOrder,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? availableFrom,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? availableUntil,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? updatedAt,
      final String? createdBy,
      final String? updatedBy}) = _$EventItemModelImpl;
  const _EventItemModel._() : super._();

  factory _EventItemModel.fromJson(Map<String, dynamic> json) =
      _$EventItemModelImpl.fromJson;

  @override
  String get id;
  @override
  String get eventId;
  @override
  String get name;
  @override
  String get description;
  @override
  String? get imageUrl;
  @override
  EventItemType get type;
  @override
  int get pointsRequired;
  @override
  int get stock;
  @override
  int get claimed;
  @override
  int get reserved;
  @override
  EventItemStatus get status;
  @override
  String? get provider;
  @override
  String? get category;
  @override
  int? get value;
  @override
  String? get unit;
  @override
  List<String>? get imageUrls;
  @override
  Map<String, dynamic>? get specifications;
  @override
  String? get terms;
  @override
  String? get instructions;
  @override
  int get maxClaimPerUser;
  @override
  bool get isActive;
  @override
  bool get isFeatured;
  @override
  int? get displayOrder;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get availableFrom;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get availableUntil;
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
  _$$EventItemModelImplCopyWith<_$EventItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
