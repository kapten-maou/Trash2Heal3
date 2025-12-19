import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'voucher_scan_model.freezed.dart';
part 'voucher_scan_model.g.dart';

enum ScanStatus {
  @JsonValue('valid')
  valid,
  @JsonValue('used')
  used,
  @JsonValue('expired')
  expired,
  @JsonValue('invalid')
  invalid,
  @JsonValue('fraud')
  fraud,
}

@freezed
class VoucherScanModel with _$VoucherScanModel {
  const VoucherScanModel._();
  const factory VoucherScanModel({
    required String id,
    required String userId,
    required String userName,
    required String eventId,
    required String eventName,
    required String itemId,
    required String itemName,
    required String voucherCode,
    required ScanStatus status,
    @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
    required DateTime scannedAt,
    required String scannedBy,
    String? scannedByName,
    String? location,
    double? latitude,
    double? longitude,
    String? deviceId,
    String? deviceInfo,
    String? remarks,
    String? invalidReason,
    Map<String, dynamic>? metadata,
    @Default(false) bool isFraudulent,
    String? fraudReason,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? verifiedAt,
    String? verifiedBy,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? createdAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? updatedAt,
  }) = _VoucherScanModel;

  factory VoucherScanModel.fromJson(Map<String, dynamic> json) =>
      _$VoucherScanModelFromJson(json);

  factory VoucherScanModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return VoucherScanModel.fromJson({...data, 'id': doc.id});
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
