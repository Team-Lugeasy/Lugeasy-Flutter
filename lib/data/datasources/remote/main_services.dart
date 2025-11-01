import 'package:lugeasy/data/datasources/base_api_service.dart';
import 'package:lugeasy/data/common/api_result.dart';
import 'package:lugeasy/data/models/match_model.dart';

class MainServices extends BaseApiService {
  static const String basePath = '/api/v1';

  Future<ApiResult<List<MatchModel>>> getMatchList() async {
    final response = await get<List<MatchModel>>(
      path: '$basePath/matches',
      fromJson: (json) => (json as List)
          .map((item) => MatchModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );

    return response;
  }

  Future<ApiResult<MatchModel>> getMatchDetail(int matchId) async {
    final response = await get<MatchModel>(
        path: '$basePath/matches/$matchId',
        fromJson: (json) => MatchModel.fromJson(json));

    return response;
  }
}
