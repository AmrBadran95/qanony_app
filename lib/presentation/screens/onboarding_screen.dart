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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingSkipped) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const ChooseRoleScreen(),
            ),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColor.primary,
        body: Stack(
          children: [
            IntroductionScreen(
              rawPages: onboardingPages,
              scrollPhysics: const ScrollPhysics(),
              allowImplicitScrolling: true,
              infiniteAutoScroll: true,
              autoScrollDuration: 2000,
              controlsMargin: EdgeInsets.all(screenWidth * 0.08),
              dotsDecorator: DotsDecorator(
                size: Size.square(screenWidth * 0.025),
                activeSize: Size(screenWidth * 0.05, screenHeight * 0.012),
                activeColor: AppColor.secondary,
                color: AppColor.grey,
                spacing: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.06),
                ),
              ),
              showDoneButton: false,
              showNextButton: false,
              showSkipButton: false,
            ),
            Positioned(
              top: screenHeight * 0.1,
              left: screenWidth * 0.1,
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
