// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_thread_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChatThreadModel _$ChatThreadModelFromJson(Map<String, dynamic> json) {
  return _ChatThreadModel.fromJson(json);
}

/// @nodoc
mixin _$ChatThreadModel {
  String get id => throw _privateConstructorUsedError;
  List<String> get participantIds => throw _privateConstructorUsedError;
  Map<String, dynamic> get participantDetails =>
      throw _privateConstructorUsedError;
  ThreadType get type => throw _privateConstructorUsedError;
  ThreadStatus get status => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get lastMessage => throw _privateConstructorUsedError;
  String? get lastMessageSenderId => throw _privateConstructorUsedError;
  String? get lastMessageSenderName => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get lastMessageAt => throw _privateConstructorUsedError;
  Map<String, int> get unreadCount => throw _privateConstructorUsedError;
  String? get relatedId => throw _privateConstructorUsedError;
  String? get relatedCollection => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  bool get isPinned => throw _privateConstructorUsedError;
  bool get isMuted => throw _privateConstructorUsedError;
  List<String>? get mutedBy => throw _privateConstructorUsedError;
  String? get closedBy => throw _privateConstructorUsedError;
  String? get closedReason => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get closedAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChatThreadModelCopyWith<ChatThreadModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatThreadModelCopyWith<$Res> {
  factory $ChatThreadModelCopyWith(
          ChatThreadModel value, $Res Function(ChatThreadModel) then) =
      _$ChatThreadModelCopyWithImpl<$Res, ChatThreadModel>;
  @useResult
  $Res call(
      {String id,
      List<String> participantIds,
      Map<String, dynamic> participantDetails,
      ThreadType type,
      ThreadStatus status,
      String? title,
      String? description,
      String? lastMessage,
      String? lastMessageSenderId,
      String? lastMessageSenderName,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? lastMessageAt,
      Map<String, int> unreadCount,
      String? relatedId,
      String? relatedCollection,
      Map<String, dynamic>? metadata,
      bool isPinned,
      bool isMuted,
      List<String>? mutedBy,
      String? closedBy,
      String? closedReason,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? closedAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? updatedAt,
      String? createdBy});
}

/// @nodoc
class _$ChatThreadModelCopyWithImpl<$Res, $Val extends ChatThreadModel>
    implements $ChatThreadModelCopyWith<$Res> {
  _$ChatThreadModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? participantIds = null,
    Object? participantDetails = null,
    Object? type = null,
    Object? status = null,
    Object? title = freezed,
    Object? description = freezed,
    Object? lastMessage = freezed,
    Object? lastMessageSenderId = freezed,
    Object? lastMessageSenderName = freezed,
    Object? lastMessageAt = freezed,
    Object? unreadCount = null,
    Object? relatedId = freezed,
    Object? relatedCollection = freezed,
    Object? metadata = freezed,
    Object? isPinned = null,
    Object? isMuted = null,
    Object? mutedBy = freezed,
    Object? closedBy = freezed,
    Object? closedReason = freezed,
    Object? closedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      participantIds: null == participantIds
          ? _value.participantIds
          : participantIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      participantDetails: null == participantDetails
          ? _value.participantDetails
          : participantDetails // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ThreadType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ThreadStatus,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessage: freezed == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageSenderId: freezed == lastMessageSenderId
          ? _value.lastMessageSenderId
          : lastMessageSenderId // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageSenderName: freezed == lastMessageSenderName
          ? _value.lastMessageSenderName
          : lastMessageSenderName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageAt: freezed == lastMessageAt
          ? _value.lastMessageAt
          : lastMessageAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      relatedId: freezed == relatedId
          ? _value.relatedId
          : relatedId // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedCollection: freezed == relatedCollection
          ? _value.relatedCollection
          : relatedCollection // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isPinned: null == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool,
      isMuted: null == isMuted
          ? _value.isMuted
          : isMuted // ignore: cast_nullable_to_non_nullable
              as bool,
      mutedBy: freezed == mutedBy
          ? _value.mutedBy
          : mutedBy // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      closedBy: freezed == closedBy
          ? _value.closedBy
          : closedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      closedReason: freezed == closedReason
          ? _value.closedReason
          : closedReason // ignore: cast_nullable_to_non_nullable
              as String?,
      closedAt: freezed == closedAt
          ? _value.closedAt
          : closedAt // ignore: cast_nullable_to_non_nullable
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatThreadModelImplCopyWith<$Res>
    implements $ChatThreadModelCopyWith<$Res> {
  factory _$$ChatThreadModelImplCopyWith(_$ChatThreadModelImpl value,
          $Res Function(_$ChatThreadModelImpl) then) =
      __$$ChatThreadModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      List<String> participantIds,
      Map<String, dynamic> participantDetails,
      ThreadType type,
      ThreadStatus status,
      String? title,
      String? description,
      String? lastMessage,
      String? lastMessageSenderId,
      String? lastMessageSenderName,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? lastMessageAt,
      Map<String, int> unreadCount,
      String? relatedId,
      String? relatedCollection,
      Map<String, dynamic>? metadata,
      bool isPinned,
      bool isMuted,
      List<String>? mutedBy,
      String? closedBy,
      String? closedReason,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? closedAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? updatedAt,
      String? createdBy});
}

/// @nodoc
class __$$ChatThreadModelImplCopyWithImpl<$Res>
    extends _$ChatThreadModelCopyWithImpl<$Res, _$ChatThreadModelImpl>
    implements _$$ChatThreadModelImplCopyWith<$Res> {
  __$$ChatThreadModelImplCopyWithImpl(
      _$ChatThreadModelImpl _value, $Res Function(_$ChatThreadModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? participantIds = null,
    Object? participantDetails = null,
    Object? type = null,
    Object? status = null,
    Object? title = freezed,
    Object? description = freezed,
    Object? lastMessage = freezed,
    Object? lastMessageSenderId = freezed,
    Object? lastMessageSenderName = freezed,
    Object? lastMessageAt = freezed,
    Object? unreadCount = null,
    Object? relatedId = freezed,
    Object? relatedCollection = freezed,
    Object? metadata = freezed,
    Object? isPinned = null,
    Object? isMuted = null,
    Object? mutedBy = freezed,
    Object? closedBy = freezed,
    Object? closedReason = freezed,
    Object? closedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
  }) {
    return _then(_$ChatThreadModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      participantIds: null == participantIds
          ? _value._participantIds
          : participantIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      participantDetails: null == participantDetails
          ? _value._participantDetails
          : participantDetails // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ThreadType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ThreadStatus,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessage: freezed == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageSenderId: freezed == lastMessageSenderId
          ? _value.lastMessageSenderId
          : lastMessageSenderId // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageSenderName: freezed == lastMessageSenderName
          ? _value.lastMessageSenderName
          : lastMessageSenderName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageAt: freezed == lastMessageAt
          ? _value.lastMessageAt
          : lastMessageAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      unreadCount: null == unreadCount
          ? _value._unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      relatedId: freezed == relatedId
          ? _value.relatedId
          : relatedId // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedCollection: freezed == relatedCollection
          ? _value.relatedCollection
          : relatedCollection // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isPinned: null == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool,
      isMuted: null == isMuted
          ? _value.isMuted
          : isMuted // ignore: cast_nullable_to_non_nullable
              as bool,
      mutedBy: freezed == mutedBy
          ? _value._mutedBy
          : mutedBy // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      closedBy: freezed == closedBy
          ? _value.closedBy
          : closedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      closedReason: freezed == closedReason
          ? _value.closedReason
          : closedReason // ignore: cast_nullable_to_non_nullable
              as String?,
      closedAt: freezed == closedAt
          ? _value.closedAt
          : closedAt // ignore: cast_nullable_to_non_nullable
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatThreadModelImpl extends _ChatThreadModel {
  const _$ChatThreadModelImpl(
      {required this.id,
      required final List<String> participantIds,
      required final Map<String, dynamic> participantDetails,
      required this.type,
      this.status = ThreadStatus.active,
      this.title,
      this.description,
      this.lastMessage,
      this.lastMessageSenderId,
      this.lastMessageSenderName,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.lastMessageAt,
      required final Map<String, int> unreadCount,
      this.relatedId,
      this.relatedCollection,
      final Map<String, dynamic>? metadata,
      this.isPinned = false,
      this.isMuted = false,
      final List<String>? mutedBy,
      this.closedBy,
      this.closedReason,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.closedAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.updatedAt,
      this.createdBy})
      : _participantIds = participantIds,
        _participantDetails = participantDetails,
        _unreadCount = unreadCount,
        _metadata = metadata,
        _mutedBy = mutedBy,
        super._();

  factory _$ChatThreadModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatThreadModelImplFromJson(json);

  @override
  final String id;
  final List<String> _participantIds;
  @override
  List<String> get participantIds {
    if (_participantIds is EqualUnmodifiableListView) return _participantIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participantIds);
  }

  final Map<String, dynamic> _participantDetails;
  @override
  Map<String, dynamic> get participantDetails {
    if (_participantDetails is EqualUnmodifiableMapView)
      return _participantDetails;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_participantDetails);
  }

  @override
  final ThreadType type;
  @override
  @JsonKey()
  final ThreadStatus status;
  @override
  final String? title;
  @override
  final String? description;
  @override
  final String? lastMessage;
  @override
  final String? lastMessageSenderId;
  @override
  final String? lastMessageSenderName;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? lastMessageAt;
  final Map<String, int> _unreadCount;
  @override
  Map<String, int> get unreadCount {
    if (_unreadCount is EqualUnmodifiableMapView) return _unreadCount;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_unreadCount);
  }

  @override
  final String? relatedId;
  @override
  final String? relatedCollection;
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
  final bool isPinned;
  @override
  @JsonKey()
  final bool isMuted;
  final List<String>? _mutedBy;
  @override
  List<String>? get mutedBy {
    final value = _mutedBy;
    if (value == null) return null;
    if (_mutedBy is EqualUnmodifiableListView) return _mutedBy;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? closedBy;
  @override
  final String? closedReason;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? closedAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? createdAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? updatedAt;
  @override
  final String? createdBy;

  @override
  String toString() {
    return 'ChatThreadModel(id: $id, participantIds: $participantIds, participantDetails: $participantDetails, type: $type, status: $status, title: $title, description: $description, lastMessage: $lastMessage, lastMessageSenderId: $lastMessageSenderId, lastMessageSenderName: $lastMessageSenderName, lastMessageAt: $lastMessageAt, unreadCount: $unreadCount, relatedId: $relatedId, relatedCollection: $relatedCollection, metadata: $metadata, isPinned: $isPinned, isMuted: $isMuted, mutedBy: $mutedBy, closedBy: $closedBy, closedReason: $closedReason, closedAt: $closedAt, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatThreadModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality()
                .equals(other._participantIds, _participantIds) &&
            const DeepCollectionEquality()
                .equals(other._participantDetails, _participantDetails) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.lastMessageSenderId, lastMessageSenderId) ||
                other.lastMessageSenderId == lastMessageSenderId) &&
            (identical(other.lastMessageSenderName, lastMessageSenderName) ||
                other.lastMessageSenderName == lastMessageSenderName) &&
            (identical(other.lastMessageAt, lastMessageAt) ||
                other.lastMessageAt == lastMessageAt) &&
            const DeepCollectionEquality()
                .equals(other._unreadCount, _unreadCount) &&
            (identical(other.relatedId, relatedId) ||
                other.relatedId == relatedId) &&
            (identical(other.relatedCollection, relatedCollection) ||
                other.relatedCollection == relatedCollection) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.isPinned, isPinned) ||
                other.isPinned == isPinned) &&
            (identical(other.isMuted, isMuted) || other.isMuted == isMuted) &&
            const DeepCollectionEquality().equals(other._mutedBy, _mutedBy) &&
            (identical(other.closedBy, closedBy) ||
                other.closedBy == closedBy) &&
            (identical(other.closedReason, closedReason) ||
                other.closedReason == closedReason) &&
            (identical(other.closedAt, closedAt) ||
                other.closedAt == closedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        const DeepCollectionEquality().hash(_participantIds),
        const DeepCollectionEquality().hash(_participantDetails),
        type,
        status,
        title,
        description,
        lastMessage,
        lastMessageSenderId,
        lastMessageSenderName,
        lastMessageAt,
        const DeepCollectionEquality().hash(_unreadCount),
        relatedId,
        relatedCollection,
        const DeepCollectionEquality().hash(_metadata),
        isPinned,
        isMuted,
        const DeepCollectionEquality().hash(_mutedBy),
        closedBy,
        closedReason,
        closedAt,
        createdAt,
        updatedAt,
        createdBy
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatThreadModelImplCopyWith<_$ChatThreadModelImpl> get copyWith =>
      __$$ChatThreadModelImplCopyWithImpl<_$ChatThreadModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatThreadModelImplToJson(
      this,
    );
  }
}

abstract class _ChatThreadModel extends ChatThreadModel {
  const factory _ChatThreadModel(
      {required final String id,
      required final List<String> participantIds,
      required final Map<String, dynamic> participantDetails,
      required final ThreadType type,
      final ThreadStatus status,
      final String? title,
      final String? description,
      final String? lastMessage,
      final String? lastMessageSenderId,
      final String? lastMessageSenderName,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? lastMessageAt,
      required final Map<String, int> unreadCount,
      final String? relatedId,
      final String? relatedCollection,
      final Map<String, dynamic>? metadata,
      final bool isPinned,
      final bool isMuted,
      final List<String>? mutedBy,
      final String? closedBy,
      final String? closedReason,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? closedAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? updatedAt,
      final String? createdBy}) = _$ChatThreadModelImpl;
  const _ChatThreadModel._() : super._();

  factory _ChatThreadModel.fromJson(Map<String, dynamic> json) =
      _$ChatThreadModelImpl.fromJson;

  @override
  String get id;
  @override
  List<String> get participantIds;
  @override
  Map<String, dynamic> get participantDetails;
  @override
  ThreadType get type;
  @override
  ThreadStatus get status;
  @override
  String? get title;
  @override
  String? get description;
  @override
  String? get lastMessage;
  @override
  String? get lastMessageSenderId;
  @override
  String? get lastMessageSenderName;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get lastMessageAt;
  @override
  Map<String, int> get unreadCount;
  @override
  String? get relatedId;
  @override
  String? get relatedCollection;
  @override
  Map<String, dynamic>? get metadata;
  @override
  bool get isPinned;
  @override
  bool get isMuted;
  @override
  List<String>? get mutedBy;
  @override
  String? get closedBy;
  @override
  String? get closedReason;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get closedAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get createdAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get updatedAt;
  @override
  String? get createdBy;
  @override
  @JsonKey(ignore: true)
  _$$ChatThreadModelImplCopyWith<_$ChatThreadModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
