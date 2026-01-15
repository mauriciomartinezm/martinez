import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/dashboard_cache_service.dart';
import '../../../core/models/pago_mensual.dart';
import '../../../core/models/apartment.dart';
import '../../../core/widgets/floating_message.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = false;
  List<PagoMensual> _pagos = [];
  List<Apartment> _apartments = [];
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
      final apartments = await fetchApartments();
      final pagos = await fetchPagos();
      if (mounted) {
        setState(() {
          _apartments = apartments;
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
      final apartments = await fetchApartments();
      final pagos = await fetchPagos();
      if (mounted) {
        hideLoadingMessage();
        setState(() {
          _apartments = apartments;
          _pagos = pagos;
          _isLoading = false;
        });
        // Actualizar caché con nuevas estadísticas
        final stats = _calculateStats();
        await DashboardCacheService.saveStats(stats);
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
    if (_pagos.isEmpty) {
      return {
        'totalArriendos': 0.0,
        'totalAdministracion': 0.0,
        'totalNeto': 0.0,
        'totalFondoInmueble': 0.0,
        'totalEpresedi': 0.0,
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
    
    double totalArriendos = 0;
    double totalAdministracion = 0;
    double totalNeto = 0;
    double totalFondoInmueble = 0;
    double totalEpresedi = 0;
    Set<String> apartamentosArrendados = {};

    debugPrint('Pagos del mes: ${pagosDelMes.length}');
    // Calcular apartamentos arrendados directamente desde la lista de apartamentos activos
    apartamentosArrendados.addAll(
      _apartments.where((apt) => apt.activa).map((apt) => apt.id),
    );

    // Calcular totales monetarios a partir de los pagos del mes
    for (var pago in pagosDelMes) {
      totalArriendos += pago.valorArriendo;
      totalAdministracion += pago.cuotaAdministracion;
      totalNeto += pago.totalNeto;
      totalFondoInmueble += pago.fondoInmueble ?? 0;
    }

    totalEpresedi = totalAdministracion + totalFondoInmueble;

    final mesAnio = '${mesNombres[currentDate.month - 1]} ${currentDate.year}';

    return {
      'totalArriendos': totalArriendos,
      'totalAdministracion': totalAdministracion,
      'totalNeto': totalNeto,
      'totalFondoInmueble': totalFondoInmueble,
      'totalEpresedi': totalEpresedi,
      'propiedadesActivas': apartamentosArrendados.length,
      'mesAnio': mesAnio,
    };
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    return formatter.format(amount);
  }

  Map<String, dynamic> _normalizeStats(Map<String, dynamic>? raw) {
    double _toDouble(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0;
      return 0;
    }

    int _toInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    final data = raw ?? {};

    return {
      'totalArriendos': _toDouble(data['totalArriendos'] ?? data['totalRecibido']),
      'totalAdministracion': _toDouble(data['totalAdministracion']),
      'totalNeto': _toDouble(data['totalNeto']),
      'totalFondoInmueble': _toDouble(data['totalFondoInmueble']),
      'totalEpresedi': _toDouble(data['totalEpresedi'] ??
          ((_toDouble(data['totalAdministracion']) + _toDouble(data['totalFondoInmueble'])))),
      'propiedadesActivas': _toInt(data['propiedadesActivas']),
      'mesAnio': data['mesAnio'] ?? 'Sin datos',
    };
  }

  @override
  Widget build(BuildContext context) {
    // Usar estadísticas en caché si no hay datos frescos
    final stats = _normalizeStats(
      _pagos.isNotEmpty ? _calculateStats() : (_cachedStats ?? _calculateStats()),
    );
    debugPrint('Estadísticas mostradas: $stats');
    return Scaffold(
      backgroundColor: Colors.white,
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
                        // Summary title with refresh button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Resumen de ${stats['mesAnio']}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : IconButton(
                                    icon: const Icon(Icons.refresh, color: Colors.black),
                                    onPressed: _refreshData,
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
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      stats['propiedadesActivas'].toString(),
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF4B4B4B),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
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
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.attach_money, size: 28, color: Color(0xFF6F6F6F)),
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
                                      _formatCurrency(stats['totalArriendos']),
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
                                    const Icon(Icons.description, size: 28, color: Color(0xFF6F6F6F)),
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
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.savings, size: 28, color: Color(0xFF6F6F6F)),
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
                                      _formatCurrency(stats['totalFondoInmueble']),
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
                                    const Icon(Icons.account_balance, size: 28, color: Color(0xFF6F6F6F)),
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
                                      _formatCurrency(stats['totalEpresedi']),
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

                        
                      ],
                    ),
                  ),
      ),
    );
  }
}
