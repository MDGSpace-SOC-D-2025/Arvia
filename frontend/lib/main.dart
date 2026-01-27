import 'package:flutter/material.dart';
import 'package:arvia/core/services/test_session_service.dart';
import 'package:arvia/features/home/home_screen.dart';  

void main() {
  testSessionService();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arvia Health',  
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),  //  starts with HomeScreen
      debugShowCheckedModeBanner: false,  // removes debug banner
    );
  }
}