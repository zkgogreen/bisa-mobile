import 'package:flutter/foundation.dart';
import '../services/mock_auth_service.dart';

/// Mock Auth Provider untuk development tanpa Firebase
/// Provider ini menggunakan MockAuthService untuk simulasi authentication
class MockAuthProvider extends ChangeNotifier {
  final MockAuthService _authService = MockAuthService();
  
  // State variables
  MockUser? _user;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isInitialized = false;

  // Getters
  MockUser? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _user != null;
  bool get isInitialized => _isInitialized;

  /// Constructor - initialize auth service
  MockAuthProvider() {
    _initializeAuth();
  }

  /// Initialize authentication
  Future<void> _initializeAuth() async {
    _setLoading(true);
    try {
      await _authService.initialize();
      _user = _authService.currentUser;
      _isInitialized = true;
    } catch (e) {
      _setError('Initialization failed: ${e.toString()}');
    }
    _setLoading(false);
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

  /// Login dengan Google (Mock)
  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);
      _setError(null);

      final user = await _authService.signInWithGoogle();
      
      if (user != null) {
        _user = user;
        _setLoading(false);
        return true;
      } else {
        _setLoading(false);
        return false;
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

  /// Check if user has complete profile
  bool get hasCompleteProfile {
    if (_user == null) return false;
    return _user!.displayName.isNotEmpty;
  }

  /// Get user display name or email
  String get userDisplayName {
    if (_user == null) return 'Guest';
    return _user!.displayName.isNotEmpty ? _user!.displayName : _user!.email;
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