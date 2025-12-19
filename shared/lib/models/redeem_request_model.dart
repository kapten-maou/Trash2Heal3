import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'redeem_request_model.freezed.dart';
part 'redeem_request_model.g.dart';

/// Redemption request status
enum RedeemStatus {
  @JsonValue('pending')
  pending, // Waiting for processing
  @JsonValue('processing')
  processing, // Being processed by admin
  @JsonValue('approved')
  approved, // Approved, coupon created
  @JsonValue('rejected')
  rejected, // Rejected by admin
  @JsonValue('cancelled')
  cancelled, // Cancelled by user
}

/// Model for point redemption requests
/// Users create this when redeeming points for vouchers/balance
@freezed
class RedeemRequestModel with _$RedeemRequestModel {
  const RedeemRequestModel._();
  const factory RedeemRequestModel({
    /// Unique request ID
    required String id,

    /// User requesting redemption
    required String userId,

    /// User's name (snapshot for display)
    required String userName,

    /// User's email (snapshot for display)
    required String userEmail,

    /// User's phone (snapshot for delivery/notification)
    required String userPhone,

    /// Type: voucher or balance
    required String type, // 'voucher' or 'balance'

    /// Points to redeem
    required int points,

    /// Value in IDR
    required int amount,

    /// Current status
    required RedeemStatus status,

    /// Voucher details (if type = voucher)
    String? voucherName,
    String? voucherProvider,
    String? voucherCategory,
    int? voucherValue,

    /// Balance details (if type = balance)
    String? bankName,
    String? accountNumber,
    String? accountHolderName,

    /// Generated coupon ID (after approval)
    String? couponId,

    /// Admin notes
    String? adminNotes,

    /// Processed by admin ID
    String? processedBy,

    /// Processing timestamp
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? processedAt,

    /// Rejection reason
    String? rejectionReason,

    /// Additional metadata
    Map<String, dynamic>? metadata,

    /// Created timestamp
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? createdAt,

    /// Updated timestamp
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? updatedAt,
  }) = _RedeemRequestModel;

  factory RedeemRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RedeemRequestModelFromJson(json);

  /// Create from Firestore document
  factory RedeemRequestModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RedeemRequestModel.fromJson({
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
