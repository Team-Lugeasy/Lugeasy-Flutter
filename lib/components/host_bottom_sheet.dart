import 'package:flutter/material.dart';
import 'host_list_sheet.dart';
import 'host_detail_sheet.dart';

class HostBottomSheet extends StatefulWidget {
  final VoidCallback onClose;

  const HostBottomSheet({super.key, required this.onClose});

  @override
  HostBottomSheetState createState() => HostBottomSheetState();
}

class HostBottomSheetState extends State<HostBottomSheet> {
  double _sheetHeightRatio = 0.4; // 초기 상태
  bool showDetail = false;
  Map<String, dynamic>? selectedHost;

  // 외부에서 현재 높이 비율을 조회 가능하게 함
  double get sheetHeightRatio => _sheetHeightRatio;

  // 외부에서 호출 가능: 바텀 시트를 비활성화 (축소)
  void deactivateSheet() {
    setState(() {
      _sheetHeightRatio = 0.1; // 비활성화 상태로 축소
    });
  }

  // 호스트 선택 → 상세 화면 전환
  void _openDetail(Map<String, dynamic> host) {
    setState(() {
      showDetail = true;
      selectedHost = host;
      _sheetHeightRatio = 0.5;
    });
  }

  // 리스트로 돌아가기
  void _backToList() {
    setState(() {
      showDetail = false;
      selectedHost = null;
      _sheetHeightRatio = 0.4;
    });
  }

  // 드래그 중 바텀 시트 높이 변경
  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _sheetHeightRatio -=
          details.primaryDelta! / MediaQuery.of(context).size.height;
      _sheetHeightRatio = _sheetHeightRatio.clamp(0.1, 0.9);
    });
  }

  // 드래그 끝났을 때 가까운 높이로 스냅
  void _onVerticalDragEnd(DragEndDetails details) {
    final breakpoints = showDetail ? [0.1, 0.5, 0.9] : [0.1, 0.4, 0.9];

    double closest = breakpoints.first;
    double minDistance = double.infinity;

    for (final point in breakpoints) {
      final distance = (_sheetHeightRatio - point).abs();
      if (distance < minDistance) {
        minDistance = distance;
        closest = point;
      }
    }

    setState(() {
      _sheetHeightRatio = closest;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * _sheetHeightRatio;

    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        height: height,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onVerticalDragUpdate: _onVerticalDragUpdate,
              onVerticalDragEnd: _onVerticalDragEnd,
              child: Container(
                height: 34,
                alignment: Alignment.center,
                child: Container(
                  width: 32,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF888888),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Expanded(
              child: showDetail
                  ? HostDetailSheet(
                      host: selectedHost!,
                      onClose: widget.onClose,
                      onBack: _backToList,
                    )
                  : HostListSheet(
                      onHostTap: _openDetail,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
