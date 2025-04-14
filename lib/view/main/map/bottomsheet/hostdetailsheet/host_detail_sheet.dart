import 'package:flutter/material.dart';
import 'package:lugeasy/services/model/host.dart';
import 'package:lugeasy/view/main/map/bottomsheet/hostdetailsheet/host_review_list.dart';
import 'host_user_info.dart';

class HostDetailSheet extends StatefulWidget {
  // 닫기 버튼 동작 (외부에서 시트 닫기)
  final VoidCallback onClose;

  // 리스트로 돌아가기 동작
  final VoidCallback onBack;

  // 선택된 호스트 정보
  final Host host;

  const HostDetailSheet({
    super.key,
    required this.onClose,
    required this.onBack,
    required this.host,
  });

  @override
  State<HostDetailSheet> createState() => _HostDetailSheetState();
}

class _HostDetailSheetState extends State<HostDetailSheet> {
  // 탭 인덱스 (0: Reservation, 1: Review)
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // 상단 닫기 버튼 (리스트 화면으로 돌아감)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.black87),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: widget.onBack,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 호스트 기본 정보 (이름, 평점, 주소 등)
          HostUserInfo(
            name: widget.host.name,
            description: widget.host.description,
            reviewRate: widget.host.reviewRate,
            reviewCount: widget.host.reviewCount,
            address: widget.host.address,
            profileImage: widget.host.profileImage,
          ),
          const SizedBox(height: 24),

          // 탭 영역 (Reservation / Review)
          Column(
            children: [
              // 탭 상단 구분선
              Container(
                height: 0.5,
                color: const Color(0xFFE0E0E0),
              ),

              // 탭 선택 영역 (고정 높이 60)
              SizedBox(
                height: 60,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _tabIndex = 0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            "Reservation",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: _tabIndex == 0
                                  ? Colors.black
                                  : Colors.black38,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _tabIndex = 1),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            "Review",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: _tabIndex == 1
                                  ? Colors.black
                                  : Colors.black38,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 탭 하단 밑줄 및 선택된 탭 강조선
              LayoutBuilder(
                builder: (context, constraints) {
                  final tabWidth = constraints.maxWidth / 2;
                  return Stack(
                    children: [
                      // 전체 하단 라인
                      Container(
                        height: 0.5,
                        color: const Color(0xFFE0E0E0),
                      ),
                      // 선택된 탭 강조선
                      AnimatedAlign(
                        alignment: _tabIndex == 0
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          width: tabWidth,
                          height: 1.5,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              if (_tabIndex == 0) ...[
                const Text("TO DO: Reservation")
              ] else ...[
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Review",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                HostReviewList(),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "See more",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 16),
              ]
            ],
          ),
        ],
      ),
    );
  }
}
