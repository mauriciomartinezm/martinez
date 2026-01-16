import 'package:flutter/material.dart';
import 'package:martinez/core/theme/app_colors.dart';
import '../../../core/models/apartment.dart';

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
    final isActive = apartment.activa;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
              Icon(
                isActive ? Icons.lock_open : Icons.lock,
                size: 48,
                color: AppColors.primary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Piso ${apartment.piso}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                color: AppColors.textPrimary,

                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      apartment.edificio.nombre,
                      style: const TextStyle(
                        fontSize: 13,
                                        color: AppColors.textSecondary,

                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? const Color(0xFFE0FFE0)
                            : const Color(0xFFFFE0E0),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isActive ? 'Activa' : 'Inactiva',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isActive
                              ? const Color(0xFF388E3C)
                              : const Color(0xFFD32F2F),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ),
    );
  } 

}
