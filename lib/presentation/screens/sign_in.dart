import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/widgets/custom_button.dart';
import 'package:qanony/Core/widgets/custom_text_form_field.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

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
                'مرحباً بعودتك',
                style: AppText.appHeading.copyWith(color: AppColor.primary),
              ),

              const Spacer(),

              CustomTextFormField(
                logo: const Icon(Icons.email_outlined),
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
                logo: const Icon(Icons.password_outlined),
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

              const Spacer(),

              CustomButton(
                text: 'تسجيل الدخول',
                onTap: () {},
                width: double.infinity,
                height: 55,
                backgroundColor: AppColor.primary,
                textStyle: AppText.bodyMedium.copyWith(
                  color: AppColor.light,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Spacer(),

              Center(
                child: Text.rich(
                  TextSpan(
                    text: 'ليس لديك حساب؟ ',
                    style: AppText.bodySmall,
                    children: [
                      TextSpan(
                        text: 'تسجيل الحساب',
                        style: AppText.bodySmall.copyWith(
                          color: AppColor.primary,
                          fontWeight: FontWeight.w600,
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
