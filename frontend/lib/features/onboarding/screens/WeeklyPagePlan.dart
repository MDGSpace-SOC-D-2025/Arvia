import 'package:flutter/material.dart';
import 'package:arvia/features/onboarding/models/diet_plan_model.dart';

class WeeklyPlanPage extends StatelessWidget {
  final DietPlanModel plan;

  const WeeklyPlanPage({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "7-Day Meal Plan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue.shade900,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: plan.weeklyPlan.length,
        itemBuilder: (context, index) {
          final day = plan.weeklyPlan[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            color: Colors.blue.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ExpansionTile(
              title: Text(
                day.dayName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
              subtitle: Text("Calories: ${_calculateDayCalories(day)} kcal"),
              children: [
                _buildMealTile("Breakfast", day.meals["breakfast"]![0].name),
                _buildMealTile("Lunch", day.meals["lunch"]![0].name),
                _buildMealTile("Dinner", day.meals["dinner"]![0].name),
                _buildMealTile("Snacks", day.meals["snack"]![0].name),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper to build meal rows inside the expansion tile
  Widget _buildMealTile(String type, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(type, style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(
            child: Text(
              name,
              textAlign: TextAlign.end,
              style: const TextStyle(color: Colors.black54),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  int _calculateDayCalories(DayPlan day) {
    int total = 0;
    day.meals.forEach((key, options) {
      total += options[0].calories;
    });
    return total;
  }
}
