import 'package:flutter/material.dart';
import '../controllers/properties_controller.dart';
import 'apartment_detail_screen.dart';
import 'apartments_screen.dart';
import 'buildings_screen.dart';

class PropertiesScreen extends StatefulWidget {
  const PropertiesScreen({super.key});

  @override
  State<PropertiesScreen> createState() => _PropertiesScreenState();
}

class _PropertiesScreenState extends State<PropertiesScreen> {
  late final PropertiesController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PropertiesController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadBuildings();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        if (_controller.currentScreen == 'apartment_detail') {
          return ApartmentDetailScreen(controller: _controller);
        } else if (_controller.currentScreen == 'apartments') {
          return ApartmentsScreen(controller: _controller);
        }
        return BuildingsScreen(controller: _controller);
      },
    );
  }
}
