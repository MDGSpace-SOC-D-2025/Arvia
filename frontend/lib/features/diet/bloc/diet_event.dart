abstract class DietEvent {}

// EVENT 1: User Clicked "Generate Diet" Button
class DietGenerateRequested extends DietEvent {
  // This event carries data the BLoC needs to generate the diet
  
  final String goal;       
  final String preference;   
  
  DietGenerateRequested({
    required this.goal,
    required this.preference,
  });
  
}

// EVENT 2: User Clicked "Retry" After Error
class DietRetryRequested extends DietEvent {   
  DietRetryRequested();
}


// FUTURE EVENT: User Updated Preferences
class DietPreferencesUpdated extends DietEvent {
  
  final String? newGoal;
  final String? newPreference;
  
  DietPreferencesUpdated({
    this.newGoal,
    this.newPreference,
  }); // both nullable as they can be updated independently
}