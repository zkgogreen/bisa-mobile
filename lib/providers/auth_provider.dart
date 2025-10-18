import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

/// Provider untuk mengelola state authentication
/// Menggunakan ChangeNotifier untuk reactive state management
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  // State variables
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _user != null;

  /// Constructor - listen to auth state changes
  AuthProvider() {
    _initializeAuth();
  }

  /// Initialize authentication listener
  void _initializeAuth() {
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error message
  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Login dengan Google
  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);
      _setError(null);

      final userCredential = await _authService.signInWithGoogle();
      
      if (userCredential != null) {
        _user = userCredential.user;
        _setLoading(false);
        return true;
      } else {
        _setLoading(false);
        return false; // User canceled
      }
    } catch (e) {
      _setError('Login gagal: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// Logout
  Future<void> signOut() async {
    try {
      _setLoading(true);
      _setError(null);

      await _authService.signOut();
      _user = null;
      _setLoading(false);
    } catch (e) {
      _setError('Logout gagal: ${e.toString()}');
      _setLoading(false);
    }
  }

  /// Update user profile
  Future<bool> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      await _authService.updateProfile(
        displayName: displayName,
        photoURL: photoURL,
      );
      
      // Refresh user data
      _user = _authService.currentUser;
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Update profile gagal: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// Get user info as Map
  Map<String, dynamic>? getUserInfo() {
    return _authService.getUserInfo();
  }

  /// Check if user has completed profile
  bool get hasCompleteProfile {
    if (_user == null) return false;
    return _user!.displayName != null && _user!.displayName!.isNotEmpty;
  }

  /// Get user display name or email
  String get userDisplayName {
    if (_user == null) return 'Guest';
    return _user!.displayName ?? _user!.email ?? 'User';
  }

  /// Get user photo URL
  String? get userPhotoURL {
    return _user?.photoURL;
  }

  /// Get user email
  String? get userEmail {
    return _user?.email;
  }
}