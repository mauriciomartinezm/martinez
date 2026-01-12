import 'package:flutter/material.dart';
import '../logic/properties_controller.dart';
import 'buildings_screen.dart';

class PropertiesScreen extends StatefulWidget {
  const PropertiesScreen({super.key});

  @override
  State<PropertiesScreen> createState() => _PropertiesScreenState();
}

class _PropertiesScreenState extends State<PropertiesScreen> {
  late final PropertiesController controller;

  @override
  void initState() {
    super.initState();
    controller = PropertiesController();
    controller.loadBuildings();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          body: _buildScreen(controller.selectedTab),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.selectedTab,
            onTap: controller.setTab,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Propiedades',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: 'Arrendatarios',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Actualizaciones',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return BuildingsScreen(controller: controller);
      case 1:
        return const Center(child: Text('Arrendatarios'));
      case 2:
        return const Center(child: Text('Actualizaciones'));
      default:
        return const Center(child: Text('Pantalla desconocida'));
    }
  }
}
