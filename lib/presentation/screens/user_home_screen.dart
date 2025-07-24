import 'package:flutter/material.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/presentation/pages/user_base_screen.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return UserBaseScreen(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PageView
            SizedBox(
              height: 200,
              child: PageView(
                children: [
                  Image.asset('assets/images/Logo.png', fit: BoxFit.cover),
                  Image.asset('assets/images/p1.png', fit: BoxFit.cover),
                  Image.asset('assets/images/court 1.png', fit: BoxFit.cover),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Container clickable
            GestureDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                padding: AppPadding.paddingMedium,
                color: AppColor.dark,
                child: Row(
                  textDirection: TextDirection.rtl, // النص يمين والأيقونة شمال
                  children: [
                    Expanded(
                      child: Text(
                        'مساعدك القانوني الذكي\nأحصل على إجابات دقيقة وفورية على استفساراتك القانونية.',
                        style: AppText.bodyMedium.copyWith(
                          color: AppColor.light,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..scale(-1.0, 1.0), // يعكس الأيقونة
                      child: Icon(
                        Icons.psychology,
                        size: 60,
                        color: AppColor.light,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // المحامون المميزون
            Padding(
              padding: AppPadding.paddingSmall,
              child: Text(
                'المحامون المميزون',
                style: AppText.title.copyWith(color: AppColor.dark),
              ),
            ),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  int rating = (index % 5) + 1;

                  return Container(
                    width: 120,
                    padding: AppPadding.paddingSmall,
                    decoration: BoxDecoration(
                      color: AppColor.light,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColor.green,
                          child: Icon(Icons.person, color: AppColor.dark),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Youssef Milad',
                          style: AppText.bodySmall.copyWith(
                            color: AppColor.dark,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Developer',
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
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // الأسئلة الشائعة
            Padding(
              padding: AppPadding.paddingMedium,
              child: Text(
                'الأسئلة الشائعة',
                style: AppText.title.copyWith(color: AppColor.dark),
              ),
            ),
            ExpansionTile(
              title: Text(
                'ازاي اعمل توكيل؟',
                style: AppText.bodyMedium.copyWith(color: AppColor.dark),
              ),
              children: [
                Container(
                  width: double.infinity,
                  padding: AppPadding.paddingMedium,
                  color: AppColor.grey,
                  child: Text(
                    'لازم تروح الشهر العقاري ومعاك بطاقتك وبطاقات الطرف الآخر.',
                    style: AppText.bodySmall.copyWith(color: AppColor.dark),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                'سؤال تاني؟',
                style: AppText.bodyMedium.copyWith(color: AppColor.dark),
              ),
              children: [
                Container(
                  width: double.infinity,
                  padding: AppPadding.paddingMedium,
                  color: AppColor.grey,
                  child: Text(
                    'الإجابة هنا.',
                    style: AppText.bodySmall.copyWith(color: AppColor.dark),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                'سؤال تاني؟',
                style: AppText.bodyMedium.copyWith(color: AppColor.dark),
              ),
              children: [
                Container(
                  width: double.infinity,
                  padding: AppPadding.paddingMedium,
                  color: AppColor.grey,
                  child: Text(
                    'الإجابة هنا.',
                    style: AppText.bodySmall.copyWith(color: AppColor.dark),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                'سؤال تاني؟',
                style: AppText.bodyMedium.copyWith(color: AppColor.dark),
              ),
              children: [
                Container(
                  width: double.infinity,
                  padding: AppPadding.paddingMedium,
                  color: AppColor.grey,
                  child: Text(
                    'الإجابة هنا.',
                    style: AppText.bodySmall.copyWith(color: AppColor.dark),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
