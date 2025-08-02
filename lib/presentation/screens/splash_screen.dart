import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/core/styles/padding.dart';
import 'package:qanony/core/styles/text.dart';
import 'package:qanony/presentation/pages/lawyer_base_screen.dart';
import 'package:qanony/presentation/screens/choose_role_screen.dart';
import 'package:qanony/presentation/screens/lawyer_account.dart';
import 'package:qanony/presentation/screens/onboarding_screen.dart';
import 'package:qanony/presentation/screens/sign_in.dart';
import 'package:qanony/presentation/screens/user_home_screen.dart';
import 'package:qanony/presentation/screens/waiting_page.dart';
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
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => OnboardingCubit(),
                child: const OnboardingScreen(),
              ),
            ),
            (route) => false,
          );
        } else if (state is SplashChooseRole) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const ChooseRoleScreen()),
            (route) => false,
          );
        } else if (state is SplashLoggedInUser) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const UserHomeScreen()),
            (route) => false,
          );
        } else if (state is SplashLoggedInLawyerPending) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const WaitingPage()),
            (route) => false,
          );
        } else if (state is SplashLoggedInLawyerAccepted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => LawyerBaseScreen(
                body: AccountLawyerScreen(),
                selectedIndex: 0,
              ),
            ),
            (route) => false,
          );
        } else if (state is SplashLoggedInLawyerRejected) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const SignInScreen()),
            (route) => false,
          );
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
          width: double.infinity,
          height: double.infinity,
          padding: AppPadding.paddingExtraLarge,
          decoration: BoxDecoration(color: AppColor.primary),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/icons/Logo.png",
                fit: BoxFit.fill,
                height: MediaQuery.of(context).size.height * .4,
              ),
              Text(
                "قانوني",
                style: AppText.title.copyWith(color: AppColor.light),
              ),
              SizedBox(height: 20.h),
              Text(
                "للمحـاماة و الأستشارات القانونية ",
                style: AppText.bodySmall.copyWith(color: AppColor.secondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
