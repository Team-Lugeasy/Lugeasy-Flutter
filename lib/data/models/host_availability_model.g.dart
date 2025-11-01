// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'host_availability_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HostAvailabilityModel _$HostAvailabilityModelFromJson(
        Map<String, dynamic> json) =>
    HostAvailabilityModel(
      hostId: (json['host_id'] as num).toInt(),
      availableDates: (json['available_dates'] as List<dynamic>)
          .map((e) => AvailableDate.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HostAvailabilityModelToJson(
        HostAvailabilityModel instance) =>
    <String, dynamic>{
      'host_id': instance.hostId,
      'available_dates': instance.availableDates,
    };

AvailableDate _$AvailableDateFromJson(Map<String, dynamic> json) =>
    AvailableDate(
      date: json['date'] as String,
      availableTimes: (json['available_times'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$AvailableDateToJson(AvailableDate instance) =>
    <String, dynamic>{
      'date': instance.date,
      'available_times': instance.availableTimes,
    };
