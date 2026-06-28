class Habit {
  final String id;
  final String title;
  final String emoji;
  bool isDone;

  Habit({
    required this.id,
    required this.title,
    required this.emoji,
    this.isDone = false,
  });
}