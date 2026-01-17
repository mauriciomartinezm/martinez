import '../models/tenant.dart';
import '../models/contract.dart';
import '../models/apartment.dart';
import '../models/pago_mensual.dart';
import '../models/building.dart';
import '../services/api_service.dart';

/// Repositorio global con caché en memoria para todos los datos de la aplicación.
/// Implementa el patrón Singleton para garantizar una única fuente de verdad.
class DataRepository {
  DataRepository._();
  static final DataRepository instance = DataRepository._();

  // Cache de datos
  List<Tenant>? _tenants;
  List<Contract>? _contracts;
  List<Apartment>? _apartments;
  List<PagoMensual>? _payments;
  List<Building>? _buildings;

  /// Precarga todos los datos desde la API
  Future<void> preloadAll({bool forceRefresh = false}) async {
    if (!forceRefresh && 
        _tenants != null && 
        _contracts != null && 
        _apartments != null && 
        _payments != null && 
        _buildings != null) {
      return;
    }

    final results = await Future.wait([
      fetchTenants(),
      fetchContracts(),
      fetchApartments(),
      fetchPagos(),
      fetchBuildings(),
    ]);

    _tenants = results[0] as List<Tenant>;
    _contracts = results[1] as List<Contract>;
    _apartments = results[2] as List<Apartment>;
    _payments = results[3] as List<PagoMensual>;
    _buildings = results[4] as List<Building>;
  }

  // ============ TENANTS ============
  Future<List<Tenant>> getTenants({bool forceRefresh = false}) async {
    if (forceRefresh || _tenants == null) {
      _tenants = await fetchTenants();
    }
    return _tenants!;
  }

  List<Tenant> get cachedTenants => _tenants ?? const [];

  // ============ CONTRACTS ============
  Future<List<Contract>> getContracts({bool forceRefresh = false}) async {
    if (forceRefresh || _contracts == null) {
      _contracts = await fetchContracts();
    }
    return _contracts!;
  }

  List<Contract> get cachedContracts => _contracts ?? const [];

  // ============ APARTMENTS ============
  Future<List<Apartment>> getApartments({bool forceRefresh = false}) async {
    if (forceRefresh || _apartments == null) {
      _apartments = await fetchApartments();
    }
    return _apartments!;
  }

  List<Apartment> get cachedApartments => _apartments ?? const [];

  // ============ PAYMENTS ============
  Future<List<PagoMensual>> getPayments({bool forceRefresh = false}) async {
    if (forceRefresh || _payments == null) {
      _payments = await fetchPagos();
    }
    return _payments!;
  }

  List<PagoMensual> get cachedPayments => _payments ?? const [];

  // ============ BUILDINGS ============
  Future<List<Building>> getBuildings({bool forceRefresh = false}) async {
    if (forceRefresh || _buildings == null) {
      _buildings = await fetchBuildings();
    }
    return _buildings!;
  }

  List<Building> get cachedBuildings => _buildings ?? const [];

  /// Limpia toda la caché
  void clearCache() {
    _tenants = null;
    _contracts = null;
    _apartments = null;
    _payments = null;
    _buildings = null;
  }

  /// Limpia la caché de un tipo específico de datos
  void clearTenantsCache() => _tenants = null;
  void clearContractsCache() => _contracts = null;
  void clearApartmentsCache() => _apartments = null;
  void clearPaymentsCache() => _payments = null;
  void clearBuildingsCache() => _buildings = null;
}
