import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                    style: AppText.bodyMedium.copyWith(color: AppColor.primary),
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
                      style: AppText.bodyMedium.copyWith(color: AppColor.green),
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
                        style: AppText.bodyMedium.copyWith(
                          color: AppColor.primary,
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
                        style: AppText.bodyMedium.copyWith(
                          color: AppColor.primary,
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
                color: Colors.black54,
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 48),
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
                              style: AppText.headingLarge.copyWith(
                                color: AppColor.primary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.star_rounded,
                              color: AppColor.primary,
                              size: MediaQuery.of(context).size.width * 0.1,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.05,
                        ),
                        Text(
                          "اختر نظام الاشتراك المناسب لك",
                          style: AppText.bodyMedium.copyWith(
                            color: AppColor.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: AppPadding.paddingMedium,
                      child: SubscriptionCard(
                        onTap: () async {
                          if (user == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'يجب تسجيل الدخول أولاً',
                                  style: AppText.bodyMedium.copyWith(
                                    color: AppColor.primary,
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
                        label: "الباقه الاولى",
                        labelColor: AppColor.secondary,
                        icon: Icons.monetization_on_outlined,
                        priceText: "مجانية",
                        title: "باقه مجانيه",
                        option1: "3 استشارات مجانية من العمولة",
                        text1: "أول 3 استشارات بدون خصم رسوم من التطبيق",
                        option2: "تنظيم المواعيد بسهولة",
                        text2: "سهولة تنظيم المواعيد الخاصة بك",
                        option3: "تعديل وحذف المواعيد",
                        text3: "تقدر تعدل أو تحذف أي موعد من جدولك.",
                      ),
                    ),
                    Padding(
                      padding: AppPadding.paddingMedium,
                      child: SubscriptionCard(
                        onTap: () async {
                          if (user == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'يجب تسجيل الدخول أولاً',
                                  style: AppText.bodyMedium.copyWith(
                                    color: AppColor.primary,
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
                        title: "باقه المحترف",
                        option1: "عمولة التطبيق 20% لكل استشارة",
                        text1: "التطبيق يحصل على نسبة 20% من كل استشارة",
                        option2: "تنظيم المواعيد بسهولة",
                        text2: "سهولة تنظيم المواعيد الخاصة بك",
                        option3: "تعديل وحذف المواعيد",
                        text3: "تقدر تعدل أو تحذف أي موعد من جدولك.",
                      ),
                    ),
                    Padding(
                      padding: AppPadding.paddingMedium,
                      child: SubscriptionCard(
                        onTap: () async {
                          if (user == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'يجب تسجيل الدخول أولاً',
                                  style: AppText.bodyMedium.copyWith(
                                    color: AppColor.primary,
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
                        priceText: "600 شهرياً",
                        title: "باقه شهريه",
                        option1: "3 استشارات مجانية من العمولة",
                        text1: "أول 3 استشارات بدون خصم رسوم من التطبيق",
                        option2: "تنظيم المواعيد بسهولة",
                        text2: "سهولة تنظيم المواعيد الخاصة بك",
                        option3: "تعديل وحذف المواعيد",
                        text3: "تقدر تعدل أو تحذف أي موعد من جدولك.",
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
