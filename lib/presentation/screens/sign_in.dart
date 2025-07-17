import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/widgets/custom_button.dart';
import 'package:qanony/Core/widgets/custom_text_form_field.dart';
import '../../services/controllers/signin_form_controller.dart';
import '../../services/validators/form_Validators.dart';
import 'lawyer_home_screen.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColor.grey,
      body: SafeArea(
        child: Padding(
          padding: AppPadding.paddingLarge,
          child: Container(
            width: double.infinity,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text(
                  'مرحباً بعودتك',
                  style: AppText.appHeading.copyWith(color: AppColor.primary),
                ),

                SizedBox(height:40 ,),
                Form(
                  key:SignFormKey.formKey ,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextFormField(
                        logo: const Icon(Icons.email_outlined),
                        label: 'البريد الالكتروني',
                        controller: SignInControllers.emailController,
                        textStyle: AppText.bodyMedium.copyWith(color: AppColor.dark),
                        labelStyle: AppText.bodyMedium.copyWith(color: AppColor.dark),
                        contentPadding: AppPadding.paddingMedium,
                        width: double.infinity,
                        height: 60,
                        backgroundColor: AppColor.light,
                        keyboardType: TextInputType.emailAddress,
                        validator: AppValidators.validateEmail,
                      ),

                      const SizedBox(height: 16),

                      CustomTextFormField(
                        logo: const Icon(Icons.password_outlined),
                        label: 'كلمة المرور',
                        controller: SignInControllers.passwordController,
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

                      CustomButton(
                        text: 'تسجيل الدخول',
                        onTap: () {

                            if (SignFormKey.formKey.currentState!.validate()) {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => LawyerHomeScreen()));
                          }

                        },
                        width: double.infinity,
                        height: 60,
                        backgroundColor: AppColor.primary,
                        textStyle: AppText.bodyMedium.copyWith(
                          color: AppColor.light,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height:30 ,),


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


              ],
            ),
          ),
        ),
      ),
    );
  }
}
