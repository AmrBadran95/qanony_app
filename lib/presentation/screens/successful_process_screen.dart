import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/Core/widgets/custom_button.dart';
import 'package:qanony/presentation/pages/lawyer_base_screen.dart';
import 'package:qanony/presentation/screens/lawyer_account.dart';
import 'package:qanony/services/helpers/pdf_generator.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/repos/lawyer_repository.dart';
import '../../services/cubits/lawyer/lawyer_cubit.dart';

class SuccessfulProcessScreen extends StatelessWidget {
  const SuccessfulProcessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text("لم يتم العثور على المستخدم، يرجى تسجيل الدخول."),
        ),
      );
    }

    return BlocProvider(
      create: (_) => LawyerCubit(LawyerRepository())..getLawyer(user.uid),
      child: Scaffold(
        backgroundColor: AppColor.grey,
        appBar: AppBar(
          backgroundColor: AppColor.primary,
          elevation: 0,
          title: Text(
            'عملية ناجحـة',
            style: AppText.headingLarge.copyWith(color: AppColor.light),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<LawyerCubit, LawyerState>(
          builder: (context, state) {
            if (state is LawyerLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LawyerLoaded) {
              final lawyer = state.lawyer;

              return Padding(
                padding: AppPadding.paddingMedium,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: AppPadding.paddingMedium,
                      decoration: BoxDecoration(
                        color: AppColor.light,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 80.sp,
                                color: AppColor.green,
                              ),
                              SizedBox(height: size.height * 0.015),
                              Text(
                                'تم الاشتراك بنجاح',
                                style: AppText.headingLarge.copyWith(
                                  color: AppColor.green,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),

                          SizedBox(height: size.height * 0.02),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'تفاصيل الاشتراك:',
                                style: AppText.title.copyWith(
                                  color: AppColor.dark,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: size.height * 0.02),
                              Text(
                                ' الباقه الحاليه: ${lawyer.subscriptionType == "free"
                                    ? "الباقة المجانية"
                                    : lawyer.subscriptionType == "fixed"
                                    ? "الباقة الشهرية"
                                    : "الأكثر إنتشاراً"}',
                                style: AppText.bodyMedium.copyWith(
                                  color: AppColor.dark,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: size.height * 0.02),
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      'تاريخ الاشتراك: ${DateFormat('EEEE، yyyy/MM/dd', 'ar').format(lawyer.subscriptionStart!)}',
                                      style: AppText.bodyMedium.copyWith(
                                        color: AppColor.dark,
                                      ),
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.visible,
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: size.height * 0.02),
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      'تاريخ الاشتراك: ${DateFormat('EEEE، yyyy/MM/dd', 'ar').format(lawyer.subscriptionEnd!)}',
                                      style: AppText.bodyMedium.copyWith(
                                        color: AppColor.dark,
                                      ),
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.visible,
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: size.height * 0.02),

                              Text(
                                'وسيلة الدفع: تحويل بنكي',
                                style: AppText.bodyMedium.copyWith(
                                  color: AppColor.dark,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),

                          SizedBox(height: size.height * 0.1),

                          CustomButton(
                            text: 'مشاركة',
                            onTap: () async {
                              try {
                                final pdfPath = await generateSubscriptionPdf(
                                  subscriptionType:
                                      lawyer.subscriptionType == "free"
                                      ? "الباقة المجانية"
                                      : lawyer.subscriptionType == "fixed"
                                      ? "الأكثر إنتشاراً"
                                      : "الباقة الشهرية",
                                  subscriptionStart:
                                      lawyer.subscriptionStart ??
                                      DateTime.now(),
                                  subscriptionEnd:
                                      lawyer.subscriptionEnd ?? DateTime.now(),
                                  paymentMethod: "تحويل بنكي",
                                );

                                final params = ShareParams(
                                  files: [XFile(pdfPath)],
                                  text: 'تفاصيل الاشتراك',
                                );

                                final result = await SharePlus.instance.share(
                                  params,
                                );

                                if (result.status ==
                                    ShareResultStatus.dismissed) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'تم إلغاء المشاركة',
                                          style: AppText.bodyMedium.copyWith(
                                            color: AppColor.primary,
                                          ),
                                        ),
                                        backgroundColor: AppColor.grey,
                                      ),
                                    );
                                  }
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'حدث خطأ أثناء المشاركة: $e',
                                        style: AppText.bodyMedium.copyWith(
                                          color: AppColor.primary,
                                        ),
                                      ),
                                      backgroundColor: AppColor.grey,
                                    ),
                                  );
                                }
                              }
                            },

                            width: double.infinity,
                            height: 50.h,
                            backgroundColor: AppColor.primary,
                            textStyle: AppText.title,
                            textColor: AppColor.light,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: size.height * 0.03),
                    CustomButton(
                      text: 'العودة للصفحة الرئيسية',
                      onTap: () async {
                        await Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LawyerBaseScreen(
                              body: AccountLawyerScreen(),
                              selectedIndex: 0,
                            ),
                          ),
                          (route) => false,
                        );
                      },
                      width: double.infinity,
                      height: 50.h,
                      backgroundColor: AppColor.secondary,
                      textStyle: AppText.title,
                      textColor: AppColor.dark,
                    ),
                  ],
                ),
              );
            } else if (state is LawyerError) {
              return Center(child: Text("حدث خطأ: ${state.message}"));
            } else {
              return const Center(child: Text("فشل في تحميل البيانات"));
            }
          },
        ),
      ),
    );
  }
}
