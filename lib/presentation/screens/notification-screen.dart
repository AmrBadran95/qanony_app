import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/services/cubits/notification/cubit/notification_cubit.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.grey,
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        title: Text(
          "الإشعارات",
          style: AppText.headingMedium.copyWith(color: AppColor.light),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.light),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: AppColor.light),
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
              return const Center(child: Text("لا توجد إشعارات."));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemCount: state.notifications.length,
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      notification.title,
                      style: AppText.bodyLarge.copyWith(color: AppColor.dark),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.body,
                          style: AppText.bodySmall.copyWith(
                            color: AppColor.dark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat.yMd().add_jm().format(notification.date),
                          style: const TextStyle(
                            color: AppColor.darkgrey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    leading: const Icon(
                      Icons.notifications_active,
                      color: AppColor.secondary,
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
