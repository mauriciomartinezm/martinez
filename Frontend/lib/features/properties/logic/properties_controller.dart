import 'package:flutter/material.dart';
import 'building_service.dart';

/// Controller for properties feature.
class PropertiesController extends ChangeNotifier {
  PropertiesController({BuildingService? service})
      : _service = service ?? const BuildingService();

  final BuildingService _service;

  int _selectedTab = 0;
  int get selectedTab => _selectedTab;

  List<Building> _buildings = [];
  List<Building> get buildings => _buildings;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Load buildings from service.
  Future<void> loadBuildings() async {
    _setLoading(true);
    _buildings = await _service.getBuildings();
    _setLoading(false);
  }

  /// Change the selected tab.
  void setTab(int index) {
    _selectedTab = index;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
