import 'package:flutter/material.dart';
import 'Core/shared/Decider.dart';
import 'Core/shared/logincash.dart';

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
      title: 'قانوني',
      theme: ThemeData(fontFamily: 'Cairo'),
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
      // home:const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
