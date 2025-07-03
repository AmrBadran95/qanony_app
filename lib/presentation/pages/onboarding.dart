import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/styles/text.dart';
import '../../Core/shared/logincash.dart';
import '../../Core/styles/color.dart';
import '../../Core/widgets/Indicator.dart';

import '../../Core/widgets/onboardingScreen.dart';
import '../../services/cubits/onboarding/onboarding_cubit.dart';
import 'ChooseRoleScreen.dart';


class onboarding extends StatelessWidget {
  const onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();

    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child:
      AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: AppColor.primary,
          statusBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          body: SafeArea(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: AppColor.primary,
              child: Column(
                children: [
                  Padding(
                    padding: AppPadding.paddingLarge,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                        onTap: () async {
                        await SharedHelper.saveOnboardingDone(true);
                        if (context.mounted) {
                        Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const ChooseRoleScreen()),
                        );
                        }
                        },


                         child: Text(
                            "تخطى",
                            style: AppText.bodyMedium.copyWith(
                              color: AppColor.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Padding(
                      padding: AppPadding.paddingLarge,
                      child: BlocBuilder<OnboardingCubit, OnboardingState>(
                        builder: (context, state) {
                          final index =
                              (state as OnboardingInitial).pageIndex;
                          return PageView(
                            controller: controller,
                            onPageChanged: (i) {
                              context.read<OnboardingCubit>().changePage(i);
                            },
                            children:  [

                              onboardingPage(
                                context: context,
                                text: 'أهلاً بك في دستورى',
                                imagepath: 'assets/images/p1.png',
                                paragraph:
                                "منصتك القانونية الذكية. سواء كنت محامٍ أو باحث عن استشارة، كل الحلول القانونية بين إيديك",
                              ),
                              onboardingPage(
                                context: context,
                                text: 'خدمات قانونية في متناولك',
                                imagepath: 'assets/images/lawyer 1.png',
                                paragraph:
                                "اختَر محامي متخصص، اطلب خدمة، وتابع كل خطواتك من مكانك.",
                              ),
                              onboardingPage(
                                context: context,
                                text: 'أمان وتنظيم في كل خطوة',
                                imagepath: 'assets/images/court 1.png',
                                paragraph:
                                "احفظ مستنداتك، راجع معاملتك، وتواصل مع محاميك بثقة كاملة..",
                              ),


                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  BlocBuilder<OnboardingCubit, OnboardingState>(
                    builder: (context, state) {
                      final index = (state as OnboardingInitial).pageIndex;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                              (i) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Indicator(
                              active: index == i,
                              width: index == i ? 40 : 30,
                              activeColor: AppColor.secondary,
                              inactiveColor: AppColor.grey,
                              radius: 100,
                              height: 10,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: AppPadding.paddingLarge,
                    child: BlocBuilder<OnboardingCubit, OnboardingState>(
                      builder: (context, state) {
                        final index = (state as OnboardingInitial).pageIndex;
                        final cubit = context.read<OnboardingCubit>();
                        final nextIndex = (index + 1) % 3;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                controller.animateToPage(
                                  nextIndex,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                                cubit.changePage(nextIndex);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: AppPadding.paddingSmall,
                                backgroundColor: AppColor.secondary,
                              ),
                              child: const Icon(
                                Icons.arrow_forward_outlined,
                                color: AppColor.light,
                                size: 30,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),




                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
