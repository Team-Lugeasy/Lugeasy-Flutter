import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lugeasy/provider/host_list_data_provider.dart';
import 'package:lugeasy/services/model/host.dart';
import 'package:lugeasy/view/main/map/bottomsheet/host_bottom_sheet.dart';

class MapPage extends ConsumerStatefulWidget {
  final ValueNotifier<bool> isDetailVisible;

  const MapPage({super.key, required this.isDetailVisible});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  final GlobalKey<HostBottomSheetState> _bottomSheetKey = GlobalKey();
  late NaverMapController _mapController;
  NLatLng? _lastCameraPosition;

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

  /// 지도에 마커를 추가하는 함수
  Future<void> _addHostMarkers(List<Host> hosts) async {
    for (final host in hosts) {
      final marker = NMarker(
        id: host.name, // 고유 ID
        position: NLatLng(host.latitude, host.longitude),
      );

      marker.setOnTapListener((NMarker clickedMarker) {
        _onMarkerTap(host);
      });

      await _mapController.addOverlay(marker);
    }
  }

  Future<void> _onMarkerTap(Host host) async {
    debugPrint("Clicked host: ${host.name}");
    _bottomSheetKey.currentState?.openDetail(host);
  }

  @override
  Widget build(BuildContext context) {
    final asyncHosts = ref.watch(hostListNotifierProvider);

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
          onMapReady: (myMapController) async {
            debugPrint("네이버 맵 로딩 완료");
            _mapController = myMapController;

            asyncHosts.when(
              data: (hosts) => _addHostMarkers(hosts),
              loading: () => debugPrint("호스트 로딩 중"),
              error: (e, _) => debugPrint("에러: $e"),
            );
          },
          onMapTapped: (point, latLng) {
            debugPrint("${latLng.latitude}、${latLng.longitude}");
          },
          onCameraIdle: () async {
            final cameraPosition = await _mapController.getCameraPosition();
            final currentCenter = cameraPosition.target;

            // 좌표 변화 감지
            const threshold = 0.0001;
            if (_lastCameraPosition == null ||
                (currentCenter.latitude - _lastCameraPosition!.latitude).abs() >
                    threshold ||
                (currentCenter.longitude - _lastCameraPosition!.longitude)
                        .abs() >
                    threshold) {
              debugPrint(
                  'center: ${currentCenter.latitude}, ${currentCenter.longitude}');

              _lastCameraPosition = currentCenter;

              await ref.read(hostListNotifierProvider.notifier).refreshHosts(
                  currentCenter.latitude, currentCenter.longitude);
            }
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
