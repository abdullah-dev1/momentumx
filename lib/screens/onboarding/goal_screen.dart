import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../main.dart';

class GoalScreen extends StatefulWidget {
  const GoalScreen({super.key});

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  int _selected = -1;

  final List<_GoalOption> _goals = const [
    _GoalOption(emoji: '🏋️', title: 'Build Muscle', sub: 'Gain strength and size'),
    _GoalOption(emoji: '🔥', title: 'Lose Weight', sub: 'Burn fat, feel lighter'),
    _GoalOption(emoji: '⚡', title: 'Get Fit', sub: 'Improve endurance and energy'),
    _GoalOption(emoji: '🧘', title: 'Stay Healthy', sub: 'Maintain a balanced lifestyle'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text('What\'s your goal? 🎯',
                  style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                  'We\'ll personalize MomentumX based on what you want to achieve.',
                  style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                      height: 1.5)),
              const SizedBox(height: 36),

              ...List.generate(
                _goals.length,
                (i) => GestureDetector(
                  onTap: () => setState(() => _selected = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: _selected == i
                          ? AppTheme.primary.withOpacity(0.15)
                          : AppTheme.card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _selected == i
                            ? AppTheme.primary
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(_goals[i].emoji,
                            style: const TextStyle(fontSize: 32)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_goals[i].title,
                                  style: TextStyle(
                                      color: _selected == i
                                          ? AppTheme.primary
                                          : AppTheme.textPrimary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 2),
                              Text(_goals[i].sub,
                                  style: const TextStyle(
                                      color: AppTheme.textSecondary,
                                      fontSize: 13)),
                            ],
                          ),
                        ),
                        if (_selected == i)
                          const Icon(Icons.check_circle,
                              color: AppTheme.primary, size: 22),
                      ],
                    ),
                  ),
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _selected == -1
                      ? null
                      : () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const MainNav()),
                          ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    disabledBackgroundColor: AppTheme.card,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: Text(
                    _selected == -1 ? 'Select a goal' : 'Let\'s Go! 🚀',
                    style: TextStyle(
                        color: _selected == -1
                            ? AppTheme.textSecondary
                            : Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoalOption {
  final String emoji, title, sub;
  const _GoalOption(
      {required this.emoji, required this.title, required this.sub});
}