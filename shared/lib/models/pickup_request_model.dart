import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'pickup_request_model.freezed.dart';
part 'pickup_request_model.g.dart';

enum PickupStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('assigned')
  assigned,
  @JsonValue('on_the_way')
  onTheWay,
  @JsonValue('arrived')
  arrived,
  @JsonValue('picked_up')
  pickedUp,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

@freezed
class PickupRequestModel with _$PickupRequestModel {
  const PickupRequestModel._();
  const factory PickupRequestModel({
    required String id,
    required String userId,
    String? courierId,
    required Map<String, int> quantities,
    required double estimatedWeight,
    double? actualWeight,
    required int estimatedPoints,
    int? actualPoints,
    required Map<String, dynamic> addressSnapshot,
    @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
    required DateTime pickupDate,
    required String timeRange,
    required String zone,
    required PickupStatus status,
    String? otp,
    List<String>? proofPhotos,
    String? cancelReason,
    String? notes,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? createdAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? updatedAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? assignedAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? onTheWayAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? arrivedAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? pickedUpAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? completedAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? cancelledAt,
  }) = _PickupRequestModel;

  factory PickupRequestModel.fromJson(Map<String, dynamic> json) =>
      _$PickupRequestModelFromJson(json);

  factory PickupRequestModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PickupRequestModel.fromJson({...data, 'id': doc.id});
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    return json;
  }

  Map<String, dynamic> get address => addressSnapshot;

  DateTime get date => pickupDate;
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
