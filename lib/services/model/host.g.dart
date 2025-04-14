// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'host.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Host _$HostFromJson(Map<String, dynamic> json) => Host(
      name: json['name'] as String,
      profileImage: json['profileImage'] as String,
      reviewRate: (json['reviewRate'] as num).toDouble(),
      reviewCount: (json['reviewCount'] as num).toInt(),
      address: json['address'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$HostToJson(Host instance) => <String, dynamic>{
      'name': instance.name,
      'profileImage': instance.profileImage,
      'reviewRate': instance.reviewRate,
      'reviewCount': instance.reviewCount,
      'address': instance.address,
      'description': instance.description,
    };
