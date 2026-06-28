import 'package:flutter/material.dart';
import '../models/exercise.dart';

class WorkoutProvider extends ChangeNotifier {
  List<Exercise> _exercises = [];
  bool _isActive = false;
  DateTime? _startTime;
  Duration _elapsed = Duration.zero;

  List<Exercise> get exercises => _exercises;
  bool get isActive => _isActive;
  Duration get elapsed => _elapsed;

  final List<WorkoutTemplate> templates = const [
    WorkoutTemplate(
      name: 'Push Day',
      emoji: '💪',
      exerciseNames: ['Bench Press', 'Overhead Press', 'Tricep Pushdown'],
    ),
    WorkoutTemplate(
      name: 'Pull Day',
      emoji: '🏋️',
      exerciseNames: ['Deadlift', 'Barbell Row', 'Bicep Curl'],
    ),
    WorkoutTemplate(
      name: 'Leg Day',
      emoji: '🦵',
      exerciseNames: ['Squat', 'Leg Press', 'Calf Raise'],
    ),
    WorkoutTemplate(
      name: 'Full Body',
      emoji: '⚡',
      exerciseNames: ['Squat', 'Bench Press', 'Deadlift'],
    ),
  ];

  final List<Map<String, String>> exerciseLibrary = [
    {'name': 'Bench Press', 'muscle': 'Chest', 'emoji': '🏋️'},
    {'name': 'Incline Dumbbell Press', 'muscle': 'Chest', 'emoji': '💪'},
    {'name': 'Overhead Press', 'muscle': 'Shoulders', 'emoji': '🔝'},
    {'name': 'Lateral Raise', 'muscle': 'Shoulders', 'emoji': '↔️'},
    {'name': 'Tricep Pushdown', 'muscle': 'Triceps', 'emoji': '⬇️'},
    {'name': 'Skull Crushers', 'muscle': 'Triceps', 'emoji': '💀'},
    {'name': 'Deadlift', 'muscle': 'Back', 'emoji': '🏆'},
    {'name': 'Barbell Row', 'muscle': 'Back', 'emoji': '🚣'},
    {'name': 'Pull-ups', 'muscle': 'Back', 'emoji': '⬆️'},
    {'name': 'Bicep Curl', 'muscle': 'Biceps', 'emoji': '💪'},
    {'name': 'Hammer Curl', 'muscle': 'Biceps', 'emoji': '🔨'},
    {'name': 'Squat', 'muscle': 'Legs', 'emoji': '🦵'},
    {'name': 'Leg Press', 'muscle': 'Legs', 'emoji': '🦿'},
    {'name': 'Leg Curl', 'muscle': 'Hamstrings', 'emoji': '🦵'},
    {'name': 'Calf Raise', 'muscle': 'Calves', 'emoji': '🦶'},
    {'name': 'Plank', 'muscle': 'Core', 'emoji': '🧘'},
    {'name': 'Crunch', 'muscle': 'Core', 'emoji': '🔄'},
  ];

  void startWorkout({List<String>? exerciseNames}) {
    _isActive = true;
    _startTime = DateTime.now();
    _exercises = [];
    if (exerciseNames != null) {
      for (final name in exerciseNames) {
        final lib = exerciseLibrary.firstWhere(
          (e) => e['name'] == name,
          orElse: () =>
              {'name': name, 'muscle': 'General', 'emoji': '💪'},
        );
        _exercises.add(Exercise(
          id: DateTime.now().millisecondsSinceEpoch.toString() + name,
          name: lib['name']!,
          muscle: lib['muscle']!,
          emoji: lib['emoji']!,
        ));
      }
    }
    notifyListeners();
  }

  void addExercise(Map<String, String> exerciseData) {
    _exercises.add(Exercise(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: exerciseData['name']!,
      muscle: exerciseData['muscle']!,
      emoji: exerciseData['emoji']!,
    ));
    notifyListeners();
  }

  void addSet(String exerciseId) {
    final ex =
        _exercises.firstWhere((e) => e.id == exerciseId);
    final lastSet = ex.sets.isNotEmpty ? ex.sets.last : null;
    ex.sets.add(ExerciseSet(
      weight: lastSet?.weight ?? 0,
      reps: lastSet?.reps ?? 0,
    ));
    notifyListeners();
  }

  void updateSet(String exerciseId, int setIndex,
      {double? weight, int? reps}) {
    final ex =
        _exercises.firstWhere((e) => e.id == exerciseId);
    if (weight != null) ex.sets[setIndex].weight = weight;
    if (reps != null) ex.sets[setIndex].reps = reps;
    notifyListeners();
  }

  void toggleSet(String exerciseId, int setIndex) {
    final ex =
        _exercises.firstWhere((e) => e.id == exerciseId);
    ex.sets[setIndex].isDone = !ex.sets[setIndex].isDone;
    notifyListeners();
  }

  void removeExercise(String exerciseId) {
    _exercises.removeWhere((e) => e.id == exerciseId);
    notifyListeners();
  }

  void updateElapsed() {
    if (_startTime != null) {
      _elapsed = DateTime.now().difference(_startTime!);
      notifyListeners();
    }
  }

  int get totalSetsCompleted => _exercises
      .expand((e) => e.sets)
      .where((s) => s.isDone)
      .length;

  double get totalVolume => _exercises
      .expand((e) => e.sets)
      .where((s) => s.isDone)
      .fold(0, (sum, s) => sum + s.weight * s.reps);

  void finishWorkout() {
    _isActive = false;
    _exercises = [];
    _elapsed = Duration.zero;
    _startTime = null;
    notifyListeners();
  }
}