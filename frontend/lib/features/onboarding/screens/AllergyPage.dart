import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_diet/features/onboarding/bloc/onboardingState.dart';
import 'package:arvia/features/onboarding/bloc/onboardingBloc.dart';
import 'package:arvia/features/onboarding/bloc/onboardingEvent.dart';
class AllergyPage extends StatelessWidget {
  const AllergyPage({super.key});

  static const List<String> availableAllergy = [
    "No Food Exclusions",
    "Lactose-free",
    "Gluten-free",
    "Nut-free",
    "Dairy-free",
    "Fructose-free",
    "Jain",
    "Halal",
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingBloc>().state;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Allergies or faith related avoidance?"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: 6 / 7,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            minHeight: 10,
            borderRadius: BorderRadius.circular(10),
          ),

          Expanded(
            child: ListView(
              children: availableAllergy.map((allergy) {
                return CheckboxListTile(
                  title: Text(allergy),
                  value: state.allergies.contains(allergy),
                  onChanged: (bool? value) {
                    context.read<OnboardingBloc>().add(
                      UpdateAllergiesEvent(selectedAllergies: allergy),
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
                onPressed: state.allergies.isNotEmpty
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
