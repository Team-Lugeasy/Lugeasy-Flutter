import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lugeasy/providers/host/host_provider.dart';
import 'package:lugeasy/models/host.dart';
import 'package:lugeasy/view/main/map/components/host_bottom_sheet.dart';
import 'package:lugeasy/view/navigation_route.dart';
import 'package:lugeasy/view/navigation_service.dart';
import 'package:lugeasy/common/extensions/context_extension.dart';

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

  void navigateToSearch() {
    NavigationService().navigateWithSlide(NavigationRoute.search);
  }

  /// 마커찍기
  Future<void> _addHostMarkers(List<Host> hosts) async {
    for (final host in hosts) {
      final marker = NMarker(
          id: host.name, // 고유 ID
          position: NLatLng(host.latitude, host.longitude),
          caption: NOverlayCaption(text: host.name));

      marker.setOnTapListener((NMarker clickedMarker) {
        _onMarkerTap(host);
      });

      await _mapController.addOverlay(marker);
    }
  }

  Future<void> _onMarkerTap(Host host) async {
    debugPrint("Clicked host: ${host.name}");

    final double latitudeOffset = 0.0015;

    _mapController.updateCamera(
      NCameraUpdate.scrollAndZoomTo(
          target: NLatLng(host.latitude - latitudeOffset, host.longitude),
          zoom: 15),
    );

    _bottomSheetKey.currentState?.openDetail(host);
  }

  @override
  Widget build(BuildContext context) {
    final asyncHosts = ref.watch(hostListProvider);

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

              await ref.read(hostListProvider.notifier).refreshHosts(
                  currentCenter.latitude, currentCenter.longitude);
            }
          },
        ),

        Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Row(
              children: [
                // 검색바
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      navigateToSearch();
                    },
                    child: Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icon_search.svg',
                              width: 20,
                              height: 20,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                context.l10n.search,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 12),

                /// 알람 버튼
                Material(
                  elevation: 3,
                  shape: CircleBorder(),
                  child: InkWell(
                    customBorder: CircleBorder(),
                    onTap: () {
                      // 아이콘 클릭 처리
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: SizedBox(
                        width: 12,
                        height: 12,
                        child: SvgPicture.asset(
                          'assets/icon_notification_unread.svg',
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
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
