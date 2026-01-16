//import 'dart:convert';

class DietPlanModel {
  final String generatedDate;
  final List<DayPlan> weeklyPlan;

  DietPlanModel({required this.generatedDate, required this.weeklyPlan});

  // Convert JSON (Map) into Dart Object
  factory DietPlanModel.fromMap(Map<String, dynamic> map) {
    return DietPlanModel(
      generatedDate: map['generated_date'] ?? '',
      weeklyPlan: List<DayPlan>.from(
        (map['weekly_plan'] ?? []).map((x) => DayPlan.fromMap(x)),
      ),
    );
  }

  // Convert Dart Object back to JSON (Map) for storage
  Map<String, dynamic> toMap() {
    return {
      'generated_date': generatedDate,
      'weekly_plan': weeklyPlan.map((x) => x.toMap()).toList(),
    };
  }
}

class DayPlan {
  final String dayName;
  final int totalCalories;
  final int totalProtein;
  final Map<String, List<MealOption>> meals; // breakfast, lunch, dinner, snack

  DayPlan({
    required this.dayName,
    required this.totalCalories,
    required this.totalProtein,
    required this.meals,
  });

  factory DayPlan.fromMap(Map<String, dynamic> map) {
    return DayPlan(
      dayName: map['day_name'] ?? '',
      totalCalories: map['total_calories'] ?? 0,
      totalProtein: map['total_protein'] ?? 0,
      meals: (map['meals'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          List<MealOption>.from(value.map((x) => MealOption.fromMap(x))),
        ),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'day_name': dayName,
      'total_calories': totalCalories,
      'total_protein': totalProtein,
      'meals': meals.map(
        (k, v) => MapEntry(k, v.map((x) => x.toMap()).toList()),
      ),
    };
  }
}

class MealOption {
  final String name;
  final int calories;
  final int proteins;

  MealOption({
    required this.name,
    required this.calories,
    required this.proteins,
  });

  factory MealOption.fromMap(Map<String, dynamic> map) {
    return MealOption(
      name: map['name'] ?? '',
      calories: map['calories'] ?? 0,
      proteins: map['proteins'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'calories': calories, 'proteins': proteins};
  }
}
