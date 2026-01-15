import 'package:flutter/material.dart';
import '../../home/logic/home_controller.dart';

class ApartmentDetailScreen extends StatelessWidget {
  const ApartmentDetailScreen({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final apartment = controller.selectedApartment;
    if (apartment == null) {
      return const Scaffold(
        body: Center(child: Text('Apartamento no disponible')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Apartamento'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            controller.goBackToApartments();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Address card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD0D0D0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.apartment,
                      size: 32,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      //apartment.direccion,
                      "Aqui va la direccion pero no es necesaria, revisar",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            /*
            // Rent date info
            if (apartment.rentDate != null) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Fecha de arrendamiento',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6F6F6F),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      apartment.rentDate!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Rent amount info
            if (apartment.rentAmount != null) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Monto del arriendo',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6F6F6F),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      apartment.rentAmount!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
            */
            // Add rent button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Agregar arriendo')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE0E0E0),
                  foregroundColor: const Color(0xFF333333),
                  elevation: 0,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Agregar arriendo',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
