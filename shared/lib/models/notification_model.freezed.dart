// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) {
  return _NotificationModel.fromJson(json);
}

/// @nodoc
mixin _$NotificationModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  NotificationType get type => throw _privateConstructorUsedError;
  NotificationPriority get priority => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get relatedId => throw _privateConstructorUsedError;
  String? get relatedCollection => throw _privateConstructorUsedError;
  Map<String, dynamic>? get data => throw _privateConstructorUsedError;
  Map<String, dynamic>? get actionData => throw _privateConstructorUsedError;
  String? get actionRoute => throw _privateConstructorUsedError;
  bool get isRead => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get readAt => throw _privateConstructorUsedError;
  bool get isSent => throw _privateConstructorUsedError;
  bool get isDelivered => throw _privateConstructorUsedError;
  bool get isFailed => throw _privateConstructorUsedError;
  String? get failureReason => throw _privateConstructorUsedError;
  String? get fcmMessageId => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get sentAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get deliveredAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get expiryDate => throw _privateConstructorUsedError;
  bool get isDeleted => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotificationModelCopyWith<NotificationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationModelCopyWith<$Res> {
  factory $NotificationModelCopyWith(
          NotificationModel value, $Res Function(NotificationModel) then) =
      _$NotificationModelCopyWithImpl<$Res, NotificationModel>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String title,
      String body,
      NotificationType type,
      NotificationPriority priority,
      String? imageUrl,
      String? relatedId,
      String? relatedCollection,
      Map<String, dynamic>? data,
      Map<String, dynamic>? actionData,
      String? actionRoute,
      bool isRead,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? readAt,
      bool isSent,
      bool isDelivered,
      bool isFailed,
      String? failureReason,
      String? fcmMessageId,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? sentAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? deliveredAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? expiryDate,
      bool isDeleted,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? deletedAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? createdAt});
}

/// @nodoc
class _$NotificationModelCopyWithImpl<$Res, $Val extends NotificationModel>
    implements $NotificationModelCopyWith<$Res> {
  _$NotificationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? body = null,
    Object? type = null,
    Object? priority = null,
    Object? imageUrl = freezed,
    Object? relatedId = freezed,
    Object? relatedCollection = freezed,
    Object? data = freezed,
    Object? actionData = freezed,
    Object? actionRoute = freezed,
    Object? isRead = null,
    Object? readAt = freezed,
    Object? isSent = null,
    Object? isDelivered = null,
    Object? isFailed = null,
    Object? failureReason = freezed,
    Object? fcmMessageId = freezed,
    Object? sentAt = freezed,
    Object? deliveredAt = freezed,
    Object? expiryDate = freezed,
    Object? isDeleted = null,
    Object? deletedAt = freezed,
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
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as NotificationType,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as NotificationPriority,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedId: freezed == relatedId
          ? _value.relatedId
          : relatedId // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedCollection: freezed == relatedCollection
          ? _value.relatedCollection
          : relatedCollection // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      actionData: freezed == actionData
          ? _value.actionData
          : actionData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      actionRoute: freezed == actionRoute
          ? _value.actionRoute
          : actionRoute // ignore: cast_nullable_to_non_nullable
              as String?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isSent: null == isSent
          ? _value.isSent
          : isSent // ignore: cast_nullable_to_non_nullable
              as bool,
      isDelivered: null == isDelivered
          ? _value.isDelivered
          : isDelivered // ignore: cast_nullable_to_non_nullable
              as bool,
      isFailed: null == isFailed
          ? _value.isFailed
          : isFailed // ignore: cast_nullable_to_non_nullable
              as bool,
      failureReason: freezed == failureReason
          ? _value.failureReason
          : failureReason // ignore: cast_nullable_to_non_nullable
              as String?,
      fcmMessageId: freezed == fcmMessageId
          ? _value.fcmMessageId
          : fcmMessageId // ignore: cast_nullable_to_non_nullable
              as String?,
      sentAt: freezed == sentAt
          ? _value.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deliveredAt: freezed == deliveredAt
          ? _value.deliveredAt
          : deliveredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationModelImplCopyWith<$Res>
    implements $NotificationModelCopyWith<$Res> {
  factory _$$NotificationModelImplCopyWith(_$NotificationModelImpl value,
          $Res Function(_$NotificationModelImpl) then) =
      __$$NotificationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String title,
      String body,
      NotificationType type,
      NotificationPriority priority,
      String? imageUrl,
      String? relatedId,
      String? relatedCollection,
      Map<String, dynamic>? data,
      Map<String, dynamic>? actionData,
      String? actionRoute,
      bool isRead,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? readAt,
      bool isSent,
      bool isDelivered,
      bool isFailed,
      String? failureReason,
      String? fcmMessageId,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? sentAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? deliveredAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? expiryDate,
      bool isDeleted,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? deletedAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? createdAt});
}

/// @nodoc
class __$$NotificationModelImplCopyWithImpl<$Res>
    extends _$NotificationModelCopyWithImpl<$Res, _$NotificationModelImpl>
    implements _$$NotificationModelImplCopyWith<$Res> {
  __$$NotificationModelImplCopyWithImpl(_$NotificationModelImpl _value,
      $Res Function(_$NotificationModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? body = null,
    Object? type = null,
    Object? priority = null,
    Object? imageUrl = freezed,
    Object? relatedId = freezed,
    Object? relatedCollection = freezed,
    Object? data = freezed,
    Object? actionData = freezed,
    Object? actionRoute = freezed,
    Object? isRead = null,
    Object? readAt = freezed,
    Object? isSent = null,
    Object? isDelivered = null,
    Object? isFailed = null,
    Object? failureReason = freezed,
    Object? fcmMessageId = freezed,
    Object? sentAt = freezed,
    Object? deliveredAt = freezed,
    Object? expiryDate = freezed,
    Object? isDeleted = null,
    Object? deletedAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$NotificationModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as NotificationType,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as NotificationPriority,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedId: freezed == relatedId
          ? _value.relatedId
          : relatedId // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedCollection: freezed == relatedCollection
          ? _value.relatedCollection
          : relatedCollection // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      actionData: freezed == actionData
          ? _value._actionData
          : actionData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      actionRoute: freezed == actionRoute
          ? _value.actionRoute
          : actionRoute // ignore: cast_nullable_to_non_nullable
              as String?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isSent: null == isSent
          ? _value.isSent
          : isSent // ignore: cast_nullable_to_non_nullable
              as bool,
      isDelivered: null == isDelivered
          ? _value.isDelivered
          : isDelivered // ignore: cast_nullable_to_non_nullable
              as bool,
      isFailed: null == isFailed
          ? _value.isFailed
          : isFailed // ignore: cast_nullable_to_non_nullable
              as bool,
      failureReason: freezed == failureReason
          ? _value.failureReason
          : failureReason // ignore: cast_nullable_to_non_nullable
              as String?,
      fcmMessageId: freezed == fcmMessageId
          ? _value.fcmMessageId
          : fcmMessageId // ignore: cast_nullable_to_non_nullable
              as String?,
      sentAt: freezed == sentAt
          ? _value.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deliveredAt: freezed == deliveredAt
          ? _value.deliveredAt
          : deliveredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationModelImpl extends _NotificationModel {
  const _$NotificationModelImpl(
      {required this.id,
      required this.userId,
      required this.title,
      required this.body,
      required this.type,
      this.priority = NotificationPriority.normal,
      this.imageUrl,
      this.relatedId,
      this.relatedCollection,
      final Map<String, dynamic>? data,
      final Map<String, dynamic>? actionData,
      this.actionRoute,
      this.isRead = false,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.readAt,
      this.isSent = false,
      this.isDelivered = false,
      this.isFailed = false,
      this.failureReason,
      this.fcmMessageId,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.sentAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.deliveredAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.expiryDate,
      this.isDeleted = false,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.deletedAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.createdAt})
      : _data = data,
        _actionData = actionData,
        super._();

  factory _$NotificationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String title;
  @override
  final String body;
  @override
  final NotificationType type;
  @override
  @JsonKey()
  final NotificationPriority priority;
  @override
  final String? imageUrl;
  @override
  final String? relatedId;
  @override
  final String? relatedCollection;
  final Map<String, dynamic>? _data;
  @override
  Map<String, dynamic>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _actionData;
  @override
  Map<String, dynamic>? get actionData {
    final value = _actionData;
    if (value == null) return null;
    if (_actionData is EqualUnmodifiableMapView) return _actionData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? actionRoute;
  @override
  @JsonKey()
  final bool isRead;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? readAt;
  @override
  @JsonKey()
  final bool isSent;
  @override
  @JsonKey()
  final bool isDelivered;
  @override
  @JsonKey()
  final bool isFailed;
  @override
  final String? failureReason;
  @override
  final String? fcmMessageId;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? sentAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? deliveredAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? expiryDate;
  @override
  @JsonKey()
  final bool isDeleted;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? deletedAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? createdAt;

  @override
  String toString() {
    return 'NotificationModel(id: $id, userId: $userId, title: $title, body: $body, type: $type, priority: $priority, imageUrl: $imageUrl, relatedId: $relatedId, relatedCollection: $relatedCollection, data: $data, actionData: $actionData, actionRoute: $actionRoute, isRead: $isRead, readAt: $readAt, isSent: $isSent, isDelivered: $isDelivered, isFailed: $isFailed, failureReason: $failureReason, fcmMessageId: $fcmMessageId, sentAt: $sentAt, deliveredAt: $deliveredAt, expiryDate: $expiryDate, isDeleted: $isDeleted, deletedAt: $deletedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.relatedId, relatedId) ||
                other.relatedId == relatedId) &&
            (identical(other.relatedCollection, relatedCollection) ||
                other.relatedCollection == relatedCollection) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            const DeepCollectionEquality()
                .equals(other._actionData, _actionData) &&
            (identical(other.actionRoute, actionRoute) ||
                other.actionRoute == actionRoute) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.readAt, readAt) || other.readAt == readAt) &&
            (identical(other.isSent, isSent) || other.isSent == isSent) &&
            (identical(other.isDelivered, isDelivered) ||
                other.isDelivered == isDelivered) &&
            (identical(other.isFailed, isFailed) ||
                other.isFailed == isFailed) &&
            (identical(other.failureReason, failureReason) ||
                other.failureReason == failureReason) &&
            (identical(other.fcmMessageId, fcmMessageId) ||
                other.fcmMessageId == fcmMessageId) &&
            (identical(other.sentAt, sentAt) || other.sentAt == sentAt) &&
            (identical(other.deliveredAt, deliveredAt) ||
                other.deliveredAt == deliveredAt) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        title,
        body,
        type,
        priority,
        imageUrl,
        relatedId,
        relatedCollection,
        const DeepCollectionEquality().hash(_data),
        const DeepCollectionEquality().hash(_actionData),
        actionRoute,
        isRead,
        readAt,
        isSent,
        isDelivered,
        isFailed,
        failureReason,
        fcmMessageId,
        sentAt,
        deliveredAt,
        expiryDate,
        isDeleted,
        deletedAt,
        createdAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationModelImplCopyWith<_$NotificationModelImpl> get copyWith =>
      __$$NotificationModelImplCopyWithImpl<_$NotificationModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationModelImplToJson(
      this,
    );
  }
}

abstract class _NotificationModel extends NotificationModel {
  const factory _NotificationModel(
      {required final String id,
      required final String userId,
      required final String title,
      required final String body,
      required final NotificationType type,
      final NotificationPriority priority,
      final String? imageUrl,
      final String? relatedId,
      final String? relatedCollection,
      final Map<String, dynamic>? data,
      final Map<String, dynamic>? actionData,
      final String? actionRoute,
      final bool isRead,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? readAt,
      final bool isSent,
      final bool isDelivered,
      final bool isFailed,
      final String? failureReason,
      final String? fcmMessageId,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? sentAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? deliveredAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? expiryDate,
      final bool isDeleted,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? deletedAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? createdAt}) = _$NotificationModelImpl;
  const _NotificationModel._() : super._();

  factory _NotificationModel.fromJson(Map<String, dynamic> json) =
      _$NotificationModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get title;
  @override
  String get body;
  @override
  NotificationType get type;
  @override
  NotificationPriority get priority;
  @override
  String? get imageUrl;
  @override
  String? get relatedId;
  @override
  String? get relatedCollection;
  @override
  Map<String, dynamic>? get data;
  @override
  Map<String, dynamic>? get actionData;
  @override
  String? get actionRoute;
  @override
  bool get isRead;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get readAt;
  @override
  bool get isSent;
  @override
  bool get isDelivered;
  @override
  bool get isFailed;
  @override
  String? get failureReason;
  @override
  String? get fcmMessageId;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get sentAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get deliveredAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get expiryDate;
  @override
  bool get isDeleted;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get deletedAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$NotificationModelImplCopyWith<_$NotificationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
