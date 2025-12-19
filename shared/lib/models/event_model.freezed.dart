// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventModel _$EventModelFromJson(Map<String, dynamic> json) {
  return _EventModel.fromJson(json);
}

/// @nodoc
mixin _$EventModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get organizer => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
  DateTime get startDate => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
  DateTime get endDate => throw _privateConstructorUsedError;
  EventStatus get status => throw _privateConstructorUsedError;
  int get participantCount => throw _privateConstructorUsedError;
  int get maxParticipants => throw _privateConstructorUsedError;
  int get itemsCount => throw _privateConstructorUsedError;
  int get totalPointsRequired => throw _privateConstructorUsedError;
  List<String>? get categories => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  Map<String, dynamic>? get contactInfo => throw _privateConstructorUsedError;
  String? get termsAndConditions => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isFeatured => throw _privateConstructorUsedError;
  int get viewCount => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  String? get updatedBy => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventModelCopyWith<EventModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventModelCopyWith<$Res> {
  factory $EventModelCopyWith(
          EventModel value, $Res Function(EventModel) then) =
      _$EventModelCopyWithImpl<$Res, EventModel>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String? imageUrl,
      String? location,
      String? organizer,
      @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
      DateTime startDate,
      @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
      DateTime endDate,
      EventStatus status,
      int participantCount,
      int maxParticipants,
      int itemsCount,
      int totalPointsRequired,
      List<String>? categories,
      List<String>? tags,
      Map<String, dynamic>? contactInfo,
      String? termsAndConditions,
      bool isActive,
      bool isFeatured,
      int viewCount,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? updatedAt,
      String? createdBy,
      String? updatedBy});
}

/// @nodoc
class _$EventModelCopyWithImpl<$Res, $Val extends EventModel>
    implements $EventModelCopyWith<$Res> {
  _$EventModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? imageUrl = freezed,
    Object? location = freezed,
    Object? organizer = freezed,
    Object? startDate = null,
    Object? endDate = null,
    Object? status = null,
    Object? participantCount = null,
    Object? maxParticipants = null,
    Object? itemsCount = null,
    Object? totalPointsRequired = null,
    Object? categories = freezed,
    Object? tags = freezed,
    Object? contactInfo = freezed,
    Object? termsAndConditions = freezed,
    Object? isActive = null,
    Object? isFeatured = null,
    Object? viewCount = null,
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
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      organizer: freezed == organizer
          ? _value.organizer
          : organizer // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as EventStatus,
      participantCount: null == participantCount
          ? _value.participantCount
          : participantCount // ignore: cast_nullable_to_non_nullable
              as int,
      maxParticipants: null == maxParticipants
          ? _value.maxParticipants
          : maxParticipants // ignore: cast_nullable_to_non_nullable
              as int,
      itemsCount: null == itemsCount
          ? _value.itemsCount
          : itemsCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalPointsRequired: null == totalPointsRequired
          ? _value.totalPointsRequired
          : totalPointsRequired // ignore: cast_nullable_to_non_nullable
              as int,
      categories: freezed == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      contactInfo: freezed == contactInfo
          ? _value.contactInfo
          : contactInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      termsAndConditions: freezed == termsAndConditions
          ? _value.termsAndConditions
          : termsAndConditions // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
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
abstract class _$$EventModelImplCopyWith<$Res>
    implements $EventModelCopyWith<$Res> {
  factory _$$EventModelImplCopyWith(
          _$EventModelImpl value, $Res Function(_$EventModelImpl) then) =
      __$$EventModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String? imageUrl,
      String? location,
      String? organizer,
      @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
      DateTime startDate,
      @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
      DateTime endDate,
      EventStatus status,
      int participantCount,
      int maxParticipants,
      int itemsCount,
      int totalPointsRequired,
      List<String>? categories,
      List<String>? tags,
      Map<String, dynamic>? contactInfo,
      String? termsAndConditions,
      bool isActive,
      bool isFeatured,
      int viewCount,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? updatedAt,
      String? createdBy,
      String? updatedBy});
}

/// @nodoc
class __$$EventModelImplCopyWithImpl<$Res>
    extends _$EventModelCopyWithImpl<$Res, _$EventModelImpl>
    implements _$$EventModelImplCopyWith<$Res> {
  __$$EventModelImplCopyWithImpl(
      _$EventModelImpl _value, $Res Function(_$EventModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? imageUrl = freezed,
    Object? location = freezed,
    Object? organizer = freezed,
    Object? startDate = null,
    Object? endDate = null,
    Object? status = null,
    Object? participantCount = null,
    Object? maxParticipants = null,
    Object? itemsCount = null,
    Object? totalPointsRequired = null,
    Object? categories = freezed,
    Object? tags = freezed,
    Object? contactInfo = freezed,
    Object? termsAndConditions = freezed,
    Object? isActive = null,
    Object? isFeatured = null,
    Object? viewCount = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
    Object? updatedBy = freezed,
  }) {
    return _then(_$EventModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      organizer: freezed == organizer
          ? _value.organizer
          : organizer // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as EventStatus,
      participantCount: null == participantCount
          ? _value.participantCount
          : participantCount // ignore: cast_nullable_to_non_nullable
              as int,
      maxParticipants: null == maxParticipants
          ? _value.maxParticipants
          : maxParticipants // ignore: cast_nullable_to_non_nullable
              as int,
      itemsCount: null == itemsCount
          ? _value.itemsCount
          : itemsCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalPointsRequired: null == totalPointsRequired
          ? _value.totalPointsRequired
          : totalPointsRequired // ignore: cast_nullable_to_non_nullable
              as int,
      categories: freezed == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      contactInfo: freezed == contactInfo
          ? _value._contactInfo
          : contactInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      termsAndConditions: freezed == termsAndConditions
          ? _value.termsAndConditions
          : termsAndConditions // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
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
class _$EventModelImpl extends _EventModel {
  const _$EventModelImpl(
      {required this.id,
      required this.title,
      required this.description,
      this.imageUrl,
      this.location,
      this.organizer,
      @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
      required this.startDate,
      @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
      required this.endDate,
      this.status = EventStatus.draft,
      this.participantCount = 0,
      this.maxParticipants = 0,
      this.itemsCount = 0,
      this.totalPointsRequired = 0,
      final List<String>? categories,
      final List<String>? tags,
      final Map<String, dynamic>? contactInfo,
      this.termsAndConditions,
      this.isActive = true,
      this.isFeatured = false,
      this.viewCount = 0,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.updatedAt,
      this.createdBy,
      this.updatedBy})
      : _categories = categories,
        _tags = tags,
        _contactInfo = contactInfo,
        super._();

  factory _$EventModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String? imageUrl;
  @override
  final String? location;
  @override
  final String? organizer;
  @override
  @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
  final DateTime startDate;
  @override
  @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
  final DateTime endDate;
  @override
  @JsonKey()
  final EventStatus status;
  @override
  @JsonKey()
  final int participantCount;
  @override
  @JsonKey()
  final int maxParticipants;
  @override
  @JsonKey()
  final int itemsCount;
  @override
  @JsonKey()
  final int totalPointsRequired;
  final List<String>? _categories;
  @override
  List<String>? get categories {
    final value = _categories;
    if (value == null) return null;
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, dynamic>? _contactInfo;
  @override
  Map<String, dynamic>? get contactInfo {
    final value = _contactInfo;
    if (value == null) return null;
    if (_contactInfo is EqualUnmodifiableMapView) return _contactInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? termsAndConditions;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool isFeatured;
  @override
  @JsonKey()
  final int viewCount;
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
    return 'EventModel(id: $id, title: $title, description: $description, imageUrl: $imageUrl, location: $location, organizer: $organizer, startDate: $startDate, endDate: $endDate, status: $status, participantCount: $participantCount, maxParticipants: $maxParticipants, itemsCount: $itemsCount, totalPointsRequired: $totalPointsRequired, categories: $categories, tags: $tags, contactInfo: $contactInfo, termsAndConditions: $termsAndConditions, isActive: $isActive, isFeatured: $isFeatured, viewCount: $viewCount, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, updatedBy: $updatedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.organizer, organizer) ||
                other.organizer == organizer) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.participantCount, participantCount) ||
                other.participantCount == participantCount) &&
            (identical(other.maxParticipants, maxParticipants) ||
                other.maxParticipants == maxParticipants) &&
            (identical(other.itemsCount, itemsCount) ||
                other.itemsCount == itemsCount) &&
            (identical(other.totalPointsRequired, totalPointsRequired) ||
                other.totalPointsRequired == totalPointsRequired) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality()
                .equals(other._contactInfo, _contactInfo) &&
            (identical(other.termsAndConditions, termsAndConditions) ||
                other.termsAndConditions == termsAndConditions) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.viewCount, viewCount) ||
                other.viewCount == viewCount) &&
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
        title,
        description,
        imageUrl,
        location,
        organizer,
        startDate,
        endDate,
        status,
        participantCount,
        maxParticipants,
        itemsCount,
        totalPointsRequired,
        const DeepCollectionEquality().hash(_categories),
        const DeepCollectionEquality().hash(_tags),
        const DeepCollectionEquality().hash(_contactInfo),
        termsAndConditions,
        isActive,
        isFeatured,
        viewCount,
        createdAt,
        updatedAt,
        createdBy,
        updatedBy
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventModelImplCopyWith<_$EventModelImpl> get copyWith =>
      __$$EventModelImplCopyWithImpl<_$EventModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventModelImplToJson(
      this,
    );
  }
}

abstract class _EventModel extends EventModel {
  const factory _EventModel(
      {required final String id,
      required final String title,
      required final String description,
      final String? imageUrl,
      final String? location,
      final String? organizer,
      @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
      required final DateTime startDate,
      @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
      required final DateTime endDate,
      final EventStatus status,
      final int participantCount,
      final int maxParticipants,
      final int itemsCount,
      final int totalPointsRequired,
      final List<String>? categories,
      final List<String>? tags,
      final Map<String, dynamic>? contactInfo,
      final String? termsAndConditions,
      final bool isActive,
      final bool isFeatured,
      final int viewCount,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? updatedAt,
      final String? createdBy,
      final String? updatedBy}) = _$EventModelImpl;
  const _EventModel._() : super._();

  factory _EventModel.fromJson(Map<String, dynamic> json) =
      _$EventModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String? get imageUrl;
  @override
  String? get location;
  @override
  String? get organizer;
  @override
  @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
  DateTime get startDate;
  @override
  @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
  DateTime get endDate;
  @override
  EventStatus get status;
  @override
  int get participantCount;
  @override
  int get maxParticipants;
  @override
  int get itemsCount;
  @override
  int get totalPointsRequired;
  @override
  List<String>? get categories;
  @override
  List<String>? get tags;
  @override
  Map<String, dynamic>? get contactInfo;
  @override
  String? get termsAndConditions;
  @override
  bool get isActive;
  @override
  bool get isFeatured;
  @override
  int get viewCount;
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
  _$$EventModelImplCopyWith<_$EventModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
