import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/core/styles/text.dart';

class SelectionDialog extends StatelessWidget {
  final String label;
  final List<String> items;
  final String? value;
  final Function(String?) onChanged;

  const SelectionDialog({
    super.key,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  void _showSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('اختر $label',
            style: AppText.title.copyWith(color: AppColor.dark)),

        content: SizedBox(
          height: 200.h,
          width: double.maxFinite,
          child: ListView(
            children: items.map((item) {
              return RadioListTile<String>(
                activeColor: AppColor.green,
                title: Text(
                  item,
                  style: AppText.bodySmall.copyWith(color: AppColor.dark),
                ),
                value: item,
                groupValue: value,
                onChanged: (val) {
                  onChanged(val);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showSelectionDialog(context),
      child: Container(
        width: 120.w,
        padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 10.sp),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.grey),
          color: AppColor.light,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value ?? label,
                style: AppText.bodySmall.copyWith(color: AppColor.dark),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
