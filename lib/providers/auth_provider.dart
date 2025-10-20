import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider untuk autentikasi sederhana menggunakan email dan password
/// Menyimpan data user di SharedPreferences (local storage)
class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _userEmail;
  String? _userDisplayName;
  String? _userPhotoURL;
  bool _isLoading = false;

  // Getter untuk mengakses status login
  bool get isLoggedIn => _isLoggedIn;
  String? get userEmail => _userEmail;
  String? get userDisplayName => _userDisplayName;
  String? get userPhotoURL => _userPhotoURL;
  bool get isLoading => _isLoading;

  /// Konstruktor - memuat status login saat provider dibuat
  AuthProvider() {
    _loadUserData();
  }

  /// Memuat data user dari SharedPreferences
  /// BYPASS MODE: Set default user sebagai logged in
  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // BYPASS LOGIN: Set default logged in dengan user dummy
      _isLoggedIn = true;
      _userEmail = 'demo@bisabasa.com';
      _userDisplayName = 'Demo User';
      _userPhotoURL = 'https://ui-avatars.com/api/?name=Demo+User&background=ff6b35&color=fff';
      
      // Simpan data default ke SharedPreferences jika belum ada
      if (!prefs.containsKey('isLoggedIn')) {
        await _saveUserData();
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading user data: $e');
      // Fallback ke default user jika ada error
      _isLoggedIn = true;
      _userEmail = 'demo@bisabasa.com';
      _userDisplayName = 'Demo User';
      _userPhotoURL = 'https://ui-avatars.com/api/?name=Demo+User&background=ff6b35&color=fff';
      notifyListeners();
    }
  }

  /// Menyimpan data user ke SharedPreferences
  Future<void> _saveUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', _isLoggedIn);
      if (_userEmail != null) {
        await prefs.setString('userEmail', _userEmail!);
      }
      if (_userDisplayName != null) {
        await prefs.setString('userDisplayName', _userDisplayName!);
      }
      if (_userPhotoURL != null) {
        await prefs.setString('userPhotoURL', _userPhotoURL!);
      }
    } catch (e) {
      debugPrint('Error saving user data: $e');
    }
  }

  /// Login dengan email dan password
  /// Untuk demo, kita terima semua email yang valid dan password minimal 6 karakter
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulasi delay network
      await Future.delayed(const Duration(seconds: 1));

      // Validasi email format
      if (!_isValidEmail(email)) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Validasi password minimal 6 karakter
      if (password.length < 6) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Set data user
      _isLoggedIn = true;
      _userEmail = email;
      _userDisplayName = _extractNameFromEmail(email);
      _userPhotoURL = _generateAvatarUrl(email);

      // Simpan ke SharedPreferences
      await _saveUserData();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error during sign in: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Register user baru dengan email dan password
  Future<bool> registerWithEmailAndPassword(String email, String password, String displayName) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulasi delay network
      await Future.delayed(const Duration(seconds: 1));

      // Validasi email format
      if (!_isValidEmail(email)) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Validasi password minimal 6 karakter
      if (password.length < 6) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Validasi display name tidak kosong
      if (displayName.trim().isEmpty) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Set data user
      _isLoggedIn = true;
      _userEmail = email;
      _userDisplayName = displayName.trim();
      _userPhotoURL = _generateAvatarUrl(email);

      // Simpan ke SharedPreferences
      await _saveUserData();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error during registration: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logout user
  Future<void> signOut() async {
    try {
      _isLoggedIn = false;
      _userEmail = null;
      _userDisplayName = null;
      _userPhotoURL = null;

      // Hapus data dari SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');
      await prefs.remove('userEmail');
      await prefs.remove('userDisplayName');
      await prefs.remove('userPhotoURL');

      notifyListeners();
    } catch (e) {
      debugPrint('Error during sign out: $e');
    }
  }

  /// Validasi format email
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Ekstrak nama dari email (bagian sebelum @)
  String _extractNameFromEmail(String email) {
    final name = email.split('@')[0];
    // Capitalize first letter
    return name.isNotEmpty 
        ? name[0].toUpperCase() + name.substring(1)
        : 'User';
  }

  /// Generate URL avatar berdasarkan email
  String _generateAvatarUrl(String email) {
    // Menggunakan UI Avatars untuk generate avatar
    final name = _extractNameFromEmail(email);
    return 'https://ui-avatars.com/api/?name=$name&background=6366f1&color=fff&size=128';
  }
}