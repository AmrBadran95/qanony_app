import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/core/styles/padding.dart';
import 'package:qanony/core/styles/text.dart';
import 'package:qanony/services/cubits/Search/search_cubit.dart';
import 'package:qanony/services/cubits/rating/rating_cubit.dart';
import 'package:qanony/services/firestore/rating_firestore_service.dart';

import '../pages/search_and_filter.dart';
import '../pages/user_base_screen.dart';
import 'lawyer_card.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SearchCubit()),
        BlocProvider(
          create: (_) =>
              RatingCubit(RatingFirestoreService())
                ..loadAllLawyersAverageRatings(),
        ),
      ],
      child: UserBaseScreen(
        searchColor: AppColor.secondary,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(AppPadding.small),
              child: SearchAndFilters(),
            ),
            Expanded(child: LawyersList()),
          ],
        ),
      ),
    );
  }
}

class LawyersList extends StatelessWidget {
  const LawyersList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPadding.small),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 10.h),
                itemCount: state.lawyers.length,
                itemBuilder: (context, index) {
                  final lawyer = state.lawyers[index];
                  return Padding(
                    padding: AppPadding.paddingSmall,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LawyerScreen(lawyer.uid),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColor.light,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColor.grey.withAlpha((0.4 * 255).round()),
                            width: 1.sp,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),

                        child: Padding(
                          padding: AppPadding.paddingMedium,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  BlocBuilder<RatingCubit, RatingState>(
                                    builder: (context, ratingState) {
                                      double rating = 0;

                                      if (ratingState
                                          is AllLawyersRatingsLoaded) {
                                        final ratingData = ratingState
                                            .lawyerRatings[lawyer.uid];
                                        if (ratingData != null) {
                                          rating = ratingData.average;
                                        }
                                      }

                                      return Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: Image.network(
                                              lawyer.profilePictureUrl ?? '',
                                              width: 60.sp,
                                              height: 60.sp,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(height: 6.h),
                                          RatingBarIndicator(
                                            rating: rating,
                                            itemBuilder: (context, index) =>
                                                Icon(
                                                  Icons.star,
                                                  color: AppColor.secondary,
                                                ),
                                            itemCount: 5,
                                            itemSize: 15.0.sp,
                                            direction: Axis.horizontal,
                                          ),
                                        ],
                                      );
                                    },
                                  ),

                                  SizedBox(width: 10.w),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        lawyer.fullName.toString(),
                                        style: AppText.bodySmall.copyWith(
                                          color: AppColor.dark,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 5.h),
                                      Text(
                                        " النوع : ${lawyer.gender}",
                                        style: AppText.bodySmall.copyWith(
                                          color: AppColor.dark,
                                        ),
                                      ),
                                      SizedBox(height: 5.h),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (lawyer.offersCall == true)
                                            Text(
                                              "مكالمة صوتية/فيديو - ${lawyer.callPrice} جنيه",
                                              style: AppText.labelSmall
                                                  .copyWith(
                                                    color: AppColor.primary,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          SizedBox(height: 5.h),
                                          if (lawyer.offersOffice == true)
                                            Text(
                                              "عبر المكتب - ${lawyer.officePrice} جنيه",
                                              style: AppText.labelSmall
                                                  .copyWith(
                                                    color: AppColor.primary,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          if (lawyer.offersCall != true &&
                                              lawyer.offersOffice != true)
                                            Text(
                                              "لا توجد وسيلة تواصل محددة",
                                              style: AppText.labelSmall
                                                  .copyWith(
                                                    color: AppColor.primary,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        } else if (state is SearchInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SearchError) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: Text("لا يوجد بيانات."));
        }
      },
    );
  }
}
