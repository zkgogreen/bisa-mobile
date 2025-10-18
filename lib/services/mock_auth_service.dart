import 'package:shared_preferences/shared_preferences.dart';

/// Mock Authentication Service untuk development tanpa Firebase
/// Service ini mensimulasikan login/logout tanpa koneksi ke server
class MockAuthService {
  static const String _isLoggedInKey = 'mock_is_logged_in';
  static const String _userNameKey = 'mock_user_name';
  static const String _userEmailKey = 'mock_user_email';
  static const String _userPhotoKey = 'mock_user_photo';

  // Simulasi user yang sedang login
  MockUser? _currentUser;

  /// Get current user
  MockUser? get currentUser => _currentUser;

  /// Check if user is logged in
  bool get isLoggedIn => _currentUser != null;

  /// Initialize service dan load saved login state
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
    
    if (isLoggedIn) {
      _currentUser = MockUser(
        name: prefs.getString(_userNameKey) ?? 'Demo User',
        email: prefs.getString(_userEmailKey) ?? 'demo@bisabasa.com',
        photoUrl: prefs.getString(_userPhotoKey),
      );
    }
  }

  /// Simulasi login dengan Google
  Future<MockUser?> signInWithGoogle() async {
    // Simulasi delay network
    await Future.delayed(const Duration(seconds: 2));
    
    // Simulasi user data dari Google
    _currentUser = MockUser(
      name: 'Demo User',
      email: 'demo@bisabasa.com',
      photoUrl: 'https://via.placeholder.com/150/4CAF50/FFFFFF?text=DU',
    );

    // Save login state
    await _saveLoginState();
    
    return _currentUser;
  }

  /// Simulasi logout
  Future<void> signOut() async {
    _currentUser = null;
    
    // Clear saved login state
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userPhotoKey);
  }

  /// Update user profile
  Future<void> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    if (_currentUser != null) {
      _currentUser = MockUser(
        name: displayName ?? _currentUser!.name,
        email: _currentUser!.email,
        photoUrl: photoURL ?? _currentUser!.photoUrl,
      );
      await _saveLoginState();
    }
  }

  /// Save login state to SharedPreferences
  Future<void> _saveLoginState() async {
    if (_currentUser != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setString(_userNameKey, _currentUser!.name);
      await prefs.setString(_userEmailKey, _currentUser!.email);
      if (_currentUser!.photoUrl != null) {
        await prefs.setString(_userPhotoKey, _currentUser!.photoUrl!);
      }
    }
  }

  /// Get user info as Map
  Map<String, dynamic>? getUserInfo() {
    if (_currentUser == null) return null;
    
    return {
      'name': _currentUser!.name,
      'email': _currentUser!.email,
      'photoUrl': _currentUser!.photoUrl,
    };
  }
}

/// Mock User class untuk simulasi user data
class MockUser {
  final String name;
  final String email;
  final String? photoUrl;

  MockUser({
    required this.name,
    required this.email,
    this.photoUrl,
  });

  String get displayName => name;
  String? get photoURL => photoUrl;
}