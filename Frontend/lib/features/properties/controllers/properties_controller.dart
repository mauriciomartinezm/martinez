import 'package:flutter/material.dart';
import '../../../core/models/building.dart';
import '../../../core/models/apartment.dart';
import '../../../core/data/properties_repository.dart';

/// Controller for properties feature (buildings and apartments).
class PropertiesController extends ChangeNotifier {
  PropertiesController({PropertiesRepository? repository})
      : _repository = repository ?? PropertiesRepository.instance;

  final PropertiesRepository _repository;

  List<Building> _buildings = [];
  List<Building> get buildings => _buildings;

  List<Apartment> _allApartments = [];
  Map<String, int> _activeCountByBuilding = {};

  List<Apartment> _apartments = [];
  List<Apartment> get apartments => _apartments;

  int activeApartmentsCount(String buildingId) =>
      _activeCountByBuilding[buildingId] ?? 0;

  int totalApartmentsCount(String buildingId) {
    return _allApartments.where((apt) => apt.edificio.id == buildingId).length;
  }

  Building? _selectedBuilding;
  Building? get selectedBuilding => _selectedBuilding;

  Apartment? _selectedApartment;
  Apartment? get selectedApartment => _selectedApartment;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Screen navigation state: 'buildings', 'apartments', 'apartment_detail'
  String _currentScreen = 'buildings';
  String get currentScreen => _currentScreen;

  /// Load buildings from repository.
  Future<void> loadBuildings() async {
    _setLoading(true);
    try {
      _buildings = await _repository.getBuildings();
      _allApartments = await _repository.getApartments();
      _recomputeActiveCounts();
    } catch (e) {
      _buildings = [];
      _allApartments = [];
      _activeCountByBuilding = {};
    }
    _setLoading(false);
  }

  /// Load apartments for a specific building.
  Future<void> selectBuilding(Building building) async {
    _selectedBuilding = building;
    _setLoading(true);
    try {
      if (_allApartments.isEmpty) {
        _allApartments = await _repository.getApartments();
        _recomputeActiveCounts();
      }
      _apartments = _filterApartmentsByBuilding(building.id);
    } catch (e) {
      _apartments = [];
    }
    _currentScreen = 'apartments';
    _setLoading(false);
  }

  /// Select an apartment and show its details.
  void selectApartment(Apartment apartment) {
    _selectedApartment = apartment;
    _currentScreen = 'apartment_detail';
    notifyListeners();
  }

  /// Go back to apartments list.
  void goBackToApartments() {
    _currentScreen = 'apartments';
    _selectedApartment = null;
    notifyListeners();
  }

  /// Go back to buildings list.
  void goBackToBuildings() {
    _currentScreen = 'buildings';
    _selectedBuilding = null;
    _apartments = [];
    _selectedApartment = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _recomputeActiveCounts() {
    final Map<String, int> counts = {};
    for (final apt in _allApartments.where((apt) => apt.activa)) {
      counts.update(apt.edificio.id, (value) => value + 1, ifAbsent: () => 1);
    }
    _activeCountByBuilding = counts;
  }

  List<Apartment> _filterApartmentsByBuilding(String buildingId) {
    return _allApartments
        .where((apt) => apt.edificio.id == buildingId)
        .toList();
  }
}
