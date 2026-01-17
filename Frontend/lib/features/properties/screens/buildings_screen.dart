import 'package:flutter/material.dart';
import 'package:martinez/core/theme/app_colors.dart';
import '../controllers/properties_controller.dart';
import '../widgets/building_card.dart';

class BuildingsScreen extends StatelessWidget {
  const BuildingsScreen({super.key, required this.controller});

  final PropertiesController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Edificios',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : controller.buildings.isEmpty
          ? const Center(child: Text('No hay edificios disponibles'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.buildings.length,
              itemBuilder: (context, index) {
                final building = controller.buildings[index];
                return BuildingCard(
                  building: building,
                  activeCount: controller.activeApartmentsCount(building.id),
                  totalCount: controller.totalApartmentsCount(building.id),
                  onTap: () {
                    controller.selectBuilding(building);
                  },
                );
              },
            ),
    );
  }
}
