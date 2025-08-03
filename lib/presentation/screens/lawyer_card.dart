import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/widgets/custom_button.dart';
import '../../Core/styles/color.dart';
import '../../Core/styles/text.dart';
import '../../data/repos/lawyer_repository.dart';
import '../../data/static/reviews.dart';
import '../../services/cubits/lawyer/lawyer_cubit.dart';
import '../../services/show_appointment_bottom_sheet/show_appointment_bottom_sheet.dart';

class LawyerScreen extends StatelessWidget {
  final String lawyerId;
  const LawyerScreen(this.lawyerId, {super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LawyerCubit(LawyerRepository())..getLawyer(lawyerId),
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
                                  height:
                                      MediaQuery.of(context).size.height *
                                      0.045,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: AppColor.primary,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: AppPadding.paddingSmall,
                                    child: Text(
                                      spec,
                                      textAlign: TextAlign.center,
                                      style: AppText.bodySmall.copyWith(
                                        color: AppColor.light,
                                      ),
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
                            Row(
                              children: [
                                Text(
                                  "التقيمات:",
                                  style: AppText.bodySmall.copyWith(
                                    color: AppColor.dark,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
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
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "4.48/5",
                                        style: AppText.headingMedium,
                                      ),
                                      Text(
                                        "29 تقيمات",
                                        style: AppText.labelSmall,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                            0.7,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            RatingBarIndicator(
                                              rating: 2.5,
                                              itemBuilder: (context, index) =>
                                                  Icon(
                                                    Icons.star,
                                                    color: AppColor.secondary,
                                                  ),
                                              itemCount: 5,
                                              itemSize: 18.sp,
                                              direction: Axis.horizontal,
                                            ),
                                            SizedBox(
                                              width:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.02,
                                            ),
                                            Flexible(
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    height:
                                                        MediaQuery.of(
                                                          context,
                                                        ).size.height *
                                                        0.01,

                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[300],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            4,
                                                          ),
                                                    ),
                                                  ),
                                                  FractionallySizedBox(
                                                    widthFactor: .6.w,
                                                    child: Container(
                                                      height:
                                                          MediaQuery.of(
                                                            context,
                                                          ).size.height *
                                                          0.01,

                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                              colors: [
                                                                AppColor.grey,
                                                                AppColor
                                                                    .secondary,
                                                              ],
                                                              begin: Alignment
                                                                  .centerLeft,
                                                              end: Alignment
                                                                  .centerRight,
                                                            ),

                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              4,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            SizedBox(
                                              width:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.02,
                                            ),
                                            Text("100%"),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      //>>>>>>>>>>>>>>>>>>>>>>>comments<<<<<<<<<<<<<<<<<<<<<
                      Flexible(
                        child: Container(
                          width: double.infinity,
                          padding: AppPadding.paddingSmall,
                          decoration: BoxDecoration(
                            color: AppColor.light,
                            border: Border(
                              bottom: BorderSide(
                                color: AppColor.dark.withAlpha(100),
                                width:
                                    MediaQuery.of(context).size.width * 0.004,
                              ),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "المراجعات:",
                                    style: AppText.bodySmall.copyWith(
                                      color: AppColor.dark,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.015,
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: reviews.length,
                                  itemBuilder: (context, index) {
                                    final review = reviews[index];
                                    return Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.only(
                                        bottom:
                                            MediaQuery.of(context).size.height *
                                            0.01,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColor.grey,
                                      ),
                                      child: Padding(
                                        padding: AppPadding.paddingSmall,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    review["name"],
                                                    style: AppText.bodySmall
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: AppColor.dark,
                                                        ),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(
                                                          context,
                                                        ).size.height *
                                                        0.005,
                                                  ),
                                                  Text(
                                                    review["comment"],
                                                    style: AppText.bodySmall
                                                        .copyWith(
                                                          color: AppColor.dark,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            RatingBarIndicator(
                                              rating: review["rating"],
                                              itemBuilder: (context, _) =>
                                                  const Icon(
                                                    Icons.star,
                                                    color: AppColor.secondary,
                                                  ),
                                              itemCount: 5,
                                              itemSize:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.05,
                                              direction: Axis.horizontal,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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
