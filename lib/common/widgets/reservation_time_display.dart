import 'package:flutter/material.dart';
import 'package:lugeasy/common/extensions/context_extension.dart';
import 'package:lugeasy/provider/reservation_state_provider.dart';
import 'package:lugeasy/models/host_time_slot.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReservationTimeDisplay extends ConsumerWidget {
  const ReservationTimeDisplay({super.key});

  String _formatDateTime(DateTime date, TimeSlot slot) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}.$month.$day ${slot.isAm ? "AM" : "PM"} ${slot.label}';
  }

  Widget _buildTimeRow(BuildContext context, String label, String value,
      {bool isGrey = false, bool isLastItem = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DefaultTextStyle(
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: const Color(0xFF1A1A1A),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Pretendard',
                        ) ??
                    const TextStyle(
                      fontSize: 14,
                      height: 1.3,
                      letterSpacing: -0.2,
                      color: Color(0xFF1A1A1A),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Pretendard',
                    ),
                child: Container(
                  constraints: const BoxConstraints(minWidth: 70),
                  child: Text(label),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DefaultTextStyle(
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isGrey
                                ? const Color(0xFF999999)
                                : const Color(0xFF1A1A1A),
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Pretendard',
                          ) ??
                      TextStyle(
                        fontSize: 14,
                        height: 1.3,
                        letterSpacing: -0.2,
                        color: isGrey
                            ? const Color(0xFF999999)
                            : const Color(0xFF1A1A1A),
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Pretendard',
                      ),
                  child: Text(
                    value,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLastItem)
          Container(
            height: 0.5,
            color: const Color(0xFFE0E0E0),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reservationNotifierProvider);
    final dropOffSlot = state.dropOffSlot;
    final findingSlot = state.findingSlot;
    final dropOffDate = state.dropOffDate;
    final findingDate = state.findingDate;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTimeRow(
          context,
          context.l10n.drop_off,
          dropOffDate != null && dropOffSlot != null
              ? _formatDateTime(dropOffDate, dropOffSlot)
              : context.l10n.drop_off_description,
          isGrey: dropOffSlot == null,
        ),
        _buildTimeRow(
          context,
          context.l10n.finding,
          findingDate != null && findingSlot != null
              ? _formatDateTime(findingDate, findingSlot)
              : context.l10n.drop_off_description,
          isGrey: findingSlot == null,
          isLastItem: true,
        ),
      ],
    );
  }
}
