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
      home: const Login(),
      debugShowCheckedModeBanner: false,
    );
  }
}

//ToDo: Add names to orders
//ToDo: 1. Process orders from consumers to vendors
//ToDo: 2. Add farmer list to vendors' view
//ToDo: 3. Add weekly ingredient summary
//ToDo: Add time devisions to B L and D
