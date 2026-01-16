import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arvia/features/onboarding/bloc/onboardingBloc.dart';
import 'package:arvia/features/onboarding/bloc/onboardingEvent.dart';

class ActivityLevelPage extends StatelessWidget {
  const ActivityLevelPage({super.key});

  static const List<String> levels = [
    "Sedentary (no exercise)",
    "Lightly Active (1-3 days/week)",
    "Moderately Active (3-5 days/week)",
    "Very Active (6-7 days/week)",
    "Extra Active (Physical Job/Athlete)",
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingBloc>().state;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("How active are you each day?"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: 2 / 7,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            minHeight: 10,
            borderRadius: BorderRadius.circular(10),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: levels.length,
              itemBuilder: (context, index) {
                final level = levels[index];
                return RadioListTile<String>(
                  title: Text(level),
                  value: level,
                  groupValue: state.activity,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      context.read<OnboardingBloc>().add(
                        UpdateActivityEvent(selectedActivity: newValue),
                      );
                    }
                  },
                );
              },
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                onPressed: state.activity.isNotEmpty
                    ? () => context.read<OnboardingBloc>().add(NextStepEvent())
                    : null,
                child: const Text(
                  "Continue",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}