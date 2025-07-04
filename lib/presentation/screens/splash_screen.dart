import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/core/styles/padding.dart';
import 'package:qanony/core/styles/text.dart';
import 'package:qanony/presentation/screens/choose_role_screen.dart';
import 'package:qanony/presentation/screens/onboarding_screen.dart';
import 'package:qanony/services/cubits/onboarding/onboarding_cubit.dart';
import 'package:qanony/services/cubits/splash/splash_cubit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<SplashCubit>().initializeApp();
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashFirstLaunch) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => BlocProvider(
                create: (context) => OnboardingCubit(),
                child: const OnboardingScreen(),
              ),
            ),
          );
        } else if (state is SplashChooseRole) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const ChooseRoleScreen(),
            ),
          );
        } else if (state is SplashLoggedInUser) {
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (BuildContext context) => const ChooseRoleScreen(),
          //   ),
          // ); Navigate to User homepage
        } else if (state is SplashLoggedInLawyer) {
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (BuildContext context) => const ChooseRoleScreen(),
          //   ),
          // ); Navigate to Lawyer homepage
        } else if (state is SplashError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: AppColor.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "حدث خطأ ما. برجاء إعادة المحاولة",
                      style: AppText.bodySmall.copyWith(
                        color: AppColor.primary,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: AppColor.grey,
              behavior: SnackBarBehavior.floating,
              margin: AppPadding.paddingMedium,
              padding: AppPadding.paddingMedium,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 6,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: AppPadding.paddingExtraLarge,
          decoration: BoxDecoration(color: AppColor.primary),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/Logo.png",
                fit: BoxFit.fill,
                height: MediaQuery.of(context).size.height * .4,
              ),
              Text(
                "قانوني",
                style: AppText.appHeading.copyWith(color: AppColor.light),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * .05),
              Text(
                "للمحـاماة و الأستشارات القانونية ",
                style: AppText.title.copyWith(color: AppColor.secondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
