import "package:flutter/material.dart";

class StepIndicator extends StatelessWidget {
  const StepIndicator({
    required this.stepCount,
    required this.currentStep,
    super.key,
  });

  final int stepCount;
  final int currentStep;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        stepCount,
        (final index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: index == currentStep ? 24 : 8,
          decoration: BoxDecoration(
            color: index == currentStep
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
