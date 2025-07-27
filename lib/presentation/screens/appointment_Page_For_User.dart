import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/core/styles/color.dart';
import 'package:qanony/data/repos/order_repository.dart';
import 'package:qanony/services/cubits/UserOrder/user_order_cubit.dart';

import '../../Core/widgets/custom_button.dart';
import '../../data/models/order_status_enum.dart';
import '../../services/cubits/checkout/checkout_cubit.dart';
import '../../services/firestore/lawyer_firestore_service.dart';
import '../../services/stripe/api_service.dart';
import '../../services/stripe/stripe_service.dart';
import '../pages/user_base_screen.dart';

class AppointmentPageForUser extends StatelessWidget {
  const AppointmentPageForUser({super.key});

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? '';
    final String userId = user?.uid??"";

    return
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => UserOrderCubit(OrderRepository())..streamUserOrders(userId),
          ),
          BlocProvider(
            create: (_) => CheckoutCubit(ApiService(), StripeService()),
          ),
        ],
      child: UserBaseScreen(
        RequestsColor: AppColor.secondary,
        body: Scaffold(
          body: BlocBuilder<UserOrderCubit, UserOrderState>(
            builder: (context, state) {
              if (state is UserOrderLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is UserOrderError) {
                return Center(child: Text(state.message));
              } else if (state is UserOrderLoaded) {
                final order = state.orders;
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
                            print('Status from Firebase: ${data.status}');

                            return FutureBuilder(
                              future: LawyerFirestoreService().getLawyerById(data.lawyerId),
                              builder: (context, snapshot) {
                                if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                                  return const SizedBox();
                                }

                                final lawyer = snapshot.data!;

                                return Card(
                                  margin: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).size.height * 0.015,
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

                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context).size.width * 0.2,
                                              height: MediaQuery.of(context).size.width * 0.2,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                image: DecorationImage(
                                                  image: NetworkImage(lawyer.profilePictureUrl.toString()),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: MediaQuery.of(context).size.width * .03),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      height: MediaQuery.of(context).size.height * 0.1,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            lawyer.fullName.toString(),
                                                            style: AppText.labelSmall.copyWith(color: AppColor.dark,fontWeight: FontWeight.bold),
                                                          ),
                                                          Text(
                                                            data.caseType,
                                                            style: AppText.labelSmall.copyWith(color: AppColor.dark),
                                                          ),

                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Icons.assignment_turned_in_outlined,
                                                                size: MediaQuery.of(context).size.width * .04,
                                                              ),
                                                              Text(
                                                                "الوصف:${data.caseDescription}",
                                                                style: AppText.labelSmall.copyWith(color: AppColor.dark),
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                            ],
                                                          ),
                                                          Text(

                                                              data.contactMethod,
                                                           style: AppText.labelSmall.copyWith(color: AppColor.dark)
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(width: MediaQuery.of(context).size.width * .01),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.money_outlined,
                                                          size: MediaQuery.of(context).size.width * .05,
                                                        ),
                                                        SizedBox(width: MediaQuery.of(context).size.width * .01),
                                                        Text(
                                                          "المبلغ :${data.price} ",
                                                          style: AppText.labelSmall,
                                                        ),
                                                        Icon(
                                                          Icons.attach_money,
                                                          size: MediaQuery.of(context).size.width * .04,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: MediaQuery.of(context).size.width * .01),
                                                Text(
                                                  data.status == OrderStatus.pending

                                                      ? "في انتظار الموافقة"
                                                      : data.status == OrderStatus.acceptedByLawyer
                                                      ? "  تم قبول الطلب"
                                                      : data.status == OrderStatus.rejectedByLawyer
                                                      ? "تم رفض الطلب"
                                                      : data.status ==OrderStatus.paymentRejected
                                                      ? "تم رفض الدفع"
                                                      : data.status == OrderStatus.paymentDone
                                                      ? "تم الدفع بنجاح"
                                                      : "حالة غير معروفة",
                                                  style: AppText.bodySmall.copyWith(
                                                    color: data.status == OrderStatus.pending
                                                        ?AppColor.secondary
                                                        : data.status == OrderStatus.acceptedByLawyer
                                                        ? AppColor.green
                                                        : data.status ==OrderStatus.rejectedByLawyer
                                                        ? AppColor.primary
                                                        : data.status == OrderStatus.paymentRejected
                                                        ? AppColor.primary
                                                        : data.status == OrderStatus.paymentDone
                                                        ? AppColor.green
                                                        : AppColor.grey,
                                                  ),
                                                ),


                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context).size.width * .04,
                                        ),

                                        data.status== OrderStatus.acceptedByLawyer
                                            ? CustomButton(
                                          text: "ادفع الآن",
                                          onTap: () {
                                            context.read<CheckoutCubit>().userMakePayment(amount: data.price.toInt(), email: email, orderId: data.orderId);

                                          },
                                          width:
                                          MediaQuery.of(context).size.width * 0.3,
                                          height:
                                          MediaQuery.of(context).size.height * 0.04,
                                          backgroundColor: AppColor.primary,
                                          textStyle: AppText.bodySmall,
                                        )
                                            : const SizedBox.shrink(),

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
                  style: AppText.bodySmall,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
