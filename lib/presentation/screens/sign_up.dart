import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanony/Core/shared/app_cache.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/widgets/custom_button.dart';
import 'package:qanony/Core/widgets/custom_text_form_field.dart';
import 'package:qanony/presentation/screens/lawyer_information.dart';
import 'package:qanony/presentation/screens/sign_in.dart';
import 'package:qanony/presentation/screens/user_home_screen.dart';
import 'package:qanony/services/cubits/auth_cubit/auth_cubit.dart';
import 'package:qanony/services/cubits/date_of_birth/date_of_birth_cubit.dart';
import 'package:qanony/services/cubits/lawyer_confirmation/lawyer_confirmation_cubit.dart';
import 'package:qanony/services/cubits/registration_date/registration_date_cubit.dart';
import 'package:qanony/services/cubits/user_confirmation/user_confirmation_cubit.dart';
import '../../services/controllers/signup_form_controller.dart';
import '../../services/validators/signin_signup_validators.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthRegistered) {
            final uid = state.uid;
            final email = SignUpControllers.emailController.text.trim();
            final phone = SignUpControllers.phoneController.text.trim();
            AppCache.savePhone(SignUpControllers.phoneController.text.trim());

            if (AppCache.isLawyer) {
              final dateOfBirthCubit = DateOfBirthCubit();
              final registrationDateCubit = RegistrationDateCubit();

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => MultiBlocProvider(
                    providers: [
                      BlocProvider<DateOfBirthCubit>.value(
                        value: dateOfBirthCubit,
                      ),
                      BlocProvider<RegistrationDateCubit>.value(
                        value: registrationDateCubit,
                      ),
                      BlocProvider(
                        create: (_) => LawyerConfirmationCubit(
                          uid: uid,
                          email: email,
                          phone: phone,
                          dateOfBirthCubit: dateOfBirthCubit,
                          registrationDateCubit: registrationDateCubit,
                        ),
                      ),
                    ],
                    child: LawyerInformation(
                      uid: uid,
                      email: email,
                      phone: phone,
                    ),
                  ),
                ),
                (route) => false,
              );
            } else {
              final userCubit = UserConfirmationCubit(
                uid: uid,
                email: email,
                phone: phone,
              );

              userCubit.submitUserData(uid: uid, email: email, phone: phone);

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: userCubit,
                    child: const UserHomeScreen(),
                  ),
                ),
                (route) => false,
              );
            }
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: AppText.bodySmall.copyWith(color: AppColor.primary),
                ),
                backgroundColor: AppColor.grey,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Scaffold(
            backgroundColor: AppColor.grey,
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.06,
                    vertical: screenHeight * 0.02,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'مرحباً , سجل للانضمام إلينا',
                          style: AppText.headingMedium.copyWith(
                            color: AppColor.primary,
                            fontSize: screenWidth * 0.05,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.06),
                        Form(
                          key: SignUpFormKey.formKey,
                          child: Column(
                            children: [
                              CustomTextFormField(
                                logo: const Icon(
                                  Icons.email_outlined,
                                  color: AppColor.dark,
                                ),
                                label: 'البريد الالكتروني',
                                controller: SignUpControllers.emailController,
                                textStyle: AppText.bodyMedium.copyWith(
                                  color: AppColor.dark,
                                ),
                                labelStyle: AppText.bodyMedium.copyWith(
                                  color: AppColor.dark,
                                ),
                                contentPadding: EdgeInsets.all(
                                  screenWidth * 0.04,
                                ),
                                width: double.infinity,
                                height: screenHeight * 0.07,
                                backgroundColor: AppColor.light,
                                keyboardType: TextInputType.emailAddress,
                                validator: AppValidators.validateEmail,
                              ),
                              SizedBox(height: screenHeight * 0.025),
                              CustomTextFormField(
                                logo: const Icon(
                                  Icons.phone,
                                  color: AppColor.dark,
                                ),
                                label: 'رقم الهاتف',
                                controller: SignUpControllers.phoneController,
                                textStyle: AppText.bodyMedium.copyWith(
                                  color: AppColor.dark,
                                ),
                                labelStyle: AppText.bodyMedium.copyWith(
                                  color: AppColor.dark,
                                ),
                                contentPadding: EdgeInsets.all(
                                  screenWidth * 0.04,
                                ),
                                width: double.infinity,
                                height: screenHeight * 0.07,
                                backgroundColor: AppColor.light,
                                keyboardType: TextInputType.phone,
                                validator: AppValidators.validatePhone,
                              ),
                              SizedBox(height: screenHeight * 0.025),
                              CustomTextFormField(
                                logo: const Icon(
                                  Icons.visibility_off,
                                  color: AppColor.dark,
                                ),
                                label: 'كلمة المرور',
                                controller:
                                    SignUpControllers.passwordController,
                                textStyle: AppText.bodyMedium.copyWith(
                                  color: AppColor.dark,
                                ),
                                labelStyle: AppText.bodyMedium.copyWith(
                                  color: AppColor.dark,
                                ),
                                contentPadding: EdgeInsets.all(
                                  screenWidth * 0.04,
                                ),
                                width: double.infinity,
                                height: screenHeight * 0.07,
                                backgroundColor: AppColor.light,
                                obscureText: true,
                                keyboardType: TextInputType.visiblePassword,
                                validator: AppValidators.validatePassword,
                              ),
                              SizedBox(height: screenHeight * 0.025),
                              CustomTextFormField(
                                logo: const Icon(
                                  Icons.visibility_off,
                                  color: AppColor.dark,
                                ),
                                label: 'تأكيد كلمة المرور',
                                controller:
                                    SignUpControllers.confirmPasswordController,
                                textStyle: AppText.bodyMedium.copyWith(
                                  color: AppColor.dark,
                                ),
                                labelStyle: AppText.bodyMedium.copyWith(
                                  color: AppColor.dark,
                                ),
                                contentPadding: EdgeInsets.all(
                                  screenWidth * 0.04,
                                ),
                                width: double.infinity,
                                height: screenHeight * 0.07,
                                backgroundColor: AppColor.light,
                                obscureText: true,
                                keyboardType: TextInputType.visiblePassword,
                                validator: (value) =>
                                    AppValidators.validateConfirmPassword(
                                      value,
                                      SignUpControllers.passwordController.text,
                                    ),
                              ),
                              SizedBox(height: screenHeight * 0.04),
                              CustomButton(
                                text: isLoading
                                    ? '...جارٍ تسجيل الحساب'
                                    : 'تسجيل الحساب',
                                onTap: () {
                                  if (SignUpFormKey.formKey.currentState!
                                      .validate()) {
                                    context.read<AuthCubit>().register(
                                      SignUpControllers.emailController.text
                                          .trim(),
                                      SignUpControllers.passwordController.text
                                          .trim(),
                                    );
                                  }
                                },
                                width: double.infinity,
                                height: screenHeight * 0.065,
                                backgroundColor: AppColor.primary,
                                textStyle: AppText.title.copyWith(
                                  color: AppColor.light,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        Center(
                          child: Text.rich(
                            TextSpan(
                              text: 'هل لديك حساب بالفعل؟ ',
                              style: AppText.bodySmall.copyWith(
                                fontSize: screenWidth * 0.035,
                              ),
                              children: [
                                TextSpan(
                                  text: 'تسجيل دخول',
                                  style: AppText.bodyMedium.copyWith(
                                    color: AppColor.primary,
                                    fontSize: screenWidth * 0.037,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const SignInScreen(),
                                        ),
                                      );
                                    },
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
        },
      ),
    );
  }
}
