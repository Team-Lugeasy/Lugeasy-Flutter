import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:lugeasy/services/base_response.dart';
import 'package:lugeasy/services/logging_interceptor.dart';
import 'package:lugeasy/services/model/login_response.dart';

class IntroServices {
  final String baseDomain = dotenv.env['BASE_URL'] ?? '';
  static const String basePath = '/api/auth/login';
  final client = InterceptedClient.build(interceptors: [LoggingInterceptor()]);

  Future<BaseResponse<LoginResponse>> login(String token, String type) async {
    // type을 쿼리로 추가
    final url = Uri.https(baseDomain, basePath, {
      'social_type': type,
    });

    print("google_id_token $token");

    try {
      final response = await client.post(
        url,
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: json.encode({'id_token': token}),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = json.decode(response.body);
        final loginData = LoginResponse.fromJson(data);
        return Success(loginData);
      } else {
        return Error('로그인 실패', code: response.statusCode);
      }
    } catch (e) {
      return Error('예외 발생: ${e.toString()}');
    }
  }
}
