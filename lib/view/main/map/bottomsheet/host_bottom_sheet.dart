import 'package:flutter/material.dart';
import 'package:lugeasy/services/model/host.dart';
import 'hostlistsheet/host_list_sheet.dart';
import 'hostdetailsheet/host_detail_sheet.dart';
import 'package:lugeasy/common/constants.dart';

class HostBottomSheet extends StatefulWidget {
  final VoidCallback onClose;

  const HostBottomSheet({super.key, required this.onClose});

  @override
  HostBottomSheetState createState() => HostBottomSheetState();
}

class HostBottomSheetState extends State<HostBottomSheet> {
  double _sheetHeightRatio = kBottomSheetListRatio; // 초기 상태
  bool showDetail = false;
  Host? selectedHost;

  // 외부에서 현재 높이 비율을 조회 가능하게 함
  double get sheetHeightRatio => _sheetHeightRatio;

  // 외부에서 호출 가능: 바텀 시트를 비활성화 (축소)
  void deactivateSheet() {
    setState(() {
      _sheetHeightRatio = kBottomSheetMinRatio; // 비활성화 상태로 축소
    });
  }

  // 호스트 선택 → 상세 화면 전환
  void _openDetail(Host host) {
    setState(() {
      showDetail = true;
      selectedHost = host;
      _sheetHeightRatio = kBottomSheetDetailRatio;
    });
  }

  // 리스트로 돌아가기
  void _backToList() {
    setState(() {
      showDetail = false;
      selectedHost = null;
      _sheetHeightRatio = kBottomSheetListRatio;
    });
  }

  // 드래그 중 바텀 시트 높이 변경
  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _sheetHeightRatio -=
          details.primaryDelta! / MediaQuery.of(context).size.height;
      _sheetHeightRatio =
          _sheetHeightRatio.clamp(kBottomSheetMinRatio, kBottomSheetMaxRatio);
    });
  }

  // 드래그 끝났을 때 가까운 높이로 스냅
  void _onVerticalDragEnd(DragEndDetails details) {
    final breakpoints = showDetail
        ? [kBottomSheetMinRatio, kBottomSheetDetailRatio, kBottomSheetMaxRatio]
        : [kBottomSheetMinRatio, kBottomSheetListRatio, kBottomSheetMaxRatio];

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
