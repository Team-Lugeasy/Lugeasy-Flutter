import 'package:flutter/material.dart';
import 'package:lugeasy/view/main/map/bottomsheet/hostdetailsheet/reservation/host_time_slot.dart';
import 'package:lugeasy/view/main/map/bottomsheet/hostdetailsheet/reservation/host_time_slot_button.dart';
import 'package:table_calendar/table_calendar.dart';

class ReservationSection extends StatefulWidget {
  const ReservationSection({super.key});

  @override
  State<ReservationSection> createState() => _ReservationSectionState();
}

class _ReservationSectionState extends State<ReservationSection> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  final Set<TimeSlot> _availableTimeSlots = {
    TimeSlot.t0001,
    TimeSlot.t0102,
    TimeSlot.t0203,
    TimeSlot.t0304,
    TimeSlot.t0405,
    TimeSlot.t0506,
    TimeSlot.t0607,
    TimeSlot.t0708,
    TimeSlot.t0809,
    TimeSlot.t0910,
    TimeSlot.t1011,
    TimeSlot.t1112,
    TimeSlot.t1213,
    TimeSlot.t1314,
    TimeSlot.t1415,
    TimeSlot.t1516,
    TimeSlot.t1617,
  };

  TimeSlot? _dropOffSlot;
  TimeSlot? _findingSlot;

  void _handleTimeSlotTap(TimeSlot slot) {
    setState(() {
      // 두 개 다 선택된 상태에서 두 번째 슬롯을 다시 누르면 두 번째만 해제
      if (_dropOffSlot != null && _findingSlot == slot) {
        _findingSlot = null;
        return;
      }

      // 두 개 다 선택된 상태에서 다른 슬롯 누르면 초기화 후 새 슬롯을 dropOff로 지정
      if (_dropOffSlot != null && _findingSlot != null) {
        _dropOffSlot = slot;
        _findingSlot = null;
        return;
      }

      // 같은 슬롯 누르면 초기화
      if (_dropOffSlot == slot) {
        _dropOffSlot = null;
        return;
      }

      // 첫 번째 슬롯만 선택된 상태
      if (_dropOffSlot != null && _findingSlot == null) {
        // dropOff 이후 시간만 선택 가능
        if (_availableTimeSlots.contains(slot) &&
            slot.index > _dropOffSlot!.index) {
          _findingSlot = slot;
        } else {
          // invalid second slot tap → 전체 초기화 후 해당 슬롯을 dropOff로
          _dropOffSlot = slot;
          _findingSlot = null;
        }
        return;
      }

      // 아무것도 선택되지 않은 상태
      _dropOffSlot = slot;
    });
  }

  Widget buildSlotGrid(List<TimeSlot> slots) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 16) / 2;
        return Wrap(
          spacing: 16,
          runSpacing: 8,
          children: slots.map((slot) {
            final bool isDisabled = !_availableTimeSlots.contains(slot) ||
                (_dropOffSlot != null &&
                    _findingSlot == null &&
                    slot.index <= _dropOffSlot!.index);

            final TimeSlotState state;
            if (_dropOffSlot == slot || _findingSlot == slot) {
              state = TimeSlotState.selected;
            } else if (isDisabled) {
              state = TimeSlotState.disabled;
            } else {
              state = TimeSlotState.enabled;
            }

            return SizedBox(
              width: itemWidth,
              child: TimeSlotButton(
                label: slot.label,
                state: state,
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
    final amSlots = TimeSlot.values.where((slot) => slot.isAm).toList();
    final pmSlots = TimeSlot.values.where((slot) => !slot.isAm).toList();

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
              Flexible(
                child: Text(
                  "${_selectedDay?.year}.${_selectedDay?.month.toString().padLeft(2, '0')}.${_selectedDay?.day.toString().padLeft(2, '0')}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _dropOffSlot = null;
                _findingSlot = null;
              });
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
          const SizedBox(height: 36),
          const Text("AM"),
          const SizedBox(height: 12),
          buildSlotGrid(amSlots),
          const SizedBox(height: 24),
          const Text("PM"),
          const SizedBox(height: 12),
          buildSlotGrid(pmSlots),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
