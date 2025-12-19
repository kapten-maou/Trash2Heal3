// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventModelImpl _$$EventModelImplFromJson(Map<String, dynamic> json) =>
    _$EventModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      location: json['location'] as String?,
      organizer: json['organizer'] as String?,
      startDate: _requiredTimestampFromJson(json['startDate']),
      endDate: _requiredTimestampFromJson(json['endDate']),
      status: $enumDecodeNullable(_$EventStatusEnumMap, json['status']) ??
          EventStatus.draft,
      participantCount: (json['participantCount'] as num?)?.toInt() ?? 0,
      maxParticipants: (json['maxParticipants'] as num?)?.toInt() ?? 0,
      itemsCount: (json['itemsCount'] as num?)?.toInt() ?? 0,
      totalPointsRequired: (json['totalPointsRequired'] as num?)?.toInt() ?? 0,
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      contactInfo: json['contactInfo'] as Map<String, dynamic>?,
      termsAndConditions: json['termsAndConditions'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      isFeatured: json['isFeatured'] as bool? ?? false,
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      createdAt: _timestampFromJson(json['createdAt']),
      updatedAt: _timestampFromJson(json['updatedAt']),
      createdBy: json['createdBy'] as String?,
      updatedBy: json['updatedBy'] as String?,
    );

Map<String, dynamic> _$$EventModelImplToJson(_$EventModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'location': instance.location,
      'organizer': instance.organizer,
      'startDate': _timestampToJson(instance.startDate),
      'endDate': _timestampToJson(instance.endDate),
      'status': _$EventStatusEnumMap[instance.status]!,
      'participantCount': instance.participantCount,
      'maxParticipants': instance.maxParticipants,
      'itemsCount': instance.itemsCount,
      'totalPointsRequired': instance.totalPointsRequired,
      'categories': instance.categories,
      'tags': instance.tags,
      'contactInfo': instance.contactInfo,
      'termsAndConditions': instance.termsAndConditions,
      'isActive': instance.isActive,
      'isFeatured': instance.isFeatured,
      'viewCount': instance.viewCount,
      'createdAt': _timestampToJson(instance.createdAt),
      'updatedAt': _timestampToJson(instance.updatedAt),
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
    };

const _$EventStatusEnumMap = {
  EventStatus.draft: 'draft',
  EventStatus.active: 'active',
  EventStatus.completed: 'completed',
  EventStatus.cancelled: 'cancelled',
};
