// lib/features/home/home_screen.dart
// Simple home screen to navigate between Symptom Checker and Diet Planner

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arvia/features/symptom_check/presentation/symptom_check_screen.dart';
import 'package:arvia/features/onboarding/screens/OnboardingWrapper.dart';
import 'package:arvia/features/onboarding/bloc/onboardingBloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // Top app bar
      appBar: AppBar(
        title: const Text('Arvia Health'),
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome message
              const SizedBox(height: 20),

              const Text(
                'Welcome!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Choose a service to get started',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),

              const SizedBox(height: 40),

              // CARD 1: Symptom Checker
              _buildFeatureCard(
                // helper twice with different parameters
                context: context,
                icon: Icons.medical_services,
                title: 'Symptom Checker',
                description: 'Check your symptoms and find nearby doctors',
                color: Colors.blue,
                onTap: () {
                  // Navigate to Symptom Checker
                  Navigator.push(
                    // Add a new screen on top of current screen
                    context,
                    MaterialPageRoute(
                      builder: (context) => SymptomCheckScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // CARD 2: Diet Planner
              _buildFeatureCard(
                context: context,
                icon: Icons.restaurant_menu,
                title: 'Diet Planner',
                description: 'Get personalized meal plans for your goals',
                color: Colors.green,
                onTap: () {
                  // Navigate to Diet Planner (Onboarding)
                  // Need to provide OnboardingBloc for the entire onboarding flow
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => OnboardingBloc(),
                        child: const OnboardingWrapper(),
                      ),
                    ),
                  );
                },
              ),

              const Spacer(),

              // Footer info
              Center(
                child: Text(
                  'Your health companion',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper method to build feature cards
  /// This creates the clickable cards for each feature
  Widget _buildFeatureCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(   //  Makes any widget clickable
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 32),
            ),

            const SizedBox(width: 20),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),

            // Arrow icon
            Icon(Icons.arrow_forward_ios, color: color, size: 20),
          ],
        ),
      ),
    );
  }
}