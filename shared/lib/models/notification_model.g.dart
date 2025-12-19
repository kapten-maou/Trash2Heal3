// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      priority: $enumDecodeNullable(
              _$NotificationPriorityEnumMap, json['priority']) ??
          NotificationPriority.normal,
      imageUrl: json['imageUrl'] as String?,
      relatedId: json['relatedId'] as String?,
      relatedCollection: json['relatedCollection'] as String?,
      data: json['data'] as Map<String, dynamic>?,
      actionData: json['actionData'] as Map<String, dynamic>?,
      actionRoute: json['actionRoute'] as String?,
      isRead: json['isRead'] as bool? ?? false,
      readAt: _timestampFromJson(json['readAt']),
      isSent: json['isSent'] as bool? ?? false,
      isDelivered: json['isDelivered'] as bool? ?? false,
      isFailed: json['isFailed'] as bool? ?? false,
      failureReason: json['failureReason'] as String?,
      fcmMessageId: json['fcmMessageId'] as String?,
      sentAt: _timestampFromJson(json['sentAt']),
      deliveredAt: _timestampFromJson(json['deliveredAt']),
      expiryDate: _timestampFromJson(json['expiryDate']),
      isDeleted: json['isDeleted'] as bool? ?? false,
      deletedAt: _timestampFromJson(json['deletedAt']),
      createdAt: _timestampFromJson(json['createdAt']),
    );

Map<String, dynamic> _$$NotificationModelImplToJson(
        _$NotificationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'body': instance.body,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'priority': _$NotificationPriorityEnumMap[instance.priority]!,
      'imageUrl': instance.imageUrl,
      'relatedId': instance.relatedId,
      'relatedCollection': instance.relatedCollection,
      'data': instance.data,
      'actionData': instance.actionData,
      'actionRoute': instance.actionRoute,
      'isRead': instance.isRead,
      'readAt': _timestampToJson(instance.readAt),
      'isSent': instance.isSent,
      'isDelivered': instance.isDelivered,
      'isFailed': instance.isFailed,
      'failureReason': instance.failureReason,
      'fcmMessageId': instance.fcmMessageId,
      'sentAt': _timestampToJson(instance.sentAt),
      'deliveredAt': _timestampToJson(instance.deliveredAt),
      'expiryDate': _timestampToJson(instance.expiryDate),
      'isDeleted': instance.isDeleted,
      'deletedAt': _timestampToJson(instance.deletedAt),
      'createdAt': _timestampToJson(instance.createdAt),
    };

const _$NotificationTypeEnumMap = {
  NotificationType.pickupScheduled: 'pickup_scheduled',
  NotificationType.pickupAssigned: 'pickup_assigned',
  NotificationType.pickupOnTheWay: 'pickup_on_the_way',
  NotificationType.pickupCompleted: 'pickup_completed',
  NotificationType.pickupCancelled: 'pickup_cancelled',
  NotificationType.pointsEarned: 'points_earned',
  NotificationType.pointsRedeemed: 'points_redeemed',
  NotificationType.voucherClaimed: 'voucher_claimed',
  NotificationType.membershipUpgraded: 'membership_upgraded',
  NotificationType.membershipExpiring: 'membership_expiring',
  NotificationType.membershipExpired: 'membership_expired',
  NotificationType.eventNew: 'event_new',
  NotificationType.eventReminder: 'event_reminder',
  NotificationType.chatMessage: 'chat_message',
  NotificationType.systemAnnouncement: 'system_announcement',
  NotificationType.promotional: 'promotional',
};

const _$NotificationPriorityEnumMap = {
  NotificationPriority.low: 'low',
  NotificationPriority.normal: 'normal',
  NotificationPriority.high: 'high',
  NotificationPriority.urgent: 'urgent',
};
