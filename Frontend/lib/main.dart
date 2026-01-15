import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/properties/screens/properties_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Deshabilitar logs excesivos en modo debug
  debugPrint = (String? message, {int? wrapWidth}) {
    if (message != null && message.isNotEmpty) {
      // Solo imprimir mensajes que no sean del framework
      if (!message.contains('GestureBinding') && 
          !message.contains('SemanticsBinding') &&
          !message.contains('RendererBinding') &&
          !message.contains('WidgetsBinding')) {
        debugPrintThrottled(message, wrapWidth: wrapWidth);
      }
    }
  };
  
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
