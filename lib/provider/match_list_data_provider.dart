import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lugeasy/services/model/match.dart';

part 'match_list_data_provider.g.dart';

@riverpod
class MatchList extends _$MatchList {
  @override
  Future<List<Match>> build() async {
    return await _fetchMatchList();
  }

  Future<void> refreshMatchs() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchMatchList());
  }

  Future<List<Match>> _fetchMatchList() async {
    final results = await Future.wait([
      _fetchCompleteReservation(),
      _fetchPendingReservation(),
    ]);

    final combinedList = [...results[0], ...results[1]];
    return combinedList;
  }

  /// 예약요청 list api 통신
  Future<List<Match>> _fetchPendingReservation() async {
    const jsonData = '''
    [
      {
        "matchId": 2,
        "profile_image": "",
        "time_stamp": "",
        "message": "OOO님께 예약을 요청중이에요",
        "match_type": "pending"
      },
      {
        "matchId": 3,
        "profile_image": "",
        "time_stamp": "",
        "message": "OOO님께 예약을 요청중이에요",
        "match_type": "pending"
      }
    ]
    ''';

    final List<dynamic> parsedJson = json.decode(jsonData);
    return parsedJson.map((e) => Match.fromJson(e)).toList();
  }

  /// 예약완료 list api 통신
  Future<List<Match>> _fetchCompleteReservation() async {
    const jsonData = '''
    [
      {
        "matchId": 0,
        "profile_image": "",
        "time_stamp": "",
        "message": "OOO님과의 예약이 완료되었어요",
        "match_type": "complete"
      },
      {
        "matchId": 1,
        "profile_image": "",
        "time_stamp": "",
        "message": "OOO님과의 예약이 완료되었어요",
        "match_type": "complete"
      }
    ]
    ''';

    final List<dynamic> parsedJson = json.decode(jsonData);
    return parsedJson.map((e) => Match.fromJson(e)).toList();
  }
}
