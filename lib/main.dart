import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'Core/shared/app_cache.dart';
import 'presentation/screens/search-screen.dart';
import 'services/cubits/splash/splash_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppCache.init();
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
        home: const SearchScreen(),
      ),
    );
  }
}
