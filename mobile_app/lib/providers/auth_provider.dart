import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userId;
  String? _userEmail;
  String? _userName;
  String? _userAvatar;
  bool _isLoading = false;

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  String? get userId => _userId;
  String? get userEmail => _userEmail;
  String? get userName => _userName;
  String? get userAvatar => _userAvatar;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _loadUserData();
  }

  // Load user data from local storage
  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
      _userId = prefs.getString('userId');
      _userEmail = prefs.getString('userEmail');
      _userName = prefs.getString('userName');
      _userAvatar = prefs.getString('userAvatar');
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  // Save user data to local storage
  Future<void> _saveUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAuthenticated', _isAuthenticated);
      if (_userId != null) await prefs.setString('userId', _userId!);
      if (_userEmail != null) await prefs.setString('userEmail', _userEmail!);
      if (_userName != null) await prefs.setString('userName', _userName!);
      if (_userAvatar != null) await prefs.setString('userAvatar', _userAvatar!);
    } catch (e) {
      debugPrint('Error saving user data: $e');
    }
  }

  // Sign in user
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Implement actual authentication
      // For now, simulate successful login
      await Future.delayed(const Duration(seconds: 2));
      
      _isAuthenticated = true;
      _userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
      _userEmail = email;
      _userName = email.split('@')[0];
      _userAvatar = null;

      await _saveUserData();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Sign up user
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Implement actual registration
      // For now, simulate successful registration
      await Future.delayed(const Duration(seconds: 2));
      
      _isAuthenticated = true;
      _userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
      _userEmail = email;
      _userName = name;
      _userAvatar = null;

      await _saveUserData();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Sign out user
  Future<void> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Implement actual sign out
      await Future.delayed(const Duration(seconds: 1));
      
      _isAuthenticated = false;
      _userId = null;
      _userEmail = null;
      _userName = null;
      _userAvatar = null;

      await _saveUserData();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Update user profile
  Future<void> updateProfile({
    String? name,
    String? avatar,
  }) async {
    try {
      if (name != null) _userName = name;
      if (avatar != null) _userAvatar = avatar;
      
      await _saveUserData();
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating profile: $e');
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Implement actual password reset
      await Future.delayed(const Duration(seconds: 2));
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Check if user is authenticated
  bool get isLoggedIn => _isAuthenticated && _userId != null;

  // Get user display name
  String get displayName => _userName ?? _userEmail ?? 'User';

  // Get user initials for avatar
  String get userInitials {
    if (_userName != null) {
      final names = _userName!.split(' ');
      if (names.length >= 2) {
        return '${names[0][0]}${names[1][0]}'.toUpperCase();
      }
      return _userName![0].toUpperCase();
    }
    if (_userEmail != null) {
      return _userEmail![0].toUpperCase();
    }
    return 'U';
  }
}