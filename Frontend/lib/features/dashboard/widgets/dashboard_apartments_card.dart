import 'package:flutter/material.dart';

class DashboardApartmentsCard extends StatelessWidget {
  final int count;
  final Color? backgroundColor;

  const DashboardApartmentsCard({
    super.key,
    required this.count,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4B4B4B),
            ),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Apartamentos',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6F6F6F),
                ),
              ),
              Text(
                'arrendados',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6F6F6F),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
