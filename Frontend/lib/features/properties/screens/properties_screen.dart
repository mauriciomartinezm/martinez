import 'package:flutter/material.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import '../../dashboard/screens/dashboard_screen.dart';
import '../../tenants/screens/tenants_screen.dart';
import '../../contracts/screens/contracts_screen.dart';
import '../logic/properties_controller.dart';
import 'apartment_detail_screen.dart';
import 'apartments_screen.dart';
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
          bottomNavigationBar: AppBottomNavBar(
            currentIndex: controller.selectedTab,
            onTap: controller.setTab,
          ),
        );
      },
    );
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        // Home/Dashboard
        return const DashboardScreen();
      case 1:
        // Properties - navigate through buildings, apartments, and details
        if (controller.currentScreen == 'apartment_detail') {
          return ApartmentDetailScreen(controller: controller);
        } else if (controller.currentScreen == 'apartments') {
          return ApartmentsScreen(controller: controller);
        }
        return BuildingsScreen(controller: controller);
      case 2:
        // Tenants
        return const TenantsScreen();
      case 3:
        // Contracts
        return const ContractsScreen();
      default:
        return const Center(child: Text('Pantalla desconocida'));
    }
  }
}
