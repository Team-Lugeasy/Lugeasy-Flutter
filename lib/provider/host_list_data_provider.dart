// host_list_data_provider.dart

import 'dart:convert';
import 'package:lugeasy/services/model/host.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'host_list_data_provider.g.dart';

@riverpod
class HostList extends _$HostList {
  @override
  Future<List<Host>> build() async {
    return await _fetchHosts(37.5665, 126.9780); // 초기 위치 (서울)
  }

  /// 중심 좌표 기반으로 호스트 리스트 새로 가져오기
  Future<void> refreshHosts(double latitude, double longitude) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchHosts(latitude, longitude));
  }

  /// 실제 API 호출 또는 더미 데이터 로딩
  Future<List<Host>> _fetchHosts(double latitude, double longitude) async {
    // TODO: 나중에 latitude/longitude 기반 필터링 추가
    const jsonData = '''
    [
      {
        "hostId": 1,
        "name": "Taerin Kim",
        "profile_image": "",
        "review_rate": 4.9,
        "review_count": 119,
        "address": "24 Saleh Al-Mahmoud Street, Yanbu",
        "description": "Reliable host near the station",
        "latitude": 37.5642135,
        "longitude": 127.0016985
      },
      {
        "hostId": 2,
        "name": "Liver Lee",
        "profile_image": "",
        "review_rate": 4.8,
        "review_count": 82,
        "address": "50 Namsan-gil, Seoul",
        "description": "Clean and safe luggage service",
        "latitude": 37.57,
        "longitude": 127.001
      },
      {
        "hostId": 3,
        "name": "Jisu Yoo",
        "profile_image": "",
        "review_rate": 5.0,
        "review_count": 65,
        "address": "12-3 Gangnam-daero, Seoul",
        "description": "Kind host in center of Seoul",
        "latitude": 37.575,
        "longitude": 127.0008
      }
    ]
    ''';

    final List<dynamic> parsedJson = json.decode(jsonData);
    final hosts = parsedJson.map((e) => Host.fromJson(e)).toList();
    return hosts;
  }
}
