
class SessionService {
  
  // SINGLETON PATTERN
  
  // PART 1: Private constructor
  // The underscore (_) makes this constructor private
  SessionService._internal() {
    print('🔷 SessionService: Singleton instance created');
  }
  
  // PART 2: The ONE instance
  // This is created ONCE when the class is first accessed
  static final SessionService _instance = SessionService._internal();
  
  // PART 3: Factory constructor
  // When someone calls SessionService(), this runs
  factory SessionService() {
    print('🔷 SessionService: Returning singleton instance');
    return _instance;
  }
  
  // DATA STORAGE

  String? _sessionId;
  
  // PUBLIC METHODS (API of this service)

  String? get sessionId {
    print('🔷 SessionService: Getting session_id = $_sessionId');
    return _sessionId;
  }
  
  // Store a new session ID
  // Call this after getting a response from backend
  void setSessionId(String id) {
    _sessionId = id;
    print('🔷 SessionService: Stored session_id = $id');
  }
  
  // Clear the session 
  void clearSession() {
    print('🔷 SessionService: Clearing session (was: $_sessionId)');
    _sessionId = null;
  }
  
 // Check if we have an active session
  bool get hasSession {
    return _sessionId != null;
  }
}