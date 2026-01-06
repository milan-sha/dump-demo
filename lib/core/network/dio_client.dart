import 'package:dio/dio.dart';
import 'endpoints.dart';

class DioClient {
  DioClient._();

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: Endpoints.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 10),
      responseType: ResponseType.json,
      contentType: 'application/json',
    ),
  )..interceptors.add(LogInterceptor(
      request: false,
      requestHeader: false,
      responseHeader: false,
      requestBody: false,
      responseBody: false,
    ));

  static Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.get<T>(path, queryParameters: queryParameters);
  }

  static Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.post<T>(path, data: data, queryParameters: queryParameters);
  }

  static Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.put<T>(path, data: data, queryParameters: queryParameters);
  }

  static Future<Response<T>> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.delete<T>(path, queryParameters: queryParameters);
  }
}
