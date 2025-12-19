import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'event_model.freezed.dart';
part 'event_model.g.dart';

enum EventStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('active')
  active,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

@freezed
class EventModel with _$EventModel {
  const EventModel._();
  const factory EventModel({
    required String id,
    required String title,
    required String description,
    String? imageUrl,
    String? location,
    String? organizer,
    @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
    required DateTime startDate,
    @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
    required DateTime endDate,
    @Default(EventStatus.draft) EventStatus status,
    @Default(0) int participantCount,
    @Default(0) int maxParticipants,
    @Default(0) int itemsCount,
    @Default(0) int totalPointsRequired,
    List<String>? categories,
    List<String>? tags,
    Map<String, dynamic>? contactInfo,
    String? termsAndConditions,
    @Default(true) bool isActive,
    @Default(false) bool isFeatured,
    @Default(0) int viewCount,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? createdAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
  }) = _EventModel;

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);

  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EventModel.fromJson({...data, 'id': doc.id});
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    return json;
  }

  bool get active => status == EventStatus.active && isActive;
}

// For nullable DateTime fields
DateTime? _timestampFromJson(dynamic timestamp) {
  if (timestamp == null) return null;
  if (timestamp is Timestamp) return timestamp.toDate();
  if (timestamp is String) return DateTime.parse(timestamp);
  return null;
}

// For required DateTime fields
DateTime _requiredTimestampFromJson(dynamic timestamp) {
  if (timestamp == null) return DateTime.now();
  if (timestamp is Timestamp) return timestamp.toDate();
  if (timestamp is String) return DateTime.parse(timestamp);
  return DateTime.now();
}

dynamic _timestampToJson(DateTime? dateTime) {
  if (dateTime == null) return null;
  return Timestamp.fromDate(dateTime);
}
