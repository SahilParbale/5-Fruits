import 'package:flutter/material.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => [..._items];

  bool isFavorite(String name) {
    return _items.any((item) => item['name'] == name);
  }

  void toggleFavorite(Map<String, dynamic> product) {
    final existingIndex = _items.indexWhere((item) => item['name'] == product['name']);
    if (existingIndex >= 0) {
      _items.removeAt(existingIndex);
    } else {
      _items.add(product);
    }
    notifyListeners();
  }
}
