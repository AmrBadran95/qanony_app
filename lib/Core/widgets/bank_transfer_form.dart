import 'package:flutter/material.dart';
import 'package:qanony/Core/widgets/custom_text_field.dart';

class BankTransferForm extends StatelessWidget {
  const BankTransferForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const CustomTextField(label: 'رقم الحساب البنكي'),
        const SizedBox(height: 15),
        const CustomTextField(label: 'اسم البنك'),
        const SizedBox(height: 15),
        const CustomTextField(label: 'اسم صاحب الحساب'),
      ],
    );
  }
}
