import 'package:json_annotation/json_annotation.dart';
import 'package:lugeasy/services/model/host_time_slot.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'reservation_state.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ReservationState {
  final DateTime? dropOffDate;
  final DateTime? findingDate;
  final TimeSlot? dropOffSlot;
  final TimeSlot? findingSlot;

  ReservationState({
    this.dropOffDate,
    this.findingDate,
    this.dropOffSlot,
    this.findingSlot,
  });

  ReservationState copyWith({
    DateTime? dropOffDate,
    DateTime? findingDate,
    TimeSlot? dropOffSlot,
    TimeSlot? findingSlot,
    bool clearFinding = false,
  }) {
    if (clearFinding) {
      return ReservationState(
        dropOffDate: dropOffDate ?? this.dropOffDate,
        dropOffSlot: dropOffSlot ?? this.dropOffSlot,
        findingDate: null,
        findingSlot: null,
      );
    }
    return ReservationState(
      dropOffDate: dropOffDate ?? this.dropOffDate,
      findingDate: findingDate ?? this.findingDate,
      dropOffSlot: dropOffSlot ?? this.dropOffSlot,
      findingSlot: findingSlot ?? this.findingSlot,
    );
  }

  bool get isComplete =>
      dropOffDate != null &&
      findingDate != null &&
      dropOffSlot != null &&
      findingSlot != null;

  factory ReservationState.fromJson(Map<String, dynamic> json) =>
      _$ReservationStateFromJson(json);
  Map<String, dynamic> toJson() => _$ReservationStateToJson(this);
}
