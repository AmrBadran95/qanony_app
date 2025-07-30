import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/presentation/screens/subscription_screen.dart';
import 'package:qanony/services/cubits/IsSubscribtion/is_subscription_cubit.dart';

import '../pages/my_appointments_tab.dart';
import '../pages/qanony_appointments_tab.dart';

class AppointmentLawyer extends StatelessWidget {
  const AppointmentLawyer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => SubscriptionCubit()..checkSubscription(),
      child: BlocBuilder<SubscriptionCubit, bool>(
        builder: (context, isSubscribed) {
          final tabController = TabController(
            length: 2,
            vsync: Scaffold.of(context),
          );

          tabController.addListener(() {
            if (tabController.indexIsChanging &&
                tabController.index == 1 &&
                isSubscribed == false) {
              tabController.animateTo(0);

              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    "خدمه مميزه",
                    style: AppText.title.copyWith(color: AppColor.primary),
                  ),
                  content: Text(
                    "استفد من كامل طاقتك كمحامي محترف  اشترك وابدأ في استقبال العملاء مباشرة!",
                    style: AppText.bodyMedium.copyWith(color: AppColor.dark),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "إلغاء",
                        style: AppText.labelLarge.copyWith(
                          color: AppColor.primary,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SubscriptionScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "اشترك الآن",
                        style: AppText.labelLarge.copyWith(
                          color: AppColor.green,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          });

          return DefaultTabController(
            length: 2,
            child: Builder(
              builder: (context) {
                return SizedBox(
                  width: screenWidth,
                  height: screenHeight,
                  child: Column(
                    children: [
                      SizedBox(
                        width: screenWidth * 0.9,
                        child: TabBar(
                          controller: tabController,
                          labelColor: AppColor.dark,
                          unselectedLabelColor: AppColor.grey,
                          indicatorColor: AppColor.secondary,
                          tabs: [
                            Tab(
                              child: Text(
                                "مواعيدى",
                                style: AppText.bodyLarge.copyWith(
                                  color: AppColor.dark,
                                ),
                              ),
                            ),
                            Tab(
                              child: Text(
                                "مواعيد قانونى",
                                style: AppText.bodyLarge.copyWith(
                                  color: isSubscribed
                                      ? AppColor.dark
                                      : AppColor.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Expanded(
                        child: TabBarView(
                          controller: tabController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: const [
                            MyAppointmentsTab(),
                            QanonyAppointmentsTab(),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
