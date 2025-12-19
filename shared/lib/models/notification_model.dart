import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

enum NotificationType {
  @JsonValue('pickup_scheduled')
  pickupScheduled,
  @JsonValue('pickup_assigned')
  pickupAssigned,
  @JsonValue('pickup_on_the_way')
  pickupOnTheWay,
  @JsonValue('pickup_completed')
  pickupCompleted,
  @JsonValue('pickup_cancelled')
  pickupCancelled,
  @JsonValue('points_earned')
  pointsEarned,
  @JsonValue('points_redeemed')
  pointsRedeemed,
  @JsonValue('voucher_claimed')
  voucherClaimed,
  @JsonValue('membership_upgraded')
  membershipUpgraded,
  @JsonValue('membership_expiring')
  membershipExpiring,
  @JsonValue('membership_expired')
  membershipExpired,
  @JsonValue('event_new')
  eventNew,
  @JsonValue('event_reminder')
  eventReminder,
  @JsonValue('chat_message')
  chatMessage,
  @JsonValue('system_announcement')
  systemAnnouncement,
  @JsonValue('promotional')
  promotional,
}

enum NotificationPriority {
  @JsonValue('low')
  low,
  @JsonValue('normal')
  normal,
  @JsonValue('high')
  high,
  @JsonValue('urgent')
  urgent,
}

@freezed
class NotificationModel with _$NotificationModel {
  const NotificationModel._();
  const factory NotificationModel({
    required String id,
    required String userId,
    required String title,
    required String body,
    required NotificationType type,
    @Default(NotificationPriority.normal) NotificationPriority priority,
    String? imageUrl,
    String? relatedId,
    String? relatedCollection,
    Map<String, dynamic>? data,
    Map<String, dynamic>? actionData,
    String? actionRoute,
    @Default(false) bool isRead,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? readAt,
    @Default(false) bool isSent,
    @Default(false) bool isDelivered,
    @Default(false) bool isFailed,
    String? failureReason,
    String? fcmMessageId,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? sentAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? deliveredAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? expiryDate,
    @Default(false) bool isDeleted,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? deletedAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? createdAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel.fromJson({...data, 'id': doc.id});
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    return json;
  }
}

// Notification Templates
class NotificationTemplates {
  static NotificationModel pickupScheduled({
    required String userId,
    required String pickupId,
    required DateTime scheduledDate,
    required String timeRange,
  }) {
    return NotificationModel(
      id: '',
      userId: userId,
      title: 'Pickup Scheduled',
      body:
          'Your pickup is scheduled for ${_formatDate(scheduledDate)} at $timeRange',
      type: NotificationType.pickupScheduled,
      priority: NotificationPriority.high,
      relatedId: pickupId,
      relatedCollection: 'pickupRequests',
      actionRoute: '/history/$pickupId',
      createdAt: DateTime.now(),
    );
  }

  static NotificationModel pickupCompleted({
    required String userId,
    required String pickupId,
    required int pointsEarned,
  }) {
    return NotificationModel(
      id: '',
      userId: userId,
      title: 'Pickup Completed! 🎉',
      body: 'You earned $pointsEarned points from your pickup',
      type: NotificationType.pickupCompleted,
      priority: NotificationPriority.high,
      relatedId: pickupId,
      relatedCollection: 'pickupRequests',
      actionRoute: '/points',
      createdAt: DateTime.now(),
    );
  }

  static NotificationModel membershipUpgraded({
    required String userId,
    required String tier,
  }) {
    return NotificationModel(
      id: '',
      userId: userId,
      title: 'Welcome to $tier! 🌟',
      body: 'Your membership has been upgraded. Enjoy exclusive benefits!',
      type: NotificationType.membershipUpgraded,
      priority: NotificationPriority.high,
      actionRoute: '/profile',
      createdAt: DateTime.now(),
    );
  }

  static NotificationModel eventNew({
    required String userId,
    required String eventId,
    required String eventTitle,
  }) {
    return NotificationModel(
      id: '',
      userId: userId,
      title: 'New Event Available! 🎊',
      body: 'Check out "$eventTitle" and claim exclusive rewards',
      type: NotificationType.eventNew,
      priority: NotificationPriority.normal,
      relatedId: eventId,
      relatedCollection: 'events',
      actionRoute: '/events/$eventId',
      createdAt: DateTime.now(),
    );
  }

  static String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

DateTime? _timestampFromJson(dynamic timestamp) {
  if (timestamp == null) return null;
  if (timestamp is Timestamp) return timestamp.toDate();
  if (timestamp is String) return DateTime.parse(timestamp);
  return null;
}

dynamic _timestampToJson(DateTime? dateTime) {
  if (dateTime == null) return null;
  return Timestamp.fromDate(dateTime);
}
