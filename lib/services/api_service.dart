import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  static const bool _isProduction = false;
  static const String _productionUrl = 'https://your-url.up.railway.app';

  static String get baseUrl {
    if (_isProduction) return _productionUrl;
    if (kIsWeb) return 'http://127.0.0.1:8000';
    return 'http://10.0.2.2:8000';
  }
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
static Future<Map<String, dynamic>> forgotPassword(String email) async {
  try {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/forgot-password'),
      headers: await _headers(auth: false),
      body: jsonEncode({'email': email}),
    );
    return {
      'status': res.statusCode,
      'data': jsonDecode(res.body)
    };
  } catch (e) {
    return {
      'status': 0,
      'data': {'detail': 'Connection error'}
    };
  }
}
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data');
  }

  static Future<Map<String, String>> _headers(
      {bool auth = true}) async {
    final headers = {'Content-Type': 'application/json'};
    if (auth) {
      final token = await getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  // ── Auth ──────────────────────────────────────────────

  static Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/auth/signup'),
        headers: await _headers(auth: false),
        body: jsonEncode(
            {'name': name, 'email': email, 'password': password}),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        await saveToken(data['access_token']);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'user_data', jsonEncode(data['user']));
      }
      return {'status': res.statusCode, 'data': data};
    } catch (e) {
      return {
        'status': 0,
        'data': {'detail': 'Connection error'}
      };
    }
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: await _headers(auth: false),
        body: jsonEncode(
            {'email': email, 'password': password}),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        await saveToken(data['access_token']);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'user_data', jsonEncode(data['user']));
      }
      return {'status': res.statusCode, 'data': data};
    } catch (e) {
      return {
        'status': 0,
        'data': {'detail': 'Connection error'}
      };
    }
  }

  static Future<Map<String, dynamic>> getMe() async {
    try {
      final res = await http.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: await _headers(),
      );
      return {'status': res.statusCode, 'data': jsonDecode(res.body)};
    } catch (e) {
      return {'status': 0, 'data': {}};
    }
  }

  static Future<bool> updateProfile(
      Map<String, dynamic> data) async {
    try {
      final res = await http.put(
        Uri.parse('$baseUrl/auth/me'),
        headers: await _headers(),
        body: jsonEncode(data),
      );
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // ── Habits ────────────────────────────────────────────

  static Future<List<dynamic>> getHabits() async {
    try {
      final res = await http.get(
        Uri.parse('$baseUrl/habits/'),
        headers: await _headers(),
      );
      if (res.statusCode == 200) return jsonDecode(res.body);
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<bool> createHabit(
      String title, String emoji) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/habits/'),
        headers: await _headers(),
        body: jsonEncode({'title': title, 'emoji': emoji}),
      );
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> toggleHabit(int id, bool isDone) async {
    try {
      final res = await http.put(
        Uri.parse('$baseUrl/habits/$id'),
        headers: await _headers(),
        body: jsonEncode({'is_done': isDone}),
      );
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteHabit(int id) async {
    try {
      final res = await http.delete(
        Uri.parse('$baseUrl/habits/$id'),
        headers: await _headers(),
      );
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // ── Workouts ──────────────────────────────────────────

  static Future<List<dynamic>> getWorkouts() async {
    try {
      final res = await http.get(
        Uri.parse('$baseUrl/workouts/'),
        headers: await _headers(),
      );
      if (res.statusCode == 200) return jsonDecode(res.body);
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<bool> saveWorkout({
    required String name,
    required int durationSeconds,
    required double totalVolume,
    required List<dynamic> exercises,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/workouts/'),
        headers: await _headers(),
        body: jsonEncode({
          'name': name,
          'duration_seconds': durationSeconds,
          'total_volume': totalVolume,
          'exercises': exercises,
        }),
      );
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}