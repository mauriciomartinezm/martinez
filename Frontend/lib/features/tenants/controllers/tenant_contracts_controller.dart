import 'package:flutter/material.dart';
import '../../../core/models/contract.dart';

class TenantContractsController extends ChangeNotifier {
  bool _isLoading = false;
  List<Contract> _contracts = [];
  String? _errorMessage;

  // Getters
  bool get isLoading => _isLoading;
  List<Contract> get contracts => _contracts;
  String? get errorMessage => _errorMessage;

  void loadContracts(String tenantId, List<Contract> allContracts) {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Filtrar contratos por arrendatario usando los contratos locales
      _contracts = allContracts.where((contract) {
        return contract.tenantId == tenantId;
      }).toList();
      
      // Ordenar por fecha de inicio (más recientes primero)
      _contracts.sort((a, b) => b.fechaInicio.compareTo(a.fechaInicio));
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al cargar contratos: $e';
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

  int getDaysUntilExpiration(Contract contract) {
    if (contract.fechaFin == null) return -1;
    return contract.fechaFin!.difference(DateTime.now()).inDays;
  }

  bool isContractExpiringSoon(Contract contract) {
    final daysUntilExpiration = getDaysUntilExpiration(contract);
    return daysUntilExpiration >= 0 && daysUntilExpiration <= 30;
  }

  int getActiveContractsCount() {
    return _contracts.where((c) => c.estado == 'vigente').length;
  }

  double getTotalMonthlyAmount() {
    return _contracts
        .where((c) => c.estado == 'vigente')
        .fold(0, (sum, contract) => sum + contract.montoMensual);
  }
}
