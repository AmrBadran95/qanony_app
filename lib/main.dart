import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/firebase_options.dart';
import 'package:qanony/presentation/pages/lawyer_base_screen.dart';
import 'package:qanony/presentation/screens/appointment_lawyer.dart';
import 'package:qanony/services/cubits/appointments/appointments_cubit.dart';
import 'package:qanony/services/cubits/auth_cubit/auth_cubit.dart';
import 'package:qanony/services/cubits/lawyer_info/lawyer_info_cubit.dart';
import 'package:qanony/services/cubits/role/role_cubit.dart';
import 'package:qanony/services/cubits/splash/splash_cubit.dart';
import 'package:qanony/services/firestore/lawyer_firestore_service.dart';

import 'Core/shared/app_cache.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppCache.init();

  final key =
      "pk_test_51RmfujBCYVFzcUuX9HnRrvPp4PQkTb30GuFpqnQu7uHfGYGJzHIiiw0eUD9HYu6fg6SZu5MTxCYiNnGpP4TOM2ki00WIIZy1Fu";
  try {
    Stripe.publishableKey = key;
  } catch (e) {
    print("Stripe error: $e");
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const QanonyApp());
}

class QanonyApp extends StatelessWidget {
  const QanonyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SplashCubit()),
        BlocProvider(create: (_) => RoleCubit()..loadSavedRole()),
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(
          create: (context) => LawyerInfoCubit(LawyerFirestoreService()),
        ),
        BlocProvider(create: (_) => AppointmentsCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        title: 'قانوني',

        theme: ThemeData(
          fontFamily: 'Cairo',

          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: AppColor.primary,
            selectionColor: AppColor.darkgrey,
            selectionHandleColor: AppColor.primary,
          ),
          inputDecorationTheme: const InputDecorationTheme(
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColor.dark),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColor.dark),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColor.dark, width: 2),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColor.primary),
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColor.dark, width: 2),
            ),
            hintStyle: TextStyle(color: AppColor.dark),
            labelStyle: TextStyle(color: AppColor.dark),
          ),
        ),
        locale: const Locale('ar', 'EG'),
        supportedLocales: const [Locale('ar', 'EG'), Locale('en', 'US')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },

        home: LawyerBaseScreen(body: AppointmentLawyer(), selectedIndex: 2),
      ),
    );
  }
}
