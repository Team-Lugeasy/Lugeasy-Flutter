import 'package:json_annotation/json_annotation.dart';

part 'match_model.g.dart';

enum MatchingState {
  @JsonValue('REQUESTED')
  requested,
  @JsonValue('ACCEPTED')
  accepted,
  @JsonValue('COMPLETED')
  completed,
}

enum UserRole {
  @JsonValue('HOST')
  host,
  @JsonValue('MEMBER')
  member,
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MatchModel {
  MatchModel({
    required this.matchId,
    required this.hostId,
    required this.hostName,
    required this.hostAddress,
    required this.memberId,
    required this.memberName,
    required this.dropOffTime,
    required this.findingTime,
    required this.status,
    required this.userRole,
    required this.createdAt,
  });

  final int matchId;
  final int hostId;
  final String hostName;
  final String hostAddress;
  final int memberId;
  final String memberName;
  final String dropOffTime;
  final String findingTime;
  final MatchingState status;
  final UserRole userRole;
  final String createdAt;

  factory MatchModel.fromJson(Map<String, dynamic> json) =>
      _$MatchModelFromJson(json);
  Map<String, dynamic> toJson() => _$MatchModelToJson(this);
}
