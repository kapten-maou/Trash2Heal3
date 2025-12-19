import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'event_item_model.freezed.dart';
part 'event_item_model.g.dart';

enum EventItemType {
  @JsonValue('voucher')
  voucher,
  @JsonValue('merchandise')
  merchandise,
  @JsonValue('reward')
  reward,
  @JsonValue('prize')
  prize,
}

enum EventItemStatus {
  @JsonValue('available')
  available,
  @JsonValue('low_stock')
  lowStock,
  @JsonValue('out_of_stock')
  outOfStock,
  @JsonValue('discontinued')
  discontinued,
}

@freezed
class EventItemModel with _$EventItemModel {
  const EventItemModel._();
  const factory EventItemModel({
    required String id,
    required String eventId,
    required String name,
    required String description,
    String? imageUrl,
    required EventItemType type,
    required int pointsRequired,
    required int stock,
    @Default(0) int claimed,
    @Default(0) int reserved,
    required EventItemStatus status,
    String? provider,
    String? category,
    int? value,
    String? unit,
    List<String>? imageUrls,
    Map<String, dynamic>? specifications,
    String? terms,
    String? instructions,
    @Default(1) int maxClaimPerUser,
    @Default(true) bool isActive,
    @Default(false) bool isFeatured,
    int? displayOrder,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? availableFrom,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? availableUntil,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? createdAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
  }) = _EventItemModel;

  factory EventItemModel.fromJson(Map<String, dynamic> json) =>
      _$EventItemModelFromJson(json);

  factory EventItemModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EventItemModel.fromJson({...data, 'id': doc.id});
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    return json;
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
