import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:lugeasy/data/datasources/http_interceptor.dart';
import 'package:lugeasy/data/datasources/local/token_service.dart';
import 'package:lugeasy/data/models/root_response.dart';
import 'package:lugeasy/data/models/login_response.dart';

class IntroServices {
  final String baseDomain = dotenv.env['BASE_URL'] ?? '';
  static const String basePath = '/auths';
  final client = InterceptedClient.build(interceptors: [HttpInterceptor()]);

  Future<RootResponse<LoginResponse>> login(String token, String type) async {
    final url = Uri.https(baseDomain, '$basePath/sign-in', {
      'socialType': type,
    });

    try {
      final response = await client.post(
        url,
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: json.encode({'encrypted_user_identifier': token}),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = json.decode(response.body);
        final loginData = LoginResponse.fromJson(data['result']);

        await TokenService.saveTokens(
          accessToken: loginData.accessToken,
          refreshToken: loginData.refreshToken,
        );
        return Success(loginData);
      } else {
        return Error('로그인 실패', code: response.statusCode);
      }
    } catch (e) {
      return Error('예외 발생: ${e.toString()}');
    }
  }

  Future<RootResponse<LoginResponse>> refresh(String refreshToken) async {
    final url = Uri.https(baseDomain, '$basePath/refresh/accessToken');

    try {
      final response = await client.post(
        url,
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: json.encode({'refreshToken': refreshToken}),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = json.decode(response.body);
        final loginData = LoginResponse.fromJson(data);

        await TokenService.saveTokens(
          accessToken: loginData.accessToken,
          refreshToken: loginData.refreshToken,
        );
        return Success(loginData);
      } else {
        return Error('토큰 리프레시 실패', code: response.statusCode);
      }
    } catch (e) {
      return Error('예외 발생: ${e.toString()}');
    }
  }
}
