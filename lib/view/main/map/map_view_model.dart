import 'dart:convert';

import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:lugeasy/core/util/log_util.dart';
import 'package:lugeasy/data/models/host_model.dart';
import 'package:lugeasy/view/navigation_route.dart';
import 'package:lugeasy/view/navigation_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_view_model.g.dart';

// State 정의
sealed class MapViewState {
  const MapViewState();
}

class MapViewInitial extends MapViewState {
  const MapViewInitial();
}

class MapViewLoading extends MapViewState {
  const MapViewLoading();
}

class MapViewFailure extends MapViewState {
  final String message;
  const MapViewFailure(this.message);
}

class MapViewDataLoaded extends MapViewState {
  final List<HostModel> hostList;
  final NLatLng? currentCenter;

  const MapViewDataLoaded({
    required this.hostList,
    this.currentCenter,
  });

  MapViewDataLoaded copyWith({
    List<HostModel>? hostList,
    NLatLng? currentCenter,
  }) {
    return MapViewDataLoaded(
      hostList: hostList ?? this.hostList,
      currentCenter: currentCenter ?? this.currentCenter,
    );
  }
}

// ✅ 이벤트 추가
class MapViewMarkerTapped extends MapViewState {
  final HostModel host;
  const MapViewMarkerTapped(this.host);
}

@riverpod
class MapViewModel extends _$MapViewModel {
  NaverMapController? _mapController;
  NLatLng? _lastCameraPosition;

  static const double _initialLatitude = 37.5666;
  static const double _initialLongitude = 126.979;
  static const double _initialZoom = 10.0;
  static const double _markerTapZoom = 15.0;
  static const double _markerTapLatitudeOffset = 0.0015;
  static const double _cameraThreshold = 0.0001;

  @override
  MapViewState build() {
    return const MapViewInitial();
  }

  NCameraPosition getInitialCameraPosition() {
    return NCameraPosition(
      target: NLatLng(_initialLatitude, _initialLongitude),
      zoom: _initialZoom,
      bearing: 0,
      tilt: 0,
    );
  }

  // 맵 컨트롤러 설정
  void setMapController(NaverMapController controller) {
    _mapController = controller;
    logger.d("네이버 맵 컨트롤러 설정 완료");
  }

  Future<void> getHostListNear(
      {double latitude = _initialLatitude,
      double longitude = _initialLongitude}) async {
    // final result = await MainServices().getHostListNear(latitude, longitude);

    // 테스트용
    final jsonData = '''
        [
          {
            "host_id": 1,
            "name": "Taerin Kim",
            "profile_img": "",
            "review_rate": 4.9,
            "review_count": 119,
            "address": "24 Saleh Al-Mahmoud Street, Yanbu",
            "description": "Reliable host near the station",
            "latitude": 37.5642135,
            "longitude": 127.0016985
          },
          {
            "host_id": 2,
            "name": "Liver Lee",
            "profile_img": "",
            "review_rate": 4.8,
            "review_count": 82,
            "address": "50 Namsan-gil, Seoul",
            "description": "Clean and safe luggage service",
            "latitude": 37.57,
            "longitude": 127.001
          },
          {
            "host_id": 3,
            "name": "Jisu Yoo",
            "profile_img": "",
            "review_rate": 5.0,
            "review_count": 65,
            "address": "12-3 Gangnam-daero, Seoul",
            "description": "Kind host in center of Seoul",
            "latitude": 37.575,
            "longitude": 127.0008
          },
          {
            "host_id": 4,
            "name": "Minho Park",
            "profile_img": "",
            "review_rate": 4.7,
            "review_count": 156,
            "address": "123 Hongdae-ro, Mapo-gu, Seoul",
            "description": "Convenient location near Hongik University",
            "latitude": 37.556,
            "longitude": 126.923
          },
          {
            "host_id": 5,
            "name": "Soojin Choi",
            "profile_img": "",
            "review_rate": 4.9,
            "review_count": 203,
            "address": "456 Itaewon-ro, Yongsan-gu, Seoul",
            "description": "International district with great accessibility",
            "latitude": 37.534,
            "longitude": 126.994
          }
        ]
        ''';

    final List<dynamic> parsedJson = json.decode(jsonData);
    final hosts = parsedJson.map((e) => HostModel.fromJson(e)).toList();

    state = MapViewDataLoaded(hostList: hosts);
  }

  Future<void> addHostMarkers(
    List<HostModel> hosts,
  ) async {
    if (_mapController == null) {
      logger.e("맵 컨트롤러가 초기화되지 않았습니다");
      return;
    }

    for (final host in hosts) {
      try {
        final marker = NMarker(
          id: host.hostId.toString(),
          icon: NOverlayImage.fromAssetImage('assets/icon/icon_marker.png'),
          position: NLatLng(host.latitude, host.longitude),
          caption: NOverlayCaption(text: host.name),
        );

        marker.setOnTapListener((NMarker clickedMarker) {
          _handleMarkerTap(host);
        });

        await _mapController!.addOverlay(marker);
      } catch (e) {
        state = MapViewFailure("마커 추가 실패: ${host.name}");
      }
    }

    state = MapViewDataLoaded(hostList: hosts);
  }

  Future<void> _handleMarkerTap(HostModel host) async {
    if (_mapController == null) return;

    state = MapViewMarkerTapped(host);

    try {
      await _mapController!.updateCamera(
        NCameraUpdate.scrollAndZoomTo(
          target: NLatLng(
            host.latitude - _markerTapLatitudeOffset,
            host.longitude,
          ),
          zoom: _markerTapZoom,
        ),
      );
    } catch (e) {
      state = MapViewFailure("카메라 이동 실패: ${e.toString()}");
    }
  }

  void handleMapTap(NLatLng latLng) {
    logger.d("지도 탭: ${latLng.latitude}, ${latLng.longitude}");
  }

  Future<void> handleCameraIdle() async {
    if (_mapController == null) return;

    try {
      final cameraPosition = await _mapController!.getCameraPosition();
      final currentCenter = cameraPosition.target;

      if (_shouldRefreshHosts(currentCenter)) {
        _lastCameraPosition = currentCenter;

        getHostListNear(
          latitude: currentCenter.latitude,
          longitude: currentCenter.longitude,
        );
      }
    } catch (e) {
      state = MapViewFailure("카메라 위치 처리 실패: ${e.toString()}");
    }
  }

  // 좌표 변화 감지 여부 확인
  bool _shouldRefreshHosts(NLatLng currentCenter) {
    if (_lastCameraPosition == null) return true;

    final latDiff =
        (currentCenter.latitude - _lastCameraPosition!.latitude).abs();
    final lngDiff =
        (currentCenter.longitude - _lastCameraPosition!.longitude).abs();

    return latDiff > _cameraThreshold || lngDiff > _cameraThreshold;
  }

  void navigateToSearch() {
    NavigationService().navigateWithSlide(NavigationRoute.search);
  }

  void navigateToAlarm() {
    NavigationService().navigateWithSlide(NavigationRoute.alarm);
  }

  void dispose() {
    _mapController = null;
    _lastCameraPosition = null;
  }
}
