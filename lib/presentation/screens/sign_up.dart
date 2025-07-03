import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/widgets/custom_button.dart';
import 'package:qanony/Core/widgets/custom_text_form_field.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColor.grey,
      body: SafeArea(
        child: Padding(
          padding: AppPadding.paddingLarge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              Text(
                'مرحباً , سجل للانضمام إلينا',
                style: AppText.headingMedium.copyWith(color: AppColor.primary),
              ),
              const Spacer(),

              CustomTextFormField(
                logo: const Icon(Icons.email_outlined, color: AppColor.dark),
                hintText: 'البريد الالكتروني',
                controller: emailController,
                textStyle: AppText.bodyMedium,
                hintStyle: AppText.bodyMedium.copyWith(color: AppColor.grey),
                contentPadding: AppPadding.paddingMedium,
                width: double.infinity,
                height: 60,
                backgroundColor: AppColor.light,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              CustomTextFormField(
                logo: const Icon(Icons.phone, color: AppColor.dark),
                hintText: 'رقم الهاتف',
                controller: phoneController,
                textStyle: AppText.bodyMedium,
                hintStyle: AppText.bodyMedium.copyWith(color: AppColor.grey),
                contentPadding: AppPadding.paddingMedium,
                width: double.infinity,
                height: 60,
                backgroundColor: AppColor.light,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              CustomTextFormField(
                logo: const Icon(Icons.password_outlined, color: AppColor.dark),
                hintText: 'كلمة المرور',
                controller: passwordController,
                textStyle: AppText.bodyMedium,
                hintStyle: AppText.bodyMedium.copyWith(color: AppColor.grey),
                contentPadding: AppPadding.paddingMedium,
                width: double.infinity,
                height: 60,
                backgroundColor: AppColor.light,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
              ),
              const SizedBox(height: 16),

              CustomTextFormField(
                logo: const Icon(Icons.password_outlined, color: AppColor.dark),
                hintText: 'تأكيد كلمة المرور',
                controller: confirmPasswordController,
                textStyle: AppText.bodyMedium,
                hintStyle: AppText.bodyMedium.copyWith(color: AppColor.grey),
                contentPadding: AppPadding.paddingMedium,
                width: double.infinity,
                height: 60,
                backgroundColor: AppColor.light,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
              ),

              const Spacer(),

              CustomButton(
                text: 'تسجيل الحساب',
                onTap: () {},
                width: double.infinity,
                height: 55,
                backgroundColor: AppColor.primary,
                textStyle: AppText.title.copyWith(color: AppColor.light),
              ),
              const Spacer(),

              Center(
                child: Text.rich(
                  TextSpan(
                    text: 'هل لديك حساب بالفعل؟ ',
                    style: AppText.bodySmall,
                    children: [
                      TextSpan(
                        text: 'تسجيل دخول',
                        style: AppText.bodyMedium.copyWith(
                          color: AppColor.primary,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
