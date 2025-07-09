import 'package:flutter/material.dart';
import 'package:qanony/Core/widgets/bank_transfer_form.dart';
import 'package:qanony/Core/widgets/credit_card_form.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/padding.dart';

class PaymentDetailsContainer extends StatelessWidget {
  final String selectedMethod;
  final double maxHeight;

  const PaymentDetailsContainer({
    super.key,
    required this.selectedMethod,
    required this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: SingleChildScrollView(
        child: Container(
          padding: AppPadding.paddingMedium,
          decoration: BoxDecoration(
            color: AppColor.light,
            borderRadius: BorderRadius.circular(8),
          ),
          child: selectedMethod == 'credit_card'
              ? const CreditCardForm()
              : const BankTransferForm(),
        ),
      ),
    );
  }
}
