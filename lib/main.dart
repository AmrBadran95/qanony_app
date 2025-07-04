import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:qanony/presentation/screens/appointment-lawyer.dart';
import 'package:qanony/presentation/screens/SplashScreen.dart';
import 'Core/shared/logincache.dart';

void main () async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedHelper.init();
  runApp(const QanonyApp());
}

class QanonyApp extends StatelessWidget {
  const QanonyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'قانوني',
      theme: ThemeData(fontFamily: 'Cairo'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
      home: const AppointmentLawyer(),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
