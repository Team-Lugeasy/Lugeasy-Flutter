import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lugeasy/models/host_availability.dart';
import 'package:lugeasy/models/host_time_slot.dart';

part 'host_availability_provider.g.dart';

@riverpod
class HostAvailabilityProvider extends _$HostAvailabilityProvider {
  int? _currentHostId;

  @override
  Future<HostAvailability> build() async {
    // 초기 상태에서는 빈 HostAvailability 반환
    if (_currentHostId == null) {
      return HostAvailability(
        hostId: 0,
        availableSlots: {},
      );
    }
    return await _fetchHostAvailability(_currentHostId!);
  }

  /// 특정 호스트의 가용성 정보를 로드
  Future<void> loadHostAvailability(int hostId) async {
    _currentHostId = hostId;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchHostAvailability(hostId));
  }

  /// 특정 날짜가 예약 가능한지 확인
  bool isDateAvailable(DateTime date) {
    final availability = state.value;
    return availability?.isDateAvailable(date) ?? false;
  }

  /// 특정 날짜의 예약 가능한 시간 슬롯을 반환
  List<TimeSlot> getAvailableSlotsForDate(DateTime date) {
    final availability = state.value;
    return availability?.getAvailableSlotsForDate(date) ?? [];
  }

  /// 특정 날짜와 시간 슬롯이 예약 가능한지 확인
  bool isSlotAvailable(DateTime date, TimeSlot slot) {
    final availability = state.value;
    return availability?.isSlotAvailable(date, slot) ?? false;
  }

  /// Mock 데이터 생성 (실제 API로 대체 예정)
  Future<HostAvailability> _fetchHostAvailability(int hostId) async {
    // 시뮬레이션을 위한 지연
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock 데이터: 호스트별로 다른 가용성 설정
    final Map<String, List<TimeSlot>> mockSlots = {
      '2025-08-04': [
        TimeSlot.t0910,
        TimeSlot.t1011,
        TimeSlot.t1112,
        TimeSlot.t1213,
        TimeSlot.t1314,
        TimeSlot.t1415,
        TimeSlot.t1516
      ],
      '2025-08-05': [
        TimeSlot.t0809,
        TimeSlot.t0910,
        TimeSlot.t1011,
        TimeSlot.t1112,
        TimeSlot.t1213,
        TimeSlot.t1314
      ],
      '2025-08-06': [
        TimeSlot.t1011,
        TimeSlot.t1112,
        TimeSlot.t1415,
        TimeSlot.t1516,
        TimeSlot.t1617,
        TimeSlot.t1718
      ],
      '2025-08-07': [
        TimeSlot.t0910,
        TimeSlot.t1011,
        TimeSlot.t1112,
        TimeSlot.t1213,
        TimeSlot.t1314,
        TimeSlot.t1415,
        TimeSlot.t1516,
        TimeSlot.t1617
      ],
      '2025-08-08': [
        TimeSlot.t0809,
        TimeSlot.t0910,
        TimeSlot.t1011,
        TimeSlot.t1112,
        TimeSlot.t1213
      ],
      '2025-08-09': [
        TimeSlot.t1011,
        TimeSlot.t1112,
        TimeSlot.t1415,
        TimeSlot.t1516,
        TimeSlot.t1617,
        TimeSlot.t1718
      ],
      '2025-08-10': [
        TimeSlot.t0809,
        TimeSlot.t0910,
        TimeSlot.t1011,
        TimeSlot.t1112,
        TimeSlot.t1213,
        TimeSlot.t1314,
        TimeSlot.t1415
      ],
      '2025-08-11': [
        TimeSlot.t0910,
        TimeSlot.t1011,
        TimeSlot.t1112,
        TimeSlot.t1213,
        TimeSlot.t1314,
        TimeSlot.t1415,
        TimeSlot.t1516,
        TimeSlot.t1617,
        TimeSlot.t1718
      ],
      '2025-08-12': [
        TimeSlot.t0809,
        TimeSlot.t0910,
        TimeSlot.t1011,
        TimeSlot.t1112,
        TimeSlot.t1213
      ],
      '2025-08-13': [
        TimeSlot.t1011,
        TimeSlot.t1112,
        TimeSlot.t1415,
        TimeSlot.t1516,
        TimeSlot.t1617
      ],
      '2025-08-14': [
        TimeSlot.t0910,
        TimeSlot.t1011,
        TimeSlot.t1112,
        TimeSlot.t1213,
        TimeSlot.t1314,
        TimeSlot.t1415,
        TimeSlot.t1516
      ],
      '2025-08-15': [
        TimeSlot.t0809,
        TimeSlot.t0910,
        TimeSlot.t1011,
        TimeSlot.t1112,
        TimeSlot.t1213,
        TimeSlot.t1314
      ],
      '2025-08-16': [
        TimeSlot.t1011,
        TimeSlot.t1112,
        TimeSlot.t1415,
        TimeSlot.t1516,
        TimeSlot.t1617,
        TimeSlot.t1718
      ],
      '2025-08-17': [
        TimeSlot.t0910,
        TimeSlot.t1011,
        TimeSlot.t1112,
        TimeSlot.t1213,
        TimeSlot.t1314,
        TimeSlot.t1415,
        TimeSlot.t1516,
        TimeSlot.t1617
      ],
      '2025-08-18': [
        TimeSlot.t0809,
        TimeSlot.t0910,
        TimeSlot.t1011,
        TimeSlot.t1112,
        TimeSlot.t1213
      ],
      '2025-08-19': [
        TimeSlot.t1011,
        TimeSlot.t1112,
        TimeSlot.t1415,
        TimeSlot.t1516,
        TimeSlot.t1617
      ],
      '2025-08-20': [
        TimeSlot.t0910,
        TimeSlot.t1011,
        TimeSlot.t1112,
        TimeSlot.t1213,
        TimeSlot.t1314,
        TimeSlot.t1415,
        TimeSlot.t1516
      ]
    };

    return HostAvailability(
      hostId: hostId,
      availableSlots: mockSlots,
    );
  }
}

// Provider 이름을 export (한 번만 사용)
final hostAvailabilityNotifierProvider = hostAvailabilityProviderProvider;
