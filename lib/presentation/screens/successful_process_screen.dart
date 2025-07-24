import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/Core/widgets/custom_button.dart';
import '../../data/repos/lawyer_repository.dart';
import '../../services/cubits/Lawyer/lawyer_cubit.dart';

class SuccessfulProcessScreen extends StatelessWidget {

  const SuccessfulProcessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("لم يتم العثور على المستخدم، يرجى تسجيل الدخول.")),
      );
    }



    return BlocProvider( create: (_) => LawyerCubit(LawyerRepository())..getLawyer(user.uid),
      child:  Scaffold(
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
        body:
        BlocBuilder<LawyerCubit, LawyerState>(
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
            height: size.height * 0.7,
            padding: AppPadding.paddingMedium,
            decoration: BoxDecoration(
            color: AppColor.light,
            borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Column(
            children: [
            const Icon(
            Icons.check_circle,
            size: 100,
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

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(
            'تفاصيل الاشتراك:',
            style: AppText.headingMedium.copyWith(
            color: AppColor.dark,
            ),
            textAlign: TextAlign.center,
            ),
              SizedBox(height: size.height * 0.02),
              Text(
                ' الباقه الحاليه:${lawyer.subscriptionType}',
                style: AppText.bodyLarge.copyWith(
                  color: AppColor.dark,
                ),
                textAlign: TextAlign.center,
              ),
            SizedBox(height: size.height * 0.02),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          'تاريخ الاشتراك: ${lawyer.subscriptionStart}',
                          style: AppText.bodyLarge.copyWith(
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
                      'تاريخ الانتهاء: ${lawyer.subscriptionEnd}',
                      style: AppText.bodyLarge.copyWith(
                        color: AppColor.dark,
                      ),
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.visible, // تأكدي من ده
                      softWrap: true,
                    ),
                  ),
                ],
              ),

              SizedBox(height: size.height * 0.02),
            SizedBox(height: size.height * 0.02),
            Text(
            'وسيلة الدفع: تحويل بنكي',
            style: AppText.bodyLarge.copyWith(
            color: AppColor.dark,
            ),
            textAlign: TextAlign.center,
            ),
            ],
            ),

            CustomButton(
            text: 'مشاركة',
            onTap: () {},
            width: double.infinity,
            height: 50,
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
            onTap: () {},
            width: double.infinity,
            height: 50,
            backgroundColor: AppColor.secondary,
            textStyle: AppText.title,
            textColor: AppColor.dark,
            ),
            ],
            ),
            );

            }else if (state is LawyerError) {
              return Center(child: Text("حدث خطأ: ${state.message}"));
            }

            else {
              return const Center(child: Text("فشل في تحميل البيانات"));
            }
          },
        ),
      )
    );

  }
}
