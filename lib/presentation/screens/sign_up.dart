import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            resizeToAvoidBottomInset: true,
            backgroundColor: AppColor.grey,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: AppPadding.paddingLarge,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 40.h,),
                          Text(
                            'مرحباً , سجل للانضمام إلينا',
                            style: AppText.headingMedium.copyWith(
                              color: AppColor.primary,
                            ),
                          ),
                          SizedBox(height: 50.h),
                          Form(
                            key: SignUpFormKey.formKey,
                            child: Column(
                              children: [
                                CustomTextFormField(
                                  logo:  Icon(
                                    Icons.email_outlined,
                                    color: AppColor.dark,
                                    size: 24.sp,
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
                                  height: 60.sp,
                                  backgroundColor: AppColor.light,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: AppValidators.validateEmail,
                                ),
                                 SizedBox(height: 20.h),
                                CustomTextFormField(
                                  logo:  Icon(
                                    Icons.phone,
                                    color: AppColor.dark,
                                    size: 24.sp,
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
                                  height: 60.sp,
                                  backgroundColor: AppColor.light,
                                  keyboardType: TextInputType.phone,
                                  validator: AppValidators.validatePhone,
                                ),
                                SizedBox(height: 20.h),
                                CustomTextFormField(
                                  logo:  Icon(
                                    Icons.visibility_off,
                                    color: AppColor.dark,
                                    size: 24.sp,
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
                                  height: 60.sp,
                                  backgroundColor: AppColor.light,
                                  obscureText: true,
                                  keyboardType: TextInputType.visiblePassword,
                                  validator: AppValidators.validatePassword,
                                ),
                                 SizedBox(height: 20.h),
                                CustomTextFormField(
                                  logo:  Icon(
                                    Icons.visibility_off,
                                    color: AppColor.dark,
                                    size: 24.sp,
                                  ),
                                  label: 'تأكيد كلمة المرور',
                                  controller: SignUpControllers
                                      .confirmPasswordController,
                                  textStyle: AppText.bodyMedium.copyWith(
                                    color: AppColor.dark,
                                  ),
                                  labelStyle: AppText.bodyMedium.copyWith(
                                    color: AppColor.dark,
                                  ),
                                  contentPadding: AppPadding.paddingMedium,
                                  width: double.infinity,
                                  height: 60.sp,
                                  backgroundColor: AppColor.light,
                                  obscureText: true,
                                  keyboardType: TextInputType.visiblePassword,
                                  validator: (value) =>
                                      AppValidators.validateConfirmPassword(
                                        value,
                                        SignUpControllers
                                            .passwordController
                                            .text,
                                      ),
                                ),
                                 SizedBox(height: 30.h),
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
                                        SignUpControllers
                                            .passwordController
                                            .text
                                            .trim(),
                                      );
                                    }
                                  },
                                  width: double.infinity,
                                  height: 50.sp,
                                  backgroundColor: AppColor.primary,
                                  textStyle: AppText.title.copyWith(
                                    color: AppColor.light,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30.h),
                          Center(
                            child: Text.rich(
                              TextSpan(
                                text: 'هل لديك حساب؟ ',
                                style: AppText.bodySmall.copyWith(color:AppColor.dark),

                                children: [
                                  TextSpan(
                                    text: 'تسجيل دخول',
                                    style: AppText.bodySmall.copyWith(
                                      color: AppColor.primary,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const SignInScreen(),
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
            ),
          );
        },
      ),
    );
  }
}
