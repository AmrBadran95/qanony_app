import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:qanony/core/styles/text.dart';
import 'package:qanony/core/styles/color.dart';
import 'package:qanony/core/styles/padding.dart';
import 'package:qanony/core/widgets/subscription_card.dart';
import 'package:qanony/presentation/screens/successful_process_screen.dart';
import 'package:qanony/services/cubits/subscription/stripe_subscription_cubit.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: BlocListener<StripeSubscriptionCubit, StripeSubscriptionState>(
        listener: (context, state) async {
          if (state is StripeSubscriptionSuccess) {
            final clientSecret = state.clientSecret;

            if (clientSecret.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "حدث خطأ: clientSecret غير متوفر",
                    style: AppText.bodySmall.copyWith(color: AppColor.error),
                  ),
                  backgroundColor: AppColor.grey,
                ),
              );
              return;
            }

            try {
              await Stripe.instance.initPaymentSheet(
                paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: clientSecret,
                  merchantDisplayName: "Qanony",
                  style: ThemeMode.light,
                ),
              );

              await Stripe.instance.presentPaymentSheet();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'تم الاشتراك بنجاح',
                      style: AppText.bodySmall.copyWith(color: AppColor.green),
                    ),
                    backgroundColor: AppColor.grey,
                  ),
                );
              }
              if (context.mounted) {
                await Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const SuccessfulProcessScreen(),
                  ),
                  (route) => false,
                );
              }
            } catch (e) {
              if (e is StripeException) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'خطأ في Stripe: ${e.error.localizedMessage}',
                        style: AppText.bodySmall.copyWith(
                          color: AppColor.error,
                        ),
                      ),
                      backgroundColor: AppColor.grey,
                    ),
                  );
                }
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'حدث خطأ أثناء الدفع',
                        style: AppText.bodySmall.copyWith(
                          color: AppColor.error,
                        ),
                      ),
                      backgroundColor: AppColor.grey,
                    ),
                  );
                }
              }
            }
          }
        },

        child: Scaffold(
          body: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/background.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: double.infinity,
                color: AppColor.dark.withAlpha((0.8 * 255).round()),
              ),
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 48.sp),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Go Pro",
                              style: AppText.headingMedium.copyWith(
                                color: AppColor.secondary,
                              ),
                            ),
                            SizedBox(width: 8.sp),
                            Icon(
                              Icons.star_rounded,
                              color: AppColor.secondary,
                              size: MediaQuery.of(context).size.width * 0.1,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.05,
                        ),
                        Text(
                          "اختر نظام الاشتراك المناسب لك",
                          style: AppText.title.copyWith(
                            color: AppColor.secondary,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: AppPadding.paddingSmall,
                      child: SubscriptionCard(
                        onTap: () async {
                          if (user == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'يجب تسجيل الدخول أولاً',
                                  style: AppText.bodySmall.copyWith(
                                    color: AppColor.error,
                                  ),
                                ),
                                backgroundColor: AppColor.grey,
                              ),
                            );
                            return;
                          }
                          await context
                              .read<StripeSubscriptionCubit>()
                              .subscribe(
                                lawyerId: user.uid,
                                email: user.email ?? '',
                                subscriptionType: 'free',
                              );
                          if (context.mounted) {
                            await Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const SuccessfulProcessScreen(),
                              ),
                              (route) => false,
                            );
                          }
                        },
                        label: "الباقة المجانية",
                        labelColor: AppColor.secondary,
                        icon: Icons.monetization_on_outlined,
                        priceText: "مجانية",
                        title: "لإدارة المهام فقط",
                        option1: "تنظيم مواعيدك اليومية بسهولة.",
                        option2: "تابع مهامك وجدولك بدون أي تكلفة.",
                        option3: "تعديل وحذف المواعيد.",
                      ),
                    ),
                    Padding(
                      padding: AppPadding.paddingSmall,
                      child: SubscriptionCard(
                        onTap: () async {
                          if (user == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'يجب تسجيل الدخول أولاً',
                                  style: AppText.bodySmall.copyWith(
                                    color: AppColor.error,
                                  ),
                                ),
                                backgroundColor: AppColor.grey,
                              ),
                            );
                            return;
                          }
                          await context
                              .read<StripeSubscriptionCubit>()
                              .subscribe(
                                lawyerId: user.uid,
                                email: user.email ?? '',
                                subscriptionType: 'percentage',
                              );
                          if (context.mounted) {
                            await Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const SuccessfulProcessScreen(),
                              ),
                              (route) => false,
                            );
                          }
                        },
                        label: "الأكثر انتشارا",
                        labelColor: AppColor.primary,
                        icon: Icons.percent_rounded,
                        priceText: "20 %",
                        title: "تشتغل وتدفع على قد استخدامك",
                        option1: "تواصل مباشر مع العملاء.",
                        option2: "استلام إشعارات فورية بالحجوزات.",
                        option3: "20% عمولة على كل استشارة.",
                      ),
                    ),
                    Padding(
                      padding: AppPadding.paddingSmall,
                      child: SubscriptionCard(
                        onTap: () async {
                          if (user == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'يجب تسجيل الدخول أولاً',
                                  style: AppText.bodySmall.copyWith(
                                    color: AppColor.error,
                                  ),
                                ),
                                backgroundColor: AppColor.grey,
                              ),
                            );
                            return;
                          }
                          await context
                              .read<StripeSubscriptionCubit>()
                              .subscribe(
                                lawyerId: user.uid,
                                email: user.email ?? '',
                                subscriptionType: 'fixed',
                              );
                        },
                        label: "الباقه الشهريه",
                        labelColor: AppColor.dark,
                        icon: Icons.attach_money_outlined,
                        priceText: "5000 شهرياً",
                        title: "احترافية كاملة برسوم ثابتة",
                        option1: "تواصل مباشر مع العملاء.",
                        option2: "إشعارات لحظية بكل جديد.",
                        option3: "تنظيم كامل للمهام والمواعيد.",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
