import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qanony/Core/shared/app_cache.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/core/styles/padding.dart';
import 'package:qanony/presentation/screens/appointment_lawyer.dart';
import 'package:qanony/presentation/screens/choose_role_screen.dart';
import 'package:qanony/presentation/screens/lawyer_account.dart';
import 'package:qanony/presentation/screens/orders_lawyer_screen.dart';

class LawyerBaseScreen extends StatelessWidget {
  final Widget body;
  final int selectedIndex;

  const LawyerBaseScreen({
    super.key,
    required this.body,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        title: Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.01,
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
                  Icon(
                    Icons.notifications_none_sharp,
                    size: MediaQuery.of(context).size.width * 0.095,
                    color: AppColor.light,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 4, top: 4),
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
                  _buildNavItem(
                    context,
                    index: 0,
                    icon: Icons.home_sharp,
                    label: "الرئيسية",
                    isSelected: selectedIndex == 0,
                    destination: const AccountLawyerScreen(),
                  ),
                  _buildNavItem(
                    context,
                    index: 1,
                    icon: Icons.assignment_sharp,
                    label: "طلباتي",
                    isSelected: selectedIndex == 1,
                    destination: const OrdersLawyerScreen(),
                  ),
                  _buildNavItem(
                    context,
                    index: 2,
                    icon: Icons.access_alarm_sharp,
                    label: "مواعيدي",
                    isSelected: selectedIndex == 2,
                    destination: const AppointmentLawyer(),
                  ),
                  GestureDetector(
                    onTap: () => _showLogoutDialog(context),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.exit_to_app,
                          size: 20,
                          color: AppColor.light,
                        ),
                        SizedBox(height: 4),
                        Text(
                          "تسجيل الخروج",
                          style: TextStyle(color: AppColor.light),
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

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String label,
    required Widget destination,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                LawyerBaseScreen(selectedIndex: index, body: destination),
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
            color: isSelected ? Colors.yellow : AppColor.light,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppText.labelSmall.copyWith(
              color: isSelected ? Colors.yellow : AppColor.light,
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'تسجيل الخروج',
          style: AppText.title.copyWith(color: AppColor.dark),
        ),
        content: const Text('هل أنت متأكد أنك تريد تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: AppText.bodyMedium.copyWith(color: AppColor.primary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              AppCache.setLoggedIn(false);
              AppCache.setIsLawyer(false);
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const ChooseRoleScreen()),
                (route) => false,
              );
            },
            child: Text(
              'خروج',
              style: AppText.bodyMedium.copyWith(color: AppColor.green),
            ),
          ),
        ],
      ),
    );
  }
}
