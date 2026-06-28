import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/workout_provider.dart';
import '../../providers/user_provider.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final workouts = context.watch<WorkoutProvider>();
    final user = context.watch<UserProvider>();

    final cardColor = isDark ? AppTheme.card : Colors.white;

    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overview cards
              Row(
                children: [
                  _OverviewCard(
                      label: 'Total Workouts',
                      value: '${workouts.exercises.length > 0 ? 1 : 0}',
                      icon: Icons.fitness_center,
                      color: AppTheme.primary),
                  const SizedBox(width: 12),
                  _OverviewCard(
                      label: 'This Week',
                      value: '3',
                      icon: Icons.calendar_today,
                      color: AppTheme.accent),
                  const SizedBox(width: 12),
                  _OverviewCard(
                      label: 'Streak',
                      value: '7🔥',
                      icon: Icons.local_fire_department,
                      color: AppTheme.warning),
                ],
              ),

              const SizedBox(height: 20),

              // Weight tracking
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('⚖️ Weight Journey',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600)),
                        TextButton(
                          onPressed: () =>
                              _showLogWeightDialog(context),
                          child: const Text('+ Log',
                              style: TextStyle(
                                  color: AppTheme.primary,
                                  fontSize: 13)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceAround,
                      children: const [
                        _WeightStat(
                            label: 'Start', value: '82 kg'),
                        _Divider(),
                        _WeightStat(
                            label: 'Current',
                            value: '78 kg',
                            highlight: true),
                        _Divider(),
                        _WeightStat(
                            label: 'Goal', value: '72 kg'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Weight chart placeholder
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppTheme.surface
                            : Colors.grey[50],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.end,
                          mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                          children: const [
                            _Bar(height: 0.9, label: 'Mon'),
                            _Bar(height: 0.85, label: 'Tue'),
                            _Bar(height: 0.8, label: 'Wed'),
                            _Bar(height: 0.78, label: 'Thu'),
                            _Bar(height: 0.75, label: 'Fri'),
                            _Bar(height: 0.73, label: 'Sat'),
                            _Bar(height: 0.70, label: 'Sun', isActive: true),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Center(
                      child: Text('▼ 4 kg lost so far 🎉',
                          style: TextStyle(
                              color: AppTheme.success,
                              fontSize: 13,
                              fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Body measurements
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('📏 Body Measurements',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600)),
                        TextButton(
                          onPressed: () =>
                              _showLogMeasurementDialog(context),
                          child: const Text('+ Log',
                              style: TextStyle(
                                  color: AppTheme.primary,
                                  fontSize: 13)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const _MeasurementRow(
                        label: 'Chest', value: '98 cm'),
                    const _MeasurementRow(
                        label: 'Waist', value: '84 cm'),
                    const _MeasurementRow(
                        label: 'Arms', value: '36 cm'),
                    const _MeasurementRow(
                        label: 'Legs', value: '58 cm'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Personal Records
              const Text('🏆 Personal Records',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              _PRCard(
                  exercise: 'Bench Press',
                  weight: '80 kg',
                  reps: '5',
                  date: 'Jun 20',
                  cardColor: cardColor),
              _PRCard(
                  exercise: 'Squat',
                  weight: '100 kg',
                  reps: '3',
                  date: 'Jun 18',
                  cardColor: cardColor),
              _PRCard(
                  exercise: 'Deadlift',
                  weight: '120 kg',
                  reps: '1',
                  date: 'Jun 15',
                  cardColor: cardColor),
              _PRCard(
                  exercise: 'Overhead Press',
                  weight: '60 kg',
                  reps: '5',
                  date: 'Jun 12',
                  cardColor: cardColor),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogWeightDialog(BuildContext context) {
    final ctrl = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppTheme.surface : Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Log Weight',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Enter weight in kg',
                filled: true,
                fillColor: isDark ? AppTheme.card : Colors.grey[100],
                suffixText: 'kg',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: AppTheme.primary, width: 1.5)),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  if (ctrl.text.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Weight logged: ${ctrl.text} kg ✓'),
                        backgroundColor: AppTheme.success,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                    Navigator.pop(ctx);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogMeasurementDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final parts = ['Chest', 'Waist', 'Arms', 'Legs'];
    final ctrls = {for (var p in parts) p: TextEditingController()};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppTheme.surface : Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Log Measurements',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...parts.map((p) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TextField(
                    controller: ctrls[p],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '$p (cm)',
                      filled: true,
                      fillColor:
                          isDark ? AppTheme.card : Colors.grey[100],
                      suffixText: 'cm',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: AppTheme.primary, width: 1.5)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                    ),
                  ),
                )),
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Measurements saved ✓'),
                      backgroundColor: AppTheme.success,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  Navigator.pop(ctx);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _OverviewCard(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.card : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppTheme.textSecondary, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class _WeightStat extends StatelessWidget {
  final String label, value;
  final bool highlight;
  const _WeightStat(
      {required this.label,
      required this.value,
      this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                color: highlight ? AppTheme.primary : null,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        Text(label,
            style: const TextStyle(
                color: AppTheme.textSecondary, fontSize: 12)),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) => Container(
      width: 1, height: 30, color: AppTheme.textSecondary.withOpacity(0.2));
}

class _Bar extends StatelessWidget {
  final double height;
  final String label;
  final bool isActive;
  const _Bar(
      {required this.height,
      required this.label,
      this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 28,
          height: 60 * height,
          decoration: BoxDecoration(
            color: isActive
                ? AppTheme.primary
                : AppTheme.primary.withOpacity(0.3),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(
                color: AppTheme.textSecondary, fontSize: 9)),
      ],
    );
  }
}

class _MeasurementRow extends StatelessWidget {
  final String label, value;
  const _MeasurementRow(
      {required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppTheme.textSecondary, fontSize: 13)),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }
}

class _PRCard extends StatelessWidget {
  final String exercise, weight, reps, date;
  final Color cardColor;
  const _PRCard(
      {required this.exercise,
      required this.weight,
      required this.reps,
      required this.date,
      required this.cardColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
          color: cardColor, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.warning.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.emoji_events,
                color: AppTheme.warning, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(exercise,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w500)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(weight,
                  style: const TextStyle(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
              Text('$reps reps · $date',
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}