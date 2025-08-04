import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lugeasy/models/match.dart';

part 'past_match_provider.g.dart';

@riverpod
class PastMatchProvider extends _$PastMatchProvider {
  int _currentPage = 0;
  bool _isLastPage = false;
  @override
  Future<List<Match>> build() async {
    return await _fetchPastMatchList(page: _currentPage);
  }

  Future<void> refreshMatchs() async {
    _currentPage = 0;
    _isLastPage = false;
    state = const AsyncLoading();
    final newList =
        await AsyncValue.guard(() => _fetchPastMatchList(page: _currentPage));
    state = newList;
  }

  Future<void> nextPage() async {
    if (_isLastPage || state.isLoading) return;

    _currentPage += 1;

    final nextData = await _fetchPastMatchList(page: _currentPage);

    if (nextData.isEmpty) {
      _isLastPage = true;
      return;
    }

    state =
        await state.whenData((currentList) => [...currentList, ...nextData]);
  }

  Future<List<Match>> _fetchPastMatchList({required int page}) async {
    final jsonData = page == 0
        ? '''
        [
          {
            "match_id": 2,
            "profile_image": "",
            "time_stamp": "",
            "message": "1페이지 - 예약 완료",
            "match_type": "past"
          },
          {
            "match_id": 3,
            "profile_image": "",
            "time_stamp": "",
            "message": "1페이지 - 예약 확정",
            "match_type": "past"
          },
                    {
            "match_id": 3,
            "profile_image": "",
            "time_stamp": "",
            "message": "1페이지 - 예약 확정",
            "match_type": "past"
          },
          {
            "match_id": 3,
            "profile_image": "",
            "time_stamp": "",
            "message": "1페이지 - 예약 확정",
            "match_type": "past"
          },
          {
            "match_id": 3,
            "profile_image": "",
            "time_stamp": "",
            "message": "1페이지 - 예약 확정",
            "match_type": "past"
          },
          {
            "match_id": 3,
            "profile_image": "",
            "time_stamp": "",
            "message": "1페이지 - 예약 확정",
            "match_type": "past"
          }
        ]
      '''
        : page == 1
            ? '''
        [
          {
            "match_id": 4,
            "profile_image": "",
            "time_stamp": "",
            "message": "2페이지 - 예약 확정",
            "match_type": "past"
          },
          {
            "match_id": 4,
            "profile_image": "",
            "time_stamp": "",
            "message": "2페이지 - 예약 확정",
            "match_type": "past"
          },
          {
            "match_id": 4,
            "profile_image": "",
            "time_stamp": "",
            "message": "2페이지 - 예약 확정",
            "match_type": "past"
          }
        ]
      '''
            : page == 2
                ? '''
        [
          {
            "match_id": 4,
            "profile_image": "",
            "time_stamp": "",
            "message": "3페이지 - 예약 확정",
            "match_type": "past"
          },
          {
            "match_id": 4,
            "profile_image": "",
            "time_stamp": "",
            "message": 3페이지 - 예약 확정",
            "match_type": "past"
          },
          {
            "match_id": 4,
            "profile_image": "",
            "time_stamp": "",
            "message": "3페이지 - 예약 확정",
            "match_type": "past"
          }
        ]
      '''
                : '''
        [] 
      ''';

    final List<dynamic> parsedJson = json.decode(jsonData);
    return parsedJson.map((e) => Match.fromJson(e)).toList();
  }
}

// Provider 이름을 export (한 번만 사용)
final pastMatchListProvider = pastMatchProviderProvider;
