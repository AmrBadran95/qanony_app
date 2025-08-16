import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/Core/widgets/custom_button.dart';
import 'package:qanony/presentation/screens/choose_role_screen.dart';
import 'package:qanony/services/cubits/lawyer_rejection/lawyer_rejection_cubit.dart';

class WaitingPageFailed extends StatelessWidget {
  const WaitingPageFailed({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return BlocProvider(
      create: (_) {
        final cubit = LawyerRejectionCubit();
        final uid = FirebaseAuth.instance.currentUser?.uid;
        cubit.fetchRejectionReason(uid);
        return cubit;
      },
      child: Scaffold(
        backgroundColor: AppColor.grey,
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.08,
              vertical: height * 0.04,
            ),
            child: BlocConsumer<LawyerRejectionCubit, LawyerRejectionState>(
              listener: (context, state) {
                if (state is LawyerRejectionDeleted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => ChooseRoleScreen()),
                    (route) => false,
                  );
                }
              },
              builder: (context, state) {
                if (state is LawyerRejectionLoading) {
                  return const CircularProgressIndicator();
                }

                if (state is LawyerRejectionError) {
                  return Center(
                    child: Text(
                      'حدث خطأ أثناء جلب البيانات',
                      style: AppText.bodyLarge.copyWith(color: AppColor.error),
                    ),
                  );
                }

                final reasons = state is LawyerRejectionLoaded
                    ? state.reasons
                    : [];

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.04),
                      Center(
                        child: Text(
                          'عملية غير ناجحة!',
                          style: AppText.headingMedium.copyWith(
                            color: AppColor.error,
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.03),
                      Text(
                        'تم رفض طلبك! برجاء التأكد من صحة البيانات والمحاولة مرة أخرى.',
                        style: AppText.bodyLarge.copyWith(
                          color: AppColor.dark,
                          fontSize: width * 0.045,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: height * 0.03),
                      if (reasons.isNotEmpty) ...[
                        Center(
                          child: Text(
                            'الأسباب:',
                            style: AppText.title.copyWith(
                              color: AppColor.primary,
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.015),
                        ...reasons.map(
                          (reason) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "- $reason.",
                                style: AppText.bodyLarge.copyWith(
                                  color: AppColor.dark,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                      ],
                      CustomButton(
                        text: 'العودة إلى تسجيل الدخول',
                        onTap: () async {
                          final uid = FirebaseAuth.instance.currentUser?.uid;
                          if (uid != null) {
                            await context
                                .read<LawyerRejectionCubit>()
                                .deleteLawyerData(uid);
                          }
                        },
                        width: double.infinity,
                        height: 60.h,
                        backgroundColor: AppColor.error,
                        textStyle: AppText.bodyMedium.copyWith(
                          color: AppColor.light,
                          fontSize: width * 0.045,
                        ),
                      ),
                      SizedBox(height: height * 0.05),
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
