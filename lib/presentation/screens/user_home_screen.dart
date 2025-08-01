import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/data/repos/lawyer_repository.dart';
import 'package:qanony/data/static/question_list.dart';
import 'package:qanony/presentation/pages/ai_chat_screen.dart';
import 'package:qanony/services/call/call_service.dart';
import '../../data/static/advertisements.dart';
import '../../services/cubits/lawyer/lawyer_cubit.dart';
import '../pages/user_base_screen.dart';
import 'lawyer_card.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? '';
    final String userId = user?.uid ?? "";
    final String userName = user?.displayName ?? email.split('@')[0];
    CallService().onUserLogin(userId, userName);
    return BlocProvider(
      create: (_) => LawyerCubit(LawyerRepository())..getPremiumLawyers(),

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
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: adsList.length,

                      itemBuilder: (context, index) {
                        final ad = adsList[index];
                        return Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Container(
                            width: 300,
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
                                          style: AppText.title.copyWith(
                                            color: AppColor.light,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Padding(
                                        padding: AppPadding.horizontalSmall,
                                        child: Text(
                                          ad['subtitle']!,
                                          style: AppText.bodySmall.copyWith(
                                            color: AppColor.light,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
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

              const SizedBox(height: 5),

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
                            style: AppText.bodyMedium.copyWith(
                              color: AppColor.light,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          Icons.chat_outlined,
                          size: 60,
                          color: AppColor.light,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 5),

              Padding(
                padding: AppPadding.paddingSmall,
                child: Text(
                  'المحاميون المميزون',
                  style: AppText.bodyMedium.copyWith(
                    color: AppColor.dark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 200,
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
                          int rating = (index % 5) + 1;

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
                              width: 130,
                              padding: AppPadding.paddingSmall,
                              decoration: BoxDecoration(color: AppColor.light),
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
                                  const SizedBox(height: 4),
                                  Text(
                                    lawyer.fullName ?? "غير معروف",
                                    style: AppText.bodySmall.copyWith(
                                      color: AppColor.dark,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    lawyer.role,
                                    style: AppText.labelSmall.copyWith(
                                      color: AppColor.dark,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(5, (starIndex) {
                                      return Icon(
                                        Icons.star,
                                        size: 14,
                                        color: starIndex < rating
                                            ? AppColor.secondary
                                            : AppColor.grey,
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return Container();
                  },
                ),
              ),

              Padding(
                padding: AppPadding.paddingMedium,
                child: Text(
                  'الأسئلة الشائعة',
                  style: AppText.title.copyWith(
                    color: AppColor.dark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 170,
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
                          padding: AppPadding.paddingMedium,
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
