import 'package:arvia/features/onboarding/models/diet_plan_model.dart';

class OnboardingState {
  final List<String> goals;
  final String activity;
  final double height;
  final double weight;
  final String gender;
  final double target_weight;
  final String dietType;
  final List<String> medical_diet;
  final List<String> allergies;
  final List<String> cuisines;
  final int currentStep; // To track screen progress

  final DietPlanModel? dietPlan;
  final int breakfastIndex;
  final int lunchIndex;
  final int dinnerIndex;
  final int snackIndex;
  final bool onboardingComplete;

  OnboardingState({
    this.goals = const [],
    this.activity = '',
    this.height = 0.0,
    this.weight = 0.0,
    this.gender = '',
    this.target_weight = 0.0,
    this.dietType = '',
    this.medical_diet = const [],
    this.allergies = const [],
    this.cuisines = const [],
    this.currentStep = 0,
    this.dietPlan,
    this.breakfastIndex = 0,
    this.lunchIndex = 0,
    this.dinnerIndex = 0,
    this.snackIndex = 0,
    this.onboardingComplete = false,
  });

  OnboardingState copyWith({
    List<String>? goals,
    String? activity,
    double? height,
    double? weight,
    String? gender,
    double? target_weight,
    String? dietType,
    List<String>? medical_diet,
    List<String>? allergies,
    List<String>? cuisines,
    int? currentStep,
    DietPlanModel? dietPlan,
    int? breakfastIndex,
    int? lunchIndex,
    int? dinnerIndex,
    int? snackIndex,
    bool? onboardingComplete,
  }) {
    return OnboardingState(
      goals: goals ?? this.goals,
      activity: activity ?? this.activity,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      gender: gender ?? this.gender,
      target_weight: target_weight ?? this.target_weight,
      dietType: dietType ?? this.dietType,
      medical_diet: medical_diet ?? this.medical_diet,
      allergies: allergies ?? this.allergies,
      cuisines: cuisines ?? this.cuisines,
      currentStep: currentStep ?? this.currentStep,
      dietPlan: dietPlan ?? this.dietPlan,
      breakfastIndex: breakfastIndex ?? this.breakfastIndex,
      lunchIndex: lunchIndex ?? this.lunchIndex,
      dinnerIndex: dinnerIndex ?? this.dinnerIndex,
      snackIndex: snackIndex ?? this.snackIndex,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'goals': goals,
      'activity_level': activity,
      'gender': gender,
      'height': height,
      'weight': weight,
      'target_weight': target_weight,
      'diet_type': dietType,
      'medical_diet': medical_diet,
      'allergies': allergies,
      'preferred_cuisines': cuisines,
    };
  }
}
