import 'package:flutter/material.dart';

void main() {
  runApp(const QanonyApp());
}

class QanonyApp extends StatelessWidget {
  const QanonyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'قانوني',
      theme: ThemeData(fontFamily: 'Cairo'),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
