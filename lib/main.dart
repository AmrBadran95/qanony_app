import 'package:flutter/material.dart';
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
      //بيشيل علامه ال debug
      debugShowCheckedModeBanner: false,

      title: 'قانوني',
      theme: ThemeData(fontFamily: 'Cairo'),
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
      home: const splashscreen(),
      // home:const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
