// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voucher_scan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VoucherScanModelImpl _$$VoucherScanModelImplFromJson(
        Map<String, dynamic> json) =>
    _$VoucherScanModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      eventId: json['eventId'] as String,
      eventName: json['eventName'] as String,
      itemId: json['itemId'] as String,
      itemName: json['itemName'] as String,
      voucherCode: json['voucherCode'] as String,
      status: $enumDecode(_$ScanStatusEnumMap, json['status']),
      scannedAt: _requiredTimestampFromJson(json['scannedAt']),
      scannedBy: json['scannedBy'] as String,
      scannedByName: json['scannedByName'] as String?,
      location: json['location'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      deviceId: json['deviceId'] as String?,
      deviceInfo: json['deviceInfo'] as String?,
      remarks: json['remarks'] as String?,
      invalidReason: json['invalidReason'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      isFraudulent: json['isFraudulent'] as bool? ?? false,
      fraudReason: json['fraudReason'] as String?,
      verifiedAt: _timestampFromJson(json['verifiedAt']),
      verifiedBy: json['verifiedBy'] as String?,
      createdAt: _timestampFromJson(json['createdAt']),
      updatedAt: _timestampFromJson(json['updatedAt']),
    );

Map<String, dynamic> _$$VoucherScanModelImplToJson(
        _$VoucherScanModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userName': instance.userName,
      'eventId': instance.eventId,
      'eventName': instance.eventName,
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'voucherCode': instance.voucherCode,
      'status': _$ScanStatusEnumMap[instance.status]!,
      'scannedAt': _timestampToJson(instance.scannedAt),
      'scannedBy': instance.scannedBy,
      'scannedByName': instance.scannedByName,
      'location': instance.location,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'deviceId': instance.deviceId,
      'deviceInfo': instance.deviceInfo,
      'remarks': instance.remarks,
      'invalidReason': instance.invalidReason,
      'metadata': instance.metadata,
      'isFraudulent': instance.isFraudulent,
      'fraudReason': instance.fraudReason,
      'verifiedAt': _timestampToJson(instance.verifiedAt),
      'verifiedBy': instance.verifiedBy,
      'createdAt': _timestampToJson(instance.createdAt),
      'updatedAt': _timestampToJson(instance.updatedAt),
    };

const _$ScanStatusEnumMap = {
  ScanStatus.valid: 'valid',
  ScanStatus.used: 'used',
  ScanStatus.expired: 'expired',
  ScanStatus.invalid: 'invalid',
  ScanStatus.fraud: 'fraud',
};
