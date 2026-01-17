import '../models/building.dart';
import '../models/apartment.dart';
import 'data_repository.dart';

/// Repositorio para propiedades que usa el DataRepository global.
class PropertiesRepository {
  PropertiesRepository._();
  static final PropertiesRepository instance = PropertiesRepository._();

  final DataRepository _dataRepo = DataRepository.instance;

  Future<void> preloadAll({bool forceRefresh = false}) async {
    await Future.wait([
      _dataRepo.getBuildings(forceRefresh: forceRefresh),
      _dataRepo.getApartments(forceRefresh: forceRefresh),
    ]);
  }

  Future<List<Building>> getBuildings({bool forceRefresh = false}) async {
    return _dataRepo.getBuildings(forceRefresh: forceRefresh);
  }

  Future<List<Apartment>> getApartments({bool forceRefresh = false}) async {
    return _dataRepo.getApartments(forceRefresh: forceRefresh);
  }

  List<Building> get cachedBuildings => _dataRepo.cachedBuildings;
  List<Apartment> get cachedApartments => _dataRepo.cachedApartments;

  void clearCache() {
    _dataRepo.clearBuildingsCache();
    _dataRepo.clearApartmentsCache();
  }
}
