import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/core/styles/text.dart';
import 'package:qanony/data/static/case_types.dart';
import 'package:qanony/presentation/pages/selection_dialog.dart';
import 'package:qanony/services/cubits/Search/search_cubit.dart';

class SearchAndFilters extends StatelessWidget {
  const SearchAndFilters({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SearchCubit>();

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
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: AppColor.grey, width: .7),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: AppColor.primary, width: 1),
              ),
            ),
            onChanged: (value) {
              cubit.updateFilter(newNameQuery: value);
            },
          ),
        ),

        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              return Padding(
                padding: AppPadding.horizontalSmall,
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          cubit.clearFilters();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.darkgrey,
                          foregroundColor: AppColor.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        icon: const Icon(Icons.all_inbox),
                        label: const Text("الكل"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SelectionDialog(
                      label: "النوع",
                      items: const ["ذكر", "أنثى"],
                      value: cubit.type,
                      onChanged: (val) {
                        cubit.updateFilter(newType: val);
                      },
                    ),
                    const SizedBox(width: 8),
                    SelectionDialog(
                      label: "التخصص",
                      items: caseTypes,
                      value: cubit.specialization,
                      onChanged: (val) {
                        cubit.updateFilter(newSpecialization: val);
                      },
                    ),
                    const SizedBox(width: 8),
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
