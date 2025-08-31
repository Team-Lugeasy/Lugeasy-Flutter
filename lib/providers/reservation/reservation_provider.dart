import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lugeasy/data/models/reservation_state.dart';
import 'package:lugeasy/data/models/host_time_slot.dart';

part 'reservation_provider.g.dart';

@riverpod
class ReservationProvider extends _$ReservationProvider {
  @override
  ReservationState build() => ReservationState();

  void selectDropOffDate(DateTime date) {
    state = state.copyWith(dropOffDate: date);
  }

  void selectFindingDate(DateTime date) {
    if (state.dropOffDate != null && date.isBefore(state.dropOffDate!)) {
      // Finding 날짜가 Drop-off 날짜보다 앞설 수 없음
      return;
    }
    state = state.copyWith(findingDate: date);
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void selectSlot(TimeSlot slot) {
    // Drop-off가 선택되지 않은 경우
    if (state.dropOffSlot == null) {
      state = state.copyWith(dropOffSlot: slot);
      return;
    }

    // Finding이 선택되지 않은 경우
    if (state.findingSlot == null) {
      // 같은 날짜인 경우
      if (state.dropOffDate != null &&
          state.findingDate != null &&
          isSameDay(state.dropOffDate!, state.findingDate!)) {
        if (slot.index > state.dropOffSlot!.index) {
          // Drop-off 이후 시간이면 Finding으로 설정
          state = state.copyWith(findingSlot: slot);
        } else {
          // Drop-off 이전 시간이면 Drop-off를 변경하고 Finding 초기화
          state = state.copyWith(
            dropOffSlot: slot,
            clearFinding: true,
          );
        }
      } else if (state.findingDate == null || state.dropOffDate == null) {
        // 날짜가 설정되지 않은 경우 Finding으로 설정
        state = state.copyWith(findingSlot: slot);
      } else {
        // 다른 날짜인 경우
        if (state.findingDate!.isAfter(state.dropOffDate!)) {
          // Finding 날짜가 Drop-off 이후면 Finding으로 설정
          state = state.copyWith(findingSlot: slot);
        } else {
          // Finding 날짜가 Drop-off 이전이면 Drop-off를 변경하고 Finding 초기화
          state = state.copyWith(
            dropOffSlot: slot,
            clearFinding: true,
          );
        }
      }
      return;
    }

    // 둘 다 선택된 경우, 새로운 Drop-off로 설정하고 Finding 초기화
    state = state.copyWith(
      dropOffSlot: slot,
      clearFinding: true,
    );
  }

  void reset() {
    state = ReservationState();
  }
}

// Provider 이름을 export (한 번만 사용)
final reservationNotifierProvider = reservationProviderProvider;
