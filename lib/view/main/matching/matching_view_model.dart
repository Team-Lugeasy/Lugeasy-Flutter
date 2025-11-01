import 'package:lugeasy/core/util/log_util.dart';
import 'package:lugeasy/data/common/api_result.dart';
import 'package:lugeasy/data/datasources/remote/main_services.dart';
import 'package:lugeasy/data/models/match_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'matching_view_model.g.dart';

class MatchingViewState {
  const MatchingViewState();
}

class MatchingInitial extends MatchingViewState {
  const MatchingInitial();
}

class MatchingViewLoading extends MatchingViewState {
  const MatchingViewLoading();
}

class MatchingViewFailure extends MatchingViewState {
  final String message;
  const MatchingViewFailure(this.message);
}

class MatchingViewDataLoaded extends MatchingViewState {
  final MatchingData data;
  const MatchingViewDataLoaded(this.data);
}

class MatchItem {
  final String name;
  final String date;
  final String profileImg;
  final MatchingState state;

  MatchItem({
    required this.name,
    required this.date,
    required this.profileImg,
    required this.state,
  });
}

class MatchingData {
  final List<MatchItem> requestedMatches;
  final List<MatchItem> acceptedMatches;
  final List<MatchItem> completeMatches;

  MatchingData({
    required this.requestedMatches,
    required this.acceptedMatches,
    required this.completeMatches,
  });
}

@riverpod
class MatchingViewModel extends _$MatchingViewModel {
  @override
  MatchingViewState build() {
    return const MatchingInitial();
  }

  Future<void> getMatchList() async {
    final result = await MainServices().getMatchList();

    switch (result) {
      case Success():
        state = MatchingViewDataLoaded(
          MatchingData(
            requestedMatches: result.data
                .where((match) => match.status == MatchingState.requested)
                .map(
                  (match) => MatchItem(
                    name: "사용자 ${match.matchId}",
                    date: match.createdAt,
                    profileImg: "",
                    state: MatchingState.requested,
                  ),
                )
                .toList(),
            acceptedMatches: result.data
                .where((match) => match.status == MatchingState.accepted)
                .map(
                  (match) => MatchItem(
                    name: "사용자 ${match.matchId}",
                    date: match.createdAt,
                    profileImg: "",
                    state: MatchingState.accepted,
                  ),
                )
                .toList(),
            completeMatches: result.data
                .where((match) => match.status == MatchingState.completed)
                .map(
                  (match) => MatchItem(
                    name: "사용자 ${match.matchId}",
                    date: match.createdAt,
                    profileImg: "",
                    state: MatchingState.completed,
                  ),
                )
                .toList(),
          ),
        );
      case Error(message: final msg, code: final errorCode):
        logger.e("데이터 불러오기 실패 - code: $errorCode, message: $msg");
        state = MatchingViewFailure(msg);
    }
  }
}
