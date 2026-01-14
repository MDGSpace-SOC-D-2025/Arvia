// handles API calls related to symptom checking
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/symptom_response.dart';
import '../../../../core/services/session_service.dart';

class SymptomRepository {
  // backend URL
  static const String baseUrl = 'http://10.0.2.2:8000'; // Localhost for Android emulator
  
  // Method to check symptoms
Future<SymptomResponse> checkSymptoms(
  String symptoms, {
  double? latitude,    // ← Optional parameters
  double? longitude,
}) async {
  print(' Repository: checkSymptoms called');
   // Get the SessionService instance
  final sessionService = SessionService();
  
  // Get current session_id (might be null for first request)
  final currentSessionId = sessionService.sessionId;
  print(' Current session_id: $currentSessionId');
  print(' Symptoms: $symptoms');
  print(' Location: ${latitude ?? "not provided"}, ${longitude ?? "not provided"}');
  
  // Prepare the request
  final url = Uri.parse('$baseUrl/check-symptoms');
  final headers = {'Content-Type': 'application/json'};
  
  // Build request body
  final Map<String, dynamic> bodyData = {
    'symptoms': symptoms,
  };
  
  // Add location if provided
  if (latitude != null && longitude != null) {
    bodyData['latitude'] = latitude;
    bodyData['longitude'] = longitude;
    print(' Including location in request');
  }

   if (currentSessionId != null) {
    bodyData['session_id'] = currentSessionId;
    print(' Including session_id in request: $currentSessionId');
  } else {
    print(' No session_id yet (first request)');
  }
  
  final body = jsonEncode(bodyData);
  
  // Make the API call
  final response = await http.post(url, headers: headers, body: body);
  
  // Handle the response
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    print(' Response received');
       // Parse the response
    final symptomResponse = SymptomResponse.fromJson(jsonData);
    
    // Store the session_id from response (for next request)
    if (symptomResponse.sessionId != null) {
      sessionService.setSessionId(symptomResponse.sessionId!);
      print(' Stored new session_id: ${symptomResponse.sessionId}');
    }
    return SymptomResponse.fromJson(jsonData);
  } else {
    throw Exception('Failed to check symptoms: ${response.statusCode}');
  }
}
}