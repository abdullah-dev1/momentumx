import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme.dart';
import '../../../providers/habit_provider.dart';

class WaterTracker extends StatelessWidget {
  const WaterTracker({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();
    final cups = provider.stats.waterCups;
    final goal = provider.stats.waterGoal;
    final filled = (cups / 0.5).toInt();
    final total = (goal / 0.5).toInt();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('💧 Water Intake',
                  style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600)),
              Text('${cups.toStringAsFixed(1)} / ${goal.toInt()} cups',
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(total, (i) {
              final isFilled = i < filled;
              return GestureDetector(
                onTap: () => provider.addWater(),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 32,
                  height: 38,
                  decoration: BoxDecoration(
                    color: isFilled
                        ? const Color(0xFF29B6F6).withOpacity(0.85)
                        : AppTheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isFilled
                          ? const Color(0xFF29B6F6)
                          : AppTheme.textSecondary.withOpacity(0.2),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      isFilled ? '💧' : '○',
                      style: TextStyle(
                          fontSize: isFilled ? 14 : 16,
                          color: AppTheme.textSecondary),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          SizedBox(
  width: double.infinity,
  child: OutlinedButton.icon(
    onPressed: () {
      if (provider.stats.waterCups < provider.stats.waterGoal) {
        provider.addWater();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('🎉 Daily water goal reached!'),
            backgroundColor: const Color(0xFF29B6F6),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    },
    icon: const Icon(Icons.add, size: 16, color: Color(0xFF29B6F6)),
    label: Text(
      provider.stats.waterCups >= provider.stats.waterGoal
          ? '✓ Goal reached!'
          : 'Add 0.5 cup',
      style: const TextStyle(
          color: Color(0xFF29B6F6), fontSize: 13),
    ),
    style: OutlinedButton.styleFrom(
      side: const BorderSide(color: Color(0xFF29B6F6), width: 1),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(vertical: 10),
    ),
  ),
),
        ],
      ),
    );
  }
}