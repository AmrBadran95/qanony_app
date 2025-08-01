import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanony/Core/shared/app_cache.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/presentation/screens/choose_role_screen.dart';
import 'package:qanony/presentation/screens/notification-screen.dart';
import 'package:qanony/services/cubits/notification/notification_cubit.dart';
import '../../services/auth/auth_service.dart';
import '../../services/call/callService.dart';
import '../screens/appointment_page_for_user.dart';
import '../screens/search_screen.dart';
import '../screens/user_home_screen.dart';

class UserBaseScreen extends StatelessWidget {
  final Widget body;
  final Color homeColor;
  final Color searchColor;
  final Color appointmentsColor;
  final Color requestsColor;

  const UserBaseScreen({
    super.key,
    required this.body,
    this.homeColor = AppColor.light,
    this.searchColor = AppColor.light,
    this.appointmentsColor = AppColor.light,
    this.requestsColor = AppColor.light,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? '';
    final String userId = user?.uid ?? "";
    final String userName = user?.displayName ?? email.split('@')[0];
    CallService().onUserLogin(userId, userName);

    return Scaffold(
      backgroundColor: AppColor.light,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: AppColor.primary,

          title: Padding(
            padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 0.01,
              bottom: MediaQuery.of(context).size.height * 0.01,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "قانوني",
                  style: AppText.headingMedium.copyWith(color: AppColor.light),
                ),

                Stack(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (_) =>
                                  NotificationCubit()..loadNotifications(),
                              child: const NotificationScreen(),
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.notifications_none_sharp,
                        size: MediaQuery.of(context).size.width * 0.095,
                        color: AppColor.light,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 12, top: 13),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.03,
                        height: MediaQuery.of(context).size.width * 0.03,

                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: Container(
        padding: AppPadding.paddingSmall,
        width: double.infinity,
        color: AppColor.primary,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserHomeScreen(),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.home_sharp, size: 20, color: homeColor),
                        const SizedBox(height: 4),
                        Text(
                          "الرئيسية",
                          style: AppText.labelSmall.copyWith(color: homeColor),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SearchScreen()),
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search, size: 20, color: searchColor),
                        const SizedBox(height: 4),
                        Text(
                          "البحث",
                          style: AppText.labelSmall.copyWith(
                            color: searchColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AppointmentPageForUser(),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.assignment_sharp,
                          size: 20,
                          color: requestsColor,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "طلباتي",
                          style: AppText.labelSmall.copyWith(
                            color: requestsColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    //>>>اظهر الدايلوج الاولر وبعدين ف الزرار احط الكود داااا
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(
                            'تسجيل الخروج',
                            style: AppText.title.copyWith(color: AppColor.dark),
                          ),
                          content: const Text(
                            'هل أنت متأكد أنك تريد تسجيل الخروج؟',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'إلغاء',
                                style: AppText.bodyMedium.copyWith(
                                  color: AppColor.primary,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final authService = AuthService();
                                await authService.logout();

                                AppCache.setLoggedIn(false);
                                AppCache.setIsLawyer(false);

                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ChooseRoleScreen(),
                                  ),
                                  (route) => false,
                                );
                              },

                              child: Text(
                                'خروج',
                                style: AppText.bodyMedium.copyWith(
                                  color: AppColor.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.logout, size: 20, color: appointmentsColor),
                        const SizedBox(height: 4),
                        Text(
                          "تسجيل الخروج",
                          style: AppText.labelSmall.copyWith(
                            color: appointmentsColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: body,
    );
  }
}
