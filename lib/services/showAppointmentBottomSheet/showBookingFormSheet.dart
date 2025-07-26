import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qanony/Core/styles/padding.dart';

import '../../Core/styles/color.dart';
import '../../Core/styles/text.dart';
import '../../Core/widgets/custom_button.dart';
import '../../Core/widgets/custom_text_form_field.dart';
import '../../data/static/case_types.dart';
import '../../presentation/pages/selection_dialog.dart';

void showBookingForm({
  required BuildContext context,
  required String bookingType,
  required String price,
  required String day,
  required String date,
  required String time,

}) {
  final nameController = TextEditingController();
  final problemController = TextEditingController();
  String? selectedCaseType;
  String? selectedSpecialty;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (context) {
      return Padding(
        padding: AppPadding.paddingLarge,
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                 Padding(
                   padding: AppPadding.paddingSmall,
                   child: Center(
                     child: Text(
                      " يرجى ادخال معلوماتك  ",
                      style: AppText.title.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColor.primary,

                      ),
                                     ),
                   ),
                 ),
                SizedBox(height: 10),
                CustomTextFormField(
                  label: "اسم المستخدم",
                  controller: nameController,
                  textStyle: AppText.bodyMedium,
                  labelStyle: AppText.bodyMedium,
                  backgroundColor: AppColor.light,
                  contentPadding: AppPadding.paddingSmall,
                  width: double.infinity,
                ),
                SizedBox(height: 16),
                CustomTextFormField(
                  label: "وصف المشكلة",
                  controller: problemController,
                  maxLines: 2,
                  textStyle: AppText.bodyMedium,
                  labelStyle: AppText.bodySmall,
                  backgroundColor:  AppColor.light,
                  contentPadding: AppPadding.paddingSmall,
                  width: double.infinity,
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: SelectionDialog(
                    label:" التخصص",
                    items: caseTypes, // تأكدي إن دي الليست اللي فيها التخصصات
                    value: selectedSpecialty,
                    onChanged: (val) {
                      selectedSpecialty = val;
                    },
                  ),
                ),
                SizedBox(height: 16),

                _buildDisabledField("نوع الحجز", bookingType),
                _buildDisabledField("السعر", price),
                _buildDisabledField("اليوم", day),
                _buildDisabledField("التاريخ", date),
                _buildDisabledField("الساعة", time),

                SizedBox(height: 24),

                CustomButton(
                  text: "تأكيد الحجز",
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.045,
                  textStyle: AppText.bodyLarge.copyWith(
                    color: AppColor.light,
                  ),
                  onTap: () {
                  },
                  backgroundColor: AppColor.primary,
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildDisabledField(String label, String value) {
  return Padding(
    padding: AppPadding.verticalSmall,
    child: TextFormField(
       initialValue: value,
       readOnly: true,
       enabled: false,
       decoration: InputDecoration(
        labelText: label,
        labelStyle: AppText.bodyMedium.copyWith(color: AppColor.primary),
        filled: true,
        fillColor:AppColor.grey,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),

      ),
      style: AppText.bodyMedium,
    ),
  );
}
