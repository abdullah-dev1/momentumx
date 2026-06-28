import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme.dart';
import '../../../providers/habit_provider.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = context.watch<HabitProvider>().stats;

    return Row(
      children: [
        _StatCard(
          emoji: '🍎',
          label: 'Calories',
          value: '${stats.caloriesConsumed}',
          sub: '/ ${stats.caloriesGoal} kcal',
          color: AppTheme.accent,
        ),
        const SizedBox(width: 10),
        _StatCard(
          emoji: '💪',
          label: 'Workouts',
          value: '${stats.workoutsThisWeek}',
          sub: 'this week',
          color: AppTheme.primary,
        ),
        const SizedBox(width: 10),
        _StatCard(
          emoji: '💧',
          label: 'Water',
          value: '${stats.waterCups.toInt()}',
          sub: '/ ${stats.waterGoal.toInt()} cups',
          color: const Color(0xFF29B6F6),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String emoji, label, value, sub;
  final Color color;

  const _StatCard({
    required this.emoji,
    required this.label,
    required this.value,
    required this.sub,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
            Text(label,
                style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500)),
            Text(sub,
                style: const TextStyle(
                    color: AppTheme.textSecondary, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}