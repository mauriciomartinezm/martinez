import 'package:flutter/material.dart';
import '../../../core/models/tenant.dart';
import '../../../core/models/contract.dart';
import '../../../core/models/apartment.dart';
import '../../../core/models/pago_mensual.dart';
import '../../../core/models/building.dart';
import '../../../core/data/tenants_repository.dart';
import 'tenant_payments_controller.dart';

class TenantsController extends ChangeNotifier {
  TenantsController({TenantsRepository? repository})
      : _repository = repository ?? TenantsRepository.instance;

  final TenantsRepository _repository;
  bool _isLoading = false;
  List<Tenant> _tenants = [];
  String? _errorMessage;
  List<Contract> _contracts = [];
  List<Apartment> _apartments = [];
  List<PagoMensual> _payments = [];

  // Getters
  bool get isLoading => _isLoading;
  List<Tenant> get tenants => _tenants;
  String? get errorMessage => _errorMessage;
  List<Contract> get contracts => _contracts;
  List<Apartment> get apartments => _apartments;
  List<PagoMensual> get payments => _payments;

  // Método para establecer datos cargados (compatibilidad)
  void setData(List<Contract> contracts, List<Apartment> apartments) {
    _contracts = contracts;
    _apartments = apartments;
    notifyListeners();
  }

  // Método para obtener información del apartamento y edificio del arrendatario
  String getApartmentInfo(Tenant tenant) {
    // Buscar el contrato activo del tenant
    final activeContract = _contracts.firstWhere(
      (contract) => contract.tenantId == tenant.id && contract.estado == 'true',
      orElse: () => _contracts.firstWhere(
        (contract) => contract.tenantId == tenant.id,
        orElse: () => Contract(
          id: '',
          tenantId: '',
          tenantName: '',
          apartamento: 'No asignado',
          apartamentoId: '',
          fechaInicio: DateTime.now(),
          montoMensual: 0,
          estado: '',
          documento: '',
        ),
      ),
    );
    
    final apartmentId = activeContract.apartamentoId;
    
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
    
    if (apartmentId == 'No asignado') {
      return 'No asignado';
    }
    
    return '${apartment.edificio.nombre} - Apto ${apartment.piso}';
  }

  Future<void> loadTenants() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.preloadAll();
      _tenants = await _repository.getTenants();
      _contracts = await _repository.getContracts();
      _apartments = await _repository.getApartments();
      _payments = await _repository.getPayments();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al cargar arrendatarios: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshTenants(BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tenants = await _repository.getTenants(forceRefresh: true);
      _contracts = await _repository.getContracts(forceRefresh: true);
      _apartments = await _repository.getApartments(forceRefresh: true);
      _payments = await _repository.getPayments(forceRefresh: true);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al actualizar: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Detecta si un arrendatario tiene aumento anual pendiente
  bool hasPendingIncrease(Tenant tenant) {
    final paymentsController = TenantPaymentsController();
    paymentsController.loadPayments(tenant.id, _payments, _contracts);
    return paymentsController.hasPendingAnnualIncrease();
  }

}
