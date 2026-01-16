import 'package:flutter/material.dart';
import '../../../core/services/api_service.dart';
import '../../../core/models/tenant.dart';
import '../../../core/models/contract.dart';
import '../../../core/models/apartment.dart';
import '../../../core/models/building.dart';

class TenantsController extends ChangeNotifier {
  bool _isLoading = false;
  List<Tenant> _tenants = [];
  String? _errorMessage;
  List<Contract> _contracts = [];
  List<Apartment> _apartments = [];

  // Getters
  bool get isLoading => _isLoading;
  List<Tenant> get tenants => _tenants;
  String? get errorMessage => _errorMessage;
  List<Contract> get contracts => _contracts;
  List<Apartment> get apartments => _apartments;

  // Método para establecer datos cargados
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
      // Fetch apartments y mapear a tenants
      // Por ahora usamos un endpoint que devuelve arrendatarios
      // Si no existe, podemos mapear desde los apartamentos
      _tenants = await _fetchTenantsFromApi();
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
      _tenants = await _fetchTenantsFromApi();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al actualizar: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Tenant>> _fetchTenantsFromApi() async {
    return await fetchTenants();
  }

  // Método para obtener pagos de un arrendatario
  Future<List<Map<String, dynamic>>> getTenantPayments(String tenantId) async {
    try {
      // Implementar cuando exista el endpoint
      return [];
    } catch (e) {
      throw Exception('Error al obtener pagos: $e');
    }
  }

  // Método para obtener contratos de un arrendatario
  Future<List<Map<String, dynamic>>> getTenantContracts(String tenantId) async {
    try {
      // Implementar cuando exista el endpoint
      return [];
    } catch (e) {
      throw Exception('Error al obtener contratos: $e');
    }
  }
}
