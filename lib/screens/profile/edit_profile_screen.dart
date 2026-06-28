import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/user_provider.dart';
import '../../services/api_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _weightCtrl;
  late TextEditingController _heightCtrl;
  late TextEditingController _calorieCtrl;
  bool _loading = false;
  String _selectedGoal = 'Get Fit';

  final List<String> _goals = [
    'Build Muscle',
    'Lose Weight',
    'Get Fit',
    'Stay Healthy',
  ];

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>();
    _nameCtrl = TextEditingController(text: user.name);
    _weightCtrl = TextEditingController(
        text: user.user['weight']?.toString() ?? '');
    _heightCtrl = TextEditingController(
        text: user.user['height']?.toString() ?? '');
    _calorieCtrl =
        TextEditingController(text: user.calorieGoal.toString());
    _selectedGoal = user.goal;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _weightCtrl.dispose();
    _heightCtrl.dispose();
    _calorieCtrl.dispose();
    super.dispose();
  }

  void _save() async {
    setState(() => _loading = true);
    final data = {
      'name': _nameCtrl.text.trim(),
      'goal': _selectedGoal,
      'weight': double.tryParse(_weightCtrl.text) ?? 0,
      'height': double.tryParse(_heightCtrl.text) ?? 0,
      'calorie_goal': int.tryParse(_calorieCtrl.text) ?? 2200,
    };

    try {
      await ApiService.updateProfile(data);
      await context.read<UserProvider>().updateUser(data);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Profile updated ✓'),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
      ));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Update failed. Try again.'),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ));
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: _loading ? null : _save,
            child: _loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppTheme.primary))
                : const Text('Save',
                    style: TextStyle(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: AppTheme.primary,
                      child: Text(
                        context.read<UserProvider>().initials,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                          color: AppTheme.primary,
                          shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt,
                          color: Colors.white, size: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              _buildField('Full Name', _nameCtrl, isDark,
                  hint: 'Muhammad Abdullah'),
              const SizedBox(height: 16),
              _buildField('Weight', _weightCtrl, isDark,
                  hint: '75',
                  suffix: 'kg',
                  type: TextInputType.number),
              const SizedBox(height: 16),
              _buildField('Height', _heightCtrl, isDark,
                  hint: '175',
                  suffix: 'cm',
                  type: TextInputType.number),
              const SizedBox(height: 16),
              _buildField('Daily Calorie Goal', _calorieCtrl, isDark,
                  hint: '2200',
                  suffix: 'kcal',
                  type: TextInputType.number),
              const SizedBox(height: 20),

              Text('Fitness Goal',
                  style: TextStyle(
                      color: isDark
                          ? AppTheme.textSecondary
                          : Colors.grey[700],
                      fontSize: 13,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _goals.map((g) {
                  final selected = g == _selectedGoal;
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _selectedGoal = g),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppTheme.primary
                            : (isDark
                                ? AppTheme.card
                                : Colors.grey[100]),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected
                              ? AppTheme.primary
                              : Colors.transparent,
                        ),
                      ),
                      child: Text(g,
                          style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : null,
                              fontSize: 13,
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.normal)),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
      String label, TextEditingController ctrl, bool isDark,
      {String? hint,
      String? suffix,
      TextInputType type = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                color: isDark
                    ? AppTheme.textSecondary
                    : Colors.grey[700],
                fontSize: 13,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          keyboardType: type,
          decoration: InputDecoration(
            hintText: hint,
            suffixText: suffix,
            filled: true,
            fillColor: isDark ? AppTheme.card : Colors.grey[100],
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: AppTheme.primary, width: 1.5)),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}