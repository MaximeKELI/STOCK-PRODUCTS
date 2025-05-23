import 'package:dio/dio.dart';
import '../config/api_config.dart';

class ApiService {
  final Dio dio;

  ApiService._() : dio = Dio(BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    connectTimeout: ApiConfig.connectTimeout,
    receiveTimeout: ApiConfig.receiveTimeout,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  static final ApiService _instance = ApiService._();

  factory ApiService() {
    return _instance;
  }
} 