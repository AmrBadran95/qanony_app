import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/core/widgets/onboarding_screen.dart';
import 'package:qanony/presentation/screens/choose_role_screen.dart';
import '../../Core/styles/color.dart';
import '../../Core/widgets/Indicator.dart';
import '../../services/cubits/onboarding/onboarding_cubit.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();

    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: AppColor.primary,
          statusBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          body: SafeArea(
            child: BlocBuilder<OnboardingCubit, OnboardingState>(
              builder: (context, state) {
                if (state is OnboardingSkipped) {
                  Future.microtask(() {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChooseRoleScreen(),
                      ),
                    );
                  });
                  //
                  return const SizedBox();
                }
                int index = 0;
                if (state is OnboardingInitial) {
                  index = state.pageIndex;
                }
                final cubit = context.read<OnboardingCubit>();
                final nextIndex = (index + 1) % 3;

                return Container(
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
                                await cubit.completeOnboarding();
                                if (context.mounted) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const ChooseRoleScreen(),
                                    ),
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
                      Expanded(
                        child: Padding(
                          padding: AppPadding.paddingLarge,
                          child: Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
                                child: PageView(
                                  controller: controller,
                                  onPageChanged: (i) {
                                    cubit.changePage(i);
                                  },
                                  children: const [
                                    OnboardingPage(
                                      text: 'أهلاً بك في دستورى',
                                      imagePath: 'assets/images/p1.png',
                                      paragraph:
                                          "منصتك القانونية الذكية. سواء كنت محامٍ أو باحث عن استشارة، كل الحلول القانونية بين إيديك",
                                    ),
                                    OnboardingPage(
                                      text: 'خدمات قانونية في متناولك',
                                      imagePath: 'assets/images/lawyer 1.png',
                                      paragraph:
                                          "اختَر محامي متخصص، اطلب خدمة، وتابع كل خطواتك من مكانك.",
                                    ),
                                    OnboardingPage(
                                      text: 'أمان وتنظيم في كل خطوة',
                                      imagePath: 'assets/images/court 1.png',
                                      paragraph:
                                          "احفظ مستنداتك، راجع معاملتك، وتواصل مع محاميك بثقة كاملة..",
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  3,
                                  (i) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
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
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      controller.animateToPage(
                                        nextIndex,
                                        duration: const Duration(
                                          milliseconds: 600,
                                        ),
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
