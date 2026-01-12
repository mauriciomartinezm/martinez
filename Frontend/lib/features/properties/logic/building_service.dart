/// Model for a building.
class Building {
  final String id;
  final String name;
  final String address;
  final String occupancy;

  Building({
    required this.id,
    required this.name,
    required this.address,
    required this.occupancy,
  });
}

/// Service to fetch buildings and related data.
class BuildingService {
  const BuildingService();

  /// Fetch mock buildings list.
  Future<List<Building>> getBuildings() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return [
      Building(
        id: '1',
        name: 'Edificio Gaitán 1',
        address: 'Calle 82 #67-28',
        occupancy: 'Ocupado 2/3',
      ),
      Building(
        id: '2',
        name: 'Edificio Gaitán 2',
        address: 'Calle 82 #67-28',
        occupancy: 'Ocupado 2/3',
      ),
      Building(
        id: '3',
        name: 'Edificio Manantial',
        address: 'Calle 82 #67-28',
        occupancy: 'Ocupado 2/3',
      ),
      Building(
        id: '4',
        name: 'Edificio Gaitán 1',
        address: 'Calle 82 #67-28',
        occupancy: 'Ocupado 2/3',
      ),
    ];
  }
}
