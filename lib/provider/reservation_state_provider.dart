import 'package:lugeasy/view/main/map/bottomsheet/hostdetailsheet/reservation/host_time_slot.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'reservation_state_provider.g.dart';

class ReservationState {
  final DateTime? selectedDate;
  final TimeSlot? dropOffSlot;
  final TimeSlot? findingSlot;

  ReservationState({
    this.selectedDate,
    this.dropOffSlot,
    this.findingSlot,
  });

  ReservationState copyWith({
    DateTime? selectedDate,
    TimeSlot? dropOffSlot,
    TimeSlot? findingSlot,
  }) {
    return ReservationState(
      selectedDate: selectedDate ?? this.selectedDate,
      dropOffSlot: dropOffSlot,
      findingSlot: findingSlot,
    );
  }

  bool get isComplete => dropOffSlot != null && findingSlot != null;
}

@riverpod
class ReservationNotifier extends _$ReservationNotifier {
  @override
  ReservationState build() => ReservationState();

  void selectDate(DateTime date) {
    state = ReservationState(selectedDate: date);
  }

  void selectSlot(TimeSlot slot) {
    final drop = state.dropOffSlot;
    final find = state.findingSlot;

    if (drop != null && find == slot) {
      state = state.copyWith(findingSlot: null);
    } else if (drop != null && find != null) {
      state = state.copyWith(dropOffSlot: slot, findingSlot: null);
    } else if (drop == slot) {
      state = state.copyWith(dropOffSlot: null);
    } else if (drop != null && find == null) {
      if (slot.index > drop.index) {
        state = state.copyWith(findingSlot: slot);
      } else {
        state = state.copyWith(dropOffSlot: slot, findingSlot: null);
      }
    } else {
      state = state.copyWith(dropOffSlot: slot);
    }
  }

  void reset() {
    state = ReservationState(selectedDate: state.selectedDate);
  }
}
