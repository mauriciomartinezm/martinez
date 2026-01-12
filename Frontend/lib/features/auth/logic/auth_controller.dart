import 'package:flutter/material.dart';
import 'auth_service.dart';

/// Controller for authentication feature.
class AuthController extends ChangeNotifier {
  AuthController({AuthService? service}) : _service = service ?? const AuthService();

  final AuthService _service;
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> login() async {
    _setLoading(true);
    /*
    final success = await _service.login(
      username: userController.text,
      password: passController.text,
    );
    _setLoading(false);
    return success;
    */
    return true;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    userController.dispose();
    passController.dispose();
    super.dispose();
  }
}
