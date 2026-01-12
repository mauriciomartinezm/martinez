import 'dart:async';

/// Handles authentication-related API calls.
class AuthService {
  const AuthService();

  /// Simulated login. Replace with real API integration.
  Future<bool> login({required String username, required String password}) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    // Simple mock: succeed if both fields are filled.
    return username.trim().isNotEmpty && password.isNotEmpty;
  }
}
