import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lugeasy/providers/host/host_selection_provider.dart';
import 'package:lugeasy/data/models/host.dart';
import 'host_list_sheet.dart';
import 'host_detail_sheet.dart';
import 'package:lugeasy/common/constants.dart';

class HostBottomSheet extends ConsumerStatefulWidget {
  final VoidCallback onClose;

  const HostBottomSheet({super.key, required this.onClose});

  @override
  HostBottomSheetState createState() => HostBottomSheetState();
}

class HostBottomSheetState extends ConsumerState<HostBottomSheet> {
  static final ValueNotifier<bool> isDetailVisible = ValueNotifier(false);
  static final ValueNotifier<double> sheetHeightRatio =
      ValueNotifier(kBottomSheetListRatio);

  double _sheetHeightRatio = kBottomSheetListRatio; // 초기 상태
  bool showDetail = false;
  Host? selectedHost;

  void _updateSheetRatio(double newRatio) {
    _sheetHeightRatio =
        newRatio.clamp(kBottomSheetMinRatio, kBottomSheetMaxRatio);
    sheetHeightRatio.value = _sheetHeightRatio;
  }

  // 외부에서 호출 가능: 바텀 시트를 비활성화 (축소)
  void deactivateSheet() {
    setState(() {
      _updateSheetRatio(kBottomSheetMinRatio);
    });
  }

  // 호스트 선택 → 상세 화면 전환
  void openDetail(Host host) {
    // 호스트 선택 시 상태 업데이트
    ref.read(hostNotifierProvider.notifier).select(host);
    setState(() {
      showDetail = true;
      selectedHost = host;
      // 현재 높이가 최대면 유지, 아니면 디테일 뷰 높이로
      final targetRatio = _sheetHeightRatio == kBottomSheetMaxRatio
          ? kBottomSheetMaxRatio
          : kBottomSheetDetailRatio;
      _updateSheetRatio(targetRatio);
      isDetailVisible.value = true;
    });
  }

  // 리스트로 돌아가기
  void _backToList() {
    // 호스트 선택 해제
    ref.read(hostNotifierProvider.notifier).clear();
    setState(() {
      showDetail = false;
      selectedHost = null;
      // 현재 높이가 최대면 유지, 아니면 기본 리스트 높이로
      final targetRatio = _sheetHeightRatio == kBottomSheetMaxRatio
          ? kBottomSheetMaxRatio
          : kBottomSheetListRatio;
      _updateSheetRatio(targetRatio);
      isDetailVisible.value = false;
    });
  }

  // 드래그 중 바텀 시트 높이 변경
  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      final delta = details.primaryDelta! / MediaQuery.of(context).size.height;
      _updateSheetRatio(_sheetHeightRatio - delta);
    });
  }

  // 드래그 끝났을 때 가까운 높이로 스냅
  void _onVerticalDragEnd(DragEndDetails details) {
    final breakpoints = showDetail
        ? [kBottomSheetMinRatio, kBottomSheetDetailRatio, kBottomSheetMaxRatio]
        : [kBottomSheetMinRatio, kBottomSheetListRatio, kBottomSheetMaxRatio];

    double closest = breakpoints.reduce((a, b) =>
        (_sheetHeightRatio - a).abs() < (_sheetHeightRatio - b).abs() ? a : b);

    setState(() {
      _updateSheetRatio(closest);
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
                      onHostTap: openDetail,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
