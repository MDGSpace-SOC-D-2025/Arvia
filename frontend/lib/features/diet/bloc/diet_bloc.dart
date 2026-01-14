import 'package:flutter_bloc/flutter_bloc.dart';
import 'diet_event.dart';
import 'diet_state.dart';
import '../data/repositories/diet_repository.dart';

// THE DIET BLOC CLASS
class DietBloc extends Bloc<DietEvent, DietState> {
  
  final DietRepository repository;
  // - Dependency Injection (makes testing easier)
  // CONSTRUCTOR
  DietBloc(this.repository) : super(DietInitial()) { // start in this state
    print(' DietBloc created');
    on<DietGenerateRequested>(_onGenerateRequested);
    on<DietRetryRequested>(_onRetryRequested);
  }
  // EVENT HANDLER 1: Generate Diet
  Future<void> _onGenerateRequested(
    DietGenerateRequested event,      // The event that was sent
    Emitter<DietState> emit,          // Tool to send states back to UI
  ) async {
    print(' BLoC received DietGenerateRequested event');
    print(' Goal: ${event.goal}');
    print(' Preference: ${event.preference}');
    emit(DietLoading());
    print('Emitted DietLoading state');

    try {
      print('Calling repository.generateDiet...');
      
      // Call repository (this makes the HTTP request)
      final dietPlan = await repository.generateDiet(
        goal: event.goal,
        preference: event.preference,
      );
      
      print(' Got DietPlan from repository');
      print(' Plan type: ${dietPlan.planType}');
      print(' Number of days: ${dietPlan.days.length}');
 
      emit(DietSuccess(plan: dietPlan));
      print(' Emitted DietSuccess state');

    } catch (e) {

      print(' Error in BLoC: $e');
      
      emit(DietError(message: 'Failed to generate diet plan. Please try again.'));
      print(' Emitted DietError state');

    }
  }

  // EVENT HANDLER 2: Retry After Error
  Future<void> _onRetryRequested(
    DietRetryRequested event,
    Emitter<DietState> emit,
  ) async {
    print(' Retry requested');

    emit(DietInitial());

  }
}