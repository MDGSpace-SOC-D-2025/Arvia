import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_diet/features/onboarding/bloc/onboardingState.dart';
import 'package:arvia/features/onboarding/bloc/onboardingBloc.dart';
import 'package:arvia/features/onboarding/bloc/onboardingEvent.dart';

class MedicalDietPage extends StatelessWidget {
  const MedicalDietPage({super.key});

  static const List<String> availableMeds = [
    "No Medical Restrictions",
    "Diabetes",
    "Low- FODMAP",
    "Anti-Inflammatory",
    "Low sodium",
    "Sulfite-free",
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingBloc>().state;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Do you follow a medical or therapeutic diet"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: 5 / 7,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            minHeight: 10,
            borderRadius: BorderRadius.circular(10),
          ),

          Expanded(
            child: ListView(
              children: availableMeds.map((med) {
                return CheckboxListTile(
                  title: Text(med),
                  value: state.medical_diet.contains(med),
                  onChanged: (bool? value) {
                    context.read<OnboardingBloc>().add(
                      UpdateMedDietEvent(med: med),
                    );
                  },
                );
              }).toList(),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: state.medical_diet.isNotEmpty
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
