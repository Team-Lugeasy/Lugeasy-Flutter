import 'package:json_annotation/json_annotation.dart';

part 'host_availability_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class HostAvailabilityModel {
  HostAvailabilityModel({
    required this.hostId,
    required this.availableDates,
  });

  final int hostId;
  final List<AvailableDate> availableDates;

  factory HostAvailabilityModel.fromJson(Map<String, dynamic> json) =>
      _$HostAvailabilityModelFromJson(json);
  Map<String, dynamic> toJson() => _$HostAvailabilityModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AvailableDate {
  AvailableDate({
    required this.date,
    required this.availableTimes,
  });

  final String date;
  final List<String> availableTimes;

  factory AvailableDate.fromJson(Map<String, dynamic> json) =>
      _$AvailableDateFromJson(json);
  Map<String, dynamic> toJson() => _$AvailableDateToJson(this);
}
