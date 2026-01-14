import 'package:flutter/material.dart';
import '../../../core/models/building.dart';
import '../../../core/models/apartment.dart';
import '../services/api_service.dart';

/// Controller for properties feature.
class PropertiesController extends ChangeNotifier {
  PropertiesController();

  int _selectedTab = 0;
  int get selectedTab => _selectedTab;

  List<Building> _buildings = [];
  List<Building> get buildings => _buildings;

  List<Apartment> _allApartments = [];
  Map<String, int> _activeCountByBuilding = {};

  List<Apartment> _apartments = [];
  List<Apartment> get apartments => _apartments;

  int activeApartmentsCount(String buildingId) => _activeCountByBuilding[buildingId] ?? 0;

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

  /// Load buildings from service.
  Future<void> loadBuildings() async {
    _setLoading(true);
    try {
      final buildingsFuture = fetchBuildings();
      final apartmentsFuture = fetchApartments();

      _buildings = await buildingsFuture;
      _allApartments = await apartmentsFuture;
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
        _allApartments = await fetchApartments();
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

  /// Change the selected tab.
  void setTab(int index) {
    _selectedTab = index;
    // Reset to buildings view when changing tabs
    if (index != 1 && (_currentScreen == 'apartments' || _currentScreen == 'apartment_detail')) {
      goBackToBuildings();
    }
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
    return _allApartments.where((apt) => apt.edificio.id == buildingId).toList();
  }
}

