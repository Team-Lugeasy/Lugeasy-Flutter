// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Match _$MatchFromJson(Map<String, dynamic> json) => Match(
      matchId: (json['match_id'] as num).toInt(),
      profileImage: json['profile_image'] as String,
      timeStamp: json['time_stamp'] as String,
      message: json['message'] as String,
      matchType: json['match_type'] as String,
    );

Map<String, dynamic> _$MatchToJson(Match instance) => <String, dynamic>{
      'match_id': instance.matchId,
      'profile_image': instance.profileImage,
      'time_stamp': instance.timeStamp,
      'message': instance.message,
      'match_type': instance.matchType,
    };
