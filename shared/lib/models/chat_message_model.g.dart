// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatMessageModelImpl _$$ChatMessageModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ChatMessageModelImpl(
      id: json['id'] as String,
      threadId: json['threadId'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      senderPhotoUrl: json['senderPhotoUrl'] as String?,
      type: $enumDecode(_$MessageTypeEnumMap, json['type']),
      message: json['message'] as String,
      imageUrl: json['imageUrl'] as String?,
      fileUrl: json['fileUrl'] as String?,
      fileName: json['fileName'] as String?,
      fileSize: (json['fileSize'] as num?)?.toInt(),
      status: $enumDecode(_$MessageStatusEnumMap, json['status']),
      readBy: json['readBy'] as Map<String, dynamic>?,
      readAt: _timestampFromJson(json['readAt']),
      replyToMessageId: json['replyToMessageId'] as String?,
      replyToMessage: json['replyToMessage'] as String?,
      replyToSenderName: json['replyToSenderName'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      isEdited: json['isEdited'] as bool? ?? false,
      editedMessage: json['editedMessage'] as String?,
      editedAt: _timestampFromJson(json['editedAt']),
      isDeleted: json['isDeleted'] as bool? ?? false,
      deletedAt: _timestampFromJson(json['deletedAt']),
      deletedBy: json['deletedBy'] as String?,
      createdAt: _timestampFromJson(json['createdAt']),
    );

Map<String, dynamic> _$$ChatMessageModelImplToJson(
        _$ChatMessageModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'threadId': instance.threadId,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'senderPhotoUrl': instance.senderPhotoUrl,
      'type': _$MessageTypeEnumMap[instance.type]!,
      'message': instance.message,
      'imageUrl': instance.imageUrl,
      'fileUrl': instance.fileUrl,
      'fileName': instance.fileName,
      'fileSize': instance.fileSize,
      'status': _$MessageStatusEnumMap[instance.status]!,
      'readBy': instance.readBy,
      'readAt': _timestampToJson(instance.readAt),
      'replyToMessageId': instance.replyToMessageId,
      'replyToMessage': instance.replyToMessage,
      'replyToSenderName': instance.replyToSenderName,
      'metadata': instance.metadata,
      'isEdited': instance.isEdited,
      'editedMessage': instance.editedMessage,
      'editedAt': _timestampToJson(instance.editedAt),
      'isDeleted': instance.isDeleted,
      'deletedAt': _timestampToJson(instance.deletedAt),
      'deletedBy': instance.deletedBy,
      'createdAt': _timestampToJson(instance.createdAt),
    };

const _$MessageTypeEnumMap = {
  MessageType.text: 'text',
  MessageType.image: 'image',
  MessageType.file: 'file',
  MessageType.system: 'system',
};

const _$MessageStatusEnumMap = {
  MessageStatus.sending: 'sending',
  MessageStatus.sent: 'sent',
  MessageStatus.delivered: 'delivered',
  MessageStatus.read: 'read',
  MessageStatus.failed: 'failed',
};
