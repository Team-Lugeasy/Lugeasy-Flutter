import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:lugeasy/view/main/map/bottomsheet/host_bottom_sheet.dart';

class MapPage extends StatefulWidget {
  final ValueNotifier<bool> isDetailVisible;

  const MapPage({super.key, required this.isDetailVisible});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final GlobalKey<HostBottomSheetState> _bottomSheetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    HostBottomSheetState.isDetailVisible.addListener(() {
      widget.isDetailVisible.value = HostBottomSheetState.isDetailVisible.value;
    });
  }

  void _deactivateSheet() {
    _bottomSheetKey.currentState?.deactivateSheet();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NaverMap(
          options: NaverMapViewOptions(
            initialCameraPosition: NCameraPosition(
              target: NLatLng(37.5666, 126.979),
              zoom: 10,
              bearing: 0,
              tilt: 0,
            ),
            mapType: NMapType.basic,
            activeLayerGroups: [NLayerGroup.building, NLayerGroup.transit],
          ),
          onMapReady: (myMapController) {
            debugPrint("네이버 맵 로딩됨!");
          },
          onMapTapped: (point, latLng) {
            debugPrint("${latLng.latitude}、${latLng.longitude}");
          },
        ),

        // 바텀 시트
        Positioned.fill(
          child: HostBottomSheet(
            key: _bottomSheetKey,
            onClose: _deactivateSheet,
          ),
        ),
      ],
    );

    // GestureDetector(
    //   behavior: HitTestBehavior.translucent,
    //   onTapDown: (details) {
    //     final renderBox = context.findRenderObject() as RenderBox;
    //     final localPosition = renderBox.globalToLocal(details.globalPosition);
    //     final screenHeight = MediaQuery.of(context).size.height;
    //     final sheetHeight =
    //         screenHeight * HostBottomSheetState.sheetHeightRatio.value;

    //     if (localPosition.dy < screenHeight - sheetHeight) {
    //       _deactivateSheet();
    //     }
    //   },
    //   child: Stack(
    //     children: [
    //       NaverMap(
    //         options: NaverMapViewOptions(
    //           initialCameraPosition: NCameraPosition(
    //             target: NLatLng(37.5666, 126.979),
    //             zoom: 10,
    //             bearing: 0,
    //             tilt: 0,
    //           ),
    //           mapType: NMapType.basic,
    //           activeLayerGroups: [NLayerGroup.building, NLayerGroup.transit],
    //         ),
    //         onMapReady: (myMapController) {
    //           debugPrint("네이버 맵 로딩됨!");
    //         },
    //         onMapTapped: (point, latLng) {
    //           debugPrint("${latLng.latitude}、${latLng.longitude}");
    //         },
    //       ),

    //       // 바텀 시트
    //       Positioned.fill(
    //         child: HostBottomSheet(
    //           key: _bottomSheetKey,
    //           onClose: _deactivateSheet,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
