import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/symptom_bloc.dart';
import '../bloc/symptom_event.dart';
import '../bloc/symptom_state.dart';
import '../data/repositories/symptom_repository.dart';
import '../data/models/symptom_response.dart';
import '../data/models/doctor_info.dart';

class SymptomCheckScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('🟣 SymptomCheckScreen building');
    return BlocProvider(
      create: (context) {
        print('🟣 Creating BlocProvider');
        return SymptomBloc(SymptomRepository());
      },
      child: SymptomCheckView(),
    );
  }
}

class SymptomCheckView extends StatefulWidget {
  @override
  State<SymptomCheckView> createState() => _SymptomCheckViewState();
}

class _SymptomCheckViewState extends State<SymptomCheckView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    print('🟣 SymptomCheckView initialized');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Symptom Checker'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            Text(
              'How are you feeling today?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Input field
            TextField(
              controller: _controller,
              maxLines: 3,
              decoration: InputDecoration(
                hintText:
                    'Describe your symptoms\ne.g. "headache and fever since 2 days"',
                border: OutlineInputBorder(),
              ),
              onChanged: (text) {
                print('🔵 TextField changed: "$text"');
              },
            ),
            SizedBox(height: 16),

            // Check button
            ElevatedButton(
              onPressed: () {
                print('🔵 Button clicked!');
                final symptoms = _controller.text.trim();
                print('🔵 Symptoms text: "$symptoms"');
                print('🔵 Symptoms length: ${symptoms.length}');

                if (symptoms.isNotEmpty) {
                  print('🔵 Symptoms not empty, sending event to BLoC');
                  try {
                    context.read<SymptomBloc>().add(
                      CheckSymptomsRequested(symptoms),
                    );
                    print('🔵 Event sent successfully!');
                  } catch (e) {
                    print('🔴 Error sending event: $e');
                  }
                } else {
                  print('🔴 Symptoms empty, NOT sending event');
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('Check Symptoms', style: TextStyle(fontSize: 18)),
              ),
            ),
            SizedBox(height: 24),

            // Results area - listens to state changes
            Expanded(
              child: BlocBuilder<SymptomBloc, SymptomState>(   // Automatically rebuilds UI when state changes
                builder: (context, state) {
                  print(
                    '🔷 BlocBuilder rebuilding with state: ${state.runtimeType}',
                  );

                  if (state is SymptomInitial) {
                    print('🔷 Showing Initial state');
                    return Center(
                      child: Text(
                        'Enter your symptoms above',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  if (state is SymptomLoading) {
                    print('🔷 Showing Loading state');
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            'Analyzing your symptoms...',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is SymptomSuccess) {
                    print('🔷 Showing Success state');
                    final response = state.response;
                    print('🔷 Severity: ${response.severity}');
                    print('🔷 Remedies count: ${response.remedies.length}');
                    print('🔷 isLoadingLocation: ${state.isLoadingLocation}');
                    print('🔷 Doctors count: ${state.doctors?.length ?? 0}');

                    return _buildSeverityUI(state,); // ← Pass entire state, not just response
                  }

                  if (state is SymptomError) {
                    print('🔷 Showing Error state: ${state.message}');
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red,
                          ),
                          SizedBox(height: 16),
                          Text(
                            state.message,
                            style: TextStyle(fontSize: 16, color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  print('🔷 Unknown state, returning empty container');
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // NEW METHODS BELOW

  // Main method: decides which UI to show based on severity
 Widget _buildSeverityUI(SymptomSuccess state) {  // ← Changed parameter type
  final response = state.response;
  final severity = response.severity.toUpperCase();
  
  if (severity == 'MILD') {
    return _buildMildUI(response);  // MILD doesn't need doctors
  } else if (severity == 'MODERATE') {
    return _buildModerateUI(state);  // ← Pass state
  } else if (severity == 'SEVERE') {
    return _buildSevereUI(state);    // ← Pass state
  } else {
    return _buildDefaultUI(response);
  }
}

  // MILD UI: Green theme, calm messaging
  Widget _buildMildUI(SymptomResponse response) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Severity badge (green)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'Severity: MILD',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),

          // Calm reassurance message
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.green[700]),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Self-care is appropriate. Monitor symptoms and seek care if they worsen.',
                    style: TextStyle(color: Colors.green[900], fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),

          // Analysis
          Text(
            'Analysis:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(response.answer, style: TextStyle(fontSize: 16)),
          SizedBox(height: 16),

          // Remedies section
          if (response.remedies.isNotEmpty)
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.home, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        'Home Remedies:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  ...response.remedies
                      .map(
                        (remedy) => Padding(
                          padding: EdgeInsets.only(left: 32, top: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('• ', style: TextStyle(fontSize: 16)),
                              Expanded(
                                child: Text(
                                  remedy,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ],
              ),
            ),

          if (response.remedies.isNotEmpty) SizedBox(height: 16),

          // Disclaimer
          Text(
            response.disclaimer,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

// MODERATE UI: Orange theme, doctor recommendation
Widget _buildModerateUI(SymptomSuccess state) {  // ← CHANGED: Now takes state instead of response
  final response = state.response;  // ← Extract response from state
  
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1: SEVERITY BADGE (Orange) 
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_amber, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Severity: MODERATE',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        
        // 2: RECOMMENDED ACTION BOX 
        // This tells user to schedule doctor visit within 24-48 hours
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.medical_services, color: Colors.orange[800], size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'RECOMMENDED ACTION',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[900],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text(
                'Schedule a doctor consultation within 24-48 hours',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.orange[900],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        
        // 3: DOCTOR FINDER SECTION 
        // This shows one of 5 things:
        // 1. "Find Nearby Doctors" button (if doctors = null)
        // 2. "Getting location..." spinner (if isLoadingLocation = true)
        // 3. List of hospitals (if doctors has data)
        // 4. "No results" message (if doctors = empty list)
        // 5. Permission error (if locationError is set)
        _buildDoctorFinderSection(state),  // ← NEW: Calls helper method with state
        
        SizedBox(height: 16),
        
        // 4: ANALYSIS TEXT 
        // Shows the detailed symptom analysis from backend
        Text(
          'Analysis:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(response.answer, style: TextStyle(fontSize: 16)),
        SizedBox(height: 16),
        
        // 5: DISCLAIMER
        Text(
          response.disclaimer,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    ),
  );
}

// SEVERE UI: Red theme, urgent messaging
Widget _buildSevereUI(SymptomSuccess state) {  // ← CHANGED: Now takes state instead of response
  final response = state.response;  // ← Extract response from state
  
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //1: SEVERITY BADGE (Red)
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Severity: SEVERE',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        
        // 2: URGENT WARNING BOX
        // This is the BIG RED WARNING telling user to seek immediate care
        // More prominent than MODERATE's action box
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red[50],  // Light red background
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red, width: 3),  // Thicker border (3 vs 2)
          ),
          child: Column(
            children: [
              // Large hospital icon
              Icon(Icons.local_hospital, color: Colors.red[700], size: 48),
              SizedBox(height: 12),
              
              // URGENT header
              Text(
                '⚠️ URGENT MEDICAL ATTENTION NEEDED',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,  // Bigger than MODERATE (20 vs 18)
                  fontWeight: FontWeight.bold,
                  color: Colors.red[900],
                ),
              ),
              SizedBox(height: 12),
              
              // Urgent instructions
              Text(
                'Seek immediate medical care. Consider visiting emergency room if symptoms are acute.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red[900],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        
        // 3: DOCTOR FINDER SECTION 
        // IMPORTANT: For SEVERE cases, finding nearby doctors is CRITICAL
        // Shows same 5 possible states as MODERATE:
        // 1. "Find Nearby Doctors" button (if doctors = null)
        // 2. "Getting location..." spinner (if isLoadingLocation = true)
        // 3. List of hospitals (if doctors has data) - MOST IMPORTANT for SEVERE!
        // 4. "No results" message (if doctors = empty list)
        // 5. Permission error (if locationError is set)
        _buildDoctorFinderSection(state),  // ← NEW: Calls helper method with state
        
        SizedBox(height: 16),
        
        //4: ANALYSIS TEXT
        // For SEVERE cases, analysis explains WHY it's urgent
        Text(
          'Analysis:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(response.answer, style: TextStyle(fontSize: 16)),
        SizedBox(height: 16),
        
        // SECTION 5: DISCLAIMER 
        Text(
          response.disclaimer,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    ),
  );
}

  // Default UI: Fallback for unknown severity
  Widget _buildDefaultUI(SymptomResponse response) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Severity: ${response.severity}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Analysis:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(response.answer, style: TextStyle(fontSize: 16)),
          SizedBox(height: 16),
          Text(
            response.disclaimer,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
  // Helper widget: Doctor finder section (button, loading, or list)
Widget _buildDoctorFinderSection(SymptomSuccess state) {
  final response = state.response;
  
  // Show error if permission denied
  if (state.locationError != null) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              state.locationError!,
              style: TextStyle(color: Colors.red[900]),
            ),
          ),
        ],
      ),
    );
  }
  
  // Show loading while getting location
  if (state.isLoadingLocation) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 16),
          Text(
            'Getting your location...',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
  
  // Show doctors list if we have them
  if (state.doctors != null && state.doctors!.isNotEmpty) {
    return _buildDoctorsList(state.doctors!);
  }
  
  // Show "no results" if searched but empty
  if (state.doctors != null && state.doctors!.isEmpty) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.grey[700]),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'No hospitals found in your area. Try expanding search radius.',
              style: TextStyle(color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }
  
  // Default: Show button to find doctors
  return ElevatedButton.icon(
    onPressed: () {
      print('🔵 Find Doctors button clicked');
      context.read<SymptomBloc>().add(LocationRequested());
    },
    icon: Icon(Icons.location_on),
    label: Text('Find Nearby Doctors'),
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.all(16),
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),
  );
}
// Helper widget: Display list of nearby hospitals
Widget _buildDoctorsList(List<DoctorInfo> doctors) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(Icons.local_hospital, color: Colors.blue),
          SizedBox(width: 8),
          Text(
            'Nearby Hospitals (${doctors.length})',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      SizedBox(height: 12),
      
      // List of doctor cards
      ...doctors.map((doctor) => Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hospital name
            Row(
              children: [
                Icon(Icons.local_hospital, color: Colors.blue, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    doctor.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            
            // Address
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.grey[600], size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    doctor.address,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            
            // Distance
            Row(
              children: [
                Icon(Icons.directions_walk, color: Colors.grey[600], size: 16),
                SizedBox(width: 8),
                Text(
                  '${doctor.distance} away',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            
            // Specialization
            Row(
              children: [
                Icon(Icons.medical_services, color: Colors.grey[600], size: 16),
                SizedBox(width: 8),
                Text(
                  doctor.specialization,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      )).toList(),
    ],
  );
}
  // OLD METHOD: Keep for color reference (not used in new UI)
  Color _getSeverityColor(String severity) {
    switch (severity.toUpperCase()) {
      case 'MILD':
        return Colors.green;
      case 'MODERATE':
        return Colors.orange;
      case 'SEVERE':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
