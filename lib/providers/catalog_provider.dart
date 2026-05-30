import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../data/fruit_data.dart';
import 'auth_provider.dart';

class CatalogProvider with ChangeNotifier {
  List<String> _categories = [];
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = false;

  List<String> get categories => _categories.isEmpty ? _staticCategories : _categories;
  List<Map<String, dynamic>> get products => _products.isEmpty ? FruitData.allFruits : _products;
  bool get isLoading => _isLoading;

  final List<String> _staticCategories = [
    'Citrus',
    'Seasonal',
    'Berries',
    'Stone',
    'Melons',
    'Pomes',
    'Combos',
    'Exotic',
    'Dry',
    'Tropical',
    'Organic',
    'Ready-to-eat',
  ];

  static String get baseUrl {
    try {
      if (Platform.isAndroid) {
        return 'http://192.168.0.103:3003/api';
      }
    } catch (_) {}
    return 'http://localhost:3003/api';
  }

  // Fetch categories and products from backend
  Future<void> fetchCatalog() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Fetch categories
      final catResponse = await http.get(Uri.parse('$baseUrl/products/categories')).timeout(const Duration(seconds: 4));
      if (catResponse.statusCode == 200) {
        final List<dynamic> catData = json.decode(catResponse.body);
        _categories = catData.map((c) => c.toString()).toList();
      }

      // 2. Fetch products
      final prodResponse = await http.get(Uri.parse('$baseUrl/products')).timeout(const Duration(seconds: 4));
      if (prodResponse.statusCode == 200) {
        final List<dynamic> prodData = json.decode(prodResponse.body);
        _products = prodData.map((p) {
          final item = p as Map<String, dynamic>;
          return {
            'id': item['id'],
            'name': item['name'],
            'category': item['category'],
            'size': item['unitSize'] ?? '1kg',
            'price': (item['price'] as num).toDouble(),
            'image': item['image'] ?? 'assets/images/apple.jpg',
            'isAvailable': (item['stock'] ?? 0) > 0,
            'description': item['description'] ?? '',
          };
        }).toList();
      }
    } catch (e) {
      debugPrint('Error fetching catalog, falling back to static data: $e');
      // Falling back to static data automatically because getters return them if lists are empty
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
