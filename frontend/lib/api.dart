import 'package:dio/dio.dart';
import 'config/api_config.dart';

class Api {
  static api() {
    final options = BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      followRedirects: true,
    );

    return Dio(options);
  }
}
