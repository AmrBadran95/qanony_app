import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/core/styles/padding.dart';
import 'package:qanony/core/widgets/role_container.dart';
import 'package:qanony/presentation/screens/sign_in.dart';
import 'package:qanony/services/cubits/role/role_cubit.dart';

class ChooseRoleScreen extends StatelessWidget {
  const ChooseRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<RoleCubit, RoleState>(
        listener: (context, state) {
          if (state is RoleSelected) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SignInScreen()),
            );
          }
        },
        child: Container(
          padding: AppPadding.paddingExtraLarge,
          width: double.infinity,
          height: double.infinity,
          color: AppColor.grey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RoleContainer(
                color: AppColor.primary,
                onTap: () {
                  context.read<RoleCubit>().selectLawyerRole();
                },
                text1: "أنا محامى",
                text2:
                    "كمحامٍ، يمكنك تقديم خدماتك، إدارة جلساتك، والتواصل مع عملائك بسهولة.",
                text3: "ابدأ رحلتك القانونية الآن.",
              ),
              RoleContainer(
                color: AppColor.secondary,
                onTap: () {
                  context.read<RoleCubit>().selectUserRole();
                },
                text1: "أنا عميل",
                text2:
                    "كعميل، يمكنك حجز جلسة مع محامٍ، طرح استشاراتك، وتتبع حالتك القانونية بكل سهولة.",
                text3: "ابدأ رحلتك نحو حل قانوني واضح.",
                textColor: AppColor.dark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
