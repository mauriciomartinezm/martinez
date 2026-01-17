import 'package:flutter/material.dart';

/// Controller for home feature.
class HomeController extends ChangeNotifier {
  HomeController();

  int _selectedTab = 0;
  int get selectedTab => _selectedTab;

  /// Change the selected tab.
  void setTab(int index) {
    _selectedTab = index;
    notifyListeners();
  }
}
