// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationState _$ReservationStateFromJson(Map<String, dynamic> json) =>
    ReservationState(
      dropOffDate: json['drop_off_date'] == null
          ? null
          : DateTime.parse(json['drop_off_date'] as String),
      findingDate: json['finding_date'] == null
          ? null
          : DateTime.parse(json['finding_date'] as String),
      dropOffSlot:
          $enumDecodeNullable(_$TimeSlotEnumMap, json['drop_off_slot']),
      findingSlot: $enumDecodeNullable(_$TimeSlotEnumMap, json['finding_slot']),
    );

Map<String, dynamic> _$ReservationStateToJson(ReservationState instance) =>
    <String, dynamic>{
      'drop_off_date': instance.dropOffDate?.toIso8601String(),
      'finding_date': instance.findingDate?.toIso8601String(),
      'drop_off_slot': _$TimeSlotEnumMap[instance.dropOffSlot],
      'finding_slot': _$TimeSlotEnumMap[instance.findingSlot],
    };

const _$TimeSlotEnumMap = {
  TimeSlot.t0001: 't0001',
  TimeSlot.t0102: 't0102',
  TimeSlot.t0203: 't0203',
  TimeSlot.t0304: 't0304',
  TimeSlot.t0405: 't0405',
  TimeSlot.t0506: 't0506',
  TimeSlot.t0607: 't0607',
  TimeSlot.t0708: 't0708',
  TimeSlot.t0809: 't0809',
  TimeSlot.t0910: 't0910',
  TimeSlot.t1011: 't1011',
  TimeSlot.t1112: 't1112',
  TimeSlot.t1213: 't1213',
  TimeSlot.t1314: 't1314',
  TimeSlot.t1415: 't1415',
  TimeSlot.t1516: 't1516',
  TimeSlot.t1617: 't1617',
  TimeSlot.t1718: 't1718',
  TimeSlot.t1819: 't1819',
  TimeSlot.t1920: 't1920',
  TimeSlot.t2021: 't2021',
  TimeSlot.t2122: 't2122',
  TimeSlot.t2223: 't2223',
  TimeSlot.t2324: 't2324',
};
