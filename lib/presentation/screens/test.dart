import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Core/styles/color.dart';
import '../../Core/styles/padding.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return  ListTile(
      contentPadding: EdgeInsets.all(AppPadding.small),
      tileColor: AppColor.light,
      leading: CircleAvatar(
        backgroundColor: AppColor.grey,
        backgroundImage: NetworkImage(
          lawyer.profilePictureUrl!,
        ),

        radius: 30,
      ),
      title:
      Text(
        lawyer.fullName.toString(),
        style: AppText.bodySmall.copyWith(
          color: AppColor.dark,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "النوع: ${lawyer.gender}",
            style: AppText.bodySmall.copyWith(
              color: AppColor.dark,
            ),
          ),
          SizedBox(width: 5),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "التواصل عبر: ",
                  style: AppText.bodySmall.copyWith(
                    color: AppColor.dark,
                  ),
                ),
                TextSpan(
                  text:
                  lawyer.offersCall == true &&
                      lawyer.offersOffice == true
                      ? "مكالمة صوتية/فيديو أو عبر المكتب"
                      : lawyer.offersCall == true
                      ? "مكالمة صوتية/فيديو"
                      : lawyer.offersOffice == true
                      ? "عبر المكتب"
                      : "لا توجد وسيلة تواصل محددة",
                  style: AppText.labelSmall.copyWith(
                    color: AppColor.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          RatingBarIndicator(
            rating: 2.5,
            itemBuilder: (context, index) =>
                Icon(Icons.star, color: AppColor.secondary),
            itemCount: 5,
            itemSize: 15.0,
            direction: Axis.horizontal,
          ),
        ],
      ),
      trailing:
      RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "السعر: ",
              style: AppText.bodySmall.copyWith(
                color: AppColor.dark,
              ),
            ),
            TextSpan(
              text:
              (lawyer.callPrice != null &&
                  lawyer.officePrice != null)
                  ? "مكالمة: ${lawyer.callPrice} جنيه\nمكتب: ${lawyer.officePrice} جنيه"
                  : (lawyer.callPrice != null)
                  ? "مكالمة: ${lawyer.callPrice} جنيه"
                  : (lawyer.officePrice != null)
                  ? "مكتب: ${lawyer.officePrice} جنيه"
                  : "لا توجد وسيلة تواصل محددة",
              style: AppText.labelSmall.copyWith(
                color: AppColor.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ),;
  }
}
