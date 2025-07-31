import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/services/cubits/qanony_appointment/qanony_appointment_cubit.dart';
import 'package:qanony/services/cubits/qanony_appointment/qanony_appointment_state.dart';
import 'package:qanony/services/firestore/order_firestore_service.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../Core/styles/text.dart';
import '../../Core/widgets/custom_button.dart';
import '../../Core/widgets/qanony_appointment_widget.dart';
import '../../data/models/order_status_enum.dart';
import '../../services/call/callService.dart';

class QanonyAppointmentsTab extends StatelessWidget {
  const QanonyAppointmentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final widthSmall = screenWidth * 0.02;
    final widthMedium = screenWidth * 0.04;
    String? email = FirebaseAuth.instance.currentUser?.email;
    String? lawyerId = FirebaseAuth.instance.currentUser?.uid;

    String lawyerName = email != null ? email.split('@')[0] : '';
    CallService callService = CallService();
    callService.onUserLogin(lawyerId.toString(), lawyerName);

    return BlocProvider(
      create: (context) {
        final lawyerId = FirebaseAuth.instance.currentUser?.uid ?? '';

        return QanonyAppointmentsCubit(OrderFirestoreService(), lawyerId);
      },
      child: BlocBuilder<QanonyAppointmentsCubit, QanonyAppointmentsState>(
        builder: (context, state) {
          if (state is QanonyAppointmentsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is QanonyAppointmentsError) {
            return Center(child: Text("حدث خطأ: ${state.message}"));
          } else if (state is QanonyAppointmentsLoaded) {
            final orders = state.appointments;
            CallService callService = CallService();

            if (orders.isEmpty) {
              return const Center(child: Text("لا توجد مواعيد حالياً"));
            }

            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final now = DateTime.now();
                final isTimeToJoin = now.isAfter(
                  order.date.subtract(Duration(minutes: 5)),
                );
                print(isTimeToJoin);

                return QanonyAppointmentCardWidget(
                  name: order.userName,
                  specialty: order.caseType,
                  description: order.caseDescription,
                  price: order.price.toString(),
                  communication: order.contactMethod,
                  date: _formatDate(order.date),
                  children: [
                    Text(
                      "الحالة: ${getStatusText(order.status)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: order.status == OrderStatus.paymentDone
                            ? AppColor.green
                            : AppColor.primary,
                      ),
                    ),
                    order.status == OrderStatus.paymentDone
                        ? CustomButton(
                            text: "انضم الى الجلسة",
                            onTap: isTimeToJoin
                                ? () async {
                                    await ZegoUIKitPrebuiltCallInvitationService()
                                        .send(
                                          resourceID: "QanonyApp",
                                          invitees: [
                                            ZegoCallUser(
                                              order.userId,
                                              order.userName,
                                            ),
                                          ],
                                          isVideoCall: true,
                                        );
                                  }
                                : null,
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: MediaQuery.of(context).size.height * 0.04,
                            backgroundColor: isTimeToJoin
                                ? AppColor.green
                                : AppColor.grey.withOpacity(0.4),
                            textStyle: AppText.bodySmall,
                          )
                        : const SizedBox.shrink(),
                  ],
                );
              },
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  String getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.acceptedByLawyer:
        return "تم قبول الطلب";
      case OrderStatus.paymentDone:
        return "تم الدفع";
      case OrderStatus.pending:
        return "قيد الانتظار";
      case OrderStatus.rejectedByLawyer:
        return "مرفوض من المحامي";
      case OrderStatus.paymentRejected:
        return "تم رفض الدفع";
    }
  }

  String _formatDate(DateTime date) {
    return "${_formatOnlyDate(date)} • ${_formatOnlyTime(date)}";
  }

  String _formatOnlyDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  String _formatOnlyTime(DateTime date) {
    return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }
}
