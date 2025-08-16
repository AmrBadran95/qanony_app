import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:qanony/data/repos/server_notifications_repo.dart';
import 'package:qanony/services/auth/auth_service.dart';
import 'package:qanony/services/cubits/order_form/order_form_cubit.dart';
import 'package:qanony/services/cubits/order_form/order_form_state.dart';
import 'package:qanony/services/cubits/server_notifications/server_notifications_cubit.dart';
import 'package:qanony/services/firestore/lawyer_firestore_service.dart';
import '../../Core/styles/color.dart';
import '../../Core/styles/text.dart';
import '../../Core/widgets/custom_button.dart';
import '../../Core/widgets/custom_text_form_field.dart';
import '../../data/models/order_model.dart';
import '../../data/models/order_status_enum.dart';
import '../../services/firestore/order_firestore_service.dart';
import '../../data/static/case_types.dart';
import '../../presentation/pages/selection_dialog.dart';

void showBookingForm({
  required BuildContext context,
  required String bookingType,
  required String price,
  required String day,
  required DateTime date,
  required String time,
  required String lawyerId,
}) {
  final nameController = TextEditingController();
  final problemController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? selectedSpecialty;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) =>
                OrderFormCubit(orderService: OrderFirestoreService()),
          ),
          BlocProvider(
            create: (_) => ServerNotificationsCubit(ServerNotificationsRepo()),
          ),
        ],
        child: StatefulBuilder(
          builder: (context, setState) {
            final media = MediaQuery.of(context).size;

            return SafeArea(
              child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: media.width * 0.05,
                    vertical: media.height * 0.02,
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: Text(
                              "يرجى إدخال معلوماتك",
                              style: AppText.bodyLarge.copyWith(
                                color: AppColor.primary,
                              ),
                            ),
                          ),
                          SizedBox(height: media.height * 0.015),
                          CustomTextFormField(
                            label: "اسم المستخدم",
                            controller: nameController,
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'يرجى إدخال الاسم';
                              }
                              return null;
                            },
                            textStyle: AppText.bodyMedium.copyWith(
                              color: AppColor.dark,
                            ),
                            labelStyle: AppText.bodyMedium.copyWith(
                              color: AppColor.dark,
                            ),
                            backgroundColor: AppColor.light,
                            contentPadding: EdgeInsets.all(media.width * 0.04),
                            width: double.infinity,
                          ),
                          SizedBox(height: media.height * 0.015),
                          CustomTextFormField(
                            label: "وصف المشكلة",
                            controller: problemController,
                            maxLines: 2,
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'يرجى وصف المشكلة';
                              }
                              return null;
                            },
                            textStyle: AppText.bodyMedium.copyWith(
                              color: AppColor.dark,
                            ),
                            labelStyle: AppText.bodyMedium.copyWith(
                              color: AppColor.dark,
                            ),
                            backgroundColor: AppColor.light,
                            contentPadding: EdgeInsets.all(media.width * 0.04),
                            width: double.infinity,
                          ),
                          SizedBox(height: media.height * 0.015),
                          FormField<String>(
                            validator: (val) {
                              if (selectedSpecialty == null) {
                                return "يرجى اختيار نوع التخصص";
                              }
                              return null;
                            },
                            builder: (formFieldState) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SelectionDialog(
                                    label: "التخصص",
                                    items: caseTypes,
                                    value: selectedSpecialty,
                                    onChanged: (val) {
                                      setState(() {
                                        selectedSpecialty = val;
                                        formFieldState.didChange(val);
                                      });
                                    },
                                  ),
                                  if (formFieldState.hasError)
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: media.height * 0.005,
                                        right: 8,
                                      ),
                                      child: Text(
                                        formFieldState.errorText!,
                                        style: AppText.bodySmall.copyWith(
                                          color: AppColor.error,
                                        ),
                                        textDirection: TextDirection.rtl,
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),

                          SizedBox(height: media.height * 0.015),
                          _buildDisabledField("نوع الحجز", bookingType, media),
                          _buildDisabledField("السعر", price, media),
                          _buildDisabledField("اليوم", day, media),
                          _buildDisabledField(
                            "التاريخ",
                            DateFormat.yMMMMd('ar').format(date),
                            media,
                          ),

                          _buildDisabledField("الساعة", time, media),
                          SizedBox(height: media.height * 0.03),
                          BlocConsumer<OrderFormCubit, OrderFormState>(
                            listener: (context, state) {
                              if (state is OrderFormSuccess) {
                                Navigator.pop(context);
                              }
                            },
                            builder: (context, state) {
                              final isLoading = state is OrderFormLoading;

                              return CustomButton(
                                text: isLoading
                                    ? "جاري الإرسال..."
                                    : "تأكيد الحجز",
                                width: media.width * 0.9,
                                height: media.height * 0.06,
                                textStyle: AppText.bodyLarge.copyWith(
                                  color: AppColor.light,
                                ),
                                backgroundColor: AppColor.primary,
                                onTap: isLoading
                                    ? null
                                    : () async {
                                        final uid =
                                            AuthService().currentUser?.uid;
                                        if (uid == null) return;

                                        if (!formKey.currentState!.validate()) {
                                          return;
                                        }

                                        if (selectedSpecialty == null) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "يرجى اختيار نوع التخصص",
                                              ),
                                              backgroundColor: AppColor.error,
                                            ),
                                          );
                                          return;
                                        }

                                        final order = OrderModel(
                                          orderId: "",
                                          userId: uid,
                                          lawyerId: lawyerId,
                                          status: OrderStatus.pending,
                                          date: date,
                                          userName: nameController.text,
                                          caseType: selectedSpecialty!,
                                          caseDescription: problemController
                                              .text
                                              .trim(),
                                          contactMethod: bookingType,
                                          price: double.tryParse(price) ?? 0.0,
                                          meetingLink: null,
                                        );

                                        context
                                            .read<OrderFormCubit>()
                                            .submitOrder(order);

                                        final lawyerData =
                                            await LawyerFirestoreService()
                                                .getLawyerById(lawyerId);
                                        final lawyerFcmToken =
                                            lawyerData?.fcmToken;
                                        if (context.mounted) {
                                          context
                                              .read<ServerNotificationsCubit>()
                                              .sendNotification(
                                                fcmToken: lawyerFcmToken ?? "",
                                                title: "طلب جديد",
                                                body:
                                                    "لديك طلب جديد من العميل ${nameController.text}",
                                                data: {"type": "lawyer_order"},
                                              );
                                        }
                                      },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}

Widget _buildDisabledField(String label, String value, Size media) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: media.height * 0.008),
    child: TextFormField(
      initialValue: value,
      readOnly: true,
      enabled: false,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppText.bodyMedium.copyWith(color: AppColor.primary),
        filled: true,
        fillColor: AppColor.grey,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      style: AppText.bodyMedium,
    ),
  );
}
