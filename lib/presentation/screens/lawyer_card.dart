import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:qanony/Core/styles/padding.dart';
import '../../Core/styles/color.dart';
import '../../Core/styles/text.dart';
import '../../Core/widgets/custom_button.dart';
import '../pages/lawyer_base_screen.dart';

class LawyerScreen extends StatelessWidget {
  const LawyerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //test بس
    final List<Map<String, dynamic>> reviews = [
      {
        "name": "أحمد محمد",
        "comment": "التعليق على الخدمة القانونية بشكل ممتاز.",
        "rating": 4.0,
      },
      {
        "name": "منى حسين",
        "comment": "خدمة ممتازة وتعامل راقي.",
        "rating": 5.0,
      },
      {"name": "كريم علي", "comment": "رد سريع ومحترف.", "rating": 4.5},
      {"name": "سارة محمود", "comment": "أنصح بالتعامل معه.", "rating": 5.0},
      {
        "name": "ياسر سالم",
        "comment": "خدمة جيدة لكن يمكن تحسين السرعة.",
        "rating": 3.5,
      },
    ];
    return LawyerBaseScreen(
      body: Container(
        color: AppColor.grey,
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: AppPadding.paddingSmall,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.02,
                    ),
                    child: Column(
                      children: [
                        //عشاان الصوره تبقى مدوره
                        ClipOval(
                          child: Image.asset(
                            "assets/images/lawyer 1.png",
                            width: MediaQuery.of(context).size.width * 0.25,
                            height: MediaQuery.of(context).size.width * 0.25,
                            fit: BoxFit.cover,
                          ),
                        ),

                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Text(
                          'Hadeer Mohamed',
                          style: AppText.title.copyWith(color: AppColor.dark),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Container(
                // height: MediaQuery.of(context).size.height * 0.065,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.light,
                  border: Border(
                    bottom: BorderSide(
                      color: AppColor.dark.withAlpha(100),
                      width: MediaQuery.of(context).size.width * 0.004,
                    ),
                  ),
                ),
                child: Padding(
                  padding: AppPadding.paddingSmall,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomButton(
                        text: "جنائى",
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.045,
                        textStyle: AppText.bodyLarge.copyWith(
                          color: AppColor.light,
                        ),
                        onTap: () {
                          //handle tap
                        },
                        backgroundColor: AppColor.primary,
                      ),
                      CustomButton(
                        text: "جنائى",
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.045,
                        textStyle: AppText.bodyLarge.copyWith(
                          color: AppColor.light,
                        ),
                        onTap: () {
                          //handle tap
                        },
                        backgroundColor: AppColor.primary,
                      ),
                      CustomButton(
                        text: "جنائى",
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.045,
                        textStyle: AppText.bodyLarge.copyWith(
                          color: AppColor.light,
                        ),
                        onTap: () {
                          //handle tap
                        },
                        backgroundColor: AppColor.primary,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: AppPadding.paddingSmall,
                decoration: BoxDecoration(
                  color: AppColor.light,
                  border: Border(
                    bottom: BorderSide(
                      color: AppColor.dark.withAlpha(100),
                      width: MediaQuery.of(context).size.width * 0.004,
                    ),
                  ),
                ),
                child: Text(
                  "محامي و مستشار قانوني مرخص من وزارة العدل. أمتلك خبرة واسعة في تقديم الاستشارات القانونية, و كتابة المذكرات و الاعتراضات, و صياغة العقود, و التمثيل القضائي أمام المحاكم",
                  softWrap: true,
                  style: AppText.labelSmall,
                ),
              ),
              Container(
                width: double.infinity,
                padding: AppPadding.paddingSmall,
                decoration: BoxDecoration(
                  color: AppColor.light,
                  border: Border(
                    bottom: BorderSide(
                      color: AppColor.dark.withAlpha(100),
                      width: MediaQuery.of(context).size.width * 0.004,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(
                          "حجز استشاره عن طريق:",
                          style: AppText.bodySmall.copyWith(
                            color: AppColor.dark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.015,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.005,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomButton(
                            text: "محادثة فيديو/صوت",
                            width: MediaQuery.of(context).size.width * 0.43,
                            height: MediaQuery.of(context).size.height * 0.055,
                            textStyle: AppText.bodySmall.copyWith(
                              color: AppColor.light,
                              fontWeight: FontWeight.bold,
                            ),
                            onTap: () {
                              //handle tap
                            },
                            backgroundColor: AppColor.secondary,
                            icon: Icons.photo_camera_front,
                            textColor: AppColor.dark,
                          ),
                          CustomButton(
                            textColor: AppColor.dark,
                            text: "حجز فى المكتب",
                            width: MediaQuery.of(context).size.width * 0.43,
                            height: MediaQuery.of(context).size.height * 0.055,
                            textStyle: AppText.bodySmall.copyWith(
                              color: AppColor.light,
                              fontWeight: FontWeight.bold,
                            ),
                            onTap: () {
                              //handle tap
                            },
                            backgroundColor: AppColor.secondary,
                            icon: Icons.message_outlined,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: AppPadding.paddingSmall,
                decoration: BoxDecoration(
                  color: AppColor.light,
                  border: Border(
                    bottom: BorderSide(
                      color: AppColor.dark.withAlpha(100),
                      width: MediaQuery.of(context).size.width * 0.004,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(
                          "التقيمات:",
                          style: AppText.bodySmall.copyWith(
                            color: AppColor.dark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.015,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.005,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("4.48/5", style: AppText.headingMedium),
                              Text("29 تقيمات"),
                            ],
                          ),
                          Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RatingBarIndicator(
                                      rating: 2.5,
                                      itemBuilder: (context, index) => Icon(
                                        Icons.star,
                                        color: AppColor.secondary,
                                      ),
                                      itemCount: 5,
                                      itemSize: 20.0,
                                      direction: Axis.horizontal,
                                    ),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.02,
                                    ),
                                    Flexible(
                                      child: Stack(
                                        children: [
                                          Container(
                                            height:
                                                MediaQuery.of(
                                                  context,
                                                ).size.height *
                                                0.01,

                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                          FractionallySizedBox(
                                            widthFactor:
                                                .5, //دى النسبه هنحسبها ب fun بعدين
                                            child: Container(
                                              height:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.height *
                                                  0.01,

                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    AppColor.grey,
                                                    AppColor.secondary,
                                                  ],
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                ),

                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.02,
                                    ),
                                    Text("100%"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Container(
                  width: double.infinity,
                  padding: AppPadding.paddingSmall,
                  decoration: BoxDecoration(
                    color: AppColor.light,
                    border: Border(
                      bottom: BorderSide(
                        color: AppColor.dark.withAlpha(100),
                        width: MediaQuery.of(context).size.width * 0.004,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "المراجعات:",
                            style: AppText.bodySmall.copyWith(
                              color: AppColor.dark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: reviews.length,
                          itemBuilder: (context, index) {
                            final review = reviews[index];
                            return Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              decoration: BoxDecoration(color: AppColor.grey),
                              child: Padding(
                                padding: AppPadding.paddingSmall,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            review["name"],
                                            style: AppText.bodySmall.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: AppColor.dark,
                                            ),
                                          ),
                                          SizedBox(
                                            height:
                                                MediaQuery.of(
                                                  context,
                                                ).size.height *
                                                0.005,
                                          ),
                                          Text(
                                            review["comment"],
                                            style: AppText.bodySmall.copyWith(
                                              color: AppColor.dark,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    RatingBarIndicator(
                                      rating: review["rating"],
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: AppColor.secondary,
                                      ),
                                      itemCount: 5,
                                      itemSize:
                                          MediaQuery.of(context).size.width *
                                          0.05,
                                      direction: Axis.horizontal,
                                    ),
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
            ],
          ),
        ),
      ),
    );
  }
}
