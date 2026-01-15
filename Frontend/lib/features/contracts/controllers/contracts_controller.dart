import 'package:flutter/material.dart';
import '../../../core/services/api_service.dart';
import '../../../core/models/contract.dart';

class ContractsController extends ChangeNotifier {
  bool _isLoading = false;
  List<Contract> _contracts = [];
  String? _errorMessage;

  // Getters
  bool get isLoading => _isLoading;
  List<Contract> get contracts => _contracts;
  String? get errorMessage => _errorMessage;

  Future<void> loadContracts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _contracts = await fetchContracts();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al cargar contratos: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshContracts(BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _contracts = await fetchContracts();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al actualizar: $e';
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
}
