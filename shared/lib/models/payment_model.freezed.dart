// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) {
  return _PaymentModel.fromJson(json);
}

/// @nodoc
mixin _$PaymentModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String get userEmail => throw _privateConstructorUsedError;
  String? get membershipId => throw _privateConstructorUsedError;
  PaymentType get type => throw _privateConstructorUsedError;
  PaymentMethod get method => throw _privateConstructorUsedError;
  PaymentStatus get status => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  int get discount => throw _privateConstructorUsedError;
  int get tax => throw _privateConstructorUsedError;
  int get totalAmount => throw _privateConstructorUsedError;
  String? get currency => throw _privateConstructorUsedError;
  String? get orderId => throw _privateConstructorUsedError;
  String? get transactionId => throw _privateConstructorUsedError;
  String? get invoiceNumber => throw _privateConstructorUsedError;
  Map<String, dynamic>? get paymentDetails =>
      throw _privateConstructorUsedError;
  String? get provider => throw _privateConstructorUsedError;
  String? get providerReference => throw _privateConstructorUsedError;
  String? get vaNumber => throw _privateConstructorUsedError;
  String? get qrCode => throw _privateConstructorUsedError;
  String? get paymentUrl => throw _privateConstructorUsedError;
  String? get promoCode => throw _privateConstructorUsedError;
  Map<String, dynamic>? get itemDetails => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get paidAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get expiryDate => throw _privateConstructorUsedError;
  String? get failureReason => throw _privateConstructorUsedError;
  String? get refundReason => throw _privateConstructorUsedError;
  int? get refundAmount => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get refundedAt => throw _privateConstructorUsedError;
  String? get refundedBy => throw _privateConstructorUsedError;
  String? get cancelReason => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get cancelledAt => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  bool get isVerified => throw _privateConstructorUsedError;
  String? get verifiedBy => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get verifiedAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaymentModelCopyWith<PaymentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentModelCopyWith<$Res> {
  factory $PaymentModelCopyWith(
          PaymentModel value, $Res Function(PaymentModel) then) =
      _$PaymentModelCopyWithImpl<$Res, PaymentModel>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String userName,
      String userEmail,
      String? membershipId,
      PaymentType type,
      PaymentMethod method,
      PaymentStatus status,
      int amount,
      int discount,
      int tax,
      int totalAmount,
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
      bool isVerified,
      String? verifiedBy,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? verifiedAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? updatedAt});
}

/// @nodoc
class _$PaymentModelCopyWithImpl<$Res, $Val extends PaymentModel>
    implements $PaymentModelCopyWith<$Res> {
  _$PaymentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userName = null,
    Object? userEmail = null,
    Object? membershipId = freezed,
    Object? type = null,
    Object? method = null,
    Object? status = null,
    Object? amount = null,
    Object? discount = null,
    Object? tax = null,
    Object? totalAmount = null,
    Object? currency = freezed,
    Object? orderId = freezed,
    Object? transactionId = freezed,
    Object? invoiceNumber = freezed,
    Object? paymentDetails = freezed,
    Object? provider = freezed,
    Object? providerReference = freezed,
    Object? vaNumber = freezed,
    Object? qrCode = freezed,
    Object? paymentUrl = freezed,
    Object? promoCode = freezed,
    Object? itemDetails = freezed,
    Object? paidAt = freezed,
    Object? expiryDate = freezed,
    Object? failureReason = freezed,
    Object? refundReason = freezed,
    Object? refundAmount = freezed,
    Object? refundedAt = freezed,
    Object? refundedBy = freezed,
    Object? cancelReason = freezed,
    Object? cancelledAt = freezed,
    Object? metadata = freezed,
    Object? notes = freezed,
    Object? isVerified = null,
    Object? verifiedBy = freezed,
    Object? verifiedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userEmail: null == userEmail
          ? _value.userEmail
          : userEmail // ignore: cast_nullable_to_non_nullable
              as String,
      membershipId: freezed == membershipId
          ? _value.membershipId
          : membershipId // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PaymentType,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as PaymentMethod,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PaymentStatus,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      discount: null == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as int,
      tax: null == tax
          ? _value.tax
          : tax // ignore: cast_nullable_to_non_nullable
              as int,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as int,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      orderId: freezed == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionId: freezed == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String?,
      invoiceNumber: freezed == invoiceNumber
          ? _value.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentDetails: freezed == paymentDetails
          ? _value.paymentDetails
          : paymentDetails // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      provider: freezed == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String?,
      providerReference: freezed == providerReference
          ? _value.providerReference
          : providerReference // ignore: cast_nullable_to_non_nullable
              as String?,
      vaNumber: freezed == vaNumber
          ? _value.vaNumber
          : vaNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      qrCode: freezed == qrCode
          ? _value.qrCode
          : qrCode // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentUrl: freezed == paymentUrl
          ? _value.paymentUrl
          : paymentUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      promoCode: freezed == promoCode
          ? _value.promoCode
          : promoCode // ignore: cast_nullable_to_non_nullable
              as String?,
      itemDetails: freezed == itemDetails
          ? _value.itemDetails
          : itemDetails // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      paidAt: freezed == paidAt
          ? _value.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      failureReason: freezed == failureReason
          ? _value.failureReason
          : failureReason // ignore: cast_nullable_to_non_nullable
              as String?,
      refundReason: freezed == refundReason
          ? _value.refundReason
          : refundReason // ignore: cast_nullable_to_non_nullable
              as String?,
      refundAmount: freezed == refundAmount
          ? _value.refundAmount
          : refundAmount // ignore: cast_nullable_to_non_nullable
              as int?,
      refundedAt: freezed == refundedAt
          ? _value.refundedAt
          : refundedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      refundedBy: freezed == refundedBy
          ? _value.refundedBy
          : refundedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      cancelReason: freezed == cancelReason
          ? _value.cancelReason
          : cancelReason // ignore: cast_nullable_to_non_nullable
              as String?,
      cancelledAt: freezed == cancelledAt
          ? _value.cancelledAt
          : cancelledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      verifiedBy: freezed == verifiedBy
          ? _value.verifiedBy
          : verifiedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      verifiedAt: freezed == verifiedAt
          ? _value.verifiedAt
          : verifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentModelImplCopyWith<$Res>
    implements $PaymentModelCopyWith<$Res> {
  factory _$$PaymentModelImplCopyWith(
          _$PaymentModelImpl value, $Res Function(_$PaymentModelImpl) then) =
      __$$PaymentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String userName,
      String userEmail,
      String? membershipId,
      PaymentType type,
      PaymentMethod method,
      PaymentStatus status,
      int amount,
      int discount,
      int tax,
      int totalAmount,
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
      bool isVerified,
      String? verifiedBy,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? verifiedAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      DateTime? updatedAt});
}

/// @nodoc
class __$$PaymentModelImplCopyWithImpl<$Res>
    extends _$PaymentModelCopyWithImpl<$Res, _$PaymentModelImpl>
    implements _$$PaymentModelImplCopyWith<$Res> {
  __$$PaymentModelImplCopyWithImpl(
      _$PaymentModelImpl _value, $Res Function(_$PaymentModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userName = null,
    Object? userEmail = null,
    Object? membershipId = freezed,
    Object? type = null,
    Object? method = null,
    Object? status = null,
    Object? amount = null,
    Object? discount = null,
    Object? tax = null,
    Object? totalAmount = null,
    Object? currency = freezed,
    Object? orderId = freezed,
    Object? transactionId = freezed,
    Object? invoiceNumber = freezed,
    Object? paymentDetails = freezed,
    Object? provider = freezed,
    Object? providerReference = freezed,
    Object? vaNumber = freezed,
    Object? qrCode = freezed,
    Object? paymentUrl = freezed,
    Object? promoCode = freezed,
    Object? itemDetails = freezed,
    Object? paidAt = freezed,
    Object? expiryDate = freezed,
    Object? failureReason = freezed,
    Object? refundReason = freezed,
    Object? refundAmount = freezed,
    Object? refundedAt = freezed,
    Object? refundedBy = freezed,
    Object? cancelReason = freezed,
    Object? cancelledAt = freezed,
    Object? metadata = freezed,
    Object? notes = freezed,
    Object? isVerified = null,
    Object? verifiedBy = freezed,
    Object? verifiedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$PaymentModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userEmail: null == userEmail
          ? _value.userEmail
          : userEmail // ignore: cast_nullable_to_non_nullable
              as String,
      membershipId: freezed == membershipId
          ? _value.membershipId
          : membershipId // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PaymentType,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as PaymentMethod,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PaymentStatus,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      discount: null == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as int,
      tax: null == tax
          ? _value.tax
          : tax // ignore: cast_nullable_to_non_nullable
              as int,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as int,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      orderId: freezed == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionId: freezed == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String?,
      invoiceNumber: freezed == invoiceNumber
          ? _value.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentDetails: freezed == paymentDetails
          ? _value._paymentDetails
          : paymentDetails // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      provider: freezed == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String?,
      providerReference: freezed == providerReference
          ? _value.providerReference
          : providerReference // ignore: cast_nullable_to_non_nullable
              as String?,
      vaNumber: freezed == vaNumber
          ? _value.vaNumber
          : vaNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      qrCode: freezed == qrCode
          ? _value.qrCode
          : qrCode // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentUrl: freezed == paymentUrl
          ? _value.paymentUrl
          : paymentUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      promoCode: freezed == promoCode
          ? _value.promoCode
          : promoCode // ignore: cast_nullable_to_non_nullable
              as String?,
      itemDetails: freezed == itemDetails
          ? _value._itemDetails
          : itemDetails // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      paidAt: freezed == paidAt
          ? _value.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      failureReason: freezed == failureReason
          ? _value.failureReason
          : failureReason // ignore: cast_nullable_to_non_nullable
              as String?,
      refundReason: freezed == refundReason
          ? _value.refundReason
          : refundReason // ignore: cast_nullable_to_non_nullable
              as String?,
      refundAmount: freezed == refundAmount
          ? _value.refundAmount
          : refundAmount // ignore: cast_nullable_to_non_nullable
              as int?,
      refundedAt: freezed == refundedAt
          ? _value.refundedAt
          : refundedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      refundedBy: freezed == refundedBy
          ? _value.refundedBy
          : refundedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      cancelReason: freezed == cancelReason
          ? _value.cancelReason
          : cancelReason // ignore: cast_nullable_to_non_nullable
              as String?,
      cancelledAt: freezed == cancelledAt
          ? _value.cancelledAt
          : cancelledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      verifiedBy: freezed == verifiedBy
          ? _value.verifiedBy
          : verifiedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      verifiedAt: freezed == verifiedAt
          ? _value.verifiedAt
          : verifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentModelImpl extends _PaymentModel {
  const _$PaymentModelImpl(
      {required this.id,
      required this.userId,
      required this.userName,
      required this.userEmail,
      this.membershipId,
      required this.type,
      required this.method,
      required this.status,
      required this.amount,
      this.discount = 0,
      this.tax = 0,
      required this.totalAmount,
      this.currency,
      this.orderId,
      this.transactionId,
      this.invoiceNumber,
      final Map<String, dynamic>? paymentDetails,
      this.provider,
      this.providerReference,
      this.vaNumber,
      this.qrCode,
      this.paymentUrl,
      this.promoCode,
      final Map<String, dynamic>? itemDetails,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.paidAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.expiryDate,
      this.failureReason,
      this.refundReason,
      this.refundAmount,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.refundedAt,
      this.refundedBy,
      this.cancelReason,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.cancelledAt,
      final Map<String, dynamic>? metadata,
      this.notes,
      this.isVerified = false,
      this.verifiedBy,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.verifiedAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      this.updatedAt})
      : _paymentDetails = paymentDetails,
        _itemDetails = itemDetails,
        _metadata = metadata,
        super._();

  factory _$PaymentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String userName;
  @override
  final String userEmail;
  @override
  final String? membershipId;
  @override
  final PaymentType type;
  @override
  final PaymentMethod method;
  @override
  final PaymentStatus status;
  @override
  final int amount;
  @override
  @JsonKey()
  final int discount;
  @override
  @JsonKey()
  final int tax;
  @override
  final int totalAmount;
  @override
  final String? currency;
  @override
  final String? orderId;
  @override
  final String? transactionId;
  @override
  final String? invoiceNumber;
  final Map<String, dynamic>? _paymentDetails;
  @override
  Map<String, dynamic>? get paymentDetails {
    final value = _paymentDetails;
    if (value == null) return null;
    if (_paymentDetails is EqualUnmodifiableMapView) return _paymentDetails;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? provider;
  @override
  final String? providerReference;
  @override
  final String? vaNumber;
  @override
  final String? qrCode;
  @override
  final String? paymentUrl;
  @override
  final String? promoCode;
  final Map<String, dynamic>? _itemDetails;
  @override
  Map<String, dynamic>? get itemDetails {
    final value = _itemDetails;
    if (value == null) return null;
    if (_itemDetails is EqualUnmodifiableMapView) return _itemDetails;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? paidAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? expiryDate;
  @override
  final String? failureReason;
  @override
  final String? refundReason;
  @override
  final int? refundAmount;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? refundedAt;
  @override
  final String? refundedBy;
  @override
  final String? cancelReason;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? cancelledAt;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? notes;
  @override
  @JsonKey()
  final bool isVerified;
  @override
  final String? verifiedBy;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? verifiedAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? createdAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'PaymentModel(id: $id, userId: $userId, userName: $userName, userEmail: $userEmail, membershipId: $membershipId, type: $type, method: $method, status: $status, amount: $amount, discount: $discount, tax: $tax, totalAmount: $totalAmount, currency: $currency, orderId: $orderId, transactionId: $transactionId, invoiceNumber: $invoiceNumber, paymentDetails: $paymentDetails, provider: $provider, providerReference: $providerReference, vaNumber: $vaNumber, qrCode: $qrCode, paymentUrl: $paymentUrl, promoCode: $promoCode, itemDetails: $itemDetails, paidAt: $paidAt, expiryDate: $expiryDate, failureReason: $failureReason, refundReason: $refundReason, refundAmount: $refundAmount, refundedAt: $refundedAt, refundedBy: $refundedBy, cancelReason: $cancelReason, cancelledAt: $cancelledAt, metadata: $metadata, notes: $notes, isVerified: $isVerified, verifiedBy: $verifiedBy, verifiedAt: $verifiedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userEmail, userEmail) ||
                other.userEmail == userEmail) &&
            (identical(other.membershipId, membershipId) ||
                other.membershipId == membershipId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.tax, tax) || other.tax == tax) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.invoiceNumber, invoiceNumber) ||
                other.invoiceNumber == invoiceNumber) &&
            const DeepCollectionEquality()
                .equals(other._paymentDetails, _paymentDetails) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.providerReference, providerReference) ||
                other.providerReference == providerReference) &&
            (identical(other.vaNumber, vaNumber) ||
                other.vaNumber == vaNumber) &&
            (identical(other.qrCode, qrCode) || other.qrCode == qrCode) &&
            (identical(other.paymentUrl, paymentUrl) ||
                other.paymentUrl == paymentUrl) &&
            (identical(other.promoCode, promoCode) ||
                other.promoCode == promoCode) &&
            const DeepCollectionEquality()
                .equals(other._itemDetails, _itemDetails) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.failureReason, failureReason) ||
                other.failureReason == failureReason) &&
            (identical(other.refundReason, refundReason) ||
                other.refundReason == refundReason) &&
            (identical(other.refundAmount, refundAmount) ||
                other.refundAmount == refundAmount) &&
            (identical(other.refundedAt, refundedAt) ||
                other.refundedAt == refundedAt) &&
            (identical(other.refundedBy, refundedBy) ||
                other.refundedBy == refundedBy) &&
            (identical(other.cancelReason, cancelReason) ||
                other.cancelReason == cancelReason) &&
            (identical(other.cancelledAt, cancelledAt) ||
                other.cancelledAt == cancelledAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.verifiedBy, verifiedBy) ||
                other.verifiedBy == verifiedBy) &&
            (identical(other.verifiedAt, verifiedAt) ||
                other.verifiedAt == verifiedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        userName,
        userEmail,
        membershipId,
        type,
        method,
        status,
        amount,
        discount,
        tax,
        totalAmount,
        currency,
        orderId,
        transactionId,
        invoiceNumber,
        const DeepCollectionEquality().hash(_paymentDetails),
        provider,
        providerReference,
        vaNumber,
        qrCode,
        paymentUrl,
        promoCode,
        const DeepCollectionEquality().hash(_itemDetails),
        paidAt,
        expiryDate,
        failureReason,
        refundReason,
        refundAmount,
        refundedAt,
        refundedBy,
        cancelReason,
        cancelledAt,
        const DeepCollectionEquality().hash(_metadata),
        notes,
        isVerified,
        verifiedBy,
        verifiedAt,
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentModelImplCopyWith<_$PaymentModelImpl> get copyWith =>
      __$$PaymentModelImplCopyWithImpl<_$PaymentModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentModelImplToJson(
      this,
    );
  }
}

abstract class _PaymentModel extends PaymentModel {
  const factory _PaymentModel(
      {required final String id,
      required final String userId,
      required final String userName,
      required final String userEmail,
      final String? membershipId,
      required final PaymentType type,
      required final PaymentMethod method,
      required final PaymentStatus status,
      required final int amount,
      final int discount,
      final int tax,
      required final int totalAmount,
      final String? currency,
      final String? orderId,
      final String? transactionId,
      final String? invoiceNumber,
      final Map<String, dynamic>? paymentDetails,
      final String? provider,
      final String? providerReference,
      final String? vaNumber,
      final String? qrCode,
      final String? paymentUrl,
      final String? promoCode,
      final Map<String, dynamic>? itemDetails,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? paidAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? expiryDate,
      final String? failureReason,
      final String? refundReason,
      final int? refundAmount,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? refundedAt,
      final String? refundedBy,
      final String? cancelReason,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? cancelledAt,
      final Map<String, dynamic>? metadata,
      final String? notes,
      final bool isVerified,
      final String? verifiedBy,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? verifiedAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? createdAt,
      @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
      final DateTime? updatedAt}) = _$PaymentModelImpl;
  const _PaymentModel._() : super._();

  factory _PaymentModel.fromJson(Map<String, dynamic> json) =
      _$PaymentModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get userName;
  @override
  String get userEmail;
  @override
  String? get membershipId;
  @override
  PaymentType get type;
  @override
  PaymentMethod get method;
  @override
  PaymentStatus get status;
  @override
  int get amount;
  @override
  int get discount;
  @override
  int get tax;
  @override
  int get totalAmount;
  @override
  String? get currency;
  @override
  String? get orderId;
  @override
  String? get transactionId;
  @override
  String? get invoiceNumber;
  @override
  Map<String, dynamic>? get paymentDetails;
  @override
  String? get provider;
  @override
  String? get providerReference;
  @override
  String? get vaNumber;
  @override
  String? get qrCode;
  @override
  String? get paymentUrl;
  @override
  String? get promoCode;
  @override
  Map<String, dynamic>? get itemDetails;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get paidAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get expiryDate;
  @override
  String? get failureReason;
  @override
  String? get refundReason;
  @override
  int? get refundAmount;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get refundedAt;
  @override
  String? get refundedBy;
  @override
  String? get cancelReason;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get cancelledAt;
  @override
  Map<String, dynamic>? get metadata;
  @override
  String? get notes;
  @override
  bool get isVerified;
  @override
  String? get verifiedBy;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get verifiedAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get createdAt;
  @override
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$PaymentModelImplCopyWith<_$PaymentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
