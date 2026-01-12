
import '../data/models/diet_plan_model.dart';
abstract class DietState {}

class DietInitial extends DietState {}

class DietLoading extends DietState {}

class DietSuccess extends DietState {
  final DietPlan plan;
  
  DietSuccess({required this.plan});
}

class DietError extends DietState {
  final String message;
  
  DietError({required this.message});
}