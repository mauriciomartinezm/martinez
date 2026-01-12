import 'package:flutter/material.dart';
import '../logic/building_service.dart';

class ApartmentCard extends StatelessWidget {
  const ApartmentCard({
    super.key,
    required this.apartment,
    required this.onTap,
  });

  final Apartment apartment;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isOccupied = apartment.status == 'Ocupado';
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
                color: isOccupied ? const Color(0xFFFFE0E0) : const Color(0xFFE0FFE0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isOccupied ? Icons.lock : Icons.lock_open,
                size: 28,
                color: isOccupied ? const Color(0xFFD32F2F) : const Color(0xFF388E3C),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    apartment.unit,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    apartment.tenant,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6F6F6F),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isOccupied ? const Color(0xFFFFE0E0) : const Color(0xFFE0FFE0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      apartment.status,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isOccupied ? const Color(0xFFD32F2F) : const Color(0xFF388E3C),
                      ),
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
