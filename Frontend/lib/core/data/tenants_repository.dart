import '../models/tenant.dart';
import '../models/contract.dart';
import '../models/apartment.dart';
import '../models/pago_mensual.dart';
import 'data_repository.dart';

/// Repositorio para arrendatarios que usa el DataRepository global.
class TenantsRepository {
  TenantsRepository._();
  static final TenantsRepository instance = TenantsRepository._();

  final DataRepository _dataRepo = DataRepository.instance;

  Future<void> preloadAll({bool forceRefresh = false}) async {
    await _dataRepo.preloadAll(forceRefresh: forceRefresh);
  }

  Future<List<Tenant>> getTenants({bool forceRefresh = false}) async {
    return _dataRepo.getTenants(forceRefresh: forceRefresh);
  }

  Future<List<Contract>> getContracts({bool forceRefresh = false}) async {
    return _dataRepo.getContracts(forceRefresh: forceRefresh);
  }

  Future<List<Apartment>> getApartments({bool forceRefresh = false}) async {
    return _dataRepo.getApartments(forceRefresh: forceRefresh);
  }

  Future<List<PagoMensual>> getPayments({bool forceRefresh = false}) async {
    return _dataRepo.getPayments(forceRefresh: forceRefresh);
  }

  List<Tenant> get cachedTenants => _dataRepo.cachedTenants;
  List<Contract> get cachedContracts => _dataRepo.cachedContracts;
  List<Apartment> get cachedApartments => _dataRepo.cachedApartments;
  List<PagoMensual> get cachedPayments => _dataRepo.cachedPayments;

  void clearCache() {
    _dataRepo.clearTenantsCache();
    _dataRepo.clearContractsCache();
    _dataRepo.clearApartmentsCache();
    _dataRepo.clearPaymentsCache();
  }
}
