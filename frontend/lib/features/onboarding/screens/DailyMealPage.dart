import 'package:arvia/features/onboarding/screens/WeeklyPagePlan.dart';
import 'package:arvia/features/onboarding/screens/OnboardingWrapper.dart';
import 'package:arvia/features/onboarding/services/storage_service.dart';
import 'package:arvia/features/onboarding/bloc/onboardingBloc.dart';
import 'package:arvia/features/onboarding/bloc/onboardingEvent.dart';
import 'package:arvia/features/onboarding/bloc/onboardingState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class DailyMealPage extends StatelessWidget {
  const DailyMealPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.redAccent),
            tooltip: "Reset App",
            onPressed: () async {
              print("DEBUG: Reset button pressed");
              try {
                // 1. Clear the physical storage
                await StorageService().clearAllData();
                print("DEBUG: Storage cleared successfully");

                // 2. Reset the BLoC state so the UI knows it's no longer 'complete'
                // We add the LoadSavedPlanEvent to force the BLoC to read the now-empty storage
                context.read<OnboardingBloc>().add(LoadSavedPlanEvent());

                if (context.mounted) {
                  // 3. Jump to the wrapper. Since we cleared storage,
                  // the LoadSavedPlanEvent will result in 'onboardingComplete = false'
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OnboardingWrapper(),
                    ),
                    (route) => false,
                  );
                  print("DEBUG: Navigation triggered");
                }
              } catch (e) {
                print("DEBUG: Reset Error: $e");
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          if (state.dietPlan == null) {
            return const Center(child: CircularProgressIndicator());
          }

          int dayIndex = (DateTime.now().weekday - 1);
          if (dayIndex >= state.dietPlan!.weeklyPlan.length) {
            dayIndex = 0; // fallback
          }
          final currentDay = state.dietPlan!.weeklyPlan[dayIndex];

          // Calculate totals using currently selected indices
          int totalCals =
              (currentDay.meals["breakfast"]?[state.breakfastIndex].calories ??
                  0) +
              (currentDay.meals["lunch"]?[state.lunchIndex].calories ?? 0) +
              (currentDay.meals["dinner"]?[state.dinnerIndex].calories ?? 0) +
              (currentDay.meals["snack"]?[state.snackIndex].calories ?? 0);

          int totalProt =
              (currentDay.meals["breakfast"]?[state.breakfastIndex].proteins ??
                  0) +
              (currentDay.meals["lunch"]?[state.lunchIndex].proteins ?? 0) +
              (currentDay.meals["dinner"]?[state.dinnerIndex].proteins ?? 0) +
              (currentDay.meals["snack"]?[state.snackIndex].proteins ?? 0);

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Icon(
                      Icons.restaurant_menu_rounded,
                      color: Colors.blue.shade900,
                      size: 75,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "TODAY'S MEAL PLAN",
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        color: Colors.blue.withOpacity( 0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Total Calories: $totalCals kcal",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 8,
                                left: 8,
                              ),
                              child: Text(
                                "Total Protein: ${totalProt}g",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildMealCard(
                      context,
                      title: "Breakfast",
                      color: Colors.blue.withValues(alpha: 0.2),
                      mealName:
                          currentDay
                              .meals["breakfast"]?[state.breakfastIndex]
                              .name ??
                          "N/A",
                      onSwap: () => context.read<OnboardingBloc>().add(
                        SwapMealEvent(mealType: "breakfast"),
                      ),
                    ),

                    _buildMealCard(
                      context,
                      title: "Lunch",
                      color: Colors.blue.withValues(alpha: .3),
                      mealName:
                          currentDay.meals["lunch"]?[state.lunchIndex].name ??
                          "N/A",
                      onSwap: () => context.read<OnboardingBloc>().add(
                        SwapMealEvent(mealType: "lunch"),
                      ),
                    ),

                    _buildMealCard(
                      context,
                      title: "Dinner",
                      color: Colors.blue.withValues(alpha: 0.4),
                      mealName:
                          currentDay.meals["dinner"]?[state.dinnerIndex].name ??
                          "N/A",
                      onSwap: () => context.read<OnboardingBloc>().add(
                        SwapMealEvent(mealType: "dinner"),
                      ),
                    ),

                    _buildMealCard(
                      context,
                      title: "Snacks",
                      color: Colors.blue.withValues(alpha: 0.5),
                      mealName:
                          currentDay.meals["snack"]?[state.snackIndex].name ??
                          "N/A",
                      onSwap: () => context.read<OnboardingBloc>().add(
                        SwapMealEvent(mealType: "snack"),
                      ),
                    ),

                    const Spacer(),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                WeeklyPlanPage(plan: state.dietPlan!),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                      ),
                      child: const Text(
                        "Show Weekly Plan",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMealCard(
    BuildContext context, {
    required String title,
    required Color color,
    required String mealName,
    required VoidCallback onSwap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    mealName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: onSwap,
                icon: const Icon(Icons.swap_horiz, size: 18),
                label: const Text("Swap"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.8),
                  foregroundColor: Colors.blue.shade900,
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
