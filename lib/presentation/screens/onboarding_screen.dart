import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/core/styles/color.dart';
import 'package:qanony/data/static/onboarding_pages.dart';
import 'package:qanony/presentation/screens/choose_role_screen.dart';
import 'package:qanony/services/cubits/onboarding/onboarding_cubit.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingSkipped) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const ChooseRoleScreen(),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColor.primary,
        body: Stack(
          children: [
            IntroductionScreen(
              rawPages: onboardingPages,
              scrollPhysics: ScrollPhysics(),
              allowImplicitScrolling: true,
              infiniteAutoScroll: true,
              autoScrollDuration: 2000,
              controlsMargin: EdgeInsets.all(48),
              dotsDecorator: DotsDecorator(
                size: const Size.square(10.0),
                activeSize: const Size(20.0, 10.0),
                activeColor: AppColor.secondary,
                color: AppColor.grey,
                spacing: const EdgeInsets.symmetric(horizontal: 4),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              showDoneButton: false,
              showNextButton: false,
              showSkipButton: false,
            ),
            Positioned(
              top: 80,
              left: 40,
              child: GestureDetector(
                onTap: () {
                  context.read<OnboardingCubit>().completeOnboarding();
                },
                child: Text(
                  "تخطى",
                  style: AppText.bodyMedium.copyWith(color: AppColor.secondary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
