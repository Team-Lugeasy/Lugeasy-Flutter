import 'package:flutter/material.dart';
import 'package:lugeasy/components/host_bottom_sheet.dart';
import 'package:lugeasy/common/constants.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final GlobalKey<HostBottomSheetState> _bottomSheetKey = GlobalKey();

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
            (_bottomSheetKey.currentState?.sheetHeightRatio ??
                kBottomSheetMinRatio);

        // 바텀 시트 영역 바깥을 눌렀을 때만 비활성화
        if (localPosition.dy < screenHeight - sheetHeight) {
          _deactivateSheet();
        }
      },
      child: Stack(
        children: [
          // 지도 또는 메인 콘텐츠
          const Center(child: Text('Map Content')), // TODO: 지도 위젯으로 교체

          // 바텀 시트
          Positioned.fill(
            child: HostBottomSheet(
              key: _bottomSheetKey,
              onClose: _deactivateSheet,
            ),
          ),
        ],
      ),
    );
  }
}
