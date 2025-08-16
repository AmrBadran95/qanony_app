import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/presentation/screens/subscription_screen.dart';
import 'package:qanony/services/cubits/is_subscription/is_subscription_cubit.dart';
import '../pages/my_appointments_tab.dart';
import '../pages/qanony_appointments_tab.dart';

class AppointmentLawyer extends StatelessWidget {
  const AppointmentLawyer({super.key});

  @override
  Widget build(BuildContext context) {
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
                          color: AppColor.error,
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
                return Column(
                  children: [
                    TabBar(
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
                          child: isSubscribed
                              ? Text(
                                  "مواعيد قانونى",
                                  style: AppText.bodyLarge.copyWith(
                                    color: AppColor.dark,
                                  ),
                                )
                              : Text(
                                  "مواعيد قانونى",
                                  style: AppText.bodyLarge.copyWith(
                                    color: AppColor.grey,
                                  ),
                                ),
                        ),
                      ],
                    ),
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
                );
              },
            ),
          );
        },
      ),
    );
  }
}
