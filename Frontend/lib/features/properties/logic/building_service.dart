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

/// Model for an apartment.
class Apartment {
  final String id;
  final String unit;
  final String buildingId;
  final String tenant;
  final String status;
  final String address;
  final String? rentDate;
  final String? rentAmount;

  Apartment({
    required this.id,
    required this.unit,
    required this.buildingId,
    required this.tenant,
    required this.status,
    required this.address,
    this.rentDate,
    this.rentAmount,
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
        id: '4',
        name: 'Edificio Gaitán 3',
        address: 'Calle 82 #67-28',
        occupancy: 'Ocupado 2/3',
      ),
      Building(
        id: '3',
        name: 'Edificio Manantial',
        address: 'Calle 82 #67-28',
        occupancy: 'Ocupado 2/3',
      ),
    ];
  }

  /// Fetch apartments for a specific building.
  Future<List<Apartment>> getApartmentsByBuilding(String buildingId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    // Mock data: return apartments based on building ID
    final mockApartments = {
      '1': [
        Apartment(id: '1', unit: 'Apt 101', buildingId: '1', tenant: 'Juan García', status: 'Ocupado', address: '123 Calle Falsa', rentDate: '01/04/2024', rentAmount: '\$2,000'),
        Apartment(id: '2', unit: 'Apt 102', buildingId: '1', tenant: 'María López', status: 'Ocupado', address: '123 Calle Falsa', rentDate: '15/03/2024', rentAmount: '\$1,800'),
        Apartment(id: '3', unit: 'Apt 103', buildingId: '1', tenant: 'Disponible', status: 'Libre', address: '123 Calle Falsa'),
      ],
      '2': [
        Apartment(id: '4', unit: 'Apt 201', buildingId: '2', tenant: 'Carlos Ruiz', status: 'Ocupado', address: '456 Avenida Principal', rentDate: '10/02/2024', rentAmount: '\$2,200'),
        Apartment(id: '5', unit: 'Apt 202', buildingId: '2', tenant: 'Ana Martínez', status: 'Ocupado', address: '456 Avenida Principal', rentDate: '20/01/2024', rentAmount: '\$2,100'),
      ],
      '3': [
        Apartment(id: '6', unit: 'Apt 301', buildingId: '3', tenant: 'Disponible', status: 'Libre', address: '789 Calle Nueva'),
        Apartment(id: '7', unit: 'Apt 302', buildingId: '3', tenant: 'Disponible', status: 'Libre', address: '789 Calle Nueva'),
        Apartment(id: '8', unit: 'Apt 303', buildingId: '3', tenant: 'Disponible', status: 'Libre', address: '789 Calle Nueva'),
      ],
      '4': [
        Apartment(id: '9', unit: 'Apt 401', buildingId: '4', tenant: 'Pedro Díaz', status: 'Ocupado', address: '321 Carrera Central', rentDate: '05/05/2024', rentAmount: '\$1,900'),
      ],
    };
    return mockApartments[buildingId] ?? [];
  }
}
