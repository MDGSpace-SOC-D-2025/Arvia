import 'dart:convert';
import 'package:arvia/features/onboarding/models/diet_plan_model.dart';
import '../models/diet_plan_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _planKey = 'user_diet_plan_json';
  static const String _onboardingKey = 'is_onboarding_complete';

  // 1. Save the entire Diet Plan
  Future<void> saveDietPlan(DietPlanModel plan) async {
    final prefs = await SharedPreferences.getInstance();

    // Convert our Dart Object into a Map, then into a String
    String jsonString = jsonEncode(plan.toMap());

    await prefs.setString(_planKey, jsonString);
    // We also set the status to true here as a backup
    await prefs.setBool(_onboardingKey, true);
    print("Plan saved successfully to local storage.");
  }

  // 2. Load the Diet Plan
  Future<DietPlanModel?> getDietPlan() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(_planKey);

    if (jsonString == null) return null;

    // Convert the String back into a Map, then into our Dart Object
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return DietPlanModel.fromMap(jsonMap);
  }

  // --- NEW: Check if onboarding is complete ---
  Future<bool> getOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    // Returns false if the key doesn't exist yet
    return prefs.getBool(_onboardingKey) ?? false;
  }

  // --- NEW: Manually set onboarding status ---
  Future<void> setOnboardingStatus(bool isComplete) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, isComplete);
  }

  // 3. Clear data (Useful for "Logout" or "Reset")
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}