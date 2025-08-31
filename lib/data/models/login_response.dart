import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final int memberId;
  final bool isMembered;
  final String name;

  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.memberId,
    required this.isMembered,
    required this.name,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
