import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'pickup_slot_model.freezed.dart';
part 'pickup_slot_model.g.dart';

@freezed
class PickupSlotModel with _$PickupSlotModel {
  const PickupSlotModel._();
  const factory PickupSlotModel({
    required String id,
    @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
    required DateTime date,
    required String timeRange,
    required String zone,
    required int capacityWeightKg,
    @Default(0) int usedWeightKg,
    String? courierId,
    String? courierName,
    @Default(true) bool isActive,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? createdAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? updatedAt,
  }) = _PickupSlotModel;

  factory PickupSlotModel.fromJson(Map<String, dynamic> json) =>
      _$PickupSlotModelFromJson(json);

  factory PickupSlotModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PickupSlotModel.fromJson({...data, 'id': doc.id});
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    return json;
  }
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
