import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/core/styles/color.dart';
import 'package:qanony/core/styles/text.dart';
import 'package:qanony/core/widgets/custom_button.dart';
import 'package:qanony/services/cubits/connect/connect_cubit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LawyerConnect extends StatelessWidget {
  final String lawyerId;
  final String email;

  const LawyerConnect({super.key, required this.lawyerId, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.sp),
        child: AppBar(
          backgroundColor: AppColor.primary,
          title: Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.01,
              right: MediaQuery.of(context).size.width * 0.01,
              bottom: MediaQuery.of(context).size.height * 0.01,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "الحساب البنكي",
                  style: AppText.headingMedium.copyWith(color: AppColor.light),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: BlocListener<ConnectCubit, ConnectState>(
          listener: (context, state) async {
            if (state is ConnectUrlLoaded) {
              final url = Uri.parse(state.url);

              try {
                final canLaunch = await canLaunchUrl(url);

                if (canLaunch) {
                  final launched = await launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  );

                  if (!launched) {
                    await launchUrlString(state.url);
                  }
                } else {
                  await launchUrlString(state.url);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'تعذر فتح الرابط',
                        style: AppText.bodySmall.copyWith(
                          color: AppColor.primary,
                        ),
                      ),
                      backgroundColor: AppColor.grey,
                    ),
                  );
                }
              }
            }
          },
          child: Padding(
            padding: AppPadding.paddingLarge,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "شكراً لإنضمامك إلى عائلة قانوني",
                    style: AppText.title.copyWith(color: AppColor.primary),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "سيتعين عليك تسجيل بيانات حسابك البنكي عبر منصة Stripe حتى تتمكن من الحصول على مستحقاتك المالية من عملائك",
                  style: AppText.bodyMedium.copyWith(color: AppColor.dark),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: CustomButton(
                      text: "اربط حسابك البنكي",
                      onTap: () {
                        context.read<ConnectCubit>().startOnboarding(
                          lawyerId: lawyerId,
                          email: email,
                        );
                      },
                      width: double.infinity,
                      height: 50.sp,
                      backgroundColor: AppColor.secondary,
                      textStyle: AppText.bodyMedium.copyWith(
                        color: AppColor.dark,
                      ),
                      textColor: AppColor.dark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
