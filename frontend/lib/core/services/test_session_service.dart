// lib/core/services/test_session_service.dart

import 'session_service.dart';

void testSessionService() {
  final separator = List.filled(60, '=').join();
  final dash = List.filled(60, '-').join();
  
  print('\n$separator');
  print('TESTING SESSION SERVICE SINGLETON');
  print(separator);
 
  // TEST 1: Creating "multiple" instances
  print('\n[TEST 1: Singleton Pattern]');
  print(dash);
  
  print('Creating session1...');
  final session1 = SessionService();
  
  print('\nCreating session2...');
  final session2 = SessionService();
  
  print('\nCreating session3...');
  final session3 = SessionService();
  
  // Check if they're the same object
  print('\nAre session1 and session2 the same object?');
  print('Answer: ${identical(session1, session2)}');
  
  print('\nAre session1 and session3 the same object?');
  print('Answer: ${identical(session1, session3)}');
  
  // TEST 2: Data persistence
  print('\n[TEST 2: Data Sharing]');
  print(dash);
  
  print('Storing session_id in session1...');
  session1.setSessionId('abc123');
  
  print('\nReading from session2 (different variable):');
  print('session2.sessionId = ${session2.sessionId}');
  
  print('\nReading from session3 (different variable):');
  print('session3.sessionId = ${session3.sessionId}');
  
  print('\n💡 All three show "abc123" because they are THE SAME OBJECT!');
  
  // TEST 3: Cross-feature simulation
  print('\n[TEST 3: Cross-Feature Simulation]');
  print(dash);
  
  print('\n🏥 Symptom Checker Feature:');
  final symptomSession = SessionService();
  symptomSession.setSessionId('user_xyz789');
  print('   Stored session: ${symptomSession.sessionId}');
  
  print('\n🍎 Diet Planner Feature:');
  final dietSession = SessionService();
  print('   Can access session: ${dietSession.sessionId}');
  print('   Same session? ${dietSession.sessionId == symptomSession.sessionId}');
  
  // TEST 4: Session methods
  print('\n[TEST 4: Session Methods]');
  print(dash);
  
  final session = SessionService();
  
  print('Has session? ${session.hasSession}');
  
  session.setSessionId('new_session_456');
  print('After setting: ${session.sessionId}');
  print('Has session? ${session.hasSession}');
  
  session.clearSession();
  print('After clearing: ${session.sessionId}');
  print('Has session? ${session.hasSession}');
  
  // TEST 5: Getter test
  print('\n[TEST 5: Getter vs Direct Access]');
  print(dash);
  
  final testSession = SessionService();
  testSession.setSessionId('test_999');
  
  print('Using getter: ${testSession.sessionId}');
  print('Direct access to _sessionId: Not allowed (private)');
  
  print('\n$separator');
  print('ALL TESTS COMPLETE!');
  print('$separator\n');
} 