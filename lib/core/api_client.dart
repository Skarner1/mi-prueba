import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  final Dio dio;

  ApiClient._(this.dio);

  /// Crea un Dio con la baseUrl configurada
  factory ApiClient.create({String baseUrl = 'https://monitoringinnovation.com/api/v1/hiring-tests'}) {
    final dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Accept': 'application/json',
      },
    ));

    // Interceptor opcional: logs básicos
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true, logPrint: (o) => debugPrint(o.toString())));

    return ApiClient._(dio);
  }
}