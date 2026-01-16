abstract class OnboardingEvent {}

class UpdateGoalEvent extends OnboardingEvent {
  final String goal;
  UpdateGoalEvent({required this.goal});
}

class UpdateActivityEvent extends OnboardingEvent {
  final String selectedActivity;
  UpdateActivityEvent({required this.selectedActivity});
}

class UpdateBodyProfileEvent extends OnboardingEvent {
  final double weight;
  final double height;
  final String gender;

  UpdateBodyProfileEvent({
    required this.weight,
    required this.height,
    required this.gender,
  });
}

class UpdateTargetWtEvent extends OnboardingEvent {
  final double selectedTargetwt;
  UpdateTargetWtEvent({required this.selectedTargetwt});
}

class UpdateDietEvent extends OnboardingEvent {
  final String selectedDiet;
  UpdateDietEvent({required this.selectedDiet});
}

class UpdateMedDietEvent extends OnboardingEvent {
  final String med;
  UpdateMedDietEvent({required this.med});
}

class UpdateAllergiesEvent extends OnboardingEvent {
  final String selectedAllergies;
  UpdateAllergiesEvent({required this.selectedAllergies});
}

class UpdateCuisinesEvent extends OnboardingEvent {
  final String selectedCuisines;
  UpdateCuisinesEvent({required this.selectedCuisines});
}

// Navigation Events
class NextStepEvent extends OnboardingEvent {}

class PreviousStepEvent extends OnboardingEvent {}

class CompleteOnboardingEvent extends OnboardingEvent {}

class SwapMealEvent extends OnboardingEvent {
  final String mealType; // "breakfast", "lunch", or "dinner"
  SwapMealEvent({required this.mealType});
}

class LoadSavedPlanEvent extends OnboardingEvent {}
