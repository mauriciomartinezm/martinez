import 'package:flutter/material.dart';
import '../controllers/dashboard_controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DashboardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DashboardController();
    // Cargar datos del caché primero
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadCachedStats();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final stats = _controller.getDisplayStats();
        debugPrint('Estadísticas mostradas: $stats');

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: _controller.errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(_controller.errorMessage!),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _controller.loadInitialData,
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  )
                : _controller.isLoading && _controller.pagos.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Summary title with refresh button
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Resumen de ${stats['mesAnio']}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                _controller.isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2),
                                      )
                                    : IconButton(
                                        icon: const Icon(Icons.refresh,
                                            color: Colors.black),
                                        onPressed: () =>
                                            _controller.refreshData(context),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Totales principales
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F5F5),
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Total neto',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF2C2C2C),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          _controller.formatCurrency(
                                              stats['totalNeto']),
                                          style: const TextStyle(
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
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          stats['propiedadesActivas']
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF4B4B4B),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'Apartamentos',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF6F6F6F),
                                              ),
                                            ),
                                            const Text(
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
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Total arriendos, administración y fondo
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F5F5),
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.attach_money,
                                            size: 28,
                                            color: Color(0xFF6F6F6F)),
                                        const SizedBox(height: 8),
                                        const Text(
                                          'Arriendos',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Color(0xFF6F6F6F),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _controller.formatCurrency(
                                              stats['totalArriendos']),
                                          style: const TextStyle(
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
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.description,
                                            size: 28,
                                            color: Color(0xFF6F6F6F)),
                                        const SizedBox(height: 8),
                                        const Text(
                                          'Administración',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Color(0xFF6F6F6F),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _controller.formatCurrency(
                                              stats['totalAdministracion']),
                                          style: const TextStyle(
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

                            // Fondo inmueble y EPRESEDI (admin + fondo)
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F5F5),
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.savings,
                                            size: 28,
                                            color: Color(0xFF6F6F6F)),
                                        const SizedBox(height: 8),
                                        const Text(
                                          'Fondo inmueble',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Color(0xFF6F6F6F),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _controller.formatCurrency(
                                              stats['totalFondoInmueble']),
                                          style: const TextStyle(
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
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(
                                            Icons.account_balance,
                                            size: 28,
                                            color: Color(0xFF6F6F6F)),
                                        const SizedBox(height: 8),
                                        const Text(
                                          'EPRESEDI',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Color(0xFF6F6F6F),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _controller.formatCurrency(
                                              stats['totalEpresedi']),
                                          style: const TextStyle(
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
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
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
                                      stats['diferenciaNeto'] >= 0
                                          ? Icons.arrow_upward
                                          : Icons.arrow_downward,
                                      size: 16,
                                      color: stats['diferenciaNeto'] >= 0
                                          ? const Color(0xFF388E3C)
                                          : const Color(0xFFC62828),
                                    ),
                                    Text(
                                      '${stats['diferenciaNeto'] >= 0 ? '+' : ''}'
                                      '${_controller.formatCurrency(stats['diferenciaNeto'].abs())}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.chevron_right,
                                        size: 16,
                                        color: Color(0xFF6F6F6F)),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Mes anterior',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF6F6F6F),
                                  ),
                                ),
                                Text(
                                  _controller.formatCurrency(
                                      stats['totalNetoAnterior']),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
          ),
        );
      },
    );
  }
}
