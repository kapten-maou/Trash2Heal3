import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'chat_thread_model.freezed.dart';
part 'chat_thread_model.g.dart';

enum ThreadType {
  @JsonValue('user_admin')
  userAdmin,
  @JsonValue('user_courier')
  userCourier,
  @JsonValue('group')
  group,
}

enum ThreadStatus {
  @JsonValue('active')
  active,
  @JsonValue('archived')
  archived,
  @JsonValue('closed')
  closed,
}

@freezed
class ChatThreadModel with _$ChatThreadModel {
  const ChatThreadModel._();
  const factory ChatThreadModel({
    required String id,
    required List<String> participantIds,
    required Map<String, dynamic> participantDetails,
    required ThreadType type,
    @Default(ThreadStatus.active) ThreadStatus status,
    String? title,
    String? description,
    String? lastMessage,
    String? lastMessageSenderId,
    String? lastMessageSenderName,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? lastMessageAt,
    required Map<String, int> unreadCount,
    String? relatedId,
    String? relatedCollection,
    Map<String, dynamic>? metadata,
    @Default(false) bool isPinned,
    @Default(false) bool isMuted,
    List<String>? mutedBy,
    String? closedBy,
    String? closedReason,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? closedAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? createdAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? updatedAt,
    String? createdBy,
  }) = _ChatThreadModel;

  factory ChatThreadModel.fromJson(Map<String, dynamic> json) =>
      _$ChatThreadModelFromJson(json);

  factory ChatThreadModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatThreadModel.fromJson({...data, 'id': doc.id});
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    return json;
  }
}

// Thread Helper Functions
class ChatThreadHelper {
  static Map<String, dynamic> createParticipantDetails({
    required String userId,
    required String userName,
    String? userPhoto,
    String? adminId,
    String? adminName,
    String? adminPhoto,
  }) {
    final details = <String, dynamic>{
      userId: {
        'name': userName,
        'photoUrl': userPhoto,
        'role': 'user',
      },
    };

    if (adminId != null && adminName != null) {
      details[adminId] = {
        'name': adminName,
        'photoUrl': adminPhoto,
        'role': 'admin',
      };
    }

    return details;
  }

  static Map<String, int> initializeUnreadCount(List<String> participantIds) {
    return Map.fromEntries(
      participantIds.map((id) => MapEntry(id, 0)),
    );
  }

  static String generateThreadId(List<String> participantIds) {
    final sortedIds = List<String>.from(participantIds)..sort();
    return sortedIds.join('_');
  }

  static String getOtherParticipantName(
    ChatThreadModel thread,
    String currentUserId,
  ) {
    final otherParticipantId = thread.participantIds
        .firstWhere((id) => id != currentUserId, orElse: () => '');

    if (otherParticipantId.isEmpty) return 'Unknown';

    final details = thread.participantDetails[otherParticipantId];
    return details != null ? details['name'] ?? 'Unknown' : 'Unknown';
  }

  static String? getOtherParticipantPhoto(
    ChatThreadModel thread,
    String currentUserId,
  ) {
    final otherParticipantId = thread.participantIds
        .firstWhere((id) => id != currentUserId, orElse: () => '');

    if (otherParticipantId.isEmpty) return null;

    final details = thread.participantDetails[otherParticipantId];
    return details != null ? details['photoUrl'] : null;
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
