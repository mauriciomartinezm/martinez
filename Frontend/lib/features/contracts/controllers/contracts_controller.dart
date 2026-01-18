import 'package:flutter/material.dart';
import '../../../core/models/apartment.dart';
import '../../../core/models/contract.dart';
import '../../../core/models/building.dart';
import '../../../core/data/contracts_repository.dart';

class ContractsController extends ChangeNotifier {
  ContractsController({ContractsRepository? repository})
      : _repository = repository ?? ContractsRepository.instance;

  final ContractsRepository _repository;
  bool _isLoading = false;
  List<Contract> _contracts = [];
  String? _errorMessage;
  List<Apartment> _apartments = [];

  // Getters
  bool get isLoading => _isLoading;
  List<Contract> get contracts => _contracts;
  String? get errorMessage => _errorMessage;

  // Método para establecer datos cargados (compatibilidad)
  void setData(List<Apartment> apartments) {
    _apartments = apartments;
    notifyListeners();
  }

  Future<void> loadContracts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _contracts = await _repository.getContracts();
      _apartments = await _repository.getApartments();
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
      _contracts = await _repository.getContracts(forceRefresh: true);
      _apartments = await _repository.getApartments(forceRefresh: true);
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

  /// Determina si el arrendatario tiene derecho a aumento anual
  /// Solo es true si:
  /// 1. Ha pasado al menos 1 año desde el primer contrato
  /// 2. La fecha de terminación del contrato es en el mes del aniversario
  bool tenantQualifiesForIncrease(Contract contract) {
    // Verificar si el contrato tiene fecha de fin
    if (contract.fechaFin == null) return false;
    
    // Encontrar el primer contrato (más antiguo) de este arrendatario
    final tenantContracts = _contracts
        .where((c) => c.tenantId == contract.tenantId)
        .toList();
    
    if (tenantContracts.isEmpty) return false;
    
    // Ordenar por fecha de inicio y obtener el primero
    tenantContracts.sort((a, b) => a.fechaInicio.compareTo(b.fechaInicio));
    final firstContractStart = tenantContracts.first.fechaInicio;
    
    final now = DateTime.now();
    
    // 1. Verificar si ha pasado al menos 1 año completo
    int yearsPassed = now.year - firstContractStart.year;
    if (now.month < firstContractStart.month ||
        (now.month == firstContractStart.month && 
         now.day < firstContractStart.day)) {
      yearsPassed--;
    }
    
    if (yearsPassed < 1) return false;
    
    // 2. Verificar si la fecha de terminación es en el mes del aniversario
    return contract.fechaFin!.month == firstContractStart.month;
  }

  // Método para obtener información del apartamento y edificio del contrato
  String getApartmentInfo(Contract contract) {
    final apartmentId = contract.apartamentoId;
    // Buscar el apartamento correspondiente para obtener el edificio
    final apartment = _apartments.firstWhere(
      (apt) => apt.id == apartmentId,
      orElse: () => _apartments.isNotEmpty ? _apartments.first : Apartment(
        activa: false,
        edificio: Building(id: '', nombre: 'Desconocido', direccion: ''),
        id: '',
        piso: '',
      ),
    );
    if (apartmentId.isEmpty) {
      return 'No asignado';
    }
    
    return '${apartment.edificio.nombre} - Apto ${apartment.piso}';
  }
}
