import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lugeasy/common/constants.dart';
import 'package:lugeasy/view/main/map/bottomsheet/host_bottom_sheet.dart';
import 'package:lugeasy/view/main/map/bottomsheet/hostdetailsheet/reservation/reservation_button.dart';
import 'package:lugeasy/view/main/map/bottomsheet/hostdetailsheet/bottom_action_bar.dart';

class MapPage extends StatefulWidget {
  final ValueNotifier<bool> isDetailVisible;

  const MapPage({super.key, required this.isDetailVisible});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final GlobalKey<HostBottomSheetState> _bottomSheetKey = GlobalKey();
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

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
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (details) {
        final renderBox = context.findRenderObject() as RenderBox;
        final localPosition = renderBox.globalToLocal(details.globalPosition);
        final screenHeight = MediaQuery.of(context).size.height;
        final sheetHeight =
            screenHeight * HostBottomSheetState.sheetHeightRatio.value;

        if (localPosition.dy < screenHeight - sheetHeight) {
          _deactivateSheet();
        }
      },
      child: Stack(
        children: [
          GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                  target: LatLng(37.521563, 126.677433), zoom: 11.0),
              onMapCreated: _onMapCreated),

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
