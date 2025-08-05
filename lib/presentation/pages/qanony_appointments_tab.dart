import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/services/cubits/qanony_appointment/qanony_appointment_cubit.dart';
import 'package:qanony/services/cubits/qanony_appointment/qanony_appointment_state.dart';
import 'package:qanony/services/firestore/order_firestore_service.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../Core/styles/text.dart';
import '../../Core/widgets/custom_button.dart';
import '../../Core/widgets/qanony_appointment_widget.dart';
import '../../data/models/order_status_enum.dart';
import '../../services/call/AppointmentPageForUser .dart';
import '../../services/call/call_service.dart';

class QanonyAppointmentsTab extends StatelessWidget {
  const QanonyAppointmentsTab({super.key});

  @override
  Widget build(BuildContext context) {
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
            return Center(
              child: Text(
                "حدث خطأ: ${state.message}",
                style: AppText.bodySmall.copyWith(color: AppColor.primary),
              ),
            );
          } else if (state is QanonyAppointmentsLoaded) {
            final orders = state.appointments;
            CallService callService = CallService();

            if (orders.isEmpty) {
              return Center(
                child: Text(
                  "لا توجد مواعيد حالياً",
                  style: AppText.bodyMedium.copyWith(color: AppColor.primary),
                ),
              );
            }

            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];

                return QanonyAppointmentCardWidget(
                  orderId: order.orderId,
                  orderdate: order.date,
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
                        color:
                            order.status == OrderStatus.paymentDone ||
                                order.status == OrderStatus.acceptedByLawyer
                            ? AppColor.green
                            : order.status == OrderStatus.pending
                            ? AppColor.secondary
                            : AppColor.primary,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    order.status == OrderStatus.paymentDone &&
                            order.contactMethod == "محادثة فيديو/صوت"
                        ? StreamBuilder<bool>(
                            stream: TimeStreamUtils.timeToJoinStream(order.date,1),
                            builder: (context, snapshot) {
                              final isTimeToJoin = snapshot.data ?? false;

                              return CustomButton(
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
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                                backgroundColor: isTimeToJoin
                                    ? AppColor.green
                                    : AppColor.grey.withAlpha(
                                        (0.4 * 255).round(),
                                      ),
                                textStyle: AppText.bodySmall,
                              );
                            },
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
