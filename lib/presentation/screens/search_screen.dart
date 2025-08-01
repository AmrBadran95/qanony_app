import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/core/styles/padding.dart';
import 'package:qanony/core/styles/text.dart';
import 'package:qanony/services/cubits/Search/search_cubit.dart';
import '../pages/search_and_filter.dart';
import '../pages/user_base_screen.dart';
import 'lawyer_card.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(),
      child: UserBaseScreen(
        searchColor: AppColor.secondary,
        body: Column(
          children: const [
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
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.small),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ListView.separated(
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
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
                            color: AppColor.grey.withOpacity(0.4),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),

                        child: ListTile(
                          contentPadding: EdgeInsets.all(AppPadding.small),
                          tileColor: AppColor.light,
                          leading: CircleAvatar(
                            backgroundColor: AppColor.grey,
                            backgroundImage: NetworkImage(
                              lawyer.profilePictureUrl!,
                            ),

                            radius: 30,
                          ),
                          title: Text(
                            lawyer.fullName.toString(),
                            style: AppText.bodyMedium.copyWith(
                              color: AppColor.dark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "النوع: ${lawyer.gender}",
                                style: AppText.bodySmall.copyWith(
                                  color: AppColor.dark,
                                ),
                              ),
                              SizedBox(width: 5),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "التواصل عبر: ",
                                      style: AppText.bodySmall.copyWith(
                                        color: AppColor.dark,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          lawyer.offersCall == true &&
                                              lawyer.offersOffice == true
                                          ? "مكالمة صوتية/فيديو أو عبر المكتب"
                                          : lawyer.offersCall == true
                                          ? "مكالمة صوتية/فيديو"
                                          : lawyer.offersOffice == true
                                          ? "عبر المكتب"
                                          : "لا توجد وسيلة تواصل محددة",
                                      style: AppText.labelSmall.copyWith(
                                        color: AppColor.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              RatingBarIndicator(
                                rating: 2.5,
                                itemBuilder: (context, index) =>
                                    Icon(Icons.star, color: AppColor.secondary),
                                itemCount: 5,
                                itemSize: 15.0,
                                direction: Axis.horizontal,
                              ),
                            ],
                          ),
                          trailing: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "السعر: ",
                                  style: AppText.bodySmall.copyWith(
                                    color: AppColor.dark,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      (lawyer.callPrice != null &&
                                          lawyer.officePrice != null)
                                      ? "مكالمة: ${lawyer.callPrice} جنيه\nمكتب: ${lawyer.officePrice} جنيه"
                                      : (lawyer.callPrice != null)
                                      ? "مكالمة: ${lawyer.callPrice} جنيه"
                                      : (lawyer.officePrice != null)
                                      ? "مكتب: ${lawyer.officePrice} جنيه"
                                      : "لا توجد وسيلة تواصل محددة",
                                  style: AppText.labelSmall.copyWith(
                                    color: AppColor.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
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
