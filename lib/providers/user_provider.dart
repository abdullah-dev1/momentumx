import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserProvider extends ChangeNotifier {
  Map<String, dynamic> _user = {};

  Map<String, dynamic> get user => _user;
  String get name => _user['name'] ?? 'User';
  String get email => _user['email'] ?? '';
  String get goal => _user['goal'] ?? 'Get Fit';
  double get waterGoal => (_user['water_goal'] ?? 8.0).toDouble();
  int get calorieGoal => _user['calorie_goal'] ?? 2200;

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('user_data');
    if (raw != null) {
      _user = jsonDecode(raw);
      notifyListeners();
    }
  }

  Future<void> updateUser(Map<String, dynamic> data) async {
    _user = {..._user, ...data};
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(_user));
    notifyListeners();
  }

  Future<void> clearUser() async {
    _user = {};
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
    await prefs.remove('auth_token');
    notifyListeners();
  }

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }
}