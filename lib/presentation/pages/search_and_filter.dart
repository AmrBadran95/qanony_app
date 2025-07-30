import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/core/styles/text.dart';
import 'package:qanony/data/static/case_types.dart';
import 'package:qanony/presentation/pages/selection_dialog.dart';
import 'package:qanony/services/cubits/Search/cubit/search_cubit.dart';

class SearchAndFilters extends StatelessWidget {
  const SearchAndFilters({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SearchCubit>();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppPadding.horizontalSmall,
          child: TextField(
            style: AppText.bodyMedium.copyWith(color: AppColor.dark),
            decoration: InputDecoration(
              hintText: "ابحث عن محامي...",
              hintStyle: AppText.bodySmall,
              prefixIcon: const Icon(Icons.search, color: AppColor.primary),
              filled: true,
              fillColor: AppColor.grey,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(screenWidth * 0.06),
                borderSide: BorderSide(color: AppColor.grey, width: 0.7),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(screenWidth * 0.06),
                borderSide: BorderSide(color: AppColor.primary, width: 1),
              ),
            ),
            onChanged: (value) {
              cubit.updateFilter(newNameQuery: value);
            },
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              return Padding(
                padding: AppPadding.horizontalSmall,
                child: Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        cubit.clearFilters();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.darkgrey,
                        foregroundColor: AppColor.primary,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                          vertical: screenHeight * 0.01,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.015,
                          ),
                        ),
                      ),
                      icon: const Icon(Icons.all_inbox),
                      label: const Text("الكل"),
                    ),
                    SizedBox(width: screenWidth * 0.025),
                    SelectionDialog(
                      label: "النوع",
                      items: const ["ذكر", "أنثى"],
                      value: cubit.type,
                      onChanged: (val) {
                        cubit.updateFilter(newType: val);
                      },
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    SelectionDialog(
                      label: "التخصص",
                      items: caseTypes,
                      value: cubit.specialization,
                      onChanged: (val) {
                        cubit.updateFilter(newSpecialization: val);
                      },
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    SelectionDialog(
                      label: "التواصل عبر",
                      items: const [
                        "مكالمه فيديو",
                        "مكالمه صوتيه",
                        "فى المكتب",
                      ],
                      value: cubit.contactMethod,
                      onChanged: (val) {
                        String? method;
                        if (val == 'مكالمه فيديو' || val == 'مكالمه صوتيه') {
                          method = 'call';
                        } else if (val == 'فى المكتب') {
                          method = 'office';
                        }
                        cubit.updateFilter(newContactMethod: method);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
