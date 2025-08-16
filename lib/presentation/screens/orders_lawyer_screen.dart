import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/Core/widgets/custom_button.dart';
import 'package:qanony/Core/widgets/qanony_appointment_widget.dart';
import 'package:qanony/data/models/order_status_enum.dart';
import 'package:qanony/data/repos/server_notifications_repo.dart';
import 'package:qanony/services/cubits/order_lawyer/order_cubit.dart';
import 'package:qanony/services/cubits/server_notifications/server_notifications_cubit.dart';
import 'package:qanony/services/firestore/lawyer_firestore_service.dart';
import 'package:qanony/services/firestore/user_firestore_service.dart';

class OrdersLawyerScreen extends StatelessWidget {
  const OrdersLawyerScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = screenWidth * 0.35;
    const buttonHeight = 40.0;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => OrderCubit()..loadMyOrders()),
        BlocProvider(
          create: (_) => ServerNotificationsCubit(ServerNotificationsRepo()),
        ),
      ],
      child: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderError) {
            return Center(child: Text(state.message));
          } else if (state is OrderLoaded) {
            final pendingOrders = state.orders
                .where((order) => order.status == OrderStatus.pending)
                .toList();

            if (pendingOrders.isEmpty) {
              return Center(
                child: Text(
                  "لا توجد طلبات حالياً",
                  style: AppText.bodyMedium.copyWith(color: AppColor.error),
                ),
              );
            }
            final dateFormat = DateFormat('dd-MM-yyyy • hh:mm a', 'ar');

            return SingleChildScrollView(
              padding: AppPadding.paddingMedium,
              child: Column(
                children: pendingOrders.map((order) {
                  return QanonyAppointmentCardWidget(
                    orderId: order.orderId,
                    orderdate: order.date,
                    name: order.userName,
                    specialty: order.caseType,
                    description: order.caseDescription,
                    price: '${order.price} EGP',
                    date: dateFormat.format(order.date),
                    communication: order.contactMethod,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomButton(
                            text: 'قبول',
                            onTap: () async {
                              await context
                                  .read<OrderCubit>()
                                  .updateOrderStatus(
                                    order.orderId,
                                    orderStatusToString(
                                      OrderStatus.acceptedByLawyer,
                                    ),
                                  );
                              final userData = await UserFirestoreService()
                                  .getUserById(order.userId);
                              final lawyerData = await LawyerFirestoreService()
                                  .getLawyerById(order.lawyerId);

                              final userFcmToken = userData?.fcmToken;
                              final lawyerName = lawyerData?.fullName;
                              if (context.mounted) {
                                context
                                    .read<ServerNotificationsCubit>()
                                    .sendNotification(
                                      fcmToken: userFcmToken ?? "",
                                      title: "تم قبول طلبك",
                                      body:
                                          "المحامي $lawyerName وافق على الاستشارة.",
                                      data: {"type": "user_order"},
                                    );
                              }
                            },
                            width: buttonWidth,
                            height: buttonHeight,
                            backgroundColor: AppColor.green,
                            textStyle: AppText.bodyMedium,
                          ),
                          CustomButton(
                            text: 'رفض',
                            onTap: () async {
                              await context
                                  .read<OrderCubit>()
                                  .updateOrderStatus(
                                    order.orderId,
                                    orderStatusToString(
                                      OrderStatus.rejectedByLawyer,
                                    ),
                                  );

                              final userData = await UserFirestoreService()
                                  .getUserById(order.userId);
                              final lawyerData = await LawyerFirestoreService()
                                  .getLawyerById(order.lawyerId);

                              final userFcmToken = userData?.fcmToken;
                              final lawyerName = lawyerData?.fullName;
                              if (context.mounted) {
                                context
                                    .read<ServerNotificationsCubit>()
                                    .sendNotification(
                                      fcmToken: userFcmToken ?? "",
                                      title: "تم رفض طلبك",
                                      body:
                                          "المحامي $lawyerName قام برفض الاستشارة.",
                                      data: {"type": "user_order"},
                                    );
                              }
                            },
                            width: buttonWidth,
                            height: buttonHeight,
                            backgroundColor: AppColor.error,
                            textStyle: AppText.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  );
                }).toList(),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
