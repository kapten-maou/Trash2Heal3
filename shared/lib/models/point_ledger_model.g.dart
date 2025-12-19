// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_ledger_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PointLedgerModelImpl _$$PointLedgerModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PointLedgerModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: $enumDecode(_$PointTransactionTypeEnumMap, json['type']),
      amount: (json['amount'] as num).toInt(),
      description: json['description'] as String,
      relatedId: json['relatedId'] as String?,
      relatedCollection: json['relatedCollection'] as String?,
      balanceAfter: (json['balanceAfter'] as num?)?.toInt(),
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: _timestampFromJson(json['createdAt']),
    );

Map<String, dynamic> _$$PointLedgerModelImplToJson(
        _$PointLedgerModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': _$PointTransactionTypeEnumMap[instance.type]!,
      'amount': instance.amount,
      'description': instance.description,
      'relatedId': instance.relatedId,
      'relatedCollection': instance.relatedCollection,
      'balanceAfter': instance.balanceAfter,
      'metadata': instance.metadata,
      'createdAt': _timestampToJson(instance.createdAt),
    };

const _$PointTransactionTypeEnumMap = {
  PointTransactionType.earn: 'earn',
  PointTransactionType.redeem: 'redeem',
  PointTransactionType.refund: 'refund',
  PointTransactionType.bonus: 'bonus',
  PointTransactionType.penalty: 'penalty',
};
