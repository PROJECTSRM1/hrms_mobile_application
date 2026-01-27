import 'package:flutter/material.dart';
import 'features/auth/screens/splash_screen.dart';

void main() {
  runApp(const HrmsApp());
}

class HrmsApp extends StatelessWidget {
  const HrmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
