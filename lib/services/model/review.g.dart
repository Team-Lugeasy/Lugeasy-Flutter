// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Review _$ReviewFromJson(Map<String, dynamic> json) => Review(
      reviewId: (json['review_id'] as num).toInt(),
      reviewerName: json['reviewer_name'] as String,
      profileImage: json['profile_image'] as String,
      createdAt: json['created_at'] as String,
      contents: json['contents'] as String,
    );

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
      'review_id': instance.reviewId,
      'reviewer_name': instance.reviewerName,
      'profile_image': instance.profileImage,
      'created_at': instance.createdAt,
      'contents': instance.contents,
    };
