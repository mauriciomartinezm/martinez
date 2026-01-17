import 'package:flutter/material.dart';
import '../../../core/models/pago_mensual.dart';
import '../../../core/models/contract.dart';

class TenantPaymentsController extends ChangeNotifier {
  bool _isLoading = false;
  List<PagoMensual> _payments = [];
  Contract? _latestContract;
  Contract? _firstContract;
  String? _errorMessage;

  // Getters
  bool get isLoading => _isLoading;
  List<PagoMensual> get payments => _payments;
  Contract? get latestContract => _latestContract;
  Contract? get firstContract => _firstContract;
  String? get errorMessage => _errorMessage;

  void loadPayments(String tenantId, List<PagoMensual> allPayments, List<Contract> allContracts) {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Filtrar pagos por arrendatario usando los pagos locales
      _payments = allPayments.where((pago) {
        return pago.contratoArriendo.arrendatario.id == tenantId;
      }).toList();
      
      // Ordenar por año y mes (más recientes primero)
      _payments.sort((a, b) {
        final yearCompare = b.anio.compareTo(a.anio);
        if (yearCompare != 0) return yearCompare;
        
        final monthOrder = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
                           'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
        final aIndex = monthOrder.indexOf(a.mes);
        final bIndex = monthOrder.indexOf(b.mes);
        return bIndex.compareTo(aIndex);
      });
      // Obtener el contrato más reciente y el primer contrato usando los contratos locales
      final tenantContracts = allContracts.where((c) => c.tenantId == tenantId).toList();
      if (tenantContracts.isNotEmpty) {
        tenantContracts.sort((a, b) => b.fechaInicio.compareTo(a.fechaInicio));
        _latestContract = tenantContracts.first; // Contrato más reciente
        _firstContract = tenantContracts.last; // Primer contrato histórico
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al cargar pagos: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  String formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',')}';
  }

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  double getTotalPaid() {
    return _payments.fold(0, (sum, pago) => sum + pago.totalNeto);
  }

  double getTotalFondoInmueble() {
    return _payments.fold(
      0,
      (sum, pago) => sum + (pago.fondoInmueble ?? 0),
    );
  }

  int getPaymentsSinceContract() {
    //debugPrint('Calculando pagos desde el último aumento...');
    if (_firstContract == null) return _payments.length;
    
    // Obtener la fecha del último aumento realizado
    final lastIncreaseDate = getIncreaseDate();
    
    // Si no ha habido ningún aumento, contar desde el primer contrato
    final countFromDate = lastIncreaseDate ?? _firstContract!.fechaInicio;
    
    //debugPrint('Contando desde: $countFromDate');
    int count = 0;
    
    for (var pago in _payments) {
      // Parsear el mes y año del pago para comparar
      final monthOrder = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
                         'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
      final monthIndex = monthOrder.indexOf(pago.mes) + 1;
      final year = int.tryParse(pago.anio) ?? 0;
      
      if (year > 0 && monthIndex > 0) {
        final pagoDate = DateTime(year, monthIndex);
        // Contar pagos DESPUÉS del último aumento (no incluir el mes del aumento)
        if (pagoDate.isAfter(countFromDate)) {
          count++;
        }
      }
    }
    
    //debugPrint('Pagos desde último aumento: $count');
    return count;
  }

  DateTime? getIncreaseDate() {
    if (_firstContract == null) return null;
    
    final contractStart = _firstContract!.fechaInicio;
    final now = DateTime.now();
    
    // Calcular cuántos años completos han pasado desde el primer contrato
    int yearsPassed = now.year - contractStart.year;
    
    // Ajustar si aún no ha llegado el mes/día del aniversario este año
    if (now.month < contractStart.month || 
        (now.month == contractStart.month && now.day < contractStart.day)) {
      yearsPassed--;
    }
    
    // Si ha pasado al menos 1 año, retornar la fecha del último aniversario
    if (yearsPassed >= 1) {
      return DateTime(
        contractStart.year + yearsPassed,
        contractStart.month,
        contractStart.day,
      );
    }
    
    return null;
  }

  DateTime? getNextIncreaseDate() {
    if (_firstContract == null) return null;
    
    final contractStart = _firstContract!.fechaInicio;
    final now = DateTime.now();
    
    // Calcular cuántos años completos han pasado desde el primer contrato
    int yearsPassed = now.year - contractStart.year;
    
    // Ajustar si aún no ha llegado el mes/día del aniversario este año
    if (now.month < contractStart.month || 
        (now.month == contractStart.month && now.day < contractStart.day)) {
      yearsPassed--;
    }
    
    // Retornar la fecha del próximo aniversario
    return DateTime(
      contractStart.year + yearsPassed + 1,
      contractStart.month,
      contractStart.day,
    );
  }

  Map<String, List<PagoMensual>> getPaymentsByYear() {
    Map<String, List<PagoMensual>> grouped = {};
    for (var pago in _payments) {
      if (!grouped.containsKey(pago.anio)) {
        grouped[pago.anio] = [];
      }
      grouped[pago.anio]!.add(pago);
    }
    return grouped;
  }
}
