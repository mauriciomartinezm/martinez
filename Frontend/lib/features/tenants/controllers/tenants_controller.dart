import 'package:flutter/material.dart';
import '../../../core/services/api_service.dart';
import '../../../core/models/tenant.dart';

class TenantsController extends ChangeNotifier {
  bool _isLoading = false;
  List<Tenant> _tenants = [];
  String? _errorMessage;

  // Getters
  bool get isLoading => _isLoading;
  List<Tenant> get tenants => _tenants;
  String? get errorMessage => _errorMessage;

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
