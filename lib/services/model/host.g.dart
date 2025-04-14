// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'host.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Host _$HostFromJson(Map<String, dynamic> json) => Host(
      name: json['name'] as String,
      profileImage: json['profile_image'] as String,
      reviewRate: (json['review_rate'] as num).toDouble(),
      reviewCount: (json['review_count'] as num).toInt(),
      address: json['address'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$HostToJson(Host instance) => <String, dynamic>{
      'name': instance.name,
      'profile_image': instance.profileImage,
      'review_rate': instance.reviewRate,
      'review_count': instance.reviewCount,
      'address': instance.address,
      'description': instance.description,
    };
