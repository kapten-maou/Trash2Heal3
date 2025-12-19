// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_thread_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatThreadModelImpl _$$ChatThreadModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ChatThreadModelImpl(
      id: json['id'] as String,
      participantIds: (json['participantIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      participantDetails: json['participantDetails'] as Map<String, dynamic>,
      type: $enumDecode(_$ThreadTypeEnumMap, json['type']),
      status: $enumDecodeNullable(_$ThreadStatusEnumMap, json['status']) ??
          ThreadStatus.active,
      title: json['title'] as String?,
      description: json['description'] as String?,
      lastMessage: json['lastMessage'] as String?,
      lastMessageSenderId: json['lastMessageSenderId'] as String?,
      lastMessageSenderName: json['lastMessageSenderName'] as String?,
      lastMessageAt: _timestampFromJson(json['lastMessageAt']),
      unreadCount: Map<String, int>.from(json['unreadCount'] as Map),
      relatedId: json['relatedId'] as String?,
      relatedCollection: json['relatedCollection'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      isPinned: json['isPinned'] as bool? ?? false,
      isMuted: json['isMuted'] as bool? ?? false,
      mutedBy:
          (json['mutedBy'] as List<dynamic>?)?.map((e) => e as String).toList(),
      closedBy: json['closedBy'] as String?,
      closedReason: json['closedReason'] as String?,
      closedAt: _timestampFromJson(json['closedAt']),
      createdAt: _timestampFromJson(json['createdAt']),
      updatedAt: _timestampFromJson(json['updatedAt']),
      createdBy: json['createdBy'] as String?,
    );

Map<String, dynamic> _$$ChatThreadModelImplToJson(
        _$ChatThreadModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'participantIds': instance.participantIds,
      'participantDetails': instance.participantDetails,
      'type': _$ThreadTypeEnumMap[instance.type]!,
      'status': _$ThreadStatusEnumMap[instance.status]!,
      'title': instance.title,
      'description': instance.description,
      'lastMessage': instance.lastMessage,
      'lastMessageSenderId': instance.lastMessageSenderId,
      'lastMessageSenderName': instance.lastMessageSenderName,
      'lastMessageAt': _timestampToJson(instance.lastMessageAt),
      'unreadCount': instance.unreadCount,
      'relatedId': instance.relatedId,
      'relatedCollection': instance.relatedCollection,
      'metadata': instance.metadata,
      'isPinned': instance.isPinned,
      'isMuted': instance.isMuted,
      'mutedBy': instance.mutedBy,
      'closedBy': instance.closedBy,
      'closedReason': instance.closedReason,
      'closedAt': _timestampToJson(instance.closedAt),
      'createdAt': _timestampToJson(instance.createdAt),
      'updatedAt': _timestampToJson(instance.updatedAt),
      'createdBy': instance.createdBy,
    };

const _$ThreadTypeEnumMap = {
  ThreadType.userAdmin: 'user_admin',
  ThreadType.userCourier: 'user_courier',
  ThreadType.group: 'group',
};

const _$ThreadStatusEnumMap = {
  ThreadStatus.active: 'active',
  ThreadStatus.archived: 'archived',
  ThreadStatus.closed: 'closed',
};
