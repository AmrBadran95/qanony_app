import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/core/styles/color.dart';
import 'package:qanony/core/styles/padding.dart';
import 'package:qanony/presentation/screens/successful_process_screen.dart';

import '../../Core/widgets/subscription_card.dart';
import '../../services/cubits/checkout/checkout_cubit.dart';
import '../../services/stripe/api_service.dart';
import '../../services/stripe/stripe_service.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? '';


    return BlocProvider(
      create: (_) => CheckoutCubit(ApiService(), StripeService()),
      child: BlocListener<CheckoutCubit, CheckoutState>(
        listener: (context, state) {
          if (state is CheckoutSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SuccessfulProcessScreen(),
              ),
            );

          } else if (state is CheckoutFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("فشل الدفع: ${state.error}")),
            );
          }
        },
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: AppColor.grey,
            statusBarIconBrightness: Brightness.dark,
          ),
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
                  color: Colors.black.withOpacity(.5),
                ),

                Column(
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
                                  color: AppColor.primary),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.star_rounded,
                              color: AppColor.primary,
                              size: MediaQuery
                                  .of(context)
                                  .size
                                  .width * .1,
                            ),
                          ],
                        ),
                        SizedBox(height: MediaQuery
                            .of(context)
                            .size
                            .width * .05),
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
                        onTap: () {

                        },
                        label: "الباقه الاولى",
                        labelColor: AppColor.secondary,
                        icon: Icons.monetization_on_outlined,
                        priceText: "مجانية",
                        title: "باقه مجانيه",
                        option1: "3 استشارات مجانية من العمولة",
                        text1: "أول 3 استشارات  بدون خصم رسوم من التطبيق",
                        option2: "تنظيم المواعيد بسهولة",
                        text2: "أول 3 استشارات  بدون خصم رسوم من التطبيق",
                        option3: "تعديل وحذف المواعيد",
                        text3: "تقدر تعدل أو تحذف أي موعد من جدولك .",
                      ),
                    ),

                    Padding(
                      padding: AppPadding.paddingMedium,
                      child: Builder(
                        builder: (context) =>
                            SubscriptionCard(
                              onTap: () {
                                context.read<CheckoutCubit>().startCheckout(
                                  100,
                                  email,
                                  "باقه المحترف",
                                );
                              },
                              label: "الأكثر انتشارا",
                              labelColor: AppColor.primary,
                              icon: Icons.percent_rounded,
                              priceText: "20 %",
                              title: "باقه المحترف ",
                              option1: "عمولة التطبيق 20% لكل استشارة",
                              text1: "التطبيق يحصل على نسبة 20% من كل استشارة ",
                              option2: "تنظيم المواعيد بسهولة",
                              text2: "أول 3 استشارات  بدون خصم رسوم من التطبيق",
                              option3: "تعديل وحذف المواعيد",
                              text3: "تقدر تعدل أو تحذف أي موعد من جدولك .",
                            ),
                      ),
                    ),

                    Padding(
                      padding: AppPadding.paddingMedium,
                      child: Builder(
                        builder: (context) =>
                            SubscriptionCard(
                              onTap: () {
                                context.read<CheckoutCubit>().startCheckout(
                                  600,
                                  email,
                                  "اشتراك شهري",
                                );
                              },
                              label: "الباقه الشهريه",
                              labelColor: AppColor.dark,
                              icon: Icons.attach_money_outlined,
                              priceText: "600 شهرياً",
                              title: "باقه شهريه ",
                              option1: "3 استشارات مجانية من العمولة",
                              text1: "أول 3 استشارات  بدون خصم رسوم من التطبيق",
                              option2: "تنظيم المواعيد بسهولة",
                              text2: "أول 3 استشارات  بدون خصم رسوم من التطبيق",
                              option3: "تعديل وحذف المواعيد",
                              text3: "تقدر تعدل أو تحذف أي موعد من جدولك .",
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}