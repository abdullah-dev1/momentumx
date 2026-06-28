import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/workout_provider.dart';
import '../../services/api_service.dart';
class ActiveWorkoutScreen extends StatefulWidget {
  const ActiveWorkoutScreen({super.key});

  @override
  State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      context.read<WorkoutProvider>().updateElapsed();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  void _showAddExercise(BuildContext context) {
    final provider = context.read<WorkoutProvider>();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (_, scrollCtrl) => Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.textSecondary.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('Add Exercise',
                  style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                controller: scrollCtrl,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: provider.exerciseLibrary.length,
                itemBuilder: (_, i) {
                  final e = provider.exerciseLibrary[i];
                  return ListTile(
                    leading: Text(e['emoji']!,
                        style: const TextStyle(fontSize: 24)),
                    title: Text(e['name']!,
                        style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 14)),
                    subtitle: Text(e['muscle']!,
                        style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12)),
                    onTap: () {
                      provider.addExercise(e);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFinishDialog(BuildContext context) {
    final provider = context.read<WorkoutProvider>();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Finish Workout?',
            style: TextStyle(color: AppTheme.textPrimary)),
        content: Text(
          '${provider.totalSetsCompleted} sets completed\n'
          '${provider.totalVolume.toStringAsFixed(0)} kg total volume',
          style: const TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
  final exercises = provider.exercises.map((e) => {
    'name': e.name,
    'muscle': e.muscle,
    'emoji': e.emoji,
    'sets': e.sets.map((s) => {
      'weight': s.weight,
      'reps': s.reps,
      'isDone': s.isDone,
    }).toList(),
  }).toList();

  await ApiService.saveWorkout(
    name: 'Workout',
    durationSeconds: provider.elapsed.inSeconds,
    totalVolume: provider.totalVolume,
    exercises: exercises,
  );

  provider.finishWorkout();
  if (!mounted) return;
  Navigator.pop(context);
  Navigator.pop(context);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text('Workout saved! 💪'),
      backgroundColor: AppTheme.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)),
    ),
  );
},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.success,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Finish',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkoutProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppTheme.textSecondary),
          onPressed: () => _showFinishDialog(context),
        ),
        title: Column(
          children: [
            const Text('Active Workout',
                style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
            Text(
              _formatDuration(provider.elapsed),
              style: const TextStyle(
                  color: AppTheme.primary, fontSize: 13),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
              onPressed: () => _showFinishDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.success,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
              ),
              child: const Text('Finish',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats bar
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 12),
            color: AppTheme.surface,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatChip(
                    label: 'Exercises',
                    value: '${provider.exercises.length}'),
                _StatChip(
                    label: 'Sets Done',
                    value: '${provider.totalSetsCompleted}'),
                _StatChip(
                    label: 'Volume',
                    value:
                        '${provider.totalVolume.toStringAsFixed(0)} kg'),
              ],
            ),
          ),

          // Exercise list
          Expanded(
            child: provider.exercises.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🏋️',
                            style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 16),
                        const Text('No exercises yet',
                            style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        const Text('Tap + to add your first exercise',
                            style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 14)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.exercises.length,
                    itemBuilder: (_, i) =>
                        _ExerciseCard(exercise: provider.exercises[i]),
                  ),
          ),

          // Add exercise button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () => _showAddExercise(context),
                icon: const Icon(Icons.add,
                    color: AppTheme.primary, size: 20),
                label: const Text('Add Exercise',
                    style: TextStyle(
                        color: AppTheme.primary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                      color: AppTheme.primary, width: 1.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label, value;
  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        Text(label,
            style: const TextStyle(
                color: AppTheme.textSecondary, fontSize: 11)),
      ],
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final exercise;
  const _ExerciseCard({required this.exercise});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<WorkoutProvider>();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exercise header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 10),
            child: Row(
              children: [
                Text(exercise.emoji,
                    style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(exercise.name,
                          style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w600)),
                      Text(exercise.muscle,
                          style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: AppTheme.textSecondary, size: 20),
                  onPressed: () =>
                      provider.removeExercise(exercise.id),
                ),
              ],
            ),
          ),

          // Set header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                SizedBox(
                    width: 32,
                    child: Text('SET',
                        style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600))),
                SizedBox(width: 12),
                Expanded(
                    child: Text('KG',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600))),
                SizedBox(width: 12),
                Expanded(
                    child: Text('REPS',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600))),
                SizedBox(width: 12),
                SizedBox(
                    width: 36,
                    child: Text('✓',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 14))),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Sets
          ...List.generate(exercise.sets.length, (i) {
            final set = exercise.sets[i];
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
              child: Row(
                children: [
                  // Set number
                  Container(
                    width: 32,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: set.isDone
                          ? AppTheme.success.withOpacity(0.15)
                          : AppTheme.surface,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text('${i + 1}',
                        style: TextStyle(
                            color: set.isDone
                                ? AppTheme.success
                                : AppTheme.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 12),

                  // Weight input
                  Expanded(
                    child: _SetInput(
                      initialValue: set.weight == 0
                          ? ''
                          : set.weight.toStringAsFixed(0),
                      hint: '0',
                      onChanged: (v) => provider.updateSet(
                          exercise.id, i,
                          weight: double.tryParse(v) ?? 0),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Reps input
                  Expanded(
                    child: _SetInput(
                      initialValue:
                          set.reps == 0 ? '' : set.reps.toString(),
                      hint: '0',
                      onChanged: (v) => provider.updateSet(
                          exercise.id, i,
                          reps: int.tryParse(v) ?? 0),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Done toggle
                  GestureDetector(
                    onTap: () => provider.toggleSet(exercise.id, i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: set.isDone
                            ? AppTheme.success
                            : AppTheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: set.isDone
                              ? AppTheme.success
                              : AppTheme.textSecondary
                                  .withOpacity(0.3),
                        ),
                      ),
                      child: Icon(
                        Icons.check,
                        color: set.isDone
                            ? Colors.white
                            : AppTheme.textSecondary,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          // Add set button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
            child: GestureDetector(
              onTap: () => provider.addSet(exercise.id),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color:
                          AppTheme.primary.withOpacity(0.3)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add,
                        color: AppTheme.primary, size: 16),
                    SizedBox(width: 6),
                    Text('Add Set',
                        style: TextStyle(
                            color: AppTheme.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SetInput extends StatelessWidget {
  final String initialValue, hint;
  final ValueChanged<String> onChanged;

  const _SetInput({
    required this.initialValue,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      keyboardType:
          const TextInputType.numberWithOptions(decimal: true),
      textAlign: TextAlign.center,
      style: const TextStyle(
          color: AppTheme.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
            color: AppTheme.textSecondary, fontSize: 14),
        filled: true,
        fillColor: AppTheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: AppTheme.primary, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
        isDense: true,
      ),
    );
  }
}