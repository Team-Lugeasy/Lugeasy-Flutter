// host_list_data_provider.dart

import 'dart:convert';
import 'dart:async';
import 'package:lugeasy/data/models/host.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'host_provider.g.dart';

@riverpod
class HostProvider extends _$HostProvider {
  int _currentPage = 0;
  bool _isLastPage = false;
  Completer<void>? _nextPageCompleter;

  @override
  Future<List<Host>> build() async {
    return await _fetchHosts(page: _currentPage);
  }

  /// 중심 좌표 기반으로 호스트 리스트 새로 가져오기
  Future<void> refreshHosts(double latitude, double longitude) async {
    _currentPage = 0;
    _isLastPage = false;
    _nextPageCompleter?.complete();
    _nextPageCompleter = null;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchHosts(page: _currentPage));
  }

  /// 다음 페이지 로드 (무한 스크롤)
  Future<void> nextPage() async {
    // 이미 마지막 페이지이거나 로딩 중이면 무시
    if (_isLastPage || state.isLoading) {
      print(
          "nextPage blocked: isLastPage=$_isLastPage, isLoading=${state.isLoading}");
      return;
    }

    // 이미 진행 중인 요청이 있으면 기다림
    if (_nextPageCompleter != null) {
      print("nextPage waiting for existing request");
      await _nextPageCompleter!.future;
      return;
    }

    print("nextPage called for page: ${_currentPage + 1}");
    _nextPageCompleter = Completer<void>();
    _currentPage += 1;

    try {
      final nextData = await _fetchHosts(page: _currentPage);

      if (nextData.isEmpty) {
        _isLastPage = true;
        print("Reached last page");
        return;
      }

      state =
          await state.whenData((currentList) => [...currentList, ...nextData]);
      print(
          "Successfully loaded page: $_currentPage with ${nextData.length} items");
    } catch (e) {
      // 에러 발생 시 페이지 번호 되돌리기
      _currentPage -= 1;
      print("Error loading page: $e");
    } finally {
      _nextPageCompleter?.complete();
      _nextPageCompleter = null;
    }
  }

  /// 실제 API 호출 또는 더미 데이터 로딩
  Future<List<Host>> _fetchHosts({required int page}) async {
    // TODO: 나중에 latitude/longitude 기반 필터링 추가
    final jsonData = page == 0
        ? '''
        [
          {
            "host_id": 1,
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
            "host_id": 2,
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
            "host_id": 3,
            "name": "Jisu Yoo",
            "profile_image": "",
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
            "profile_image": "",
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
            "profile_image": "",
            "review_rate": 4.9,
            "review_count": 203,
            "address": "456 Itaewon-ro, Yongsan-gu, Seoul",
            "description": "International district with great accessibility",
            "latitude": 37.534,
            "longitude": 126.994
          }
        ]
        '''
        : page == 1
            ? '''
        [
          {
            "host_id": 6,
            "name": "Junho Kim",
            "profile_image": "",
            "review_rate": 4.6,
            "review_count": 89,
            "address": "789 Myeongdong-gil, Jung-gu, Seoul",
            "description": "Shopping district with tourist attractions",
            "latitude": 37.563,
            "longitude": 126.983
          },
          {
            "host_id": 7,
            "name": "Yuna Lee",
            "profile_image": "",
            "review_rate": 5.0,
            "review_count": 178,
            "address": "321 Dongdaemun-ro, Jung-gu, Seoul",
            "description": "Fashion district with 24/7 shopping",
            "latitude": 37.567,
            "longitude": 127.009
          },
          {
            "host_id": 8,
            "name": "Seungwoo Han",
            "profile_image": "",
            "review_rate": 4.8,
            "review_count": 134,
            "address": "654 Sinchon-ro, Seodaemun-gu, Seoul",
            "description": "University area with young atmosphere",
            "latitude": 37.561,
            "longitude": 126.936
          },
          {
            "host_id": 9,
            "name": "Hyeri Jung",
            "profile_image": "",
            "review_rate": 4.7,
            "review_count": 95,
            "address": "987 Apgujeong-ro, Gangnam-gu, Seoul",
            "description": "Trendy area with luxury shopping",
            "latitude": 37.526,
            "longitude": 127.028
          },
          {
            "host_id": 10,
            "name": "Donghyun Yoon",
            "profile_image": "",
            "review_rate": 4.9,
            "review_count": 167,
            "address": "456 Garosu-gil, Gangnam-gu, Seoul",
            "description": "Fashion street with boutique shops",
            "latitude": 37.522,
            "longitude": 127.023
          }
        ]
        '''
            : page == 2
                ? '''
        [
          {
            "host_id": 11,
            "name": "Seoyeon Kang",
            "profile_image": "",
            "review_rate": 4.8,
            "review_count": 112,
            "address": "789 Insadong-gil, Jongno-gu, Seoul",
            "description": "Traditional culture area with hanbok experience",
            "latitude": 37.573,
            "longitude": 126.989
          },
          {
            "host_id": 12,
            "name": "Jiwon Bae",
            "profile_image": "",
            "review_rate": 4.6,
            "review_count": 78,
            "address": "123 Bukchon-ro, Jongno-gu, Seoul",
            "description": "Traditional hanok village area",
            "latitude": 37.581,
            "longitude": 126.984
          }
        ]
        '''
                : '''
        []
        ''';

    final List<dynamic> parsedJson = json.decode(jsonData);
    final hosts = parsedJson.map((e) => Host.fromJson(e)).toList();
    return hosts;
  }
}

// Provider 이름을 export (한 번만 사용)
final hostListProvider = hostProviderProvider;
