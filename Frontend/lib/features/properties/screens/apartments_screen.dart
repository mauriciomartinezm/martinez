import 'package:flutter/material.dart';
import '../logic/properties_controller.dart';
import '../widgets/apartment_card.dart';

class ApartmentsScreen extends StatelessWidget {
  const ApartmentsScreen({super.key, required this.controller});

  final PropertiesController controller;

  @override
  Widget build(BuildContext context) {
    final building = controller.selectedBuilding;
    if (building == null) {
      return const Scaffold(
        body: Center(child: Text('Edificio no disponible')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(building.name),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            controller.goBackToBuildings();
          },
        ),
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : controller.apartments.isEmpty
              ? const Center(child: Text('No hay apartamentos disponibles'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.apartments.length,
                  itemBuilder: (context, index) {
                    final apartment = controller.apartments[index];
                    return ApartmentCard(
                      apartment: apartment,
                      onTap: () {
                        controller.selectApartment(apartment);
                      },
                    );
                  },
                ),
    );
  }
}
