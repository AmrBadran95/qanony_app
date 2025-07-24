import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/Core/widgets/custom_button.dart';
import 'package:qanony/Core/widgets/custom_text_form_field.dart';
import 'package:qanony/presentation/pages/lawyer_base_screen.dart';
import 'package:qanony/presentation/screens/lawyer_account.dart';
import 'package:qanony/presentation/screens/lawyer_information.dart';
import 'package:qanony/presentation/screens/sign_up.dart';
import 'package:qanony/presentation/screens/user_home_screen.dart';
import 'package:qanony/presentation/screens/waiting_page.dart';
import 'package:qanony/presentation/screens/waiting_page_failed.dart';
import 'package:qanony/services/cubits/auth_cubit/auth_cubit.dart';

import '../../services/controllers/signin_form_controller.dart';
import '../../services/validators/signin_signup_validators.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.grey,
      body: SafeArea(
        child: Padding(
          padding: AppPadding.paddingLarge,
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthLoggedIn) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const UserHomeScreen()),
                  (route) => false,
                );
              }

              if (state is AuthLoggedInWithStatus) {
                if (state.status == 'pending') {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const WaitingPage()),
                    (route) => false,
                  );
                } else if (state.status == 'accepted') {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LawyerBaseScreen(
                        body: AccountLawyerScreen(),
                        selectedIndex: 0,
                      ),
                    ), // LawyerHomeScreen
                    (route) => false,
                  );
                } else if (state.status == 'rejected') {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const WaitingPageFailed(),
                    ),
                    (route) => false,
                  );
                }
              }

              if (state is AuthLawyerNeedsInfo) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LawyerInformation(
                      uid: state.uid,
                      email: state.email,
                      phone: state.phone,
                    ),
                  ),
                  (route) => false,
                );
              }

              if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.message,
                      style: AppText.bodySmall.copyWith(
                        color: AppColor.primary,
                      ),
                    ),
                    backgroundColor: AppColor.grey,
                  ),
                );
              }
            },

            builder: (context, state) {
              final isLoading = state is AuthLoading;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'مرحباً بعودتك',
                    style: AppText.appHeading.copyWith(color: AppColor.primary),
                  ),
                  const SizedBox(height: 40),
                  Form(
                    key: SignFormKey.formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        CustomTextFormField(
                          logo: const Icon(Icons.email_outlined),
                          label: 'البريد الالكتروني',
                          controller: SignInControllers.emailController,
                          textStyle: AppText.bodyMedium.copyWith(
                            color: AppColor.dark,
                          ),
                          labelStyle: AppText.bodyMedium.copyWith(
                            color: AppColor.dark,
                          ),
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
                          textStyle: AppText.bodyMedium.copyWith(
                            color: AppColor.dark,
                          ),
                          labelStyle: AppText.bodyMedium.copyWith(
                            color: AppColor.dark,
                          ),
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
                          text: isLoading ? '...جارٍ الدخول' : 'تسجيل الدخول',
                          onTap: () {
                            if (isLoading) return;

                            if (SignFormKey.formKey.currentState!.validate()) {
                              final email = SignInControllers
                                  .emailController
                                  .text
                                  .trim();
                              final password = SignInControllers
                                  .passwordController
                                  .text
                                  .trim();
                              context.read<AuthCubit>().login(email, password);
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
                  const SizedBox(height: 30),
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
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SignUpScreen(),
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
