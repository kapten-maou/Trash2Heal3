import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'chat_message_model.freezed.dart';
part 'chat_message_model.g.dart';

enum MessageType {
  @JsonValue('text')
  text,
  @JsonValue('image')
  image,
  @JsonValue('file')
  file,
  @JsonValue('system')
  system,
}

enum MessageStatus {
  @JsonValue('sending')
  sending,
  @JsonValue('sent')
  sent,
  @JsonValue('delivered')
  delivered,
  @JsonValue('read')
  read,
  @JsonValue('failed')
  failed,
}

@freezed
class ChatMessageModel with _$ChatMessageModel {
  const ChatMessageModel._();
  const factory ChatMessageModel({
    required String id,
    required String threadId,
    required String senderId,
    required String senderName,
    String? senderPhotoUrl,
    required MessageType type,
    required String message,
    String? imageUrl,
    String? fileUrl,
    String? fileName,
    int? fileSize,
    required MessageStatus status,
    Map<String, dynamic>? readBy,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? readAt,
    String? replyToMessageId,
    String? replyToMessage,
    String? replyToSenderName,
    Map<String, dynamic>? metadata,
    @Default(false) bool isEdited,
    String? editedMessage,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? editedAt,
    @Default(false) bool isDeleted,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? deletedAt,
    String? deletedBy,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? createdAt,
  }) = _ChatMessageModel;

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(json);

  factory ChatMessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatMessageModel.fromJson({...data, 'id': doc.id});
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    return json;
  }
}

// Message Helper Functions
class ChatMessageHelper {
  static ChatMessageModel createTextMessage({
    required String threadId,
    required String senderId,
    required String senderName,
    String? senderPhotoUrl,
    required String message,
    String? replyToMessageId,
    String? replyToMessage,
    String? replyToSenderName,
  }) {
    return ChatMessageModel(
      id: '',
      threadId: threadId,
      senderId: senderId,
      senderName: senderName,
      senderPhotoUrl: senderPhotoUrl,
      type: MessageType.text,
      message: message,
      status: MessageStatus.sending,
      replyToMessageId: replyToMessageId,
      replyToMessage: replyToMessage,
      replyToSenderName: replyToSenderName,
      createdAt: DateTime.now(),
    );
  }

  static ChatMessageModel createImageMessage({
    required String threadId,
    required String senderId,
    required String senderName,
    String? senderPhotoUrl,
    required String imageUrl,
    String? caption,
  }) {
    return ChatMessageModel(
      id: '',
      threadId: threadId,
      senderId: senderId,
      senderName: senderName,
      senderPhotoUrl: senderPhotoUrl,
      type: MessageType.image,
      message: caption ?? '',
      imageUrl: imageUrl,
      status: MessageStatus.sending,
      createdAt: DateTime.now(),
    );
  }

  static ChatMessageModel createSystemMessage({
    required String threadId,
    required String message,
  }) {
    return ChatMessageModel(
      id: '',
      threadId: threadId,
      senderId: 'system',
      senderName: 'System',
      type: MessageType.system,
      message: message,
      status: MessageStatus.sent,
      createdAt: DateTime.now(),
    );
  }

  static Map<String, dynamic> createReadByEntry(
    String userId,
    String userName,
  ) {
    return {
      userId: {
        'name': userName,
        'readAt': FieldValue.serverTimestamp(),
      },
    };
  }

  static bool isMessageRead(ChatMessageModel message, String userId) {
    if (message.readBy == null) return false;
    return message.readBy!.containsKey(userId);
  }

  static String formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      // Today - show time
      final hour = timestamp.hour.toString().padLeft(2, '0');
      final minute = timestamp.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[timestamp.weekday - 1];
    } else {
      final day = timestamp.day.toString().padLeft(2, '0');
      final month = timestamp.month.toString().padLeft(2, '0');
      return '$day/$month/${timestamp.year}';
    }
  }

  static String getMessagePreview(ChatMessageModel message,
      {int maxLength = 50}) {
    String preview = '';

    switch (message.type) {
      case MessageType.text:
        preview = message.message;
        break;
      case MessageType.image:
        preview =
            message.message.isNotEmpty ? '📷 ${message.message}' : '📷 Image';
        break;
      case MessageType.file:
        preview = '📎 ${message.fileName ?? 'File'}';
        break;
      case MessageType.system:
        preview = message.message;
        break;
    }

    if (preview.length > maxLength) {
      return '${preview.substring(0, maxLength)}...';
    }

    return preview;
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
