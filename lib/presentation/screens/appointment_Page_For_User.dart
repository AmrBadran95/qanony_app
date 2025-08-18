import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;
import 'package:intl/intl.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/Core/widgets/RatingDialog.dart';
import 'package:qanony/core/styles/color.dart';
import 'package:qanony/data/repos/order_repository.dart';
import 'package:qanony/data/repos/server_notifications_repo.dart';
import 'package:qanony/services/cubits/payment/payment_cubit.dart';
import 'package:qanony/services/cubits/payment/payment_state.dart';
import 'package:qanony/services/cubits/rating/rating_cubit.dart';
import 'package:qanony/services/cubits/server_notifications/server_notifications_cubit.dart';
import 'package:qanony/services/cubits/user_order/user_order_cubit.dart';
import 'package:qanony/services/firestore/rating_firestore_service.dart';
import 'package:qanony/services/firestore/user_firestore_service.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../Core/widgets/custom_button.dart';
import '../../data/models/order_status_enum.dart';

import '../../services/call/AppointmentPageForUser .dart';
import '../../services/firestore/lawyer_firestore_service.dart';
import '../../services/firestore/order_firestore_service.dart';
import '../pages/user_base_screen.dart';

class AppointmentPageForUser extends StatelessWidget {
  const AppointmentPageForUser({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final String userId = user?.uid ?? " ";
    final orderService = OrderFirestoreService();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              UserOrderCubit(OrderRepository())..streamUserOrders(userId),
        ),
        BlocProvider(create: (_) => PaymentCubit()),
        BlocProvider(
          create: (_) => ServerNotificationsCubit(ServerNotificationsRepo()),
        ),
        BlocProvider(
          create: (_) =>
              RatingCubit(RatingFirestoreService())
                ..loadAllLawyersAverageRatings(),
        ),
      ],
      child: UserBaseScreen(
        requestsColor: AppColor.secondary,
        body: BlocListener<PaymentCubit, PaymentState>(
          listener: (context, state) async {
            if (state is PaymentSuccess) {
              await Stripe.instance.initPaymentSheet(
                paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: state.clientSecret,
                  merchantDisplayName: 'Qanony',
                  style: ThemeMode.light,
                ),
              );

              try {
                await Stripe.instance.presentPaymentSheet();
                await orderService.updateOrder(state.orderId, {
                  'status': orderStatusToString(OrderStatus.paymentDone),
                });
              } catch (e) {
                rethrow;
              }
            } else if (state is PaymentFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.error,
                    style: AppText.bodyMedium.copyWith(color: AppColor.primary),
                  ),
                  backgroundColor: AppColor.grey,
                ),
              );
            }
          },

          child: Scaffold(
            body: BlocBuilder<UserOrderCubit, UserOrderState>(
              builder: (context, state) {
                if (state is UserOrderLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is UserOrderError) {
                  return Center(child: Text(state.message));
                } else if (state is UserOrderLoaded) {
                  final order = state.orders
                    ..sort((a, b) => b.date.compareTo(a.date));
                  return SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: order.length,
                            padding: AppPadding.paddingMedium,
                            itemBuilder: (context, index) {
                              final data = order[index];

                              return FutureBuilder(
                                future: LawyerFirestoreService().getLawyerById(
                                  data.lawyerId,
                                ),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError ||
                                      !snapshot.hasData ||
                                      snapshot.data == null) {
                                    return SizedBox();
                                  }

                                  final lawyer = snapshot.data!;

                                  return Card(
                                    margin: EdgeInsets.only(
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                          0.014,
                                    ),
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: AppPadding.paddingSmall,
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              BlocBuilder<
                                                RatingCubit,
                                                RatingState
                                              >(
                                                builder: (context, ratingState) {
                                                  double averageRating = 0.0;

                                                  if (ratingState
                                                      is AllLawyersRatingsLoaded) {
                                                    final ratingData =
                                                        ratingState
                                                            .lawyerRatings[lawyer
                                                            .uid];
                                                    if (ratingData != null) {
                                                      averageRating =
                                                          ratingData.average;
                                                    }
                                                  }

                                                  return Column(
                                                    children: [
                                                      Container(
                                                        width:
                                                            MediaQuery.of(
                                                              context,
                                                            ).size.width *
                                                            0.19,
                                                        height:
                                                            MediaQuery.of(
                                                              context,
                                                            ).size.width *
                                                            0.19,
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                20,
                                                              ),
                                                          image: DecorationImage(
                                                            image: NetworkImage(
                                                              lawyer
                                                                  .profilePictureUrl
                                                                  .toString(),
                                                            ),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 5.h),
                                                      RatingBarIndicator(
                                                        rating: averageRating,
                                                        itemBuilder:
                                                            (
                                                              context,
                                                              index,
                                                            ) => Icon(
                                                              Icons.star,
                                                              color: AppColor
                                                                  .secondary,
                                                            ),
                                                        itemCount: 5,
                                                        itemSize: 15.0.sp,
                                                        direction:
                                                            Axis.horizontal,
                                                      ),
                                                      data.status ==
                                                              OrderStatus
                                                                  .paymentDone
                                                          ? StreamBuilder<bool>(
                                                              stream:
                                                                  TimeStreamUtils.timeToJoinStream(
                                                                    data.date,
                                                                    1,
                                                                  ),
                                                              builder: (context, snapshot) {
                                                                final isTimeToJoin =
                                                                    snapshot
                                                                        .data ??
                                                                    false;
                                                                if (!isTimeToJoin) {
                                                                  return SizedBox.shrink();
                                                                }
                                                                return IconButton(
                                                                  icon: Icon(
                                                                    Icons
                                                                        .rate_review,
                                                                    color: AppColor
                                                                        .secondary,
                                                                    size: 24.sp,
                                                                  ),
                                                                  onPressed: () async {
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder: (_) => RatingDialog(
                                                                        userId:
                                                                            userId,
                                                                        lawyerId:
                                                                            data.lawyerId,
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                            )
                                                          : SizedBox.shrink(),
                                                    ],
                                                  );
                                                },
                                              ),
                                              SizedBox(
                                                width:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    .025,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        height:
                                                            MediaQuery.of(
                                                              context,
                                                            ).size.height *
                                                            0.13,

                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              lawyer.fullName
                                                                  .toString(),
                                                              style: AppText
                                                                  .labelSmall
                                                                  .copyWith(
                                                                    color:
                                                                        AppColor
                                                                            .dark,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                            ),
                                                            Text(
                                                              data.caseType,
                                                              style: AppText
                                                                  .labelSmall
                                                                  .copyWith(
                                                                    color:
                                                                        AppColor
                                                                            .dark,
                                                                  ),
                                                            ),

                                                            SizedBox(
                                                              width:
                                                                  MediaQuery.of(
                                                                    context,
                                                                  ).size.width *
                                                                  .3,
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      "الوصف:${data.caseDescription}",
                                                                      style: AppText
                                                                          .labelSmall
                                                                          .copyWith(
                                                                            color:
                                                                                AppColor.dark,
                                                                          ),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      softWrap:
                                                                          false,
                                                                      maxLines:
                                                                          1,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Text(
                                                              "${data.contactMethod} - ${data.price} جنيه",
                                                              style: AppText
                                                                  .labelSmall
                                                                  .copyWith(
                                                                    color:
                                                                        AppColor
                                                                            .dark,
                                                                  ),
                                                            ),
                                                            Text(
                                                              DateFormat(
                                                                'EEEE، yyyy/MM/dd – hh:mm a',
                                                                'ar',
                                                              ).format(
                                                                data.date,
                                                              ),
                                                              style: AppText
                                                                  .labelSmall
                                                                  .copyWith(
                                                                    color:
                                                                        AppColor
                                                                            .dark,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(
                                                          context,
                                                        ).size.width *
                                                        .01,
                                                  ),
                                                  Text(
                                                    data.status ==
                                                            OrderStatus.pending
                                                        ? "في انتظار الموافقة"
                                                        : data.status ==
                                                              OrderStatus
                                                                  .acceptedByLawyer
                                                        ? "  تم قبول الطلب"
                                                        : data.status ==
                                                              OrderStatus
                                                                  .rejectedByLawyer
                                                        ? "تم رفض الطلب"
                                                        : data.status ==
                                                              OrderStatus
                                                                  .paymentRejected
                                                        ? "تم رفض الدفع"
                                                        : data.status ==
                                                              OrderStatus
                                                                  .paymentDone
                                                        ? "تم الدفع بنجاح"
                                                        : "حالة غير معروفة",
                                                    style: AppText.bodySmall.copyWith(
                                                      color:
                                                          data.status ==
                                                              OrderStatus
                                                                  .pending
                                                          ? AppColor.secondary
                                                          : data.status ==
                                                                OrderStatus
                                                                    .acceptedByLawyer
                                                          ? AppColor.green
                                                          : data.status ==
                                                                OrderStatus
                                                                    .rejectedByLawyer
                                                          ? AppColor.error
                                                          : data.status ==
                                                                OrderStatus
                                                                    .paymentRejected
                                                          ? AppColor.error
                                                          : data.status ==
                                                                OrderStatus
                                                                    .paymentDone
                                                          ? AppColor.green
                                                          : AppColor.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              data.status ==
                                                          OrderStatus
                                                              .rejectedByLawyer ||
                                                      data.status ==
                                                          OrderStatus
                                                              .paymentRejected
                                                  ? Expanded(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Padding(
                                                            padding: AppPadding
                                                                .paddingSmall,
                                                            child: GestureDetector(
                                                              onTap: () {
                                                                orderService
                                                                    .deleteOrder(
                                                                      data.orderId,
                                                                    );
                                                              },
                                                              child: Icon(
                                                                Icons.delete,
                                                                size: 24.sp,
                                                                color: AppColor
                                                                    .error,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : data.status ==
                                                        OrderStatus.paymentDone
                                                  ? StreamBuilder<bool>(
                                                      stream:
                                                          TimeStreamUtils.canDeleteAfterSession(
                                                            data.date,
                                                            2,
                                                          ),
                                                      builder: (context, snapshot) {
                                                        final canDelete =
                                                            snapshot.data ??
                                                            false;
                                                        if (!canDelete) {
                                                          return SizedBox.shrink();
                                                        }

                                                        return Expanded(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Padding(
                                                                padding: AppPadding
                                                                    .paddingSmall,
                                                                child: GestureDetector(
                                                                  onTap: () {
                                                                    orderService
                                                                        .deleteOrder(
                                                                          data.orderId,
                                                                        );
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .delete,
                                                                    size: 24.sp,
                                                                    color: AppColor
                                                                        .error,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    )
                                                  : SizedBox.shrink(),
                                            ],
                                          ),
                                          SizedBox(
                                            height:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                .04,
                                          ),

                                          data.status ==
                                                  OrderStatus.acceptedByLawyer
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    CustomButton(
                                                      text: "ادفع الآن",
                                                      onTap: () {
                                                        context
                                                            .read<
                                                              PaymentCubit
                                                            >()
                                                            .createPayment(
                                                              lawyerId:
                                                                  data.lawyerId,
                                                              orderId:
                                                                  data.orderId,
                                                            );
                                                      },
                                                      width:
                                                          MediaQuery.of(
                                                            context,
                                                          ).size.width *
                                                          0.3,
                                                      height:
                                                          MediaQuery.of(
                                                            context,
                                                          ).size.height *
                                                          0.04,
                                                      backgroundColor:
                                                          AppColor.green,
                                                      textStyle:
                                                          AppText.bodySmall,
                                                    ),
                                                    CustomButton(
                                                      text: "الغاء الطلب",
                                                      onTap: () async {
                                                        await orderService.updateOrder(
                                                          data.orderId,
                                                          {
                                                            'status':
                                                                orderStatusToString(
                                                                  OrderStatus
                                                                      .paymentRejected,
                                                                ),
                                                          },
                                                        );

                                                        final userData =
                                                            await UserFirestoreService()
                                                                .getUserById(
                                                                  data.userId,
                                                                );
                                                        final lawyerData =
                                                            await LawyerFirestoreService()
                                                                .getLawyerById(
                                                                  data.lawyerId,
                                                                );

                                                        final lawyerFcmToken =
                                                            lawyerData
                                                                ?.fcmToken;
                                                        final userName =
                                                            userData?.username;
                                                        if (context.mounted) {
                                                          context
                                                              .read<
                                                                ServerNotificationsCubit
                                                              >()
                                                              .sendNotification(
                                                                fcmToken:
                                                                    lawyerFcmToken ??
                                                                    "",
                                                                title:
                                                                    "تم إلغاء الطلب",
                                                                body:
                                                                    "قام العميل $userName برفض الدفع و تم إلغاء الطلب.",
                                                                data: {
                                                                  "type":
                                                                      "lawyer_order",
                                                                },
                                                              );
                                                        }
                                                      },
                                                      width:
                                                          MediaQuery.of(
                                                            context,
                                                          ).size.width *
                                                          0.3,
                                                      height:
                                                          MediaQuery.of(
                                                            context,
                                                          ).size.height *
                                                          0.04,
                                                      backgroundColor:
                                                          AppColor.error,
                                                      textStyle:
                                                          AppText.bodySmall,
                                                    ),
                                                  ],
                                                )
                                              : data.status ==
                                                        OrderStatus
                                                            .paymentDone &&
                                                    data.contactMethod ==
                                                        "حجز فى المكتب"
                                              ? Text(
                                                  "${lawyer.address}",
                                                  textAlign: TextAlign.center,
                                                  style: AppText.labelSmall
                                                      .copyWith(
                                                        color: AppColor.green,
                                                      ),
                                                )
                                              : data.status ==
                                                        OrderStatus
                                                            .paymentDone &&
                                                    data.contactMethod ==
                                                        "محادثة فيديو/صوت"
                                              ? StreamBuilder<bool>(
                                                  stream:
                                                      TimeStreamUtils.timeToJoinStream(
                                                        data.date,
                                                        1,
                                                      ),
                                                  builder: (context, snapshot) {
                                                    final isTimeToJoin =
                                                        snapshot.data ?? false;

                                                    return Row(
                                                      children: [
                                                        Expanded(
                                                          child: CustomButton(
                                                            text:
                                                                "انضم الى الجلسة",
                                                            onTap: isTimeToJoin
                                                                ? () async {
                                                                    await ZegoUIKitPrebuiltCallInvitationService().send(
                                                                      resourceID:
                                                                          "QanonyApp",
                                                                      invitees: [
                                                                        ZegoCallUser(
                                                                          data.lawyerId,
                                                                          lawyer
                                                                              .fullName
                                                                              .toString(),
                                                                        ),
                                                                      ],
                                                                      isVideoCall:
                                                                          true,
                                                                    );
                                                                  }
                                                                : null,
                                                            width:
                                                                MediaQuery.of(
                                                                  context,
                                                                ).size.width *
                                                                0.3,
                                                            height:
                                                                MediaQuery.of(
                                                                  context,
                                                                ).size.height *
                                                                0.04,
                                                            backgroundColor:
                                                                isTimeToJoin
                                                                ? AppColor.green
                                                                : AppColor.grey
                                                                      .withAlpha(
                                                                        (0.4 * 255)
                                                                            .round(),
                                                                      ),
                                                            textStyle: AppText
                                                                .bodySmall,
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                )
                                              : SizedBox.shrink(),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Center(
                  child: Text(
                    'لا توجد طلبات حالياً',
                    style: AppText.bodySmall.copyWith(color: AppColor.dark),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
