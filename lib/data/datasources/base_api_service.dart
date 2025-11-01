import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:lugeasy/data/datasources/http_interceptor.dart';
import 'package:lugeasy/data/common/api_response.dart';
import 'package:lugeasy/data/common/api_result.dart';

class BaseApiService {
  final String baseDomain = dotenv.env['BASE_URL'] ?? '';
  final client = InterceptedClient.build(interceptors: [HttpInterceptor()]);

  Future<ApiResult<T>> get<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, String>? headers,
  }) async {
    return _handleRequest<T>(
      () => client.get(
        Uri.https(baseDomain, path, queryParameters),
        headers: _buildHeaders(headers),
      ),
      fromJson,
    );
  }

  Future<ApiResult<T>> post<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, String>? headers,
  }) async {
    return _handleRequest<T>(
      () => client.post(
        Uri.https(baseDomain, path, queryParameters),
        headers: _buildHeaders(headers),
        body: body != null ? json.encode(body) : null,
      ),
      fromJson,
    );
  }

  Future<ApiResult<T>> put<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, String>? headers,
  }) async {
    return _handleRequest<T>(
      () => client.put(
        Uri.https(baseDomain, path, queryParameters),
        headers: _buildHeaders(headers),
        body: body != null ? json.encode(body) : null,
      ),
      fromJson,
    );
  }

  Future<ApiResult<T>> delete<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, String>? headers,
  }) async {
    return _handleRequest<T>(
      () => client.delete(
        Uri.https(baseDomain, path, queryParameters),
        headers: _buildHeaders(headers),
      ),
      fromJson,
    );
  }

  Future<ApiResult<T>> _handleRequest<T>(
    Future<http.Response> Function() request,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await request();
      final responseBody = json.decode(utf8.decode(response.bodyBytes));

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        responseBody,
        (json) => json as Map<String, dynamic>,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (apiResponse.result != null) {
          final data = fromJson(apiResponse.result!);
          return Success(data);
        } else {
          return Error(
            apiResponse.message,
            code: response.statusCode,
          );
        }
      } else {
        return Error(
          apiResponse.message.isNotEmpty
              ? apiResponse.message
              : _getDefaultErrorMessage(response.statusCode),
          code: response.statusCode,
        );
      }
    } catch (e) {
      return Error('Parsing Error: ${e.toString()}');
    }
  }

  Map<String, String> _buildHeaders(Map<String, String>? customHeaders) {
    final headers = {
      "Content-Type": "application/json; charset=UTF-8",
    };

    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }

    return headers;
  }

  String _getDefaultErrorMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return '잘못된 요청입니다.';
      case 401:
        return '인증에 실패했습니다.';
      case 403:
        return '접근 권한이 없습니다.';
      case 404:
        return '요청한 리소스를 찾을 수 없습니다.';
      case 500:
        return '서버 내부 오류가 발생했습니다.';
      case 502:
        return '게이트웨이 오류가 발생했습니다.';
      case 503:
        return '서비스를 일시적으로 사용할 수 없습니다.';
      default:
        return '알 수 없는 오류가 발생했습니다.';
    }
  }
}
