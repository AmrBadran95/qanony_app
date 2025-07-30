import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/services/cubits/notification/cubit/notification_cubit.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      backgroundColor: AppColor.grey,
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        title: Text(
          "الإشعارات",
          style: AppText.headingMedium.copyWith(
            color: AppColor.light,
            fontSize: screenWidth * 0.05,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColor.light,
            size: screenWidth * 0.06,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete,
              color: AppColor.light,
              size: screenWidth * 0.06,
            ),
            onPressed: () {
              context.read<NotificationCubit>().clearNotifications();
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) {
              return Center(
                child: Text(
                  "لا توجد إشعارات.",
                  style: AppText.bodyLarge.copyWith(
                    fontSize: screenWidth * 0.045,
                  ),
                ),
              );
            }
            return ListView.separated(
              padding: EdgeInsets.all(screenWidth * 0.04),
              separatorBuilder: (_, __) =>
                  SizedBox(height: screenHeight * 0.01),
              itemCount: state.notifications.length,
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.01,
                      horizontal: screenWidth * 0.03,
                    ),
                    child: ListTile(
                      title: Text(
                        notification.title,
                        style: AppText.bodyLarge.copyWith(
                          color: AppColor.dark,
                          fontSize: screenWidth * 0.045,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification.body,
                            style: AppText.bodySmall.copyWith(
                              color: AppColor.dark,
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.005),
                          Text(
                            DateFormat.yMd().add_jm().format(notification.date),
                            style: TextStyle(
                              color: AppColor.darkgrey,
                              fontSize: screenWidth * 0.03,
                            ),
                          ),
                        ],
                      ),
                      leading: Icon(
                        Icons.notifications_active,
                        color: AppColor.secondary,
                        size: screenWidth * 0.07,
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
