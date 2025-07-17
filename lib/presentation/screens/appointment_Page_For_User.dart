import 'package:flutter/material.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/core/styles/color.dart';

import '../../Core/widgets/custom_button.dart';
import '../pages/lawyer_base_screen.dart';

class AppointmentPageForUser extends StatelessWidget {
  const AppointmentPageForUser({super.key});

  @override
  Widget build(BuildContext context) {
    //for testing
    final List<Map<String, dynamic>> appointments = [
      {
        "name": "مريم عبد العزيز سعود",
        "session": "حضور جلسة",
        "requestNumber": "30445",
        "amount": 40,
        "status": "جديدة - بانتظار الموافقة",
      },
      {
        "name": "أحمد محمود يوسف",
        "session": "استشارة قانونية",
        "requestNumber": "30446",
        "amount": 50,
        "status": "قيد المراجعة",
      },
      {
        "name": "سارة خالد عبد الرحمن",
        "session": "مرافعة في المحكمة",
        "requestNumber": "30447",
        "amount": 80,
        "status": "مقبولة - قيد التنفيذ",
      },
      {
        "name": "يوسف إبراهيم حسن",
        "session": "جلسة تحكيم",
        "requestNumber": "30448",
        "amount": 60,
        "status": "مقبولة - قيد التنفيذ",
      },
      {
        "name": "أميرة محمد فؤاد",
        "session": "استشارة عقود",
        "requestNumber": "30449",
        "amount": 55,
        "status": "مقبولة - قيد التنفيذ",
      },
      {
        "name": "خالد سامي عبد الله",
        "session": "جلسة نزاع تجاري",
        "requestNumber": "30450",
        "amount": 70,
        "status": "منتهية",
      },
    ];
    return Scaffold(
      body: LawyerBaseScreen(
        body: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: appointments.length,
                  padding: AppPadding.paddingMedium,
                  itemBuilder: (context, index) {
                    final data = appointments[index];
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
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  height:
                                      MediaQuery.of(context).size.width * 0.2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      image: AssetImage(
                                        'assets/images/lawyer 1.png',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * .03,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          height:
                                              MediaQuery.of(
                                                context,
                                              ).size.height *
                                              0.08,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                data["name"],
                                                style: AppText.labelSmall,
                                              ),
                                              Text(
                                                data["session"],
                                                style: AppText.labelSmall,
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .assignment_turned_in_outlined,
                                                    size:
                                                        MediaQuery.of(
                                                          context,
                                                        ).size.width *
                                                        .04,
                                                  ),
                                                  Text(
                                                    "رقم الطلب:${data["requestNumber"]}",
                                                    style: AppText.labelSmall,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              .03,
                                        ),
                                        Container(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.money_outlined,
                                                size:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    .05,
                                              ),
                                              SizedBox(
                                                width:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    .01,
                                              ),
                                              Text(
                                                "المبلغ :${data['amount']} ",
                                                style: AppText.labelSmall,
                                              ),
                                              Icon(
                                                Icons.attach_money,
                                                size:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    .04,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.width *
                                          .01,
                                    ),
                                    Text(
                                      data["status"],
                                      style: AppText.bodySmall.copyWith(
                                        color:
                                            data["status"] ==
                                                "مقبولة - قيد التنفيذ"
                                            ? AppColor.green
                                            : AppColor.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width * .04,
                            ),

                            data["status"] == "مقبولة - قيد التنفيذ"
                                ? CustomButton(
                                    text: "ادفع الآن",
                                    onTap: () {},
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    height:
                                        MediaQuery.of(context).size.height *
                                        0.04,
                                    backgroundColor: AppColor.primary,
                                    textStyle: AppText.bodySmall,
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
