import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

@JsonSerializable(
    genericArgumentFactories: true, fieldRename: FieldRename.snake)
class ApiResponse<T> {
  final String timeStamp;
  final String code;
  final String message;
  final T? result;

  ApiResponse({
    required this.timeStamp,
    required this.code,
    required this.message,
    this.result,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);
}
