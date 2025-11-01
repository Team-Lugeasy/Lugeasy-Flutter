// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'host_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HostModel _$HostModelFromJson(Map<String, dynamic> json) => HostModel(
      hostId: (json['host_id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      reviewCount: (json['review_count'] as num).toInt(),
      reviewRate: (json['review_rate'] as num).toDouble(),
      profileImg: json['profile_img'] as String,
      address: json['address'] as String,
    );

Map<String, dynamic> _$HostModelToJson(HostModel instance) => <String, dynamic>{
      'host_id': instance.hostId,
      'name': instance.name,
      'description': instance.description,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'review_count': instance.reviewCount,
      'review_rate': instance.reviewRate,
      'profile_img': instance.profileImg,
      'address': instance.address,
    };
