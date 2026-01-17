import 'package:flutter/material.dart';
import 'package:martinez/core/theme/app_colors.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_stat_card.dart';
import '../widgets/dashboard_apartments_card.dart';
import '../widgets/dashboard_comparison.dart';
import '../widgets/dashboard_error_view.dart';

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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final stats = _controller.getDisplayStats();
        final int pendingCount = stats['pendingIncreaseCount'] ?? 0;
        final List<dynamic> pendingTenantsRaw = stats['pendingIncreaseTenants'] ?? [];
        final List<String> pendingTenants = pendingTenantsRaw.map((e) => e.toString()).toList();
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: _controller.errorMessage != null
                ? DashboardErrorView(
                    errorMessage: _controller.errorMessage!,
                    onRetry: _controller.loadInitialData,
                  )
                : _controller.isLoading && _controller.pagos.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Summary header
                        DashboardHeader(
                          title: 'Resumen de ${stats['mesAnio']}',
                          isLoading: _controller.isLoading,
                          onRefresh: () => _controller.refreshData(context),
                        ),
                        const SizedBox(height: 16),

                        if (pendingCount > 0)
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.orange.withOpacity(0.35)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.orange,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        pendingCount == 1
                                            ? '1 arrendatario sin aumento anual aplicado'
                                            : '$pendingCount arrendatarios sin aumento anual aplicado',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.orange,
                                        ),
                                      ),
                                      if (pendingTenants.isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          pendingTenants.join(', '),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                        if (pendingCount > 0) const SizedBox(height: 12),

                        // Main totals row
                        Row(
                          children: [
                            Expanded(
                              child: DashboardStatCard(
                                title: 'Total neto',
                                value: _controller.formatCurrency(
                                  stats['totalNeto'],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DashboardApartmentsCard(
                                count: stats['propiedadesActivas'],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Income breakdown row
                        Row(
                          children: [
                            Expanded(
                              child: DashboardStatCard(
                                icon: Icons.attach_money,
                                title: 'Arriendos',
                                value: _controller.formatCurrency(
                                  stats['totalArriendos'],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DashboardStatCard(
                                icon: Icons.description,
                                title: 'Administración',
                                value: _controller.formatCurrency(
                                  stats['totalAdministracion'],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Funds row
                        Row(
                          children: [
                            Expanded(
                              child: DashboardStatCard(
                                icon: Icons.savings,
                                title: 'Fondo inmueble',
                                value: _controller.formatCurrency(
                                  stats['totalFondoInmueble'],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DashboardStatCard(
                                icon: Icons.account_balance,
                                title: 'EPRESEDI',
                                value: _controller.formatCurrency(
                                  stats['totalEpresedi'],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Monthly comparison
                        DashboardComparison(
                          currentMonthValue: _controller.formatCurrency(
                            stats['totalNeto'],
                          ),
                          difference: stats['diferenciaNeto'],
                          previousMonthValue: _controller.formatCurrency(
                            stats['totalNetoAnterior'],
                          ),
                          formatCurrency: _controller.formatCurrency,
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
