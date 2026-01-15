import 'package:flutter/material.dart';
import 'features/symptom_check/presentation/symptom_check_screen.dart';
import 'package:arvia/core/services/test_session_service.dart';


  

void main() {
  testSessionService();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Symptom Checker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SymptomCheckScreen(),   // First screen shown
    );
  }
}