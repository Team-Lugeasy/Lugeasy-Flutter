import 'package:flutter/material.dart';
import 'package:lugeasy/components/host_bottom_sheet.dart';

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  _MainContainerState createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  // 바텀 시트 컨트롤러에 접근하기 위한 글로벌 키
  final GlobalKey<HostBottomSheetState> _bottomSheetKey = GlobalKey();

  // 바텀 시트를 비활성화 (축소) 처리
  void _deactivateSheet() {
    _bottomSheetKey.currentState?.deactivateSheet();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (details) {
        final renderBox = context.findRenderObject() as RenderBox;
        final localPosition = renderBox.globalToLocal(details.globalPosition);

        final screenHeight = MediaQuery.of(context).size.height;
        final sheetHeight = screenHeight *
            (_bottomSheetKey.currentState?.sheetHeightRatio ?? 0.1);

        // 바텀 시트 영역 바깥을 눌렀을 때만 비활성화
        if (localPosition.dy < screenHeight - sheetHeight) {
          _deactivateSheet();
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            // 메인 콘텐츠 (예: 지도 영역)
            Center(child: Text('main page')),
            // 바텀 시트는 항상 열려 있음
            Positioned.fill(
              child: HostBottomSheet(
                key: _bottomSheetKey,
                onClose: _deactivateSheet,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
