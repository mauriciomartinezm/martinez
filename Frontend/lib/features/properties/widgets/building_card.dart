import 'package:flutter/material.dart';
import '../logic/building_service.dart';

class BuildingCard extends StatelessWidget {
  const BuildingCard({
    super.key,
    required this.building,
    required this.onTap,
  });

  final Building building;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.home, size: 32, color: Colors.grey),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      building.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      building.address,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6F6F6F),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      building.occupancy,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6F6F6F),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

