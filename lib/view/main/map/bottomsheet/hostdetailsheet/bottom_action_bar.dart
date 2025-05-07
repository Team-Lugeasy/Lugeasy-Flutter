import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lugeasy/view/main/map/bottomsheet/hostdetailsheet/reservation/host_time_slot.dart';
import 'package:lugeasy/view/main/map/bottomsheet/hostdetailsheet/reservation/reservation_button.dart';
import 'package:lugeasy/provider/reservation_state_provider.dart';

class BottomActionBar extends ConsumerWidget {
  const BottomActionBar({super.key});

  String? _formatSlot(DateTime? date, TimeSlot? slot) {
    if (date == null || slot == null) return null;

    final parts = slot.label.split('-');
    if (parts.length < 2) return null;

    final start = parts[0].trim();
    final end = parts[1].trim();
    final period = slot.isAm ? 'AM' : 'PM';
    final formattedDate = DateFormat('yy.MM.dd').format(date);

    return '$formattedDate $period $start-$end';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reservationNotifierProvider);

    final dropOffText = _formatSlot(state.selectedDate, state.dropOffSlot);
    final findingText = _formatSlot(state.selectedDate, state.findingSlot);

    final List<Widget> children = [];

    if (dropOffText != null) {
      children.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Drop-Off   $dropOffText",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            GestureDetector(
              onTap: () => ref
                  .read(reservationNotifierProvider.notifier)
                  .selectSlot(state.dropOffSlot!),
              child: const Icon(Icons.close, color: Colors.grey),
            ),
          ],
        ),
      );
      children.add(const SizedBox(height: 8));
    }

    if (findingText != null) {
      children.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Finding   $findingText",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            GestureDetector(
              onTap: () => ref
                  .read(reservationNotifierProvider.notifier)
                  .selectSlot(state.findingSlot!),
              child: const Icon(Icons.close, color: Colors.grey),
            ),
          ],
        ),
      );
      children.add(const SizedBox(height: 8));
    }

    children.add(
      ReservationButton(
        onPressed: () {
          // 예약 요청 처리
        },
        enabled: state.isComplete,
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
