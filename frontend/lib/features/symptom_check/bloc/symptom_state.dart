import '../data/models/symptom_response.dart';
import '../data/models/symptom_response.dart';

// Base class - all states extend this
abstract class SymptomState {}

// State 1: Initial (app just opened)
class SymptomInitial extends SymptomState {}

// State 2: Loading (API call in progress)
class SymptomLoading extends SymptomState {}

// State 3: Success (got data)
class SymptomSuccess extends SymptomState {
  final SymptomResponse response;
  final bool isLoadingLocation;        // ← NEW! True while getting GPS
  final List<DoctorInfo>? doctors;     // ← NEW! Nullable, starts as null
  final String? locationError;         // ← NEW! Error message if permission denied
  
  SymptomSuccess({
    required this.response,
    this.isLoadingLocation = false,    // ← Default: not loading
    this.doctors,                      // ← Default: null (no doctors yet)
    this.locationError,                // ← Default: null (no error)
  });
  
  // NEW: Helper method to create a copy with changes
  SymptomSuccess copyWith({
    SymptomResponse? response,
    bool? isLoadingLocation,
    List<DoctorInfo>? doctors,
    String? locationError,
  }) {
    return SymptomSuccess(
      response: response ?? this.response,
      isLoadingLocation: isLoadingLocation ?? this.isLoadingLocation,
      doctors: doctors ?? this.doctors,
      locationError: locationError ?? this.locationError,
    );
  }
}

// State 4: Error (something failed)
class SymptomError extends SymptomState {
  final String message;
  
  SymptomError(this.message);
}