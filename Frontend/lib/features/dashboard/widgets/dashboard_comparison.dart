import 'package:flutter/material.dart';

class DashboardComparison extends StatelessWidget {
  final String currentMonthValue;
  final double difference;
  final String previousMonthValue;
  final String Function(double) formatCurrency;

  const DashboardComparison({
    super.key,
    required this.currentMonthValue,
    required this.difference,
    required this.previousMonthValue,
    required this.formatCurrency,
  });

  @override
  Widget build(BuildContext context) {
    final isDifferencePositive = difference >= 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Comparativo mensual:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Este mes',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6F6F6F),
              ),
            ),
            Row(
              children: [
                Icon(
                  isDifferencePositive
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  size: 16,
                  color: isDifferencePositive
                      ? const Color(0xFF388E3C)
                      : const Color(0xFFC62828),
                ),
                Text(
                  '${isDifferencePositive ? '+' : ''}'
                  '${formatCurrency(difference.abs())}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right,
                    size: 16, color: Color(0xFF6F6F6F)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Mes anterior',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6F6F6F),
              ),
            ),
            Text(
              previousMonthValue,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
