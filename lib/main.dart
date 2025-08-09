import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/data/repos/gemini_repo.dart';
import 'package:qanony/data/repos/stripe_subscription_repo.dart';
import 'package:qanony/firebase_options.dart';
import 'package:qanony/presentation/screens/splash_screen.dart';
import 'package:qanony/services/call/call_service.dart';
import 'package:qanony/services/cubits/appointments/appointments_cubit.dart';
import 'package:qanony/services/cubits/auth_cubit/auth_cubit.dart';
import 'package:qanony/services/cubits/deep_link/deep_link_cubit.dart';
import 'package:qanony/services/cubits/gemini/gemini_cubit.dart';
import 'package:qanony/services/cubits/lawyer_info/lawyer_info_cubit.dart';
import 'package:qanony/services/cubits/role/role_cubit.dart';
import 'package:qanony/services/cubits/splash/splash_cubit.dart';
import 'package:qanony/services/cubits/subscription/stripe_subscription_cubit.dart';
import 'package:qanony/services/firestore/lawyer_firestore_service.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import 'Core/shared/app_cache.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/env/.env");
  await AppCache.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final String userId = AppCache.getUserId() ?? "";
  final String userName = AppCache.getUserName() ?? "";

  final key = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;
  Stripe.publishableKey = key;

  await Stripe.instance.applySettings();

  if (userId != "") {
    await CallService().onUserLogin(userId, userName);
  }
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

  await ZegoUIKit().initLog().then((value) async {
    await ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI([
      ZegoUIKitSignalingPlugin(),
    ]);
    runApp(
      ScreenUtilInit(
        designSize: Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => const QanonyApp(),
      ),
    );
  });
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
        BlocProvider(create: (_) => GeminiCubit(GeminiRepository())),
        BlocProvider(create: (_) => (DeepLinkCubit())..listenToDeepLinks()),
        BlocProvider(
          create: (_) => StripeSubscriptionCubit(StripeSubscriptionRepo(Dio())),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        title: 'قانوني',
        navigatorKey: navigatorKey,

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
          progressIndicatorTheme: ProgressIndicatorThemeData(
            color: AppColor.primary,
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

        home: SplashScreen(),
      ),
    );
  }
}
