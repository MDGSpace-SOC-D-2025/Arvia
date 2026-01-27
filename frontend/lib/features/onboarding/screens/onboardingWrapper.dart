import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:arvia/features/onboarding/bloc/onboardingBloc.dart';
import 'package:arvia/features/onboarding/bloc/onboardingState.dart';
import 'package:arvia/features/onboarding/bloc/onboardingEvent.dart';
import 'package:arvia/features/onboarding/screens/ActivityLevelPage.dart';
import 'package:arvia/features/onboarding/screens/AllergyPage.dart';
import 'package:arvia/features/onboarding/screens/CuisinesPage.dart';
import 'package:arvia/features/onboarding/screens/DietTypePage.dart';
import 'package:arvia/features/onboarding/screens/GoalSelectionPage.dart';
import 'package:arvia/features/onboarding/screens/IntroductoryPage.dart';
import 'package:arvia/features/onboarding/screens/MedicalDietPage.dart';
import 'package:arvia/features/onboarding/screens/TargetWeightPage.dart';
import 'package:arvia/features/onboarding/screens/DailyMealPage.dart';
import 'package:arvia/features/onboarding/screens/OnboardingCompletePage.dart';

class OnboardingWrapper extends StatelessWidget {
  const OnboardingWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        if (state.onboardingComplete) {
          if (state.dietPlan == null) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return const DailyMealPage();
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: state.currentStep > 0
                ? IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () =>
                        context.read<OnboardingBloc>().add(PreviousStepEvent()),
                  )
                : null,
          ),
          body: _getStepPage(state.currentStep),
        );
      },
    );
  }

  Widget _getStepPage(int step) {
    switch (step) {
      case 0:
        return const IntroductoryPage();
      case 1:
        return const GoalSelectionPage();
      case 2:
        return const ActivityLevelPage();
      case 3:
        return const TargetWeightPage();
      case 4:
        return const DietTypePage();
      case 5:
        return const MedicalDietPage();
      case 6:
        return const AllergyPage();
      case 7:
        return const CuisinesPage();
      case 8:
        return const OnboardingCompletePage();
      default:
        return const IntroductoryPage();
    }
  }
}
