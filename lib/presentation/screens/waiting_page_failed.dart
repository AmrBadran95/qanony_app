import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/padding.dart';
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
              horizontal: width * 0.06,
              vertical: height * 0.03,
            ),
            child: BlocConsumer<LawyerRejectionCubit, LawyerRejectionState>(
              listener: (context, state) {
                if (state is LawyerRejectionDeleted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const ChooseRoleScreen()),
                    (route) => false,
                  );
                }
              },
              builder: (context, state) {
                if (state is LawyerRejectionLoading) {
                  return const CircularProgressIndicator();
                }

                if (state is LawyerRejectionError) {
                  return Text(
                    'حدث خطأ أثناء جلب البيانات',
                    style: AppText.bodyLarge.copyWith(
                      color: AppColor.dark,
                      fontSize: width * 0.045,
                    ),
                    textAlign: TextAlign.center,
                  );
                }

                final reasons = state is LawyerRejectionLoaded
                    ? state.reasons
                    : [];

                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: height * 0.04),
                      Text(
                        'عملية غير ناجحة!',
                        style: AppText.headingMedium.copyWith(
                          color: AppColor.primary,
                          fontSize: width * 0.06,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: height * 0.025),
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
                        Text(
                          'الأسباب:',
                          style: AppText.bodyLarge.copyWith(
                            color: AppColor.primary,
                            fontSize: width * 0.045,
                          ),
                        ),
                        SizedBox(height: height * 0.015),
                        ...reasons.map(
                          (reason) => Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: height * 0.007,
                            ),
                            child: Text(
                              '• $reason',
                              style: AppText.bodyLarge.copyWith(
                                color: AppColor.dark,
                                fontSize: width * 0.043,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.025),
                      ],
                      CustomButton(
                        text: 'العودة إلى تسجيل الدخول',
                        onTap: () {
                          final uid = FirebaseAuth.instance.currentUser?.uid;
                          if (uid != null) {
                            context
                                .read<LawyerRejectionCubit>()
                                .deleteLawyerData(uid);
                          }
                        },
                        width: double.infinity,
                        height: height * 0.07,
                        backgroundColor: AppColor.primary,
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
