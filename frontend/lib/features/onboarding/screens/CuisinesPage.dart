import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_diet/features/onboarding/bloc/onboardingState.dart';
import 'package:diet_app_recovered/features/onboarding/bloc/onboardingBloc.dart';
import 'package:diet_app_recovered/features/onboarding/bloc/onboardingEvent.dart';

class CuisinesPage extends StatelessWidget {
  const CuisinesPage({super.key});

  static const List<String> availableCuisines = [
    "American",
    "Asian",
    "Chinese",
    "Indian",
    "Italian",
    "Japanese",
    "Mediterranean",
    "Mexican",
    "Thai",
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingBloc>().state;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Select Your Preferred Cuisines"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: 7 / 7,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            minHeight: 10,
            borderRadius: BorderRadius.circular(10),
          ),

          Expanded(
            child: ListView(
              children: availableCuisines.map((cuisine) {
                return CheckboxListTile(
                  title: Text(cuisine),
                  value: state.cuisines.contains(cuisine),
                  onChanged: (bool? value) {
                    context.read<OnboardingBloc>().add(
                      UpdateCuisinesEvent(selectedCuisines: cuisine),
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
                onPressed: state.cuisines.isNotEmpty
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
