import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_diet/features/onboarding/bloc/onboardingState.dart';
import 'package:arvia/features/onboarding/bloc/onboardingBloc.dart';
import 'package:arvia/features/onboarding/bloc/onboardingEvent.dart';


class GoalSelectionPage extends StatelessWidget {
  const GoalSelectionPage({super.key});

  static const List<String> availableGoals = [
    "Lose Weight",
    "Eat Healthy",
    "Try New Recipes",
    "Build Muscle",
    "Prevent Diseases",
    "Be More Energetic",
    "Balance Nutrition",
    "Lower Cholestrol",
    "Manage Blood Sugar",
    "Improve Digestion",
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingBloc>().state;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Select Your Goals"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: 1 / 7,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            minHeight: 10,
            borderRadius: BorderRadius.circular(10),
          ),

          Expanded(
            child: ListView(
              children: availableGoals.map((goal) {
                return CheckboxListTile(
                  title: Text(goal),
                  value: state.goals.contains(goal),
                  onChanged: (bool? value) {
                    context.read<OnboardingBloc>().add(
                      UpdateGoalEvent(goal: goal),
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
                onPressed: state.goals.isNotEmpty
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
