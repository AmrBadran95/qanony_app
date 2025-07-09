import 'package:flutter/material.dart';
import 'package:qanony/Core/widgets/custom_text_field.dart';

class CreditCardForm extends StatelessWidget {
  const CreditCardForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const CustomTextField(label: 'رقم البطاقة'),
        const SizedBox(height: 15),
        Row(
          children: const [
            Expanded(child: CustomTextField(label: 'تاريخ الانتهاء')),
            SizedBox(width: 8),
            Expanded(child: CustomTextField(label: 'CVV')),
          ],
        ),
        const SizedBox(height: 15),
        const CustomTextField(label: 'العنوان'),
      ],
    );
  }
}
