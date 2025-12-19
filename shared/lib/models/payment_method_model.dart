import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'payment_method_model.freezed.dart';
part 'payment_method_model.g.dart';

@freezed
class PaymentMethodModel with _$PaymentMethodModel {
  const factory PaymentMethodModel({
    required String id,
    required String userId,

    // Payment Type
    required String type, // 'bank_transfer', 'e_wallet', 'credit_card'
    required String provider, // 'BCA', 'Mandiri', 'GoPay', 'OVO', etc.

    // Account Info
    required String accountName,
    String? accountNumber, // For bank transfer
    String? phoneNumber, // For e-wallet
    String? cardNumber, // Last 4 digits for credit card

    // Status
    @Default(false) bool isPrimary,
    @Default(true) bool isActive,

    // Timestamps
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? createdAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? updatedAt,
  }) = _PaymentMethodModel;

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodModelFromJson(json);

  factory PaymentMethodModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PaymentMethodModel.fromJson({...data, 'id': doc.id});
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
