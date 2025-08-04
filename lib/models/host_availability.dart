import 'package:lugeasy/models/host_time_slot.dart';

class HostAvailability {
  final int hostId;
  final Map<String, List<TimeSlot>>
      availableSlots; // "YYYY-MM-DD" -> [TimeSlot]

  HostAvailability({
    required this.hostId,
    required this.availableSlots,
  });

  factory HostAvailability.fromJson(Map<String, dynamic> json) {
    final Map<String, List<TimeSlot>> slots = {};

    if (json['available_slots'] != null) {
      final Map<String, dynamic> slotsMap = json['available_slots'];
      slotsMap.forEach((date, slotsList) {
        if (slotsList is List) {
          slots[date] = slotsList
              .map((slot) => TimeSlot.values.firstWhere(
                    (ts) => ts.label == slot,
                    orElse: () => TimeSlot.t0001,
                  ))
              .toList();
        }
      });
    }

    return HostAvailability(
      hostId: json['host_id'] ?? 0,
      availableSlots: slots,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, List<String>> slotsMap = {};
    availableSlots.forEach((date, slots) {
      slotsMap[date] = slots.map((slot) => slot.label).toList();
    });

    return {
      'host_id': hostId,
      'available_slots': slotsMap,
    };
  }

  /// 특정 날짜에 예약 가능한 시간 슬롯을 반환
  List<TimeSlot> getAvailableSlotsForDate(DateTime date) {
    final dateKey = _formatDateKey(date);
    return availableSlots[dateKey] ?? [];
  }

  /// 특정 날짜가 예약 가능한지 확인
  bool isDateAvailable(DateTime date) {
    final dateKey = _formatDateKey(date);
    return availableSlots.containsKey(dateKey) &&
        availableSlots[dateKey]!.isNotEmpty;
  }

  /// 특정 날짜와 시간 슬롯이 예약 가능한지 확인
  bool isSlotAvailable(DateTime date, TimeSlot slot) {
    final dateKey = _formatDateKey(date);
    return availableSlots[dateKey]?.contains(slot) ?? false;
  }

  /// 날짜 키 포맷 (YYYY-MM-DD)
  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
