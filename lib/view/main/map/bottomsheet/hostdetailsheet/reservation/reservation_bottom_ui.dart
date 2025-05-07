import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lugeasy/provider/reservation_state_provider.dart';
import 'package:lugeasy/view/main/map/bottomsheet/hostdetailsheet/reservation/reservation_button.dart';

class ReservationBottomUI extends ConsumerWidget {
  const ReservationBottomUI({super.key});

  String _format(DateTime date, bool isAm, String timeLabel) {
    final dateStr = DateFormat('yy.MM.dd').format(date);
    final period = isAm ? 'AM' : 'PM';
    return "$dateStr $period $timeLabel";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reservationNotifierProvider);
    final dropOffSlot = state.dropOffSlot;
    final findingSlot = state.findingSlot;
    final selectedDate = state.selectedDate;

    final texts = <Widget>[];

    if (selectedDate != null && dropOffSlot != null) {
      texts.add(_ReservationInfoItem(
        label: "Drop-Off",
        text: _format(selectedDate, dropOffSlot.isAm, dropOffSlot.label),
      ));
    }

    if (selectedDate != null && findingSlot != null) {
      texts.add(_ReservationInfoItem(
        label: "Finding",
        text: _format(selectedDate, findingSlot.isAm, findingSlot.label),
      ));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (texts.isNotEmpty)
          Column(
            children: [
              ...texts,
              const SizedBox(height: 16),
            ],
          ),
        ReservationButton(
          onPressed: () {},
          enabled: state.isComplete,
        ),
      ],
    );
  }
}

class _ReservationInfoItem extends StatelessWidget {
  final String label;
  final String text;

  const _ReservationInfoItem({required this.label, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
