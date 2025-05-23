class ApiConfig {
  static const String baseUrl = 'http://localhost:5084/api';  // URL du backend .NET
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
} 