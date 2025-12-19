import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'pickup_rate_model.freezed.dart';
part 'pickup_rate_model.g.dart';

@freezed
class PickupRateModel with _$PickupRateModel {
  const factory PickupRateModel({
    required String id,

    // Category Info
    required String
        category, // 'Plastik', 'Kaca', 'Kaleng', 'Kardus', 'Kain', 'Keramik'
    required String displayName,
    String? description,
    String? iconUrl,

    // Rate Calculation
    required double pointsPerKg, // Points earned per kilogram
    required double
        avgWeightPerUnit, // Average weight in kg (e.g., 1 plastic bottle = 0.05kg)

    // Limits
    int? minQuantity,
    int? maxQuantity,

    // Status
    @Default(true) bool isActive,

    // Display Order
    @Default(0) int sortOrder,

    // Timestamps
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? createdAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? updatedAt,
  }) = _PickupRateModel;

  factory PickupRateModel.fromJson(Map<String, dynamic> json) =>
      _$PickupRateModelFromJson(json);

  factory PickupRateModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PickupRateModel.fromJson({...data, 'id': doc.id});
  }
}

// Timestamp converters
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
