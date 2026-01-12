import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/properties/screens/properties_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Martínez',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const PropertiesScreen(),
    );
  }
}
