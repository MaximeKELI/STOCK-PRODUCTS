import 'package:dio/dio.dart';
import 'package:stock_landy/services/api.dart';
import 'package:stock_landy/models/supplier.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupplierService {
  final ApiService _apiService = ApiService();

  Future<List<Supplier>> getAll() async {
    try {
      final response = await _apiService.dio.get('/suppliers');
      return (response.data as List)
          .map((item) => Supplier.fromJson(item))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Supplier> get(String id) async {
    try {
      final response = await _apiService.dio.get('/suppliers/$id');
      return Supplier.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Supplier> create(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.dio.post('/suppliers', data: data);
      return Supplier.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Supplier> update(String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiService.dio.put('/suppliers/$id', data: data);
      return Supplier.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    try {
      await _apiService.dio.delete('/suppliers/$id');
    } catch (e) {
      rethrow;
    }
  }
}
