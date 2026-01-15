// Base class - all events extend this
abstract class SymptomEvent {}

// event: user clicked button
class CheckSymptomsRequested extends SymptomEvent {
  final String symptoms;
  
  CheckSymptomsRequested(this.symptoms);
}

// NEW EVENT: User clicked "Find Nearby Doctors"
class LocationRequested extends SymptomEvent {}