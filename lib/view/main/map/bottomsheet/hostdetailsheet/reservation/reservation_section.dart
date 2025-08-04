import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lugeasy/services/model/host_time_slot.dart';
import 'package:lugeasy/services/model/reservation_state.dart';
import 'package:lugeasy/view/main/map/bottomsheet/hostdetailsheet/reservation/host_time_slot_button.dart';
import 'package:lugeasy/provider/reservation_state_provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  final Set<TimeSlot> _availableTimeSlots = Set.from(TimeSlot.values);

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
      // Finding 날짜 설정
      if (state.dropOffDate != null) {
        ref
            .read(reservationNotifierProvider.notifier)
            .selectFindingDate(state.dropOffDate!);
      }
      ref.read(reservationNotifierProvider.notifier).selectSlot(slot);
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
    final currentDate =
        _isSelectingDropOff ? state.dropOffDate : state.findingDate;
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

            // Drop-off 모드일 때만 이전 시간 비활성화
            final bool isBeforeDropOff = _isSelectingDropOff &&
                state.dropOffSlot != null &&
                slot.index <= state.dropOffSlot!.index &&
                slot != state.dropOffSlot;

            final bool isDisabled = !_availableTimeSlots.contains(slot) ||
                (!isDifferentDate && isBeforeDropOff);

            TimeSlotState slotState;
            if (slot == state.dropOffSlot) {
              slotState = TimeSlotState.selected;
            } else if (slot == state.findingSlot && !_isSelectingDropOff) {
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
    final amSlots = TimeSlot.values.where((slot) => slot.isAm).toList();
    final pmSlots = TimeSlot.values.where((slot) => !slot.isAm).toList();

    String _formatDate(DateTime date) {
      return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
    }

    // Finding 모드로 전환할 때 Finding 날짜가 있다면 해당 날짜로 포커스 이동
    if (!_isSelectingDropOff &&
        state.findingDate != null &&
        _focusedDay != state.findingDate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _focusedDay = state.findingDate!;
        });
      });
    }

    // Drop-off 모드로 전환할 때 Drop-off 날짜가 있다면 해당 날짜로 포커스 이동
    if (_isSelectingDropOff &&
        state.dropOffDate != null &&
        _focusedDay != state.dropOffDate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _focusedDay = state.dropOffDate!;
        });
      });
    }

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
          TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              // Drop-off와 Finding 날짜 모두 표시
              return (state.dropOffDate != null &&
                      isSameDay(day, state.dropOffDate)) ||
                  (state.findingDate != null &&
                      isSameDay(day, state.findingDate));
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
              if (_isSelectingDropOff) {
                ref
                    .read(reservationNotifierProvider.notifier)
                    .selectDropOffDate(selectedDay);
              } else {
                ref
                    .read(reservationNotifierProvider.notifier)
                    .selectFindingDate(selectedDay);
              }
            },
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarStyle: const CalendarStyle(
              todayDecoration:
                  BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
              selectedDecoration:
                  BoxDecoration(color: Colors.black, shape: BoxShape.circle),
              selectedTextStyle: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.am,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildSlotGrid(amSlots, state.dropOffSlot, state.findingSlot),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.pm,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildSlotGrid(pmSlots, state.dropOffSlot, state.findingSlot),
          const SizedBox(height: 120),
        ],
      ),
    );
  }
}
