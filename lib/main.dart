import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/auth/splash_screen.dart';
import 'theme/theme_provider.dart';
import 'theme/app_theme.dart';
import 'models/tax_declaration_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        /// 🌙 Theme Provider
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),

        /// 💰 Tax Declaration Provider (GLOBAL)
        ChangeNotifierProvider(
          create: (_) => TaxDeclarationModel(),
        ),
      ],
      child: const HrmsApp(),
    ),
  );
}

class HrmsApp extends StatelessWidget {
  const HrmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: const SplashScreen(),
    );
  }
}
