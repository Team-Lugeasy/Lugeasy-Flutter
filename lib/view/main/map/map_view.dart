import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lugeasy/core/util/color_style.dart';
import 'package:lugeasy/core/util/text_style.dart';
import 'package:lugeasy/view/main/map/host_bottom_sheet.dart';
import 'package:lugeasy/view/main/map/map_view_model.dart';
import 'package:lugeasy/view/popup/custom_toast.dart';
import 'package:lugeasy/widgets/button.dart';

class MapView extends ConsumerStatefulWidget {
  final ValueNotifier<bool> isDetailVisible;

  const MapView({super.key, required this.isDetailVisible});

  @override
  ConsumerState<MapView> createState() => _MapViewState();
}

class _MapViewState extends ConsumerState<MapView> {
  final GlobalKey<HostBottomSheetState> _bottomSheetKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    // 바텀시트 상태 리스너
    HostBottomSheetState.isDetailVisible.addListener(() {
      widget.isDetailVisible.value = HostBottomSheetState.isDetailVisible.value;
    });
  }

  @override
  void dispose() {
    ref.read(mapViewModelProvider.notifier).dispose();
    super.dispose();
  }

  void _deactivateSheet() {
    _bottomSheetKey.currentState?.deactivateSheet();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(mapViewModelProvider.notifier);

    ref.listen<MapViewState>(mapViewModelProvider, (previous, next) {
      if (next is MapViewFailure) {
        CustomToast.showError(context, next.message.toString());
      }

      if (next is MapViewMarkerTapped) {
        _bottomSheetKey.currentState?.openDetail(next.host);
      }
    });

    return Stack(
      children: [
        NaverMap(
          options: NaverMapViewOptions(
            initialCameraPosition: viewModel.getInitialCameraPosition(),
            mapType: NMapType.basic,
            activeLayerGroups: [NLayerGroup.building, NLayerGroup.transit],
          ),
          onMapReady: (controller) async {
            viewModel.setMapController(controller);
            viewModel.getHostListNear();
          },
          onMapTapped: (point, latLng) {
            viewModel.handleMapTap(latLng);
          },
          onCameraIdle: () => viewModel.handleCameraIdle(),
        ),

        // 검색바 및 알림 버튼
        Positioned(
          top: 68.h,
          left: 16.w,
          right: 16.w,
          child: _buildTopBar(viewModel),
        ),

        // 바텀시트
        Positioned.fill(
          child: HostBottomSheet(
            key: _bottomSheetKey,
            onClose: _deactivateSheet,
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar(MapViewModel viewModel) {
    return Row(
      children: [
        Expanded(
          child: Button(
            onTap: viewModel.navigateToSearch,
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
          onTap: viewModel.navigateToAlarm,
          child: Image.asset(
            "assets/icon/icon_notification.png",
            width: 56.w,
            height: 56.h,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
