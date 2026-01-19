import 'package:flutter/material.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../core/data/data_repository.dart';
import '../../dashboard/screens/dashboard_screen.dart';
import '../../tenants/screens/tenants_screen.dart';
import '../../contracts/screens/contracts_screen.dart';
import '../logic/home_controller.dart';
import '../../properties/screens/properties_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeController controller;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    controller = HomeController();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Precarga todos los datos de la API al inicio
      await DataRepository.instance.preloadAll();
    } catch (e) {
      // Si falla la precarga, los datos se habrán cargado desde cache local si está disponible
      debugPrint('Error al precargar datos: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final isOffline = DataRepository.instance.isOfflineMode;
        
        return Scaffold(
          body: Column(
            children: [
              // Banner de modo offline
              if (isOffline)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.orange.shade100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_off, size: 16, color: Colors.orange.shade900),
                      const SizedBox(width: 8),
                      Text(
                        'Modo sin conexión - Mostrando datos guardados',
                        style: TextStyle(
                          color: Colors.orange.shade900,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              // Contenido principal
              Expanded(
                child: IndexedStack(
                  index: controller.selectedTab,
                  children: const [
                    DashboardScreen(),
                    PropertiesScreen(),
                    TenantsScreen(),
                    ContractsScreen(),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: AppBottomNavBar(
            currentIndex: controller.selectedTab,
            onTap: controller.setTab,
          ),
        );
      },
    );
  }
}
