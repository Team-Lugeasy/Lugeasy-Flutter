import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lugeasy/data/models/match.dart';

part 'match_provider.g.dart';

class MatchListResult {
  final List<Match> pendingList;
  final List<Match> completeList;

  MatchListResult({
    required this.pendingList,
    required this.completeList,
  });
}

@riverpod
class MatchProvider extends _$MatchProvider {
  @override
  Future<MatchListResult> build() async {
    return await _fetchMatchList();
  }

  Future<void> refreshMatchs() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchMatchList());
  }

  Future<MatchListResult> _fetchMatchList() async {
    final results = await Future.wait([
      _fetchCompleteReservation(),
      _fetchPendingReservation(),
    ]);
    return MatchListResult(
      completeList: results[0],
      pendingList: results[1],
    );
  }

  /// 예약요청 list api 통신
  Future<List<Match>> _fetchPendingReservation() async {
    const jsonData = '''
    [
      {
        "match_id": 2,
        "profile_image": "",
        "time_stamp": "",
        "message": "OOO님께 예약을 요청중이에요",
        "match_type": "pending"
      },
      {
        "match_id": 3,
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
        "match_id": 0,
        "profile_image": "",
        "time_stamp": "",
        "message": "OOO님과의 예약이 완료되었어요",
        "match_type": "complete"
      },
      {
        "match_id": 1,
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

// Provider 이름을 export (한 번만 사용)
final matchListProvider = matchProviderProvider;
