import 'package:dio/dio.dart';
import 'package:stock_landy/api.dart';
import 'package:stock_landy/services/api.dart';
import 'package:stock_landy/models/stock_movement.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StockmovementServive {
  final ApiService _apiService = ApiService();

  Future<StockMovement> create(Map<String, dynamic> data) async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      _apiService.dio.options.headers['AUTHORIZATION'] = 'Bearer $token';
    }

    final response = await _apiService.dio.post('stock_movements/', data: data);

    return StockMovement.fromJson(response.data);
  }

  Future<StockMovement> get(String id) async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      _apiService.dio.options.headers['AUTHORIZATION'] = 'Bearer $token';
    }

    final response = await _apiService.dio.get('stock_movements/$id');

    return StockMovement.fromJson(response.data);
  }

  Future<List<StockMovement>> getAll() async {
    try {
      final response = await _apiService.dio.get('/stock-movements');
      return (response.data as List)
          .map((item) => StockMovement.fromJson(item))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<StockMovement> update(String id, Map<String, dynamic> data) async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      _apiService.dio.options.headers['AUTHORIZATION'] = 'Bearer $token';
    }

    final response = await _apiService.dio.put('stock_movements/$id', data: data);

    return StockMovement.fromJson(response.data);
  }

  Future<void> delete(String id) async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      _apiService.dio.options.headers['AUTHORIZATION'] = 'Bearer $token';
    }

    await _apiService.dio.delete('stock_movements/$id');
  }
  
}
