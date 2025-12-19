import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'payment_model.freezed.dart';
part 'payment_model.g.dart';

enum PaymentType {
  @JsonValue('membership')
  membership,
  @JsonValue('renewal')
  renewal,
  @JsonValue('upgrade')
  upgrade,
}

enum PaymentMethod {
  @JsonValue('bank_transfer')
  bankTransfer,
  @JsonValue('credit_card')
  creditCard,
  @JsonValue('ewallet')
  ewallet,
  @JsonValue('qris')
  qris,
  @JsonValue('virtual_account')
  virtualAccount,
}

enum PaymentStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('processing')
  processing,
  @JsonValue('paid')
  paid,
  @JsonValue('failed')
  failed,
  @JsonValue('expired')
  expired,
  @JsonValue('refunded')
  refunded,
  @JsonValue('cancelled')
  cancelled,
}

@freezed
class PaymentModel with _$PaymentModel {
  const PaymentModel._();
  const factory PaymentModel({
    required String id,
    required String userId,
    required String userName,
    required String userEmail,
    String? membershipId,
    required PaymentType type,
    required PaymentMethod method,
    required PaymentStatus status,
    required int amount,
    @Default(0) int discount,
    @Default(0) int tax,
    required int totalAmount,
    String? currency,
    String? orderId,
    String? transactionId,
    String? invoiceNumber,
    Map<String, dynamic>? paymentDetails,
    String? provider,
    String? providerReference,
    String? vaNumber,
    String? qrCode,
    String? paymentUrl,
    String? promoCode,
    Map<String, dynamic>? itemDetails,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? paidAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? expiryDate,
    String? failureReason,
    String? refundReason,
    int? refundAmount,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? refundedAt,
    String? refundedBy,
    String? cancelReason,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? cancelledAt,
    Map<String, dynamic>? metadata,
    String? notes,
    @Default(false) bool isVerified,
    String? verifiedBy,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? verifiedAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? createdAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    DateTime? updatedAt,
  }) = _PaymentModel;

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);

  factory PaymentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PaymentModel.fromJson({...data, 'id': doc.id});
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    return json;
  }
}

// Payment Provider Configs
class PaymentProviders {
  static const String midtrans = 'midtrans';
  static const String xendit = 'xendit';
  static const String doku = 'doku';
  static const String ipaymu = 'ipaymu';

  static Map<String, dynamic> getMidtransConfig() {
    return {
      'serverKey': 'YOUR_MIDTRANS_SERVER_KEY',
      'clientKey': 'YOUR_MIDTRANS_CLIENT_KEY',
      'isProduction': false,
      'merchantId': 'YOUR_MERCHANT_ID',
    };
  }

  static Map<String, dynamic> getXenditConfig() {
    return {
      'apiKey': 'YOUR_XENDIT_API_KEY',
      'webhookToken': 'YOUR_WEBHOOK_TOKEN',
      'isProduction': false,
    };
  }
}

// Payment Method Details
class PaymentMethodDetails {
  static Map<String, dynamic> bankTransfer({
    required String bankName,
    required String accountNumber,
    required String accountHolder,
  }) {
    return {
      'bankName': bankName,
      'accountNumber': accountNumber,
      'accountHolder': accountHolder,
    };
  }

  static Map<String, dynamic> creditCard({
    required String cardNumber,
    required String cardHolder,
    required String expiryMonth,
    required String expiryYear,
  }) {
    return {
      'cardNumber': cardNumber.replaceAll(' ', ''),
      'cardHolder': cardHolder,
      'expiryMonth': expiryMonth,
      'expiryYear': expiryYear,
    };
  }

  static Map<String, dynamic> ewallet({
    required String provider,
    required String phoneNumber,
  }) {
    return {
      'provider': provider, // gopay, ovo, dana, etc
      'phoneNumber': phoneNumber,
    };
  }

  static Map<String, dynamic> qris() {
    return {
      'type': 'qris',
      'description': 'Scan QR code to pay',
    };
  }

  static Map<String, dynamic> virtualAccount({
    required String bankCode,
  }) {
    return {
      'bankCode': bankCode, // bca, bni, mandiri, etc
      'type': 'virtual_account',
    };
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
