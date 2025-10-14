import "package:flutter/material.dart";
import "package:rainly/features/onboarding/presentation/widgets/add_gauge_step.dart";
import "package:rainly/features/onboarding/presentation/widgets/permissions_step.dart";
import "package:rainly/features/onboarding/presentation/widgets/step_indicator.dart";
import "package:rainly/features/onboarding/presentation/widgets/welcome_step.dart";

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.page?.round() != _currentPage) {
        setState(() {
          _currentPage = _pageController.page!.round();
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(final BuildContext context) {
    final List<Widget> pages = [
      WelcomeStep(onNext: _nextPage),
      AddGaugeStep(onNext: _nextPage, onSkip: _nextPage),
      const PermissionsStep(),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: pages,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: StepIndicator(
                stepCount: pages.length,
                currentStep: _currentPage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
