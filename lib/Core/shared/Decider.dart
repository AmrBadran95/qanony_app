import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanony/presentation/screens/choose_role_screen.dart';
import '../../presentation/screens/onboarding.dart';
import '../../services/cubits/decider/decider_cubit.dart';

class Decider extends StatelessWidget {
  const Decider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DeciderCubit()..checkDeciderState(),
      child: BlocListener<DeciderCubit, DeciderState>(
        listener: (context, state) {
          if (state is DeciderOnboarding) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const Onboarding()),
            );
          } else if (state is DeciderChooseRole) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ChooseRoleScreen()),
            );
          }
        },
        child: const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
    );
  }
}
