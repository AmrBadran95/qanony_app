import 'package:flutter/material.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/styles/text.dart';

class PaymentMethodOption extends StatelessWidget {
  final String selectedMethod;
  final String method;
  final IconData icon;
  final String label;
  final VoidCallback onChanged;

  const PaymentMethodOption({
    super.key,
    required this.selectedMethod,
    required this.method,
    required this.icon,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged,
      child: Container(
        padding: AppPadding.paddingMedium,
        height: 80,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColor.light,
          border: Border.all(
            color: selectedMethod == method ? AppColor.primary : Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: AppColor.dark),
            Text(label, style: AppText.title.copyWith(color: AppColor.dark)),
            Radio<String>(
              activeColor: AppColor.dark,
              value: method,
              groupValue: selectedMethod,
              onChanged: (_) => onChanged(),
            ),
          ],
        ),
      ),
    );
  }
}
