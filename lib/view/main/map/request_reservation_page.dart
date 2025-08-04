import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lugeasy/providers/host/host_selection_provider.dart';
import 'package:lugeasy/providers/reservation/reservation_provider.dart';
import 'package:lugeasy/common/extensions/context_extension.dart';
import 'package:lugeasy/common/widgets/common_button.dart';
import 'package:lugeasy/common/widgets/reservation_time_display.dart';
import 'package:lugeasy/common/constants.dart';
import 'package:lugeasy/view/main/map/request_completed_page.dart';

class RequestReservationPage extends ConsumerWidget {
  const RequestReservationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final host = ref.watch(hostNotifierProvider);
    final reservation = ref.watch(reservationNotifierProvider);

    // null 체크
    if (host == null || !reservation.isComplete) {
      return const Scaffold(
        body: Center(child: Text('필요한 정보가 없습니다')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.reservation_confirm_title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        host.profileImage.toString().isNotEmpty
                            ? CircleAvatar(
                                backgroundImage:
                                    NetworkImage(host.profileImage),
                                radius: 28,
                              )
                            : defaultProfileIcon(iconSize: 28),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(host.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16)),
                              const SizedBox(height: 8),
                              Container(
                                height: 0.5,
                                color: const Color(0xFFE0E0E0),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined,
                                      size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      host.address,
                                      style: const TextStyle(
                                          fontSize: 13, color: Colors.grey),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  ReservationTimeDisplay(),
                  const Spacer(),
                  Text(
                    context.l10n.reservation_confirm_description,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                20, 12, 20, MediaQuery.of(context).padding.bottom + 16),
            child: CommonButton(
              text: context.l10n.reservation_confirm_button,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const RequestCompletedPage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
