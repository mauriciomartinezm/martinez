import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/dashboard_cache_service.dart';
import '../../../core/models/pago_mensual.dart';
import '../../../core/widgets/floating_message.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = false;
  List<PagoMensual> _pagos = [];
  String? _errorMessage;
  Map<String, dynamic>? _cachedStats;

  @override
  void initState() {
    super.initState();
    // Cargar datos del caché primero
    _loadCachedStats();
  }

  Future<void> _loadCachedStats() async {
    final cachedStats = await DashboardCacheService.loadStats();
    if (mounted) {
      setState(() {
        _cachedStats = cachedStats;
      });
      // Si no hay caché, cargar datos de la API
      if (cachedStats == null) {
        _loadInitialData();
      }
    }
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final pagos = await fetchPagos();
      if (mounted) {
        setState(() {
          _pagos = pagos;
          _isLoading = false;
        });
        // Guardar las estadísticas calculadas en caché
        final stats = _calculateStats();
        await DashboardCacheService.saveStats(stats);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error al cargar datos: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    final hideLoadingMessage = FloatingMessage.showLoading(
      context,
      message: 'Actualizando datos...',
    );
    
    try {
      await fetchBuildings();
      await fetchApartments();
      final pagos = await fetchPagos();
      if (mounted) {
        hideLoadingMessage();
        setState(() {
          _pagos = pagos;
          _isLoading = false;
        });
        FloatingMessage.showSuccess(
          context,
          message: 'Datos actualizados correctamente',
        );
      }
    } catch (e) {
      if (mounted) {
        hideLoadingMessage();
        setState(() {
          _errorMessage = 'Error al actualizar: $e';
          _isLoading = false;
        });
        FloatingMessage.showError(
          context,
          message: 'Error al actualizar: $e',
        );
      }
    }
  }

  Map<String, dynamic> _calculateStats() {
    debugPrint('Calculando estadísticas del dashboard...');
    debugPrint('Total pagos disponibles: ${_pagos.length}');
    if (_pagos.isEmpty) {
      return {
        'totalRecibido': 0.0,
        'totalAdministracion': 0.0,
        'totalNeto': 0.0,
        'totalArriendo': 0.0,
        'totalFondoInmueble': 0.0,
        'propiedadesActivas': 0,
        'mesAnio': 'Sin datos',
      };
    }

    final mesNombres = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 
                        'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];

    // Obtener el mes actual y retroceder si no hay pagos
    final now = DateTime.now();
    var currentDate = DateTime(now.year, now.month);
    var pagosDelMes = <PagoMensual>[];
    // Intentar encontrar un mes con pagos (máximo 12 meses hacia atrás)
    for (int i = 0; i < 12 && pagosDelMes.isEmpty; i++) {
      final mesNombre = mesNombres[currentDate.month - 1];
      final year = currentDate.year.toString();
      
      pagosDelMes = _pagos.where((pago) {
        return pago.mes == mesNombre && pago.anio == year;
      }).toList();
      
      if (pagosDelMes.isEmpty) {
        currentDate = DateTime(currentDate.year, currentDate.month - 1);
      }
    }
    
    double totalRecibido = 0;
    double totalAdministracion = 0;
    double totalNeto = 0;
    double totalArriendo = 0;
    double totalFondoInmueble = 0;
    Set<String> contratoActivos = {};

    for (var pago in pagosDelMes) {
      totalRecibido += pago.valorArriendo - pago.cuotaAdministracion - (pago.fondoInmueble ?? 0);
      totalAdministracion += pago.cuotaAdministracion;
      totalNeto += pago.totalNeto;
      totalArriendo += pago.valorArriendo;
      totalFondoInmueble += pago.fondoInmueble ?? 0;
      
      if (pago.contratoArriendo.activo) {
        contratoActivos.add(pago.contratoArriendo.id);
      }
    }

    final mesAnio = '${mesNombres[currentDate.month - 1]} ${currentDate.year}';

    return {
      'totalRecibido': totalRecibido,
      'totalAdministracion': totalAdministracion,
      'totalNeto': totalNeto,
      'totalArriendo': totalArriendo,
      'totalFondoInmueble': totalFondoInmueble,
      'propiedadesActivas': contratoActivos.length,
      'mesAnio': mesAnio,
    };
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    // Usar estadísticas en caché si no hay datos frescos
    final stats = _pagos.isNotEmpty ? _calculateStats() : (_cachedStats ?? _calculateStats());

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.black),
                      onPressed: _refreshData,
                    ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: _errorMessage != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(_errorMessage!),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadInitialData,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              )
            : _isLoading && _pagos.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Summary title
                        Text(
                          'Resumen de ${stats['mesAnio']}',
                          style: const TextStyle(
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Total recibido',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF6F6F6F),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _formatCurrency(stats['totalRecibido']),
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
                                          color: index < stats['propiedadesActivas']
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Total',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF6F6F6F),
                                      ),
                                    ),
                                    const Text(
                                      'administración',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF6F6F6F),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _formatCurrency(stats['totalAdministracion']),
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
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Total neto',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF6F6F6F),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _formatCurrency(stats['totalNeto']),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Este mes',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6F6F6F),
                              ),
                            ),
                            Row(
                              children: [
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
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F5F5),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.home, size: 32, color: Color(0xFF6F6F6F)),
                                        const SizedBox(height: 8),
                                        const Text(
                                          'Arriendo',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF6F6F6F),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _formatCurrency(stats['totalArriendo']),
                                          style: const TextStyle(
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
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.description, size: 32, color: Color(0xFF6F6F6F)),
                                        const SizedBox(height: 8),
                                        const Text(
                                          'Administración',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF6F6F6F),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _formatCurrency(stats['totalAdministracion']),
                                          style: const TextStyle(
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
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.savings, size: 32, color: Color(0xFF6F6F6F)),
                                        const SizedBox(height: 8),
                                        const Text(
                                          'Fondo',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF6F6F6F),
                                          ),
                                        ),
                                        const Text(
                                          'Inmueble',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF6F6F6F),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _formatCurrency(stats['totalFondoInmueble']),
                                          style: const TextStyle(
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
                      ],
                    ),
                  ),
      ),
    );
  }
}
