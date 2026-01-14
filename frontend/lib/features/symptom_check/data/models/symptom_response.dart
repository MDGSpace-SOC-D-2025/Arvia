import 'doctor_info.dart';

class SymptomResponse {
  final String answer;
  final String severity;
  final bool needsDoctor;
  final String disclaimer;
  final List<String> remedies;
  final String? originalQuery;                    // ← NEW
  final String? recommendedSpecialization;        // ← NEW
  final List<DoctorInfo> doctorsNearby;     
  final String? sessionId;            
  
  SymptomResponse({
    required this.answer,
    required this.severity,
    required this.needsDoctor,
    required this.disclaimer,
    required this.remedies,
    this.originalQuery,                           // ← (optional)
    this.recommendedSpecialization,               // ← (optional)
    this.doctorsNearby = const [],                // ← (default empty)
    this.sessionId,  
  });
  
  factory SymptomResponse.fromJson(Map<String, dynamic> json) {
    return SymptomResponse(
      answer: json['answer'] as String,
      severity: json['severity'] as String,
      needsDoctor: json['needs_doctor'] as bool,
      disclaimer: json['disclaimer'] as String,
      remedies: (json['remedies'] as List<dynamic>?)
          ?.map((item) => item as String)
          .toList() ?? [],
      originalQuery: json['original_query'] as String?,       // ← NEW
      recommendedSpecialization: json['recommended_specialization'] as String?,  // ← NEW
      doctorsNearby: (json['doctors_nearby'] as List<dynamic>?)  // ← NEW
          ?.map((item) => DoctorInfo.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
           sessionId: json['session_id'] as String?,
    );
  }
}