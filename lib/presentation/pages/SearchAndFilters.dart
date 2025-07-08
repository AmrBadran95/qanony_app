import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/data/static/case_types.dart';
import 'package:qanony/presentation/pages/SelectionDialog.dart';
import 'package:qanony/services/cubits/Search/cubit/search_cubit.dart';

class SearchAndFilters extends StatelessWidget {
  const SearchAndFilters({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SearchCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: const InputDecoration(
            hintText: "بحث...",
            hintStyle: TextStyle(color: AppColor.dark),
            prefixIcon: Icon(Icons.search, color: AppColor.dark),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            filled: true,
            fillColor: AppColor.light,
          ),
          onChanged: (value) {
            cubit.updateFilter(newNameQuery: value);
          },
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              return Row(
                children: [
                  SelectionDialog(
                    label: "النوع",
                    items: const ["ذكر", "انثى"],
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
                    items: const ["مكالمه فيديو", "مكالمه صوتيه", "فى المكتب"],
                    value: cubit.contactMethod,
                    onChanged: (val) {
                      cubit.updateFilter(newContactMethod: val);
                    },
                  ),

                  const SizedBox(width: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        cubit.clearFilters();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.darkgrey,
                        foregroundColor: AppColor.light,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      icon: const Icon(Icons.clear),
                      label: const Text("مسح التحديد"),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
