import 'dart:math';
import 'package:flutter/material.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/Core/widgets/custom_button.dart';
import 'package:qanony/Core/widgets/payment_details_container.dart';
import 'package:qanony/Core/widgets/payment_method_option.dart';

class PaymentMethodLawyerScreen extends StatefulWidget {
  const PaymentMethodLawyerScreen({super.key});

  @override
  State<PaymentMethodLawyerScreen> createState() =>
      _PaymentMethodLawyerScreenState();
}

class _PaymentMethodLawyerScreenState extends State<PaymentMethodLawyerScreen> {
  String _selectedMethod = 'credit_card';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColor.grey,
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'طرق الدفع',
          style: AppText.headingLarge.copyWith(color: AppColor.light),
        ),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back, color: AppColor.light),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppPadding.paddingMedium,
          child: Column(
            children: [
              PaymentMethodOption(
                selectedMethod: _selectedMethod,
                method: 'credit_card',
                icon: Icons.credit_card,
                label: 'بطاقة ائتمان',
                onChanged: () {
                  setState(() => _selectedMethod = 'credit_card');
                },
              ),
              PaymentMethodOption(
                selectedMethod: _selectedMethod,
                method: 'bank_transfer',
                icon: Icons.account_balance,
                label: 'تحويل بنكي',
                onChanged: () {
                  setState(() => _selectedMethod = 'bank_transfer');
                },
              ),
              const SizedBox(height: 16),
              PaymentDetailsContainer(
                selectedMethod: _selectedMethod,
                maxHeight: min(size.height * 0.45, 280),
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'متابعة الدفع',
                onTap: () {},
                width: double.infinity,
                height: 50,
                backgroundColor: AppColor.primary,
                textStyle: AppText.title,
                textColor: AppColor.light,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
