import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

class MagentoApiService {
  static MagentoApiService? _instance;
  late final Dio _dio;

  MagentoApiService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://api.example.com',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));
  }

  static MagentoApiService get instance {
    _instance ??= MagentoApiService._internal();
    return _instance!;
  }

  Dio get dio => _dio;

  // Mock API methods for search
  Future<List<Map<String, dynamic>>> searchProducts({
    String? query,
    Map<String, dynamic>? filters,
  }) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      // Return mock search results
      return List.generate(
          10,
          (index) => {
                'id': index + 1,
                'name': 'Product ${index + 1}',
                'price': 99.99 + (index * 10),
                'image':
                    'https://via.placeholder.com/300x300?text=Product+${index + 1}',
                'description': 'Description for product ${index + 1}',
                'sku': 'SKU-${index + 1}',
                'category': 'Electronics',
                'in_stock': true,
                'rating': 4.5,
                'reviews_count': 10 + index,
              });
    } catch (e) {
      debugPrint('Error searching products: $e');
      return [];
    }
  }

  // Get product suggestions
  Future<List<String>> getProductSuggestions(String query) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 300));

      // Return mock suggestions
      return [
        'Product 1',
        'Product 2',
        'Product 3',
        'Electronics',
        'Clothing',
        'Home & Garden',
      ]
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      debugPrint('Error getting product suggestions: $e');
      return [];
    }
  }

  // Get search history
  Future<List<String>> getSearchHistory() async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 200));

      // Return mock search history
      return [
        'iPhone',
        'Samsung',
        'Laptop',
        'Headphones',
        'Camera',
      ];
    } catch (e) {
      debugPrint('Error getting search history: $e');
      return [];
    }
  }

  // Save search query
  Future<void> saveSearchQuery(String query) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 100));
      debugPrint('Search query saved: $query');
    } catch (e) {
      debugPrint('Error saving search query: $e');
    }
  }
}
