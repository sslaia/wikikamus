import 'package:flutter/material.dart';
import 'package:wikikamus/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoggedIn = false;
  bool _isLoading = true;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  AuthService get authService => _authService;

  AuthProvider() {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();
    _isLoggedIn = await _authService.isLoggedIn();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> login() async {
    try {
      await _authService.login();
      _isLoggedIn = true;
      notifyListeners();
    } catch (e) {
      print("Login failed in provider: $e");
      _isLoggedIn = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _isLoggedIn = false;
    notifyListeners();
  }
}
