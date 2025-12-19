import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'coupon_model.freezed.dart';
part 'coupon_model.g.dart';

/// Coupon types
enum CouponType {
  @JsonValue('voucher')
  voucher, // Gift voucher (Indomaret, Alfamart, etc)
  @JsonValue('balance')
  balance, // Cash balance (to bank/e-wallet)
}

/// Coupon status
enum CouponStatus {
  @JsonValue('active')
  active,
  @JsonValue('used')
  used,
  @JsonValue('expired')
  expired,
  @JsonValue('cancelled')
  cancelled,
}

/// Model for redeemed coupons/vouchers
/// Created when user redeems points for rewards
@freezed
class CouponModel with _$CouponModel {
  const CouponModel._();
  const factory CouponModel({
    /// Unique coupon ID
    required String id,

    /// User who owns this coupon
    required String userId,

    /// Unique redemption code (QR/barcode scannable)
    required String code,

    /// Coupon name/title
    required String name,

    /// Type: voucher or balance
    required CouponType type,

    /// Coupon value in IDR
    required int value,

    /// Points spent to redeem
    required int pointsSpent,

    /// Current status
    required CouponStatus status,

    /// Related redeem request ID
    String? redeemRequestId,

    /// Voucher provider (e.g., "Indomaret", "Alfamart", "Shopee")
    String? provider,

    /// Voucher category (e.g., "Gift Card", "Discount")
    String? category,

    /// Voucher image URL
    String? imageUrl,

    /// Terms and conditions
    String? terms,

    /// Instructions to use
    String? instructions,

    /// Expiry date (if applicable)
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? expiryDate,

    /// When coupon was used
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? usedAt,

    /// Where coupon was used (store location, event ID, etc.)
    String? usedLocation,

    /// Additional metadata
    Map<String, dynamic>? metadata,

    /// Created timestamp
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? createdAt,

    /// Updated timestamp
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? updatedAt,
  }) = _CouponModel;

  factory CouponModel.fromJson(Map<String, dynamic> json) =>
      _$CouponModelFromJson(json);

  /// Create from Firestore document
  factory CouponModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CouponModel.fromJson({
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
