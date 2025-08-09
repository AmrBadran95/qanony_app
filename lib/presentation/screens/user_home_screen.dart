import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/data/repos/lawyer_repository.dart';
import 'package:qanony/data/static/question_list.dart';
import 'package:qanony/presentation/pages/ai_chat_screen.dart';
import 'package:qanony/services/cubits/rating/rating_cubit.dart';
import 'package:qanony/services/firestore/rating_firestore_service.dart';
import '../../data/static/advertisements.dart';
import '../../services/cubits/lawyer/lawyer_cubit.dart';
import '../pages/user_base_screen.dart';
import 'lawyer_card.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LawyerCubit(LawyerRepository())..getPremiumLawyers(),
        ),
        BlocProvider<RatingCubit>(
          create: (_) =>
              RatingCubit(RatingFirestoreService())
                ..loadAllLawyersAverageRatings(),
        ),
      ],
      child: UserBaseScreen(
        homeColor: AppColor.secondary,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 160.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: adsList.length,

                      itemBuilder: (context, index) {
                        final ad = adsList[index];
                        return Padding(
                          padding: EdgeInsets.only(left: 5.w),
                          child: Container(
                            width: 300.w,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("${ad['image']}"),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  color: AppColor.dark.withAlpha(
                                    (0.5 * 255).round(),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: AppPadding.horizontalSmall,
                                        child: Text(
                                          ad['title']!,
                                          style: AppText.bodyMedium.copyWith(
                                            color: AppColor.light,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Padding(
                                        padding: AppPadding.horizontalSmall,
                                        child: Text(
                                          ad['subtitle']!,
                                          style: AppText.bodySmall.copyWith(
                                            color: AppColor.light,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5.h),
                                    ],
                                  ),
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

              SizedBox(height: 5.h),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => AiChatScreen(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,

                  decoration: BoxDecoration(
                    color: AppColor.dark.withAlpha((0.6 * 255).round()),
                    image: DecorationImage(
                      image: AssetImage('assets/images/image.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: AppPadding.paddingMedium,
                    color: AppColor.dark.withAlpha((0.3 * 255).round()),
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Expanded(
                          child: Text(
                            'مساعدك القانوني الذكي\nأحصل على إجابات دقيقة وفورية على استفساراتك القانونية.',
                            style: AppText.bodySmall.copyWith(
                              color: AppColor.light,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Icon(
                          Icons.chat_outlined,
                          size: 60.sp,
                          color: AppColor.light,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 5.h),

              Padding(
                padding: AppPadding.paddingSmall,
                child: Text(
                  'المحاميون المميزون',
                  style: AppText.bodySmall.copyWith(
                    color: AppColor.dark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 200.h,
                child: BlocBuilder<LawyerCubit, LawyerState>(
                  builder: (context, state) {
                    if (state is LawyerLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is LawyersMapedLoaded) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.lawyers.length,
                        itemBuilder: (context, index) {
                          final lawyer = state.lawyers[index];

                          return BlocBuilder<RatingCubit, RatingState>(
                            builder: (context, ratingState) {
                              double averageRating = 0;
                              int ratingCount = 0;

                              if (ratingState is AllLawyersRatingsLoaded &&
                                  ratingState.lawyerRatings.containsKey(
                                    lawyer.uid,
                                  )) {
                                final ratingData =
                                    ratingState.lawyerRatings[lawyer.uid]!;
                                averageRating = ratingData.average;
                                ratingCount = ratingData.count;
                              }

                              final fullStars = averageRating.floor();
                              final hasHalfStar =
                                  (averageRating - fullStars) >= 0.5;

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          LawyerScreen(lawyer.uid),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 130.w,
                                  padding: AppPadding.paddingSmall,
                                  decoration: BoxDecoration(
                                    color: AppColor.light,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 50,
                                        backgroundImage:
                                            lawyer.profilePictureUrl != null
                                            ? NetworkImage(
                                                lawyer.profilePictureUrl!,
                                              )
                                            : null,
                                        child: lawyer.profilePictureUrl == null
                                            ? Icon(Icons.person)
                                            : null,
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        lawyer.fullName ?? "غير معروف",
                                        style: AppText.bodySmall.copyWith(
                                          color: AppColor.dark,
                                        ),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      Text(
                                        lawyer.role,
                                        style: AppText.labelSmall.copyWith(
                                          color: AppColor.dark,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),

                                      // ⭐ تقييم فعلي
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List.generate(5, (starIndex) {
                                          if (starIndex < fullStars) {
                                            return Icon(
                                              Icons.star,
                                              size: 14.sp,
                                              color: AppColor.secondary,
                                            );
                                          } else if (starIndex == fullStars &&
                                              hasHalfStar) {
                                            return Icon(
                                              Icons.star_half,
                                              size: 14.sp,
                                              color: AppColor.secondary,
                                            );
                                          } else {
                                            return Icon(
                                              Icons.star_border,
                                              size: 14.sp,
                                              color: AppColor.grey,
                                            );
                                          }
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }
                    return Container();
                  },
                ),
              ),

              Padding(
                padding: AppPadding.paddingSmall,
                child: Text(
                  'الأسئلة الشائعة',
                  style: AppText.bodySmall.copyWith(
                    color: AppColor.dark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 120.h,
                child: ListView.builder(
                  itemCount: questionList.length,
                  itemBuilder: (context, index) {
                    final question = questionList[index];
                    return ExpansionTile(
                      collapsedIconColor: AppColor.dark,
                      iconColor: AppColor.primary,
                      title: Text(
                        question['question'] ?? '',
                        style: AppText.bodyMedium.copyWith(
                          color: AppColor.dark,
                        ),
                      ),
                      children: [
                        Container(
                          width: double.infinity,
                          padding: AppPadding.paddingSmall,
                          color: AppColor.grey,
                          child: Text(
                            question['answer'] ?? '',
                            style: AppText.bodyMedium.copyWith(
                              color: AppColor.dark,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
