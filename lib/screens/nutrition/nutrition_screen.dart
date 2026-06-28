import 'package:flutter/material.dart';
import '../../core/theme.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  final List<Map<String, dynamic>> _meals = [
    {'meal': 'Breakfast', 'items': 'Eggs, Roti, Chai', 'cal': 420},
    {'meal': 'Lunch', 'items': 'Daal Chawal, Salad', 'cal': 680},
    {'meal': 'Dinner', 'items': 'Chicken Karahi, Naan', 'cal': 740},
  ];

  int get _totalCal =>
      _meals.fold(0, (sum, m) => sum + (m['cal'] as int));
  final int _goal = 2200;

  void _showAddMeal() {
    final nameCtrl = TextEditingController();
    final itemsCtrl = TextEditingController();
    final calCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? AppTheme.surface
              : Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Log a Meal',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildField('Meal name', 'e.g. Breakfast', nameCtrl),
            const SizedBox(height: 14),
            _buildField('Food items', 'e.g. Roti, Daal, Salad', itemsCtrl),
            const SizedBox(height: 14),
            _buildField('Calories (kcal)', 'e.g. 450', calCtrl,
                type: TextInputType.number),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  if (nameCtrl.text.isNotEmpty &&
                      calCtrl.text.isNotEmpty) {
                    setState(() {
                      _meals.add({
                        'meal': nameCtrl.text.trim(),
                        'items': itemsCtrl.text.trim(),
                        'cal': int.tryParse(calCtrl.text) ?? 0,
                      });
                    });
                    Navigator.pop(ctx);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Add Meal',
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

  Widget _buildField(String label, String hint,
      TextEditingController ctrl,
      {TextInputType type = TextInputType.text}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
            hintStyle: TextStyle(
                color: isDark
                    ? AppTheme.textSecondary
                    : Colors.grey[400],
                fontSize: 13),
            filled: true,
            fillColor: isDark ? AppTheme.card : Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: AppTheme.primary, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition'),
        actions: [
          TextButton.icon(
            onPressed: _showAddMeal,
            icon: const Icon(Icons.add,
                color: AppTheme.primary, size: 18),
            label: const Text('Add',
                style: TextStyle(
                    color: AppTheme.primary, fontSize: 13)),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Calorie summary
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.card : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Daily Calories',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600)),
                        Text('$_totalCal / $_goal kcal',
                            style: const TextStyle(
                                color: AppTheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (_totalCal / _goal).clamp(0.0, 1.0),
                        backgroundColor: isDark
                            ? AppTheme.surface
                            : Colors.grey[200],
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(
                                AppTheme.primary),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceAround,
                      children: const [
                        _MacroChip(
                            label: 'Protein',
                            value: '142g',
                            color: AppTheme.accent),
                        _MacroChip(
                            label: 'Carbs',
                            value: '210g',
                            color: AppTheme.warning),
                        _MacroChip(
                            label: 'Fats',
                            value: '58g',
                            color: AppTheme.success),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Today's Meals",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600)),
                  TextButton.icon(
                    onPressed: _showAddMeal,
                    icon: const Icon(Icons.add,
                        color: AppTheme.primary, size: 18),
                    label: const Text('Add',
                        style: TextStyle(
                            color: AppTheme.primary, fontSize: 13)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ..._meals.map((m) => Dismissible(
                    key: Key(m['meal'] + m['cal'].toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.delete_outline,
                          color: Colors.redAccent),
                    ),
                    onDismissed: (_) =>
                        setState(() => _meals.remove(m)),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppTheme.card : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(m['meal'],
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                                if ((m['items'] as String).isNotEmpty)
                                  Text(m['items'],
                                      style: const TextStyle(
                                          color:
                                              AppTheme.textSecondary,
                                          fontSize: 12)),
                              ],
                            ),
                          ),
                          Text('${m['cal']} kcal',
                              style: const TextStyle(
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13)),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class _MacroChip extends StatelessWidget {
  final String label, value;
  final Color color;
  const _MacroChip(
      {required this.label,
      required this.value,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
        Text(label,
            style: const TextStyle(
                color: AppTheme.textSecondary, fontSize: 12)),
      ],
    );
  }
}