import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:qanony/firebase_options.dart';
import 'package:qanony/presentation/screens/lawyer_account.dart';
import 'package:qanony/services/cubits/auth_cubit/auth_cubit.dart';
import 'package:qanony/services/cubits/lawyer/lawyer_cubit.dart';
import 'package:qanony/services/cubits/role/role_cubit.dart';
import 'package:qanony/services/cubits/splash/splash_cubit.dart';
import 'package:qanony/services/firestore/lawyer_firestore_service.dart';

import 'Core/shared/app_cache.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppCache.init();
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
          create: (context) => LawyerCubit(LawyerFirestoreService()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        title: 'قانوني',
        theme: ThemeData(fontFamily: 'Cairo'),
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
        home: const AccountLawyerScreen(
          lawyerId: 'EI9zXLuMKpNTGjledGy330bJDHE2',
        ),
      ),
    );
  }
}
