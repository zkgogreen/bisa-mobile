import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:go_router/go_router.dart';

/// Halaman Login dengan Google Sign-In
/// Menggunakan background poster yang indah dan UI modern
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> 
    with SingleTickerProviderStateMixin {
  
  // Controller untuk animasi
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  // Loading state untuk button
  bool _isLoading = false;
  
  // Firebase Auth dan Google Sign-In instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
    
    // Setup animasi untuk entrance effect
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    ));
    
    // Mulai animasi
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Fungsi untuk login dengan Google
  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // User canceled the sign-in
        setState(() {
          _isLoading = false;
        });
        return;
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
      
      if (userCredential.user != null) {
        // Login berhasil, navigasi ke dashboard
        if (mounted) {
          context.go('/dashboard');
        }
      }
    } catch (e) {
      // Handle error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login gagal: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // Background menggunakan poster image
          image: DecorationImage(
            image: AssetImage('assets/images/poster.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          // Overlay gradient untuk readability
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
          child: SafeArea(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Spacer untuk push content ke tengah
                          const Spacer(),
                          
                          // Logo dan Welcome Text
                          _buildWelcomeSection(),
                          
                          const SizedBox(height: 60),
                          
                          // Google Sign-In Button
                          _buildGoogleSignInButton(),
                          
                          const SizedBox(height: 24),
                          
                          // Terms and Privacy
                          _buildTermsText(),
                          
                          const Spacer(),
                          
                          // Skip untuk guest mode (opsional)
                          _buildSkipButton(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Widget untuk section welcome
  Widget _buildWelcomeSection() {
    return Column(
      children: [
        // App Logo/Icon
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.school,
            size: 50,
            color: Color(0xFF2196F3),
          ),
        ),
        
        const SizedBox(height: 32),
        
        // Welcome Text
        const Text(
          'Selamat Datang di',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white70,
            fontWeight: FontWeight.w300,
          ),
        ),
        
        const SizedBox(height: 8),
        
        // App Name
        const Text(
          'BisaBasa',
          style: TextStyle(
            fontSize: 42,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Subtitle
        const Text(
          'Belajar bahasa Inggris dengan mudah\ndan menyenangkan',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white70,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  /// Widget untuk Google Sign-In Button
  Widget _buildGoogleSignInButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _signInWithGoogle,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Google Icon
                  Image.asset(
                    'assets/icons/google_icon.png',
                    width: 24,
                    height: 24,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback jika icon tidak ada
                      return const Icon(
                        Icons.login,
                        size: 24,
                        color: Colors.blue,
                      );
                    },
                  ),
                  
                  const SizedBox(width: 16),
                  
                  const Text(
                    'Masuk dengan Google',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  /// Widget untuk Terms and Privacy text
  Widget _buildTermsText() {
    return Text(
      'Dengan masuk, Anda menyetujui Syarat & Ketentuan\ndan Kebijakan Privasi kami',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 12,
        color: Colors.white.withOpacity(0.7),
        height: 1.4,
      ),
    );
  }

  /// Widget untuk Skip button (guest mode)
  Widget _buildSkipButton() {
    return TextButton(
      onPressed: () {
        // Navigasi ke dashboard tanpa login (guest mode)
        context.go('/dashboard');
      },
      child: Text(
        'Lewati untuk sekarang',
        style: TextStyle(
          fontSize: 14,
          color: Colors.white.withOpacity(0.8),
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}