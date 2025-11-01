import 'package:lugeasy/data/datasources/base_api_service.dart';
import 'package:lugeasy/data/datasources/local/token_service.dart';
import 'package:lugeasy/data/common/api_result.dart';
import 'package:lugeasy/data/models/login_response.dart';

class IntroServices extends BaseApiService {
  static const String basePath = '/auths';

  Future<ApiResult<LoginResponse>> login(String token, String type) async {
    final response = await post<LoginResponse>(
      path: '$basePath/sign-in',
      queryParameters: {
        'socialType': type,
      },
      body: {
        'encrypted_user_identifier': 'kyungsugoja',
      },
      fromJson: (json) => LoginResponse.fromJson(json),
    );

    // 성공 시 토큰 저장
    if (response is Success<LoginResponse>) {
      await TokenService.saveTokens(
        accessToken: response.data.accessToken,
        refreshToken: response.data.refreshToken,
      );
    }

    return response;
  }

  Future<ApiResult<LoginResponse>> refresh(String refreshToken) async {
    final response = await post<LoginResponse>(
      path: '$basePath/refresh/accessToken',
      body: {
        'refreshToken': refreshToken,
      },
      fromJson: (json) => LoginResponse.fromJson(json),
    );

    // 성공 시 토큰 저장
    if (response is Success<LoginResponse>) {
      await TokenService.saveTokens(
        accessToken: response.data.accessToken,
        refreshToken: response.data.refreshToken,
      );
    }

    return response;
  }
}
