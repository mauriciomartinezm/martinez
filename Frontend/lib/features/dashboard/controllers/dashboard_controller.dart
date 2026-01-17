import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/data/data_repository.dart';
import '../../../core/services/dashboard_cache_service.dart';
import '../../../core/models/pago_mensual.dart';
import '../../../core/models/apartment.dart';
import '../../../core/models/contract.dart';
import '../../../core/widgets/floating_message.dart';

class DashboardController extends ChangeNotifier {
  final DataRepository _dataRepo = DataRepository.instance;
  
  static const List<String> _monthOrder = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre',
  ];

  bool _isLoading = false;
  List<PagoMensual> _pagos = [];
  List<Apartment> _apartments = [];
  List<Contract> _contracts = [];
  String? _errorMessage;
  Map<String, dynamic>? _cachedStats;
  Map<String, dynamic>? _calculatedStats;

  // Getters
  bool get isLoading => _isLoading;
  List<PagoMensual> get pagos => _pagos;
  List<Apartment> get apartments => _apartments;
  List<Contract> get contracts => _contracts;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get cachedStats => _cachedStats;

  Future<void> loadCachedStats() async {
    final cachedStats = await DashboardCacheService.loadStats();
    _cachedStats = cachedStats;
    notifyListeners();
    // Si no hay caché, cargar datos del repositorio (ya precargados)
    if (cachedStats == null) {
      await loadInitialData();
    }
  }

  Future<void> loadInitialData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      // Obtener datos del repositorio (ya están en caché desde HomeScreen)
      _apartments = _dataRepo.cachedApartments;
      _pagos = _dataRepo.cachedPayments;
      _contracts = _dataRepo.cachedContracts;
      
      // Si por alguna razón no hay datos en caché, cargarlos
      if (_apartments.isEmpty || _pagos.isEmpty || _contracts.isEmpty) {
        _apartments = await _dataRepo.getApartments();
        _pagos = await _dataRepo.getPayments();
        _contracts = await _dataRepo.getContracts();
      }
      
      _isLoading = false;
      notifyListeners();
      
      // Calcular y guardar las estadísticas en caché
      _calculatedStats = calculateStats();
      await DashboardCacheService.saveStats(_calculatedStats!);
    } catch (e) {
      _errorMessage = 'Error al cargar datos: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshData(BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    final hideLoadingMessage = FloatingMessage.showLoading(
      context,
      message: 'Actualizando datos...',
    );
    
    try {
      // Forzar refresh desde el repositorio global
      _apartments = await _dataRepo.getApartments(forceRefresh: true);
      _pagos = await _dataRepo.getPayments(forceRefresh: true);
      _contracts = await _dataRepo.getContracts(forceRefresh: true);
      _isLoading = false;
      notifyListeners();
      
      // Calcular y actualizar caché con nuevas estadísticas
      _calculatedStats = calculateStats();
      await DashboardCacheService.saveStats(_calculatedStats!);
      
      hideLoadingMessage();
      FloatingMessage.showSuccess(
        context,
        message: 'Datos actualizados correctamente',
      );
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      
      hideLoadingMessage();
      FloatingMessage.showError(
        context,
        message: 'Error al actualizar: $e',
      );
    }
  }

  Map<String, dynamic> calculateStats() {
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
        'totalNetoAnterior': 0.0,
        'diferenciaNeto': 0.0,
        'porcentajeDiferencia': 0.0,
        'pendingIncreaseCount': 0,
        'pendingIncreaseTenants': <String>[],
      };
    }

    final mesNombres = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];

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

    // Obtener el mes anterior
    var previousDate = DateTime(currentDate.year, currentDate.month - 1);
    var pagosDelMesAnterior = <PagoMensual>[];
    final mesAnteriorNombre = mesNombres[previousDate.month - 1];
    final yearAnterior = previousDate.year.toString();
    
    pagosDelMesAnterior = _pagos.where((pago) {
      return pago.mes == mesAnteriorNombre && pago.anio == yearAnterior;
    }).toList();

    double totalArriendos = 0;
    double totalAdministracion = 0;
    double totalNeto = 0;
    double totalFondoInmueble = 0;
    double totalEpresedi = 0;
    double totalNetoAnterior = 0;
    Set<String> apartamentosArrendados = {};
    
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

    // Calcular total neto del mes anterior
    for (var pago in pagosDelMesAnterior) {
      totalNetoAnterior += pago.totalNeto;
    }

    totalEpresedi = totalAdministracion + totalFondoInmueble;

    // Calcular diferencia y porcentaje
    double diferenciaNeto = totalNeto - totalNetoAnterior;
    double porcentajeDiferencia = totalNetoAnterior > 0 
        ? (diferenciaNeto / totalNetoAnterior) * 100 
        : 0;

    final mesAnio = '${mesNombres[currentDate.month - 1]} ${currentDate.year}';

    final pendingTenants = _computePendingIncreaseTenants();

    return {
      'totalArriendos': totalArriendos,
      'totalAdministracion': totalAdministracion,
      'totalNeto': totalNeto,
      'totalFondoInmueble': totalFondoInmueble,
      'totalEpresedi': totalEpresedi,
      'propiedadesActivas': apartamentosArrendados.length,
      'mesAnio': mesAnio,
      'totalNetoAnterior': totalNetoAnterior,
      'diferenciaNeto': diferenciaNeto,
      'porcentajeDiferencia': porcentajeDiferencia,
      'pendingIncreaseCount': pendingTenants.length,
      'pendingIncreaseTenants': pendingTenants,
    };
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    return formatter.format(amount);
  }

  Map<String, dynamic> normalizeStats(Map<String, dynamic>? raw) {
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
      'totalArriendos':
          _toDouble(data['totalArriendos'] ?? data['totalRecibido']),
      'totalAdministracion': _toDouble(data['totalAdministracion']),
      'totalNeto': _toDouble(data['totalNeto']),
      'totalFondoInmueble': _toDouble(data['totalFondoInmueble']),
      'totalEpresedi': _toDouble(data['totalEpresedi'] ??
          ((_toDouble(data['totalAdministracion']) +
              _toDouble(data['totalFondoInmueble'])))),
      'propiedadesActivas': _toInt(data['propiedadesActivas']),
      'mesAnio': data['mesAnio'] ?? 'Sin datos',
      'totalNetoAnterior': _toDouble(data['totalNetoAnterior']),
      'diferenciaNeto': _toDouble(data['diferenciaNeto']),
      'porcentajeDiferencia': _toDouble(data['porcentajeDiferencia']),
      'pendingIncreaseCount': _toInt(data['pendingIncreaseCount']),
      'pendingIncreaseTenants':
          (data['pendingIncreaseTenants'] as List?)?.map((e) => e.toString()).toList() ?? <String>[],
    };
  }

  Map<String, dynamic> getDisplayStats() {
    // Si ya tenemos estadísticas calculadas, usarlas
    if (_calculatedStats != null) {
      return normalizeStats(_calculatedStats!);
    }
    
    // Si tenemos pagos, calcular y cachear
    if (_pagos.isNotEmpty) {
      _calculatedStats = calculateStats();
      return normalizeStats(_calculatedStats!);
    }
    
    // Usar caché del servicio o calcular por defecto
    return normalizeStats(_cachedStats ?? calculateStats());
  }

  List<String> _computePendingIncreaseTenants() {
    if (_contracts.isEmpty || _pagos.isEmpty) return <String>[];

    final Map<String, List<Contract>> contractsByTenant = {};
    for (final contract in _contracts) {
      contractsByTenant.putIfAbsent(contract.tenantId, () => []).add(contract);
    }

    final List<String> pendingTenants = [];

    contractsByTenant.forEach((tenantId, tenantContracts) {
      tenantContracts.sort((a, b) => a.fechaInicio.compareTo(b.fechaInicio));
      final firstContract = tenantContracts.first;

      final increaseDate = _getIncreaseDate(firstContract.fechaInicio);
      if (increaseDate == null) return; // aún no cumple un año

      final tenantPayments = _pagos
          .where((p) => p.contratoArriendo.arrendatario.id == tenantId)
          .toList();

      if (tenantPayments.isEmpty) return;

      tenantPayments.sort((a, b) {
        final aDate = _parsePagoDate(a);
        final bDate = _parsePagoDate(b);
        if (aDate == null || bDate == null) return 0;
        return bDate.compareTo(aDate); // más recientes primero
      });

      final baseline = _findRentOnOrBefore(tenantPayments, increaseDate, firstContract.montoMensual);
      if (baseline == null) return;

      PagoMensual? latestAfterIncrease;
      for (final pago in tenantPayments) {
        final pagoDate = _parsePagoDate(pago);
        if (pagoDate == null) continue;
        if (pagoDate.isAfter(increaseDate)) {
          latestAfterIncrease = pago;
          break;
        }
      }

      if (latestAfterIncrease != null && latestAfterIncrease.valorArriendo <= baseline) {
        pendingTenants.add(firstContract.tenantName);
      }
    });

    return pendingTenants;
  }

  DateTime? _parsePagoDate(PagoMensual pago) {
    final monthIndex = _monthOrder.indexOf(pago.mes) + 1;
    final year = int.tryParse(pago.anio) ?? 0;
    if (year <= 0 || monthIndex <= 0) return null;
    return DateTime(year, monthIndex);
  }

  DateTime? _getIncreaseDate(DateTime contractStart) {
    final now = DateTime.now();
    int yearsPassed = now.year - contractStart.year;

    if (now.month < contractStart.month ||
        (now.month == contractStart.month && now.day < contractStart.day)) {
      yearsPassed--;
    }

    if (yearsPassed >= 1) {
      return DateTime(
        contractStart.year + yearsPassed,
        contractStart.month,
        contractStart.day,
      );
    }

    return null;
  }

  double? _findRentOnOrBefore(List<PagoMensual> pagos, DateTime targetDate, double fallback) {
    for (final pago in pagos) {
      final pagoDate = _parsePagoDate(pago);
      if (pagoDate == null) continue;
      if (!pagoDate.isAfter(targetDate)) {
        return pago.valorArriendo;
      }
    }

    return fallback;
  }
}
