import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/Core/styles/text.dart';
import 'package:qanony/Core/styles/padding.dart';
import 'package:qanony/Core/widgets/custom_button.dart';
import 'package:qanony/Core/widgets/custom_text_form_field.dart';
import 'package:qanony/presentation/screens/lawyer_information.dart';
import 'package:qanony/services/cubits/auth_cubit/auth_cubit.dart';
import 'package:qanony/services/cubits/date_of_birth/date_of_birth_cubit.dart';
import 'package:qanony/services/cubits/lawyer_confirmation/lawyer_confirmation_cubit.dart';
import 'package:qanony/services/cubits/registration_date/registration_date_cubit.dart';
import '../../services/controllers/signup_form_controller.dart';
import '../../services/validators/signin_signup_validators.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthRegistered) {
            final dateOfBirthCubit = DateOfBirthCubit();
            final registrationDateCubit = RegistrationDateCubit();

            Navigator.pushReplacement(
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
                        uid: state.uid,
                        email: SignUpControllers.emailController.text.trim(),
                        phone: SignUpControllers.phoneController.text.trim(),
                        dateOfBirthCubit: dateOfBirthCubit,
                        registrationDateCubit: registrationDateCubit,
                      ),
                    ),
                  ],
                  child: LawyerInformation(
                    uid: state.uid,
                    email: SignUpControllers.emailController.text.trim(),
                    phone: SignUpControllers.phoneController.text.trim(),
                  ),
                ),
              ),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: AppText.bodyLarge.copyWith(color: AppColor.primary),
                ),
                backgroundColor: AppColor.grey,
              ),
            );
          }
        },
        builder: (context, state) {
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
                          style: AppText.headingMedium.copyWith(
                            color: AppColor.primary,
                          ),
                        ),
                        SizedBox(height: 50),
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
                                contentPadding: AppPadding.paddingMedium,
                                width: double.infinity,
                                height: 60,
                                backgroundColor: AppColor.light,
                                keyboardType: TextInputType.emailAddress,
                                validator: AppValidators.validateEmail,
                              ),
                              const SizedBox(height: 20),
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
                                contentPadding: AppPadding.paddingMedium,
                                width: double.infinity,
                                height: 60,
                                backgroundColor: AppColor.light,
                                keyboardType: TextInputType.phone,
                                validator: AppValidators.validatePhone,
                              ),
                              const SizedBox(height: 20),
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
                                contentPadding: AppPadding.paddingMedium,
                                width: double.infinity,
                                height: 60,
                                backgroundColor: AppColor.light,
                                obscureText: true,
                                keyboardType: TextInputType.visiblePassword,
                                validator: (value) =>
                                    AppValidators.validateConfirmPassword(
                                      value,
                                      SignUpControllers.passwordController.text,
                                    ),
                              ),
                              const SizedBox(height: 30),
                              CustomButton(
                                text: 'تسجيل الحساب',
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
                                height: 55,
                                backgroundColor: AppColor.primary,
                                textStyle: AppText.title.copyWith(
                                  color: AppColor.light,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
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
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {},
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
