// model 1 : Meals for a single day
class DayMeals {
  final String breakfast;
  final String lunch;
  final String dinner;
  final String snacks;
  
  DayMeals({
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.snacks,
  });
  
  // fromJson: Convert JSON → Dart object
  // This is called when we receive data from backend
  factory DayMeals.fromJson(Map<String, dynamic> json) {
    return DayMeals(
      breakfast: json['breakfast'] as String,
      lunch: json['lunch'] as String,
      dinner: json['dinner'] as String,
      snacks: json['snacks'] as String,
    );
  }

}

// MODEL 2: Single Day Plan
class DietDay {
  final String day;              
  final DayMeals meals;          // Breakfast, lunch, dinner, snacks
  final int calories;            
  final String hydration;       
  
  DietDay({
    required this.day,
    required this.meals,
    required this.calories,
    required this.hydration,
  });
  
  // fromJson: Parse one day's data
  factory DietDay.fromJson(Map<String, dynamic> json) {
    return DietDay(
      day: json['day'] as String,
      meals: DayMeals.fromJson(json['meals'] as Map<String, dynamic>),  // ← Nested model
      calories: json['calories'] as int,
      hydration: json['hydration'] as String,
    );
  }

}

// MODEL 3: Complete 7-Day Diet Plan
class DietPlan {
  final String planType;         
  final String dietPreference;   
  final List<DietDay> days;      
  final List<String> lifestyleTips;  
  
  DietPlan({
    required this.planType,
    required this.dietPreference,
    required this.days,
    required this.lifestyleTips,
  });
  
  // fromJson: Parse complete backend response
  factory DietPlan.fromJson(Map<String, dynamic> json) {
    return DietPlan(
      planType: json['plan_type'] as String,
      dietPreference: json['diet_preference'] as String,
      
      // Parse list of days
      // Backend sends: "days": [{day1}, {day2}, ...], convert each to DietDay object
      days: (json['days'] as List<dynamic>)
          .map((dayJson) => DietDay.fromJson(dayJson as Map<String, dynamic>))
          .toList(),
      
      // Parse list of tips
      lifestyleTips: (json['lifestyle_tips'] as List<dynamic>)
          .map((tip) => tip as String)
          .toList(),
    );
  }
  
  // Helper method: Get specific day by name
  DietDay? getDayByName(String dayName) {
    try {
      return days.firstWhere((day) => day.day == dayName);
    } catch (e) {
      return null;  // Day not found
    }
  }
  
  // Helper method: Get total weekly calories
  int getTotalWeeklyCalories() {
    return days.fold(0, (sum, day) => sum + day.calories);
  }
}