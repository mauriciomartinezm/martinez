import 'package:flutter/material.dart';
import 'package:martinez/features/properties/services/api_service.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/properties/screens/properties_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Prefetch initial data from API on app startup
  await fetchBuildings();
  await fetchApartments();
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
