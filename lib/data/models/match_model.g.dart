// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchModel _$MatchModelFromJson(Map<String, dynamic> json) => MatchModel(
      matchId: (json['match_id'] as num).toInt(),
      hostId: (json['host_id'] as num).toInt(),
      hostName: json['host_name'] as String,
      hostAddress: json['host_address'] as String,
      memberId: (json['member_id'] as num).toInt(),
      memberName: json['member_name'] as String,
      dropOffTime: json['drop_off_time'] as String,
      findingTime: json['finding_time'] as String,
      status: $enumDecode(_$MatchingStateEnumMap, json['status']),
      userRole: $enumDecode(_$UserRoleEnumMap, json['user_role']),
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$MatchModelToJson(MatchModel instance) =>
    <String, dynamic>{
      'match_id': instance.matchId,
      'host_id': instance.hostId,
      'host_name': instance.hostName,
      'host_address': instance.hostAddress,
      'member_id': instance.memberId,
      'member_name': instance.memberName,
      'drop_off_time': instance.dropOffTime,
      'finding_time': instance.findingTime,
      'status': _$MatchingStateEnumMap[instance.status]!,
      'user_role': _$UserRoleEnumMap[instance.userRole]!,
      'created_at': instance.createdAt,
    };

const _$MatchingStateEnumMap = {
  MatchingState.requested: 'REQUESTED',
  MatchingState.accepted: 'ACCEPTED',
  MatchingState.completed: 'COMPLETED',
};

const _$UserRoleEnumMap = {
  UserRole.host: 'HOST',
  UserRole.member: 'MEMBER',
};
