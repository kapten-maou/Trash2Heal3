import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'membership_model.freezed.dart';
part 'membership_model.g.dart';

enum MembershipTier {
  @JsonValue('basic')
  basic,
  @JsonValue('gold')
  gold,
  @JsonValue('platinum')
  platinum,
}

enum MembershipStatus {
  @JsonValue('active')
  active,
  @JsonValue('expired')
  expired,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('pending')
  pending,
}

@freezed
class MembershipModel with _$MembershipModel {
  const MembershipModel._();
  const factory MembershipModel({
    required String id,
    required String userId,
    required String userName,
    required String userEmail,
    required MembershipTier tier,
    required MembershipStatus status,
    @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
    required DateTime startDate,
    @JsonKey(fromJson: _requiredTimestampFromJson, toJson: _timestampToJson)
    required DateTime endDate,
    required int durationMonths,
    required int price,
    String? paymentId,
    String? previousTier,
    @Default(false) bool autoRenew,
    @Default(false) bool isLifetime,
    required Map<String, dynamic> benefits,
    Map<String, dynamic>? usageStats,
    String? cancellationReason,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? cancelledAt,
    String? cancelledBy,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? renewalDate,
    String? renewalPaymentId,
    @Default(0) int renewalCount,
    String? promoCode,
    int? discount,
    String? notes,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? createdAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
  }) = _MembershipModel;

  factory MembershipModel.fromJson(Map<String, dynamic> json) =>
      _$MembershipModelFromJson(json);

  factory MembershipModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MembershipModel.fromJson({...data, 'id': doc.id});
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    return json;
  }
}

// Membership Benefits Template
class MembershipBenefits {
  static Map<String, dynamic> basic() {
    return {
      'pickupPriority': 'standard',
      'pickupDiscount': 0,
      'pointsMultiplier': 1.0,
      'maxPickupsPerMonth': 4,
      'freePickups': 0,
      'support': '24h response',
      'features': [
        'Standard pickup scheduling',
        'Basic rewards',
        'Email support',
      ],
    };
  }

  static Map<String, dynamic> gold() {
    return {
      'pickupPriority': 'high',
      'pickupDiscount': 10,
      'pointsMultiplier': 1.5,
      'maxPickupsPerMonth': 12,
      'freePickups': 2,
      'support': '12h response',
      'features': [
        'Priority pickup scheduling',
        '1.5x points multiplier',
        '10% pickup discount',
        '2 free pickups/month',
        'Chat support',
        'Exclusive event access',
      ],
    };
  }

  static Map<String, dynamic> platinum() {
    return {
      'pickupPriority': 'urgent',
      'pickupDiscount': 20,
      'pointsMultiplier': 2.0,
      'maxPickupsPerMonth': -1, // unlimited
      'freePickups': 5,
      'support': '2h response',
      'features': [
        'VIP pickup scheduling',
        '2x points multiplier',
        '20% pickup discount',
        '5 free pickups/month',
        'Priority chat support',
        'Exclusive events & rewards',
        'Personal account manager',
        'Custom pickup slots',
      ],
    };
  }

  static Map<String, dynamic> forTier(MembershipTier tier) {
    switch (tier) {
      case MembershipTier.basic:
        return basic();
      case MembershipTier.gold:
        return gold();
      case MembershipTier.platinum:
        return platinum();
    }
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
