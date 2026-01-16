import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arvia/features/onboarding/bloc/onboardingBloc.dart';
import 'package:arvia/features/onboarding/bloc/onboardingEvent.dart';

class DietTypePage extends StatelessWidget {
  const DietTypePage({super.key});

  static const List<String> dietss = [
    "Low Carb",
    "Keto",
    "Vegetarian",
    "Vegan",
    "Carnivore",
    "Mediterranean",
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingBloc>().state;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Select Your Diet"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: 4 / 7,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            minHeight: 10,
            borderRadius: BorderRadius.circular(10),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: dietss.length,
              itemBuilder: (context, index) {
                final diet = dietss[index];
                return RadioListTile<String>(
                  title: Text(diet),
                  value: diet,
                  groupValue: state.dietType,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      context.read<OnboardingBloc>().add(
                        UpdateDietEvent(selectedDiet: newValue),
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
                onPressed: state.dietType.isNotEmpty
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