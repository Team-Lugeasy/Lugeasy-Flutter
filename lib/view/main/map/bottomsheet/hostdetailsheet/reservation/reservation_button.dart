// reservation_bottom_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lugeasy/providers/reservation/reservation_provider.dart';
import 'package:lugeasy/providers/host/host_selection_provider.dart';
import 'package:lugeasy/common/extensions/context_extension.dart';
import 'package:lugeasy/models/host.dart';
import 'package:lugeasy/models/host_time_slot.dart';
import 'package:lugeasy/view/main/map/request_reservation_page.dart';

class ReservationBottomBar extends ConsumerWidget {
  final Host host; // host 정보를 받도록 수정

  const ReservationBottomBar({super.key, required this.host});

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

    return Container(
      width: double.infinity,
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
      child: Column(
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
          Padding(
            padding: EdgeInsets.fromLTRB(
                20, 12, 20, MediaQuery.of(context).padding.bottom + 16),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: state.isComplete
                    ? () {
                        // host와 reservation 정보를 전역 상태에 저장
                        ref.read(hostNotifierProvider.notifier).select(host);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RequestReservationPage(),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      state.isComplete ? Colors.black : const Color(0xFFDADADA),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  disabledBackgroundColor: const Color(0xFFDADADA),
                  disabledForegroundColor: Colors.black,
                ),
                child: Text(
                  context.l10n.reservation_button,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                    fontFamily: 'Pretendard',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
