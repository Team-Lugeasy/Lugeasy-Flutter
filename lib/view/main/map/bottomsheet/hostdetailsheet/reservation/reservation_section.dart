import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lugeasy/view/main/map/bottomsheet/hostdetailsheet/reservation/host_time_slot.dart';
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
  DateTime _focusedDay = DateTime.now();

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
    TimeSlot.t1718,
    TimeSlot.t1819,
    TimeSlot.t1920,
    TimeSlot.t2021,
    TimeSlot.t2122,
    TimeSlot.t2223,
    TimeSlot.t2324,
  };

  void _handleTimeSlotTap(TimeSlot slot) {
    ref.read(reservationNotifierProvider.notifier).selectSlot(slot);
  }

  Widget buildSlotGrid(
      List<TimeSlot> slots, TimeSlot? dropOff, TimeSlot? finding) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 16) / 2;
        return Wrap(
          spacing: 16,
          runSpacing: 8,
          children: slots.map((slot) {
            final bool isDisabled = !_availableTimeSlots.contains(slot) ||
                (dropOff != null &&
                    finding == null &&
                    slot.index <= dropOff.index &&
                    slot != dropOff);

            final TimeSlotState state;
            if (dropOff == slot || finding == slot) {
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
    final state = ref.watch(reservationNotifierProvider);
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
                  "${state.selectedDate?.year}.${state.selectedDate?.month.toString().padLeft(2, '0')}.${state.selectedDate?.day.toString().padLeft(2, '0')}",
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
            selectedDayPredicate: (day) => isSameDay(day, state.selectedDate),
            onDaySelected: (selectedDay, focusedDay) {
              ref
                  .read(reservationNotifierProvider.notifier)
                  .selectDate(selectedDay);
              setState(() {
                _focusedDay = focusedDay;
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
          Text(AppLocalizations.of(context)!.am),
          const SizedBox(height: 12),
          buildSlotGrid(amSlots, state.dropOffSlot, state.findingSlot),
          const SizedBox(height: 24),
          Text(AppLocalizations.of(context)!.pm),
          const SizedBox(height: 12),
          buildSlotGrid(pmSlots, state.dropOffSlot, state.findingSlot),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
