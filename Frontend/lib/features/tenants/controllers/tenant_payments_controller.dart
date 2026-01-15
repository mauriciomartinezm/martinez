import 'package:flutter/material.dart';
import '../../../core/models/pago_mensual.dart';
import '../../../core/models/contract.dart';

class TenantPaymentsController extends ChangeNotifier {
  bool _isLoading = false;
  List<PagoMensual> _payments = [];
  Contract? _latestContract;
  String? _errorMessage;

  // Getters
  bool get isLoading => _isLoading;
  List<PagoMensual> get payments => _payments;
  Contract? get latestContract => _latestContract;
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
      // Obtener el contrato más reciente usando los contratos locales
      final tenantContracts = allContracts.where((c) => c.tenantId == tenantId).toList();
      if (tenantContracts.isNotEmpty) {
        tenantContracts.sort((a, b) => b.fechaInicio.compareTo(a.fechaInicio));
        _latestContract = tenantContracts.first;
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
    if (_latestContract == null) return _payments.length;
    
    // Contar pagos desde la fecha de inicio del contrato
    final contractStart = _latestContract!.fechaInicio;
    int count = 0;
    
    for (var pago in _payments) {
      // Parsear el mes y año del pago para comparar
      final monthOrder = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
                         'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
      final monthIndex = monthOrder.indexOf(pago.mes) + 1;
      final year = int.tryParse(pago.anio) ?? 0;
      
      if (year > 0 && monthIndex > 0) {
        final pagoDate = DateTime(year, monthIndex);
        if (pagoDate.isAfter(contractStart) || 
            pagoDate.year == contractStart.year && pagoDate.month == contractStart.month) {
          count++;
        }
      }
    }
    
    return count;
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
