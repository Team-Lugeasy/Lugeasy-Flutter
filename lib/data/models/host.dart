import 'package:json_annotation/json_annotation.dart';

part 'host.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Host {
  Host({
    required this.hostId,
    required this.name,
    required this.profileImage,
    required this.reviewRate,
    required this.reviewCount,
    required this.address,
    required this.description,
    required this.latitude,
    required this.longitude,
  });
  int hostId;
  String name;
  String profileImage;
  double reviewRate;
  int reviewCount;
  String address;
  String description;
  double latitude;
  double longitude;

  factory Host.fromJson(Map<String, dynamic> json) => _$HostFromJson(json);
  Map<String, dynamic> toJson() => _$HostToJson(this);
}
