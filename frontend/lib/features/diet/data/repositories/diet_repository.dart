import 'dart:convert'; 
import 'package:http/http.dart' as http;  
import '../models/diet_plan_model.dart';  
// REPOSITORY CLASS
class DietRepository {
  
  // Backend URL
  static const String baseUrl = 'http://10.0.2.2:8000';  
  // METHOD: Generate Diet Plan
  Future<DietPlan> generateDiet({
    required String goal,         
    required String preference,   
  }) async {
    
    print(' Repository: generateDiet called');
    print(' Goal: $goal');
    print(' Preference: $preference');
    
    // Step 1: Prepare the request
    final url = Uri.parse('$baseUrl/generate-diet');  // Full endpoint URL
    
    final headers = {
      'Content-Type': 'application/json',  // Tell server we're sending JSON
    };
    
    // Request body (data we send to backend)
    final Map<String, dynamic> bodyData = {
      'goal': goal,
      'preference': preference,
    };
    
    // Convert Dart Map → JSON string
    final body = jsonEncode(bodyData);
    
    print('🔍 Making API call to: $url');
    
    
    // Step 2: Make the HTTP POST request
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );
      
      print('🔍 Response status: ${response.statusCode}');
      
      
      // Step 3: Check if request was successful
      if (response.statusCode == 200) {
        //  Parse the response
        
        print('🔍 Response received successfully');
        
        // Parse JSON string → Dart Map
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        
        print('🔍 Parsing JSON to DietPlan object...');
        
        // Convert Map → DietPlan object using our model
        final dietPlan = DietPlan.fromJson(jsonData);
        
        print(' DietPlan created successfully');
        print(' Plan type: ${dietPlan.planType}');
        print(' Number of days: ${dietPlan.days.length}');
        
        return dietPlan;  // Return to BLoC
        
      } else {
        print('🔴 API Error: ${response.statusCode}');
        print('🔴 Response body: ${response.body}');
        
        throw Exception(
          'Failed to generate diet plan: Server returned ${response.statusCode}'
        );
      }
      
    } catch (e) {
      // Network error or parsing error
      print('🔴 Exception in generateDiet: $e');
      
      // Re-throw with more context
      if (e is Exception) {
        rethrow; 
      } else {
        throw Exception('Network error: ${e.toString()}');
      }
    }
  }
  

  Future<void> saveDietToFavorites(DietPlan plan) async {

    
    throw UnimplementedError('Save feature coming soon!');
  }
  
  

  Future<List<DietPlan>> getSavedDiets() async {
    throw UnimplementedError('Feature coming soon!');
  }
}