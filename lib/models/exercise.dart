class ExerciseSet {
  double weight;
  int reps;
  bool isDone;

  ExerciseSet({this.weight = 0, this.reps = 0, this.isDone = false});
}

class Exercise {
  final String id;
  final String name;
  final String muscle;
  final String emoji;
  List<ExerciseSet> sets;

  Exercise({
    required this.id,
    required this.name,
    required this.muscle,
    required this.emoji,
    List<ExerciseSet>? sets,
  }) : sets = sets ?? [ExerciseSet()];
}

class WorkoutTemplate {
  final String name;
  final String emoji;
  final List<String> exerciseNames;

  const WorkoutTemplate({
    required this.name,
    required this.emoji,
    required this.exerciseNames,
  });
}