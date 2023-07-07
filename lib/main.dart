// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'screens/login.dart';

void main() {
  runApp(const Victu());
}

class Victu extends StatelessWidget {
  const Victu({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Victu',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff54b860)),
        useMaterial3: true,
      ),
      home: Login(),
      debugShowCheckedModeBanner: false,
    );
  }
}
