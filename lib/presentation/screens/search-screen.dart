import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/core/styles/padding.dart';
import 'package:qanony/presentation/pages/SearchAndFilters.dart';
import 'package:qanony/presentation/pages/user-base-screen.dart';
import 'package:qanony/services/cubits/Search/cubit/search_cubit.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(),
      child: UserBaseScreen(
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
                  return ListTile(
                    contentPadding: EdgeInsets.all(AppPadding.small),
                    tileColor: AppColor.light,
                    leading: CircleAvatar(
                      backgroundColor: AppColor.grey,
                      backgroundImage: AssetImage('assets/images/lawyer1.png'),

                      radius: 30,
                    ),
                    title: Text(lawyer.name),
                    subtitle: RichText(
                      text: TextSpan(
                        style: TextStyle(color: AppColor.dark, fontSize: 14),
                        children: [
                          TextSpan(
                            text: ' ${lawyer.specialization.join(" - ")}',
                          ),
                        ],
                      ),
                    ),
                    trailing: Text(' ${lawyer.YearsOfExperience} سنوات خبرة'),
                  );
                },
              ),
            ),
          );
        } else if (state is SearchInitial) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const Center(child: Text("لا يوجد بيانات."));
        }
      },
    );
  }
}
