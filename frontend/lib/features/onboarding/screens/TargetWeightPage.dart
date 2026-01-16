import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/onboardingBloc.dart';

import '../bloc/onboardingEvent.dart';

class TargetWeightPage extends StatelessWidget {
  const TargetWeightPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingBloc>().state;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            const Text(
              "Goal Weight",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            LinearProgressIndicator(
              value: 3 / 7,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              minHeight: 10,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 40),

            TextField(
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              autofocus: true,
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: "0.0",
                suffixText: "kg",
                border: UnderlineInputBorder(),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
              onChanged: (val) {
                final target = double.tryParse(val) ?? 0;
                context.read<OnboardingBloc>().add(
                  UpdateTargetWtEvent(selectedTargetwt: target),
                );
              },
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                ),
                onPressed: state.target_weight > 0
                    ? () => context.read<OnboardingBloc>().add(NextStepEvent())
                    : null,
                child: const Text("Next", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
