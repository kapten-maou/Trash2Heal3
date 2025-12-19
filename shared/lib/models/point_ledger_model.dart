import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'point_ledger_model.freezed.dart';
part 'point_ledger_model.g.dart';

/// Point transaction types
enum PointTransactionType {
  @JsonValue('earn')
  earn,
  @JsonValue('redeem')
  redeem,
  @JsonValue('refund')
  refund,
  @JsonValue('bonus')
  bonus,
  @JsonValue('penalty')
  penalty,
}

/// Model for tracking all point transactions
/// Each transaction creates an immutable ledger entry
@freezed
class PointLedgerModel with _$PointLedgerModel {
  const PointLedgerModel._();
  const factory PointLedgerModel({
    /// Unique ledger entry ID
    required String id,

    /// User who owns this transaction
    required String userId,

    /// Type of transaction (earn/redeem/refund/bonus/penalty)
    required PointTransactionType type,

    /// Point amount (positive for earn/refund/bonus, negative for redeem/penalty)
    required int amount,

    /// Human-readable description of transaction
    required String description,

    /// Related document ID (pickupRequestId, couponId, eventId, etc.)
    String? relatedId,

    /// Related collection name for reference
    String? relatedCollection,

    /// Running balance after this transaction
    int? balanceAfter,

    /// Additional metadata (JSON)
    Map<String, dynamic>? metadata,

    /// Transaction timestamp (server-side)
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? createdAt,
  }) = _PointLedgerModel;

  factory PointLedgerModel.fromJson(Map<String, dynamic> json) =>
      _$PointLedgerModelFromJson(json);

  /// Create from Firestore document
  factory PointLedgerModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PointLedgerModel.fromJson({
      ...data,
      'id': doc.id,
    });
  }

  /// Convert to Firestore data (without id)
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    return json;
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
