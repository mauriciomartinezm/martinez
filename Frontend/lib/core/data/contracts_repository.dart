import '../models/apartment.dart';
import '../models/contract.dart';
import '../services/api_service.dart';

/// Repositorio con caché en memoria para contratos y apartamentos.
class ContractsRepository {
  ContractsRepository._();
  static final ContractsRepository instance = ContractsRepository._();

  List<Contract>? _contracts;
  List<Apartment>? _apartments;

  Future<void> preloadAll({bool forceRefresh = false}) async {
    if (!forceRefresh && _contracts != null && _apartments != null) return;
    final results = await Future.wait([
      fetchContracts(),
      fetchApartments(),
    ]);
    _contracts = results[0] as List<Contract>;
    _apartments = results[1] as List<Apartment>;
  }

  Future<List<Contract>> getContracts({bool forceRefresh = false}) async {
    if (forceRefresh || _contracts == null) {
      _contracts = await fetchContracts();
    }
    return _contracts!;
  }

  Future<List<Apartment>> getApartments({bool forceRefresh = false}) async {
    if (forceRefresh || _apartments == null) {
      _apartments = await fetchApartments();
    }
    return _apartments!;
  }

  List<Contract> get cachedContracts => _contracts ?? const [];
  List<Apartment> get cachedApartments => _apartments ?? const [];

  void clearCache() {
    _contracts = null;
    _apartments = null;
  }
}
