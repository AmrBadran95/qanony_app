import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:qanony/firebase_options.dart';
import 'package:qanony/presentation/screens/sign_up.dart';
import 'package:qanony/presentation/screens/splash_screen.dart';
import 'package:qanony/presentation/screens/subscription_screen.dart';

import 'package:qanony/services/cubits/checkout/checkout_cubit.dart';
import 'package:qanony/services/stripe/api_service.dart';
import 'package:qanony/services/stripe/stripe_service.dart';
import 'Core/shared/app_cache.dart';
import 'services/cubits/splash/splash_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppCache.init();
  final key ="pk_test_51RmfujBCYVFzcUuX9HnRrvPp4PQkTb30GuFpqnQu7uHfGYGJzHIiiw0eUD9HYu6fg6SZu5MTxCYiNnGpP4TOM2ki00WIIZy1Fu";
  try {
    Stripe.publishableKey = key; // تأكدي منه
  } catch (e) {
    print("Stripe error: $e");
  }
  runApp(const QanonyApp());
}

class QanonyApp extends StatelessWidget {
  const QanonyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => SplashCubit())],
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

        // home: CheckoutPage(),
        // home:
        home:SplashScreen (),
      ),
    );
  }
}
