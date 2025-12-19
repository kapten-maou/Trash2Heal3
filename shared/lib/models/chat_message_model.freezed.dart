// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChatMessageModel _$ChatMessageModelFromJson(Map<String, dynamic> json) {
  return _ChatMessageModel.fromJson(json);
}

/// @nodoc
mixin _$ChatMessageModel {
  String get id => throw _privateConstructorUsedError;
  String get threadId => throw _privateConstructorUsedError;
  String get senderId => throw _privateConstructorUsedError;
  String get senderName => throw _privateConstructorUsedError;
  String? get senderPhotoUrl => throw _privateConstructorUsedError;
  MessageType get type => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get fileUrl => throw _privateConstructorUsedError;
  String? get fileName => throw _privateConstructorUsedError;
  int? get fileSize => throw _privateConstructorUsedError;
  MessageStatus get status => throw _privateConstructorUsedError;
  Map<String, dynamic>? get readBy => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get readAt => throw _privateConstructorUsedError;
  String? get replyToMessageId => throw _privateConstructorUsedError;
  String? get replyToMessage => throw _privateConstructorUsedError;
  String? get replyToSenderName => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  bool get isEdited => throw _privateConstructorUsedError;
  String? get editedMessage => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get editedAt => throw _privateConstructorUsedError;
  bool get isDeleted => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  String? get deletedBy => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChatMessageModelCopyWith<ChatMessageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageModelCopyWith<$Res> {
  factory $ChatMessageModelCopyWith(
          ChatMessageModel value, $Res Function(ChatMessageModel) then) =
      _$ChatMessageModelCopyWithImpl<$Res, ChatMessageModel>;
  @useResult
  $Res call(
      {String id,
      String threadId,
      String senderId,
      String senderName,
      String? senderPhotoUrl,
      MessageType type,
      String message,
      String? imageUrl,
      String? fileUrl,
      String? fileName,
      int? fileSize,
      MessageStatus status,
      Map<String, dynamic>? readBy,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? readAt,
      String? replyToMessageId,
      String? replyToMessage,
      String? replyToSenderName,
      Map<String, dynamic>? metadata,
      bool isEdited,
      String? editedMessage,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? editedAt,
      bool isDeleted,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? deletedAt,
      String? deletedBy,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? createdAt});
}

/// @nodoc
class _$ChatMessageModelCopyWithImpl<$Res, $Val extends ChatMessageModel>
    implements $ChatMessageModelCopyWith<$Res> {
  _$ChatMessageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? threadId = null,
    Object? senderId = null,
    Object? senderName = null,
    Object? senderPhotoUrl = freezed,
    Object? type = null,
    Object? message = null,
    Object? imageUrl = freezed,
    Object? fileUrl = freezed,
    Object? fileName = freezed,
    Object? fileSize = freezed,
    Object? status = null,
    Object? readBy = freezed,
    Object? readAt = freezed,
    Object? replyToMessageId = freezed,
    Object? replyToMessage = freezed,
    Object? replyToSenderName = freezed,
    Object? metadata = freezed,
    Object? isEdited = null,
    Object? editedMessage = freezed,
    Object? editedAt = freezed,
    Object? isDeleted = null,
    Object? deletedAt = freezed,
    Object? deletedBy = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      threadId: null == threadId
          ? _value.threadId
          : threadId // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      senderName: null == senderName
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String,
      senderPhotoUrl: freezed == senderPhotoUrl
          ? _value.senderPhotoUrl
          : senderPhotoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MessageType,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      fileUrl: freezed == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      fileName: freezed == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String?,
      fileSize: freezed == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MessageStatus,
      readBy: freezed == readBy
          ? _value.readBy
          : readBy // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      replyToMessageId: freezed == replyToMessageId
          ? _value.replyToMessageId
          : replyToMessageId // ignore: cast_nullable_to_non_nullable
              as String?,
      replyToMessage: freezed == replyToMessage
          ? _value.replyToMessage
          : replyToMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      replyToSenderName: freezed == replyToSenderName
          ? _value.replyToSenderName
          : replyToSenderName // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isEdited: null == isEdited
          ? _value.isEdited
          : isEdited // ignore: cast_nullable_to_non_nullable
              as bool,
      editedMessage: freezed == editedMessage
          ? _value.editedMessage
          : editedMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      editedAt: freezed == editedAt
          ? _value.editedAt
          : editedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedBy: freezed == deletedBy
          ? _value.deletedBy
          : deletedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatMessageModelImplCopyWith<$Res>
    implements $ChatMessageModelCopyWith<$Res> {
  factory _$$ChatMessageModelImplCopyWith(_$ChatMessageModelImpl value,
          $Res Function(_$ChatMessageModelImpl) then) =
      __$$ChatMessageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String threadId,
      String senderId,
      String senderName,
      String? senderPhotoUrl,
      MessageType type,
      String message,
      String? imageUrl,
      String? fileUrl,
      String? fileName,
      int? fileSize,
      MessageStatus status,
      Map<String, dynamic>? readBy,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? readAt,
      String? replyToMessageId,
      String? replyToMessage,
      String? replyToSenderName,
      Map<String, dynamic>? metadata,
      bool isEdited,
      String? editedMessage,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? editedAt,
      bool isDeleted,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? deletedAt,
      String? deletedBy,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? createdAt});
}

/// @nodoc
class __$$ChatMessageModelImplCopyWithImpl<$Res>
    extends _$ChatMessageModelCopyWithImpl<$Res, _$ChatMessageModelImpl>
    implements _$$ChatMessageModelImplCopyWith<$Res> {
  __$$ChatMessageModelImplCopyWithImpl(_$ChatMessageModelImpl _value,
      $Res Function(_$ChatMessageModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? threadId = null,
    Object? senderId = null,
    Object? senderName = null,
    Object? senderPhotoUrl = freezed,
    Object? type = null,
    Object? message = null,
    Object? imageUrl = freezed,
    Object? fileUrl = freezed,
    Object? fileName = freezed,
    Object? fileSize = freezed,
    Object? status = null,
    Object? readBy = freezed,
    Object? readAt = freezed,
    Object? replyToMessageId = freezed,
    Object? replyToMessage = freezed,
    Object? replyToSenderName = freezed,
    Object? metadata = freezed,
    Object? isEdited = null,
    Object? editedMessage = freezed,
    Object? editedAt = freezed,
    Object? isDeleted = null,
    Object? deletedAt = freezed,
    Object? deletedBy = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$ChatMessageModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      threadId: null == threadId
          ? _value.threadId
          : threadId // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      senderName: null == senderName
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String,
      senderPhotoUrl: freezed == senderPhotoUrl
          ? _value.senderPhotoUrl
          : senderPhotoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MessageType,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      fileUrl: freezed == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      fileName: freezed == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String?,
      fileSize: freezed == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MessageStatus,
      readBy: freezed == readBy
          ? _value._readBy
          : readBy // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      replyToMessageId: freezed == replyToMessageId
          ? _value.replyToMessageId
          : replyToMessageId // ignore: cast_nullable_to_non_nullable
              as String?,
      replyToMessage: freezed == replyToMessage
          ? _value.replyToMessage
          : replyToMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      replyToSenderName: freezed == replyToSenderName
          ? _value.replyToSenderName
          : replyToSenderName // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isEdited: null == isEdited
          ? _value.isEdited
          : isEdited // ignore: cast_nullable_to_non_nullable
              as bool,
      editedMessage: freezed == editedMessage
          ? _value.editedMessage
          : editedMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      editedAt: freezed == editedAt
          ? _value.editedAt
          : editedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedBy: freezed == deletedBy
          ? _value.deletedBy
          : deletedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatMessageModelImpl extends _ChatMessageModel {
  const _$ChatMessageModelImpl(
      {required this.id,
      required this.threadId,
      required this.senderId,
      required this.senderName,
      this.senderPhotoUrl,
      required this.type,
      required this.message,
      this.imageUrl,
      this.fileUrl,
      this.fileName,
      this.fileSize,
      required this.status,
      final Map<String, dynamic>? readBy,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.readAt,
      this.replyToMessageId,
      this.replyToMessage,
      this.replyToSenderName,
      final Map<String, dynamic>? metadata,
      this.isEdited = false,
      this.editedMessage,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.editedAt,
      this.isDeleted = false,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.deletedAt,
      this.deletedBy,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.createdAt})
      : _readBy = readBy,
        _metadata = metadata,
        super._();

  factory _$ChatMessageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatMessageModelImplFromJson(json);

  @override
  final String id;
  @override
  final String threadId;
  @override
  final String senderId;
  @override
  final String senderName;
  @override
  final String? senderPhotoUrl;
  @override
  final MessageType type;
  @override
  final String message;
  @override
  final String? imageUrl;
  @override
  final String? fileUrl;
  @override
  final String? fileName;
  @override
  final int? fileSize;
  @override
  final MessageStatus status;
  final Map<String, dynamic>? _readBy;
  @override
  Map<String, dynamic>? get readBy {
    final value = _readBy;
    if (value == null) return null;
    if (_readBy is EqualUnmodifiableMapView) return _readBy;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? readAt;
  @override
  final String? replyToMessageId;
  @override
  final String? replyToMessage;
  @override
  final String? replyToSenderName;
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
  final bool isEdited;
  @override
  final String? editedMessage;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? editedAt;
  @override
  @JsonKey()
  final bool isDeleted;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? deletedAt;
  @override
  final String? deletedBy;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? createdAt;

  @override
  String toString() {
    return 'ChatMessageModel(id: $id, threadId: $threadId, senderId: $senderId, senderName: $senderName, senderPhotoUrl: $senderPhotoUrl, type: $type, message: $message, imageUrl: $imageUrl, fileUrl: $fileUrl, fileName: $fileName, fileSize: $fileSize, status: $status, readBy: $readBy, readAt: $readAt, replyToMessageId: $replyToMessageId, replyToMessage: $replyToMessage, replyToSenderName: $replyToSenderName, metadata: $metadata, isEdited: $isEdited, editedMessage: $editedMessage, editedAt: $editedAt, isDeleted: $isDeleted, deletedAt: $deletedAt, deletedBy: $deletedBy, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.threadId, threadId) ||
                other.threadId == threadId) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.senderName, senderName) ||
                other.senderName == senderName) &&
            (identical(other.senderPhotoUrl, senderPhotoUrl) ||
                other.senderPhotoUrl == senderPhotoUrl) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._readBy, _readBy) &&
            (identical(other.readAt, readAt) || other.readAt == readAt) &&
            (identical(other.replyToMessageId, replyToMessageId) ||
                other.replyToMessageId == replyToMessageId) &&
            (identical(other.replyToMessage, replyToMessage) ||
                other.replyToMessage == replyToMessage) &&
            (identical(other.replyToSenderName, replyToSenderName) ||
                other.replyToSenderName == replyToSenderName) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.isEdited, isEdited) ||
                other.isEdited == isEdited) &&
            (identical(other.editedMessage, editedMessage) ||
                other.editedMessage == editedMessage) &&
            (identical(other.editedAt, editedAt) ||
                other.editedAt == editedAt) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.deletedBy, deletedBy) ||
                other.deletedBy == deletedBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        threadId,
        senderId,
        senderName,
        senderPhotoUrl,
        type,
        message,
        imageUrl,
        fileUrl,
        fileName,
        fileSize,
        status,
        const DeepCollectionEquality().hash(_readBy),
        readAt,
        replyToMessageId,
        replyToMessage,
        replyToSenderName,
        const DeepCollectionEquality().hash(_metadata),
        isEdited,
        editedMessage,
        editedAt,
        isDeleted,
        deletedAt,
        deletedBy,
        createdAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageModelImplCopyWith<_$ChatMessageModelImpl> get copyWith =>
      __$$ChatMessageModelImplCopyWithImpl<_$ChatMessageModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatMessageModelImplToJson(
      this,
    );
  }
}

abstract class _ChatMessageModel extends ChatMessageModel {
  const factory _ChatMessageModel(
      {required final String id,
      required final String threadId,
      required final String senderId,
      required final String senderName,
      final String? senderPhotoUrl,
      required final MessageType type,
      required final String message,
      final String? imageUrl,
      final String? fileUrl,
      final String? fileName,
      final int? fileSize,
      required final MessageStatus status,
      final Map<String, dynamic>? readBy,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? readAt,
      final String? replyToMessageId,
      final String? replyToMessage,
      final String? replyToSenderName,
      final Map<String, dynamic>? metadata,
      final bool isEdited,
      final String? editedMessage,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? editedAt,
      final bool isDeleted,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? deletedAt,
      final String? deletedBy,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? createdAt}) = _$ChatMessageModelImpl;
  const _ChatMessageModel._() : super._();

  factory _ChatMessageModel.fromJson(Map<String, dynamic> json) =
      _$ChatMessageModelImpl.fromJson;

  @override
  String get id;
  @override
  String get threadId;
  @override
  String get senderId;
  @override
  String get senderName;
  @override
  String? get senderPhotoUrl;
  @override
  MessageType get type;
  @override
  String get message;
  @override
  String? get imageUrl;
  @override
  String? get fileUrl;
  @override
  String? get fileName;
  @override
  int? get fileSize;
  @override
  MessageStatus get status;
  @override
  Map<String, dynamic>? get readBy;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get readAt;
  @override
  String? get replyToMessageId;
  @override
  String? get replyToMessage;
  @override
  String? get replyToSenderName;
  @override
  Map<String, dynamic>? get metadata;
  @override
  bool get isEdited;
  @override
  String? get editedMessage;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get editedAt;
  @override
  bool get isDeleted;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get deletedAt;
  @override
  String? get deletedBy;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$ChatMessageModelImplCopyWith<_$ChatMessageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
