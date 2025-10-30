import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lugeasy/core/util/color_style.dart';
import 'package:lugeasy/core/util/text_style.dart';
import 'package:lugeasy/providers/host/host_provider.dart';
import 'package:lugeasy/data/models/host.dart';
import 'package:lugeasy/view/main/map/host_bottom_sheet.dart';
import 'package:lugeasy/view/navigation_route.dart';
import 'package:lugeasy/view/navigation_service.dart';
import 'package:lugeasy/widgets/button.dart';

class MapView extends ConsumerStatefulWidget {
  final ValueNotifier<bool> isDetailVisible;

  const MapView({super.key, required this.isDetailVisible});

  @override
  ConsumerState<MapView> createState() => _MapViewState();
}

class _MapViewState extends ConsumerState<MapView> {
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

  void navigateToAlarm() {
    NavigationService().navigateWithSlide(NavigationRoute.alarm);
  }

  /// 마커찍기
  Future<void> _addHostMarkers(List<Host> hosts) async {
    for (final host in hosts) {
      final marker = NMarker(
          id: host.name,
          icon: NOverlayImage.fromAssetImage('assets/icon/icon_marker.png'),
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
            top: 68.h,
            left: 16.w,
            right: 16.w,
            child: Row(
              children: [
                Expanded(
                  child: Button(
                    onTap: () {
                      navigateToSearch();
                    },
                    child: Container(
                      width: 312.w,
                      height: 56.h,
                      padding: EdgeInsets.only(left: 18.w),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100.h),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4.r,
                            offset: Offset(0, 4.h),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/icon/icon_search.png',
                            width: 28.w,
                            height: 28.h,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(width: 14.w),
                          Text(
                            "호스트를 찾아보세요",
                            style: LugeasyTextStyles.body1.copyWith(
                              color: LugeasyColorStyles.gray500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Button(
                  child: Image.asset(
                    "assets/icon/icon_notification.png",
                    width: 56.w,
                    height: 56.h,
                    fit: BoxFit.contain,
                  ),
                  onTap: () {
                    navigateToAlarm();
                  },
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
  }
}
