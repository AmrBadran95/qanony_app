import 'package:flutter/material.dart';
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
        title: Text('اختر $label'),
        content: SizedBox(
          height: 200,
          width: double.maxFinite,
          child: ListView(
            children: items.map((item) {
              return RadioListTile<String>(
                title: Text(item),
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
        width: 120,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
