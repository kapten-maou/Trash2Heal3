// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventItemModelImpl _$$EventItemModelImplFromJson(Map<String, dynamic> json) =>
    _$EventItemModelImpl(
      id: json['id'] as String,
      eventId: json['eventId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      type: $enumDecode(_$EventItemTypeEnumMap, json['type']),
      pointsRequired: (json['pointsRequired'] as num).toInt(),
      stock: (json['stock'] as num).toInt(),
      claimed: (json['claimed'] as num?)?.toInt() ?? 0,
      reserved: (json['reserved'] as num?)?.toInt() ?? 0,
      status: $enumDecode(_$EventItemStatusEnumMap, json['status']),
      provider: json['provider'] as String?,
      category: json['category'] as String?,
      value: (json['value'] as num?)?.toInt(),
      unit: json['unit'] as String?,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      specifications: json['specifications'] as Map<String, dynamic>?,
      terms: json['terms'] as String?,
      instructions: json['instructions'] as String?,
      maxClaimPerUser: (json['maxClaimPerUser'] as num?)?.toInt() ?? 1,
      isActive: json['isActive'] as bool? ?? true,
      isFeatured: json['isFeatured'] as bool? ?? false,
      displayOrder: (json['displayOrder'] as num?)?.toInt(),
      availableFrom: _timestampFromJson(json['availableFrom']),
      availableUntil: _timestampFromJson(json['availableUntil']),
      createdAt: _timestampFromJson(json['createdAt']),
      updatedAt: _timestampFromJson(json['updatedAt']),
      createdBy: json['createdBy'] as String?,
      updatedBy: json['updatedBy'] as String?,
    );

Map<String, dynamic> _$$EventItemModelImplToJson(
        _$EventItemModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventId': instance.eventId,
      'name': instance.name,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'type': _$EventItemTypeEnumMap[instance.type]!,
      'pointsRequired': instance.pointsRequired,
      'stock': instance.stock,
      'claimed': instance.claimed,
      'reserved': instance.reserved,
      'status': _$EventItemStatusEnumMap[instance.status]!,
      'provider': instance.provider,
      'category': instance.category,
      'value': instance.value,
      'unit': instance.unit,
      'imageUrls': instance.imageUrls,
      'specifications': instance.specifications,
      'terms': instance.terms,
      'instructions': instance.instructions,
      'maxClaimPerUser': instance.maxClaimPerUser,
      'isActive': instance.isActive,
      'isFeatured': instance.isFeatured,
      'displayOrder': instance.displayOrder,
      'availableFrom': _timestampToJson(instance.availableFrom),
      'availableUntil': _timestampToJson(instance.availableUntil),
      'createdAt': _timestampToJson(instance.createdAt),
      'updatedAt': _timestampToJson(instance.updatedAt),
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
    };

const _$EventItemTypeEnumMap = {
  EventItemType.voucher: 'voucher',
  EventItemType.merchandise: 'merchandise',
  EventItemType.reward: 'reward',
  EventItemType.prize: 'prize',
};

const _$EventItemStatusEnumMap = {
  EventItemStatus.available: 'available',
  EventItemStatus.lowStock: 'low_stock',
  EventItemStatus.outOfStock: 'out_of_stock',
  EventItemStatus.discontinued: 'discontinued',
};
