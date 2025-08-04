import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/widgets/custom_button.dart';
import 'package:qanony/services/cubits/rating/rating_cubit.dart';
import 'package:qanony/services/firestore/rating_firestore_service.dart';

import '../../Core/styles/color.dart';
import '../../Core/styles/text.dart';
import '../../data/repos/lawyer_repository.dart';
import '../../services/cubits/lawyer/lawyer_cubit.dart';
import '../../services/show_appointment_bottom_sheet/show_appointment_bottom_sheet.dart';

class LawyerScreen extends StatelessWidget {
  final String lawyerId;
  const LawyerScreen(this.lawyerId, {super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LawyerCubit(LawyerRepository())..getLawyer(lawyerId),
        ),
        BlocProvider(
          create: (_) =>
              RatingCubit(RatingFirestoreService())
                ..loadLawyerReviews(lawyerId),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.primary,
          title: Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.01,
              right: MediaQuery.of(context).size.width * 0.01,
              bottom: MediaQuery.of(context).size.height * 0.01,
            ),
            child: Text(
              "قانوني",
              style: AppText.headingMedium.copyWith(color: AppColor.light),
            ),
          ),
        ),
        body: BlocBuilder<LawyerCubit, LawyerState>(
          builder: (context, state) {
            if (state is LawyerLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LawyerLoaded) {
              final lawyer = state.lawyer;
              return Container(
                color: AppColor.grey,
                width: double.infinity,
                height: double.infinity,
                child: Padding(
                  padding: AppPadding.paddingSmall,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.02,
                            ),
                            child: Column(
                              children: [
                                ClipOval(
                                  child: Image.network(
                                    lawyer.profilePictureUrl.toString(),
                                    width:
                                        MediaQuery.of(context).size.width *
                                        0.25,
                                    height:
                                        MediaQuery.of(context).size.width *
                                        0.25,
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                Text(
                                  lawyer.fullName.toString(),
                                  style: AppText.title.copyWith(
                                    color: AppColor.dark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),

                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColor.light,
                          border: Border(
                            bottom: BorderSide(
                              color: AppColor.dark.withAlpha(100),
                              width: MediaQuery.of(context).size.width * 0.004,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: AppPadding.paddingSmall,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: lawyer.specialty!.map((spec) {
                                return Container(
                                  padding: AppPadding.paddingSmall,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: AppColor.primary,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    spec,
                                    textAlign: TextAlign.center,
                                    style: AppText.bodySmall.copyWith(
                                      color: AppColor.light,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: AppPadding.paddingSmall,
                        decoration: BoxDecoration(
                          color: AppColor.light,
                          border: Border(
                            bottom: BorderSide(
                              color: AppColor.dark.withAlpha(100),
                              width: MediaQuery.of(context).size.width * 0.004,
                            ),
                          ),
                        ),
                        child: Text(
                          lawyer.bio.toString(),
                          softWrap: true,
                          style: AppText.bodySmall,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: AppPadding.paddingSmall,
                        decoration: BoxDecoration(
                          color: AppColor.light,
                          border: Border(
                            bottom: BorderSide(
                              color: AppColor.dark.withAlpha(100),
                              width: MediaQuery.of(context).size.width * 0.004,
                            ),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Text(
                                    "حجز استشارة عن طريق:",
                                    style: AppText.bodySmall.copyWith(
                                      color: AppColor.dark,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.015,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).size.height * 0.005,
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Wrap(
                                  spacing: 8.sp,
                                  runSpacing: 8.sp,
                                  children: [
                                    CustomButton(
                                      padding: AppPadding.paddingSmall,
                                      text: "محادثة فيديو/صوت",
                                      textColor: AppColor.dark,
                                      height:
                                          MediaQuery.of(context).size.height *
                                          0.055,
                                      textStyle: AppText.bodySmall.copyWith(
                                        color: AppColor.light,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      onTap: () {
                                        showAppointmentBottomSheet(
                                          context: context,
                                          appointments:
                                              lawyer.availableAppointments,
                                          bookingType: "محادثة فيديو/صوت",
                                          price: lawyer.callPrice.toString(),
                                          lawyerId: lawyerId,
                                        );
                                      },
                                      backgroundColor: AppColor.secondary,
                                      icon: Icons.photo_camera_front,
                                    ),
                                    CustomButton(
                                      padding: AppPadding.paddingSmall,
                                      text: "حجز فى المكتب",
                                      textColor: AppColor.dark,
                                      height:
                                          MediaQuery.of(context).size.height *
                                          0.055,
                                      textStyle: AppText.bodySmall.copyWith(
                                        color: AppColor.light,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      onTap: () {
                                        showAppointmentBottomSheet(
                                          context: context,
                                          appointments:
                                              lawyer.availableAppointments,
                                          bookingType: "حجز فى المكتب",
                                          price: lawyer.officePrice.toString(),
                                          lawyerId: lawyerId,
                                        );
                                      },
                                      backgroundColor: AppColor.secondary,
                                      icon: Icons.message_outlined,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      BlocBuilder<RatingCubit, RatingState>(
                        builder: (context, state) {
                          if (state is RatingLoading) {
                            return Center(child: CircularProgressIndicator());
                          } else if (state is ReviewsLoaded) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "${state.average}/5",
                                      style: AppText.bodyMedium.copyWith(
                                        color: AppColor.dark,
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Text(
                                      "${state.count} تقيمات",
                                      style: AppText.labelSmall.copyWith(
                                        color: AppColor.dark,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 16.h),

                                if (state.reviews.isEmpty)
                                  Text(
                                    "لا توجد مراجعات حتى الآن",
                                    style: AppText.bodyMedium.copyWith(
                                      color: AppColor.primary,
                                    ),
                                  )
                                else
                                  Container(
                                    color: AppColor.light,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: state.reviews.length,
                                      itemBuilder: (context, index) {
                                        final review = state.reviews[index];
                                        return ListTile(
                                          title: Text(review.name),
                                          subtitle: Text(review.comment),
                                          trailing: RatingBarIndicator(
                                            rating: review.rating,
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: AppColor.secondary,
                                              size: 24.sp,
                                            ),
                                            itemCount: 5,
                                            itemSize: 20,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                              ],
                            );
                          } else if (state is RatingError) {
                            return Text(
                              "حدث خطأ: ${state.message}",
                              style: AppText.bodySmall.copyWith(
                                color: AppColor.primary,
                              ),
                            );
                          } else {
                            return SizedBox();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is LawyerError) {
              return Center(
                child: Text(
                  "حدث خطأ: ${state.message}",
                  style: AppText.bodySmall.copyWith(color: AppColor.primary),
                ),
              );
            } else {
              return Center(
                child: Text(
                  "فشل في تحميل البيانات",
                  style: AppText.bodySmall.copyWith(color: AppColor.primary),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
