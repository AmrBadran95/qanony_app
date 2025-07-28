import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/Core/widgets/custom_button.dart';
import 'package:qanony/Core/widgets/qanony_appointment_widget.dart';
import 'package:qanony/data/models/order_status_enum.dart';
import 'package:qanony/presentation/pages/my_appointments_tab.dart';
import 'package:qanony/services/cubits/order_lawyer/order_cubit.dart';

class OrdersLawyerScreen extends StatelessWidget {
  const OrdersLawyerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = screenWidth * 0.35;
    const buttonHeight = 40.0;

    return BlocProvider(
      create: (context) => OrderCubit()..loadMyOrders(),
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
              return const Center(child: Text('لا يوجد طلبات حالياً'));
            }

            return SingleChildScrollView(
              padding: AppPadding.paddingMedium,
              child: Column(
                children: pendingOrders.map((order) {
                  return QanonyAppointmentCardWidget(
                    name: order.userName,
                    specialty: order.caseType,
                    description: order.caseDescription,
                    price: '${order.price} EGP',
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
                                    'accepted_by_lawyer',
                                  );

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("تم قبول الطلب بنجاح"),
                                  ),
                                );

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const MyAppointmentsTab(),
                                  ),
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
                                    'rejected_by_lawyer',
                                  );

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("تم رفض الطلب")),
                                );
                              }
                            },
                            width: buttonWidth,
                            height: buttonHeight,
                            backgroundColor: AppColor.primary,
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
