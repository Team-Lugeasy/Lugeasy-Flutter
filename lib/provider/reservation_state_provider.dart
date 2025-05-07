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
      // 2번째 슬롯을 다시 누르면 해제
      state = state.copyWith(findingSlot: null);
    } else if (drop != null && find != null) {
      // 이미 두 개 다 선택된 경우 → 초기화 후 첫 슬롯으로
      state = state.copyWith(dropOffSlot: slot, findingSlot: null);
    } else if (drop == slot) {
      // 첫 슬롯을 다시 누르면 해제
      state = state.copyWith(dropOffSlot: null);
    } else if (drop != null && find == null) {
      // 첫 슬롯 선택된 후 → 두 번째 슬롯 선택
      if (slot.index > drop.index) {
        state = state.copyWith(findingSlot: slot);
      } else if (slot != drop) {
        // drop보다 작거나 같지만 동일하지 않을 경우는 drop만 바꿈
        state = state.copyWith(dropOffSlot: slot);
      }
      // slot == drop은 위에서 처리됨
    } else {
      // 아무 것도 없는 경우 → drop만 선택
      state = state.copyWith(dropOffSlot: slot);
    }
  }

  void reset() {
    state = ReservationState(selectedDate: state.selectedDate);
  }
}
