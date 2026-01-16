import 'package:flutter/material.dart';
import 'package:martinez/core/theme/app_colors.dart';

class DashboardStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;

  const DashboardStatCard({
    super.key,
    required this.title,
    required this.value,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 28, color: AppColors.textSecondary),
            const SizedBox(height: 8),
          ],
          Text(
            title,
            style: const TextStyle(fontSize: 15, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
