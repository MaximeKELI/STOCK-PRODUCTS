import '../api.dart';
import 'package:dio/dio.dart';
import '../models/authenticated_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  Dio api = Api.api();

  Future<AuthenticatedUser> login(Map<String, dynamic> data) async {
    final response = await api.post('/auth/login', data: data);
    return AuthenticatedUser.fromJson(response.data);
  }

  Future<User> create(Map<String, dynamic> data) async {
    final response = await api.post('/auth/register', data: data);
    return User.fromJson(response.data);
  }

  Future<User> get(String id) async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      api.options.headers['Authorization'] = 'Bearer $token';
    }

    final response = await api.get('/users/$id');
    return User.fromJson(response.data);
  }

  Future<User> update(int id, Map<String, dynamic> data) async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      api.options.headers['Authorization'] = 'Bearer $token';
    }

    final response = await api.put('/users/$id', data: data);
    return User.fromJson(response.data);
  }

  Future<Map<String, dynamic>> updatePassword(Map<String, dynamic> data) async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      api.options.headers['Authorization'] = 'Bearer $token';
    }

    final response = await api.post('/users/password', data: data);
    return response.data;
  }
}
