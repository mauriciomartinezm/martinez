import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo and title
              Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      physics: const NeverScrollableScrollPhysics(),
                      children: const [
                        ColoredBox(color: Color(0xFF4B4B4B)),
                        ColoredBox(color: Color(0xFFAAAAAA)),
                        ColoredBox(color: Color(0xFFAAAAAA)),
                        ColoredBox(color: Color(0xFF4B4B4B)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Martínez',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Text(
                    'Gestión Inmobiliaria',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6F6F6F),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Summary title
              const Text(
                'Resumen del último mes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              // Total received and active properties
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total recibido',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6F6F6F),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '\$12,500',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: List.generate(
                            4,
                            (index) => Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Icon(
                                Icons.home,
                                size: 20,
                                color: index < 3
                                    ? const Color(0xFF4B4B4B)
                                    : const Color(0xFFAAAAAA),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Propiedades',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF6F6F6F),
                          ),
                        ),
                        const Text(
                          'activas',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF6F6F6F),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Total administration and net
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6F6F6F),
                            ),
                          ),
                          Text(
                            'administración',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6F6F6F),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '\$2,750',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total neto',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6F6F6F),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '\$9,750',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Monthly comparison
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
                    children: const [
                      Icon(Icons.arrow_upward, size: 16, color: Color(0xFF388E3C)),
                      Text(
                        '+500',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.chevron_right, size: 16, color: Color(0xFF6F6F6F)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Mes anterior',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6F6F6F),
                    ),
                  ),
                  Text(
                    '\$12,000',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Breakdown cards
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.home, size: 32, color: Color(0xFF6F6F6F)),
                          SizedBox(height: 8),
                          Text(
                            'Arriendo',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6F6F6F),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '\$9,000',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.description, size: 32, color: Color(0xFF6F6F6F)),
                          SizedBox(height: 8),
                          Text(
                            'Administración',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6F6F6F),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '\$2,750',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
