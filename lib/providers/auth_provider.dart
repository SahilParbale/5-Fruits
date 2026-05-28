import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  UserModel? _user;
  bool _isLoading = false;

  String? get token => _token;
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;

  static String get baseUrl {
    try {
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:3003/api';
      }
    } catch (_) {}
    return 'http://localhost:3003/api';
  }

  // Load token on startup
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('jwt_token')) {
      return false;
    }

    _token = prefs.getString('jwt_token');
    
    // Fetch profile to verify token
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _user = UserModel.fromJson(data);
        notifyListeners();
        return true;
      } else {
        // Token is invalid/expired
        await logout();
        return false;
      }
    } catch (e) {
      // Network error, but we keep token to allow offline/graceful usage
      debugPrint('Auto-login error: $e');
      return true;
    }
  }

  // Register a new customer
  Future<void> register(String email, String password, String name, String phone) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          'name': name,
          'phone': phone,
          'role': 'CUSTOMER',
        }),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 201) {
        _token = responseData['token'];
        _user = UserModel.fromJson(responseData['user']);
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', _token!);
        notifyListeners();
      } else {
        throw HttpException(responseData['error'] ?? 'Registration failed');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login customer
  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        _token = responseData['token'];
        _user = UserModel.fromJson(responseData['user']);
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', _token!);
        notifyListeners();
      } else {
        throw HttpException(responseData['error'] ?? 'Login failed');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Google Login Simulation
  Future<void> googleLogin(String email, String name) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/google-login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'name': name,
        }),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        _token = responseData['token'];
        _user = UserModel.fromJson(responseData['user']);
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', _token!);
        notifyListeners();
      } else {
        throw HttpException(responseData['error'] ?? 'Google login failed');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logout customer
  Future<void> logout() async {
    _token = null;
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    notifyListeners();
  }
}
