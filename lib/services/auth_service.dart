import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service untuk mengelola authentication
/// Menyediakan fungsi login, logout, dan status authentication
class AuthService {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Firebase Auth dan Google Sign-In instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Stream untuk mendengarkan perubahan status authentication
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Mendapatkan user yang sedang login
  User? get currentUser => _auth.currentUser;

  /// Cek apakah user sudah login
  bool get isLoggedIn => _auth.currentUser != null;

  /// Login dengan Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = 
          await _auth.signInWithCredential(credential);
      
      // Simpan status login
      await _saveLoginStatus(true);
      
      return userCredential;
    } catch (e) {
      print('Error signing in with Google: $e');
      rethrow;
    }
  }

  /// Logout
  Future<void> signOut() async {
    try {
      // Sign out dari Google
      await _googleSignIn.signOut();
      
      // Sign out dari Firebase
      await _auth.signOut();
      
      // Hapus status login
      await _saveLoginStatus(false);
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }

  /// Simpan status login ke SharedPreferences
  Future<void> _saveLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', isLoggedIn);
  }

  /// Cek status login dari SharedPreferences
  Future<bool> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  /// Mendapatkan informasi user
  Map<String, dynamic>? getUserInfo() {
    final user = _auth.currentUser;
    if (user == null) return null;

    return {
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoURL': user.photoURL,
      'emailVerified': user.emailVerified,
    };
  }

  /// Update profile user
  Future<void> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await user.updateDisplayName(displayName);
      await user.updatePhotoURL(photoURL);
      await user.reload();
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }

  /// Delete account
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await user.delete();
      await _saveLoginStatus(false);
    } catch (e) {
      print('Error deleting account: $e');
      rethrow;
    }
  }
}