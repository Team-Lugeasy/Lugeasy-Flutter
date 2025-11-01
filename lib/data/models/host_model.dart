import 'package:json_annotation/json_annotation.dart';

part 'host_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class HostModel {
  HostModel({
    required this.hostId,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.reviewCount,
    required this.reviewRate,
    required this.profileImg,
    required this.address,
  });

  final int hostId;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final int reviewCount;
  final double reviewRate;
  final String profileImg;
  final String address;

  factory HostModel.fromJson(Map<String, dynamic> json) =>
      _$HostModelFromJson(json);
  Map<String, dynamic> toJson() => _$HostModelToJson(this);
}
