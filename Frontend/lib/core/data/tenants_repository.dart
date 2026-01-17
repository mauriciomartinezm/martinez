import '../models/tenant.dart';
import '../models/contract.dart';
import '../models/apartment.dart';
import '../models/pago_mensual.dart';
import '../services/api_service.dart';
import 'contracts_repository.dart';

/// Repositorio con caché en memoria para arrendatarios y pagos.
/// Reutiliza ContractsRepository para contratos y apartamentos.
class TenantsRepository {
  TenantsRepository._();
  static final TenantsRepository instance = TenantsRepository._();

  final ContractsRepository _contractsRepository = ContractsRepository.instance;

  List<Tenant>? _tenants;
  List<PagoMensual>? _payments;

  Future<void> preloadAll({bool forceRefresh = false}) async {
    await Future.wait([
      getTenants(forceRefresh: forceRefresh),
      getPayments(forceRefresh: forceRefresh),
      _contractsRepository.getContracts(forceRefresh: forceRefresh),
      _contractsRepository.getApartments(forceRefresh: forceRefresh),
    ]);
  }

  Future<List<Tenant>> getTenants({bool forceRefresh = false}) async {
    if (forceRefresh || _tenants == null) {
      _tenants = await fetchTenants();
    }
    return _tenants!;
  }

  Future<List<PagoMensual>> getPayments({bool forceRefresh = false}) async {
    if (forceRefresh || _payments == null) {
      _payments = await fetchPagos();
    }
    return _payments!;
  }

  Future<List<Contract>> getContracts({bool forceRefresh = false}) async {
    return _contractsRepository.getContracts(forceRefresh: forceRefresh);
  }

  Future<List<Apartment>> getApartments({bool forceRefresh = false}) async {
    return _contractsRepository.getApartments(forceRefresh: forceRefresh);
  }

  List<Tenant> get cachedTenants => _tenants ?? const [];
  List<PagoMensual> get cachedPayments => _payments ?? const [];

  void clearCache() {
    _tenants = null;
    _payments = null;
    _contractsRepository.clearCache();
  }
}
