import 'package:flutter/material.dart';
import '../../Core/shared/logincash.dart';
import '../../presentation/pages/ChooseRoleScreen.dart';
import '../../presentation/pages/onboarding.dart';

class Decider extends StatelessWidget {
  const Decider({super.key});

  @override
  Widget build(BuildContext context) {
    final onboardingDonee = SharedHelper.getOnboardingDone();
    print(' onboarding = $onboardingDonee');

    return onboardingDonee
        ? const ChooseRoleScreen()
        : const onboarding();
  }
}
