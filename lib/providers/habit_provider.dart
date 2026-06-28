import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../models/user_stats.dart';

class HabitProvider extends ChangeNotifier {
  final UserStats stats = UserStats();

  final List<Habit> _habits = [
    Habit(id: '1', title: 'Morning workout', emoji: '🏋️'),
    Habit(id: '2', title: 'Drink 8 glasses of water', emoji: '💧'),
    Habit(id: '3', title: 'Log all meals', emoji: '🍽️'),
    Habit(id: '4', title: 'Sleep by 11pm', emoji: '😴'),
    Habit(id: '5', title: 'Take vitamins', emoji: '💊'),
    Habit(id: '6', title: '10k steps', emoji: '👟'),
  ];

  List<Habit> get habits => _habits;
  int get completedCount => _habits.where((h) => h.isDone).length;
  double get completionRate =>
      _habits.isEmpty ? 0 : completedCount / _habits.length;

  void toggleHabit(String id) {
    final habit = _habits.firstWhere((h) => h.id == id);
    habit.isDone = !habit.isDone;
    notifyListeners();
  }

  void addHabit(String title, String emoji) {
    _habits.add(Habit(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      emoji: emoji,
    ));
    notifyListeners();
  }

  void deleteHabit(String id) {
    _habits.removeWhere((h) => h.id == id);
    notifyListeners();
  }

  void addWater() {
    if (stats.waterCups < stats.waterGoal) {
      stats.waterCups += 0.5;
    }
    notifyListeners();
  }

  void resetWater() {
    stats.waterCups = 0;
    notifyListeners();
  }
}