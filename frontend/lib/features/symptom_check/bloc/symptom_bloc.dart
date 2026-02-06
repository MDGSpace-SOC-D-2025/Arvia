import 'package:flutter_bloc/flutter_bloc.dart';
import 'symptom_event.dart';
import 'symptom_state.dart';
import '../data/repositories/symptom_repository.dart';
import 'package:geolocator/geolocator.dart';

class SymptomBloc extends Bloc<SymptomEvent, SymptomState> {
  final SymptomRepository repository;
  
  SymptomBloc(this.repository) : super(SymptomInitial()) {
    print('🟣 SymptomBloc created');
    on<CheckSymptomsRequested>(_onCheckSymptomsRequested);
    on<LocationRequested>(_onLocationRequested);
  }
  
Future<void> _onCheckSymptomsRequested(
  CheckSymptomsRequested event,
  Emitter<SymptomState> emit,
) async {
  print('🟢 BLoC received event with symptoms: "${event.symptoms}"');
  
  emit(SymptomLoading());
  print('🟢 Emitted Loading state');
  
  try {
    print('🟢 Calling repository...');
    final response = await repository.checkSymptoms(event.symptoms);
    print('🟢 Got response from repository');
    print('🟢 Response severity: ${response.severity}');
    print('🟢 Response remedies: ${response.remedies}');
    
    emit(SymptomSuccess(response: response));  // ← FIXED: Added "response:" label
    print('🟢 Emitted Success state');
  } catch (e) {
    print('🔴 Error in BLoC: $e');
    emit(SymptomError('Failed to check symptoms. Please try again.'));
    print('🔴 Emitted Error state');
  }
}

  Future<void> _onLocationRequested(
  LocationRequested event,
  Emitter<SymptomState> emit,
) async {
  print('🟢 Location requested');
  
  // Get current state (must be SymptomSuccess to request location)
  final currentState = state;
  if (currentState is! SymptomSuccess) {
    print('🔴 Cannot request location - not in Success state');
    return;
  }
  
  // Step 1: Show loading
  emit(currentState.copyWith(isLoadingLocation: true));
  print('🟢 Emitted: isLoadingLocation = true');
  
  try {
    // Step 2: Check if location services are enabled, Different from app permission
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('🔴 Location services disabled');
      emit(currentState.copyWith(
        isLoadingLocation: false,
        locationError: 'Location services are disabled. Please enable them in settings.',
      ));
      return;
    }
    
    // Step 3: Check permission status
    LocationPermission permission = await Geolocator.checkPermission();
    print('🟢 Current permission: $permission');
    
    if (permission == LocationPermission.denied) {
      // Request permission
      print('🟢 Requesting permission...');
      permission = await Geolocator.requestPermission();
      print('🟢 Permission result: $permission');
      
      if (permission == LocationPermission.denied) {
        print('🔴 Permission denied by user');
        emit(currentState.copyWith(
          isLoadingLocation: false,
          locationError: 'Location permission denied. Cannot find nearby doctors.',
        ));
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      print('🔴 Permission denied forever');
      emit(currentState.copyWith(
        isLoadingLocation: false,
        locationError: 'Location permission permanently denied. Please enable in settings.',
      ));
      return;
    }
    
    // Step 4: Get current position
    print('🟢 Getting current position...');
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    print('🟢 Got position: ${position.latitude}, ${position.longitude}');
    
    // Step 5: Call backend with location
    print('🟢 Calling backend with location...');
    final response = await repository.checkSymptoms(
      currentState.response.originalQuery ?? 'symptoms',
      latitude: position.latitude,
      longitude: position.longitude,
    );
    print('🟢 Got response with ${response.doctorsNearby.length} doctors');
    
    // Step 6: Emit success with doctors
    emit(SymptomSuccess(
      response: response,
      isLoadingLocation: false,
      doctors: response.doctorsNearby,
    ));
    print('🟢 Emitted success with doctors');
    
  } catch (e) {
    print('🔴 Error getting location: $e');
    emit(currentState.copyWith(
      isLoadingLocation: false,
      locationError: 'Failed to get location: ${e.toString()}',
    ));
  }
}
}