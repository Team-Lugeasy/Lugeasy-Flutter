import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lugeasy/data/models/host_time_slot.dart';
import 'package:lugeasy/view/search/host_time_slot_button.dart';
import 'package:lugeasy/providers/reservation/reservation_provider.dart';
import 'package:lugeasy/providers/host/host_selection_provider.dart';
import 'package:lugeasy/providers/host/host_availability_provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:lugeasy/common/extensions/context_extension.dart';

class ReservationSection extends ConsumerStatefulWidget {
  const ReservationSection({super.key});

  @override
  ConsumerState<ReservationSection> createState() => _ReservationSectionState();
}

class _ReservationSectionState extends ConsumerState<ReservationSection> {
  late DateTime _focusedDay;
  bool _isSelectingDropOff = true; // true: Drop-off 선택 중, false: Finding 선택 중

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    // 초기 날짜 설정
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(reservationNotifierProvider.notifier)
          .selectDropOffDate(_focusedDay);
    });
  }

  bool _isTimeSlotInPast(TimeSlot slot) {
    final now = DateTime.now();
    final currentHour = now.hour;
    final currentMinute = now.minute;

    // 시간 슬롯의 시작 시간 계산
    final slotStartHour =
        slot.index + 1; // TimeSlot.t0001은 1시, TimeSlot.t0102는 2시...

    // 현재 시간이 슬롯 시작 시간보다 늦으면 과거 시간
    if (currentHour > slotStartHour) {
      return true;
    }

    // 같은 시간대인 경우 분까지 비교
    if (currentHour == slotStartHour) {
      // 슬롯은 1시간 단위이므로 현재 분이 0보다 크면 해당 슬롯은 과거
      return currentMinute > 0;
    }

    return false;
  }

  void _handleTimeSlotTap(TimeSlot slot) {
    final state = ref.read(reservationNotifierProvider);

    // Drop-off 시간이 없는 경우
    if (state.dropOffSlot == null) {
      ref.read(reservationNotifierProvider.notifier).selectSlot(slot);
      // Finding 날짜가 설정되어 있지 않으면 Drop-off 날짜로 설정
      if (state.findingDate == null && state.dropOffDate != null) {
        ref
            .read(reservationNotifierProvider.notifier)
            .selectFindingDate(state.dropOffDate!);
      }
      setState(() {
        _isSelectingDropOff = false; // Finding 선택 모드로 전환
      });
      return;
    }

    // Finding 모드에서 새로운 슬롯 선택
    if (!_isSelectingDropOff) {
      final currentState = ref.read(reservationNotifierProvider);

      if (currentState.dropOffSlot != null &&
          currentState.findingSlot != null) {
        // 둘 다 선택된 상태에서 새로운 슬롯 선택 시
        // 현재 날짜와 새로운 타일을 Drop-off로 설정하고 Finding 초기화
        ref
            .read(reservationNotifierProvider.notifier)
            .selectDropOffDate(_focusedDay);
        ref.read(reservationNotifierProvider.notifier).selectSlot(slot);
        setState(() {
          _isSelectingDropOff = false; // Finding 선택 모드로 전환
        });
      } else {
        // Finding만 선택된 상태에서 새로운 슬롯 선택
        ref
            .read(reservationNotifierProvider.notifier)
            .selectFindingDate(_focusedDay);
        ref.read(reservationNotifierProvider.notifier).selectSlot(slot);
      }
      return;
    }

    // Drop-off 모드에서 새로운 슬롯 선택
    ref.read(reservationNotifierProvider.notifier).selectSlot(slot);
    setState(() {
      _isSelectingDropOff = false; // Finding 선택 모드로 전환
    });
    // Finding 날짜가 설정되어 있지 않으면 Drop-off 날짜로 설정
    if (state.dropOffDate != null) {
      ref
          .read(reservationNotifierProvider.notifier)
          .selectFindingDate(state.dropOffDate!);
    }
  }

  Widget _buildSlotGrid(
      List<TimeSlot> slots, TimeSlot? dropOff, TimeSlot? finding) {
    final state = ref.watch(reservationNotifierProvider);
    final host = ref.watch(hostNotifierProvider);
    // 둘 다 선택된 상태에서는 현재 포커스된 날짜를 사용
    final currentDate = (state.dropOffSlot != null && state.findingSlot != null)
        ? _focusedDay
        : (_isSelectingDropOff ? state.dropOffDate : state.findingDate);
    final otherDate =
        _isSelectingDropOff ? state.findingDate : state.dropOffDate;

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = 2;
        final spacing = 16.0;
        final itemWidth =
            (constraints.maxWidth - (crossAxisCount - 1) * spacing) /
                crossAxisCount;

        return Wrap(
          spacing: spacing,
          runSpacing: 12,
          children: slots.map((slot) {
            final bool isDifferentDate = currentDate != null &&
                otherDate != null &&
                !isSameDay(currentDate, otherDate);

            // 호스트 가용성 확인
            final bool isHostAvailable = host != null &&
                ref
                    .read(hostAvailabilityNotifierProvider.notifier)
                    .isSlotAvailable(currentDate ?? _focusedDay, slot);

            // 현재 시간보다 이전 시간 비활성화 (오늘 날짜인 경우에만)
            final bool isPastTime = currentDate != null &&
                isSameDay(currentDate, DateTime.now()) &&
                _isTimeSlotInPast(slot);

            // Drop-off 모드일 때만 이전 시간 비활성화
            final bool isBeforeDropOff = _isSelectingDropOff &&
                state.dropOffSlot != null &&
                slot.index <= state.dropOffSlot!.index &&
                slot != state.dropOffSlot;

            final bool isDisabled = !isHostAvailable ||
                isPastTime ||
                (!isDifferentDate && isBeforeDropOff);

            TimeSlotState slotState;

            // 현재 날짜와 Drop-off/Finding 날짜 비교
            final bool isDropOffDate = state.dropOffDate != null &&
                isSameDay(currentDate ?? _focusedDay, state.dropOffDate!);
            final bool isFindingDate = state.findingDate != null &&
                isSameDay(currentDate ?? _focusedDay, state.findingDate!);

            if (slot == state.dropOffSlot && isDropOffDate) {
              // Drop-off 슬롯이고 현재 날짜가 Drop-off 날짜와 같을 때만 선택됨
              slotState = TimeSlotState.selected;
            } else if (slot == state.findingSlot &&
                isFindingDate &&
                !_isSelectingDropOff &&
                _focusedDay == state.findingDate) {
              // Finding 슬롯이고 현재 날짜가 Finding 날짜와 같을 때만 선택됨
              // (현재 포커스된 날짜가 Finding 날짜일 때만)
              slotState = TimeSlotState.selected;
            } else if (isDisabled) {
              slotState = TimeSlotState.disabled;
            } else {
              slotState = TimeSlotState.enabled;
            }

            return SizedBox(
              width: itemWidth,
              child: TimeSlotButton(
                label: slot.label,
                state: slotState,
                onTap: () => _handleTimeSlotTap(slot),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reservationNotifierProvider);
    final host = ref.watch(hostNotifierProvider);
    final hostAvailability = ref.watch(hostAvailabilityNotifierProvider);
    final amSlots = TimeSlot.values.where((slot) => slot.isAm).toList();
    final pmSlots = TimeSlot.values.where((slot) => !slot.isAm).toList();

    String _formatDate(DateTime date) {
      return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
    }

    // 호스트 가용성 정보가 로드되지 않았다면 자동으로 가져오기
    if (host != null && hostAvailability.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(hostAvailabilityNotifierProvider.notifier)
            .loadHostAvailability(host!.hostId);
      });
    }

    // Finding 모드로 전환할 때 Finding 날짜가 있다면 해당 날짜로 포커스 이동
    if (!_isSelectingDropOff &&
        state.findingDate != null &&
        _focusedDay != state.findingDate &&
        !(state.dropOffSlot != null && state.findingSlot != null)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _focusedDay = state.findingDate!;
        });
      });
    }

    // Drop-off 모드로 전환할 때 Drop-off 날짜가 있다면 해당 날짜로 포커스 이동
    if (_isSelectingDropOff &&
        state.dropOffDate != null &&
        _focusedDay != state.dropOffDate &&
        !(state.dropOffSlot != null && state.findingSlot != null)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _focusedDay = state.dropOffDate!;
        });
      });
    }

    // 호스트 가용성 정보가 로드 중인지 확인
    final isLoading = hostAvailability.isLoading;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.calendar_month, size: 20),
              const SizedBox(width: 8),
              Text(
                _formatDate(_focusedDay),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TableCalendar(
                  firstDay: DateTime.now(),
                  lastDay: DateTime.now().add(const Duration(days: 365)),
                  focusedDay: _focusedDay,
                  currentDay: _focusedDay,
                  enabledDayPredicate: (day) {
                    // 호스트가 있고 해당 날짜에 예약 가능한 시간이 있는 경우 활성화
                    return host != null &&
                        ref
                            .read(hostAvailabilityNotifierProvider.notifier)
                            .isDateAvailable(day);
                  },
                  selectedDayPredicate: (day) {
                    // Drop-off와 Finding 날짜 모두 표시
                    return (state.dropOffDate != null &&
                            isSameDay(day, state.dropOffDate)) ||
                        (state.findingDate != null &&
                            isSameDay(day, state.findingDate));
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    final currentState = ref.read(reservationNotifierProvider);

                    if (_isSelectingDropOff) {
                      setState(() {
                        _focusedDay = focusedDay;
                      });
                      ref
                          .read(reservationNotifierProvider.notifier)
                          .selectDropOffDate(selectedDay);
                    } else {
                      // Finding 모드에서 새로운 날짜 선택 시
                      if (currentState.dropOffSlot != null &&
                          currentState.findingSlot != null) {
                        // 둘 다 선택된 상태에서 새로운 날짜 선택 시 focusedDay를 선택한 날짜로 고정
                        setState(() {
                          _focusedDay = selectedDay;
                        });
                      } else {
                        setState(() {
                          _focusedDay = focusedDay;
                        });
                        // Finding만 선택된 상태에서 새로운 날짜 선택 시 Finding 날짜 업데이트
                        ref
                            .read(reservationNotifierProvider.notifier)
                            .selectFindingDate(selectedDay);
                      }
                    }
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(
                        color: Colors.grey, shape: BoxShape.circle),
                    selectedDecoration: BoxDecoration(
                        color: Colors.black, shape: BoxShape.circle),
                    selectedTextStyle: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  context.l10n.am,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildSlotGrid(amSlots, state.dropOffSlot, state.findingSlot),
                const SizedBox(height: 24),
                Text(
                  context.l10n.pm,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildSlotGrid(pmSlots, state.dropOffSlot, state.findingSlot),
                const SizedBox(height: 120),
              ],
            ),
        ],
      ),
    );
  }
}
