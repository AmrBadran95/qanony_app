import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/widgets/custom_button.dart';
import 'package:qanony/Core/widgets/custom_text_form_field.dart';

import '../../services/controllers/signUpFormController.dart';
import '../../services/validators/form_Validators.dart';
import 'lawyer_home_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColor.grey,
      body: SafeArea(
        child: Center(

          child: Padding(
            padding: AppPadding.paddingLarge,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'مرحباً , سجل للانضمام إلينا',
                    style: AppText.headingMedium.copyWith(color: AppColor.primary),
                  ),
                  SizedBox(height: 50,),
                  Form(
                    key: SignUpFormKey.formKey,
                    child: Column(
                      children: [
                        CustomTextFormField(
                          logo: const Icon(Icons.email_outlined, color: AppColor.dark),
                          label: 'البريد الالكتروني',
                          controller: SignUpControllers.emailController,
                          textStyle: AppText.bodyMedium.copyWith(color: AppColor.dark),
                          labelStyle: AppText.bodyMedium.copyWith(color: AppColor.dark),
                          contentPadding: AppPadding.paddingMedium,
                          width: double.infinity,
                          height: 60,
                          backgroundColor: AppColor.light,
                          keyboardType: TextInputType.emailAddress,
                          validator: AppValidators.validateEmail,
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          logo: const Icon(Icons.phone, color: AppColor.dark),
                          label: 'رقم الهاتف',
                          controller: SignUpControllers.phoneController,
                          textStyle: AppText.bodyMedium.copyWith(color: AppColor.dark),
                          labelStyle: AppText.bodyMedium.copyWith(color: AppColor.dark),
                          contentPadding: AppPadding.paddingMedium,
                          width: double.infinity,
                          height: 60,
                          backgroundColor: AppColor.light,
                          keyboardType: TextInputType.phone,
                          validator: AppValidators.validatePhone,

                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          logo: const Icon(Icons.visibility_off, color: AppColor.dark),
                          label: 'كلمة المرور',
                          controller: SignUpControllers.passwordController,
                          textStyle: AppText.bodyMedium.copyWith(color: AppColor.dark),
                          labelStyle: AppText.bodyMedium.copyWith(color: AppColor.dark),
                          contentPadding: AppPadding.paddingMedium,
                          width: double.infinity,
                          height: 60,
                          backgroundColor: AppColor.light,
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          validator: AppValidators.validatePassword,
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          logo: const Icon(Icons.visibility_off, color: AppColor.dark),
                          label: 'تأكيد كلمة المرور',
                          controller: SignUpControllers.confirmPasswordController,
                          textStyle: AppText.bodyMedium.copyWith(color: AppColor.dark),
                          labelStyle: AppText.bodyMedium.copyWith(color: AppColor.dark),
                          contentPadding: AppPadding.paddingMedium,
                          width: double.infinity,
                          height: 60,
                          backgroundColor: AppColor.light,
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) => AppValidators.validateConfirmPassword(
                            value,
                            SignUpControllers.passwordController.text,
                          ),
                        ),
                        const SizedBox(height: 30),
                        CustomButton(
                          text: 'تسجيل الحساب',
                          onTap: () {
                            if (SignUpFormKey.formKey.currentState!.validate()) {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => LawyerHomeScreen()));
                            }
                          },
                          width: double.infinity,
                          height: 55,
                          backgroundColor: AppColor.primary,
                          textStyle: AppText.title.copyWith(color: AppColor.light),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
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

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
