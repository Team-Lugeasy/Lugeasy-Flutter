import 'package:json_annotation/json_annotation.dart';

part 'match.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Match {
  Match(
      {required this.matchId,
      required this.profileImage,
      required this.timeStamp,
      required this.message,
      required this.matchType});
  int matchId;
  String profileImage;
  String timeStamp;
  String message;
  String matchType;

  factory Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);
  Map<String, dynamic> toJson() => _$MatchToJson(this);
}
