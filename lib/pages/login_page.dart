import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bisabasa/widgets/app_brand_icon.dart';

/// Halaman Login/Register dengan foto background yang jelas
/// Form login berada di bagian bawah untuk memaksimalkan visibilitas foto
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with TickerProviderStateMixin {
  // Controllers untuk input field
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // State variables
  bool _isPasswordVisible = false;
  bool _isRegisterMode = false;
  String _errorMessage = '';

  // Animation controllers untuk efek visual
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Inisialisasi animasi
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));

    // Mulai animasi
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  /// Fungsi untuk menangani proses login
  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _errorMessage = '';
      });

      try {
        // Simulasi proses login/register
        await Future.delayed(const Duration(seconds: 1));
        
        if (mounted) {
          // Navigasi ke halaman utama setelah berhasil login
          context.go('/');
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Login gagal. Silakan coba lagi.';
        });
      }
    }
  }

  /// Fungsi untuk toggle antara mode login dan register
  void _toggleMode() {
    setState(() {
      _isRegisterMode = !_isRegisterMode;
      _errorMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    // Tambahkan ukuran layar untuk menentukan flex dinamis
    final size = MediaQuery.of(context).size;
    final isSmallHeight = size.height < 700;
    final isTinyHeight = size.height < 580;
    final topFlex = isTinyHeight ? 3 : (isSmallHeight ? 4 : 5);
    final bottomFlex = isTinyHeight ? 7 : (isSmallHeight ? 6 : 5);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Background image dengan opacity yang lebih tinggi
            Positioned.fill(
              child: Image.asset(
                'assets/images/poster.jpg',
                fit: BoxFit.cover,
                opacity: const AlwaysStoppedAnimation(0.4), // Opacity ditingkatkan untuk visibility
              ),
            ),
            
            // Gradient overlay minimal untuk readability (diabaikan gesture)
            Positioned.fill(
              child: IgnorePointer(
                ignoring: true,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent, // Bagian atas transparan total
                        Colors.transparent, // Bagian tengah transparan
                        Colors.black.withOpacity(0.3), // Sedikit gelap di bawah untuk readability
                      ],
                      stops: const [0.0, 0.6, 1.0], // Gradient hanya di 40% bawah
                    ),
                  ),
                ),
              ),
            ),
            
            // Logo di pojok kiri atas
            Positioned(
              top: 50,
              left: 20,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade400, Colors.deepOrange.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const AppBrandIcon(
                  size: 30,
                ),
              ),
            ),
            
            // Main content dengan form di posisi yang lebih seimbang
            SafeArea(
              child: Column(
                children: [
                  // Spacer untuk memberikan ruang untuk foto tapi tidak terlalu besar
                  Expanded(
                    flex: topFlex, // 5/10 dari layar untuk menampilkan foto (dikurangi dari 7)
                    child: const SizedBox(),
                  ),
                  
                  // Form login di bagian tengah-bawah
                  Expanded(
                    flex: bottomFlex, // 5/10 dari layar untuk form (ditingkatkan dari 3)
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                        bottom: 30.0 + bottomInset, // Tambah padding sesuai tinggi keyboard/viewport
                        top: 10.0,
                      ),
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 400),
                            child: Card(
                              elevation: 25,
                              shadowColor: Colors.black.withOpacity(0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(28.0), // Padding ditingkatkan sedikit
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white.withOpacity(0.50), // Background putih semi-transparan
                                ),
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _buildHeader(),
                                      const SizedBox(height: 20), // Spacing ditingkatkan
                                      _buildForm(),
                                      const SizedBox(height: 12),
                                      _buildErrorMessage(),
                                      const SizedBox(height: 20),
                                      _buildSubmitButton(),
                                      const SizedBox(height: 12),
                                      _buildToggleModeButton(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget untuk header (hanya judul tanpa logo)
  Widget _buildHeader() {
    return Column(
      children: [
        // Judul aplikasi
        Text(
          'BisaBasa',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.orange.shade700,
          ),
        ),
        const SizedBox(height: 8),
        // Subtitle
        Text(
          _isRegisterMode ? 'Daftar Akun Baru' : 'Masuk ke Akun Anda',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Widget untuk form input - dibuat lebih kompak
  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Input nama (hanya untuk register)
          if (_isRegisterMode) ...[
            TextFormField(
              controller: _nameController,
              style: const TextStyle(fontSize: 14), // Font lebih kecil
              decoration: InputDecoration(
                labelText: 'Nama Lengkap',
                labelStyle: const TextStyle(fontSize: 14),
                prefixIcon: Icon(Icons.person_outline, color: Colors.orange.shade600, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.orange.shade600, width: 2),
                ),
                filled: true,
                fillColor: Colors.orange.shade50,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), // Padding dikurangi
              ),
              validator: (value) {
                if (_isRegisterMode && (value == null || value.isEmpty)) {
                  return 'Nama tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 12), // Dikurangi
          ],
          
          // Input email
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
            style: const TextStyle(fontSize: 14), // Font lebih kecil
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: const TextStyle(fontSize: 14),
              prefixIcon: Icon(Icons.email_outlined, color: Colors.orange.shade600, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.orange.shade600, width: 2),
              ),
              filled: true,
              fillColor: Colors.orange.shade50,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), // Padding dikurangi
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email tidak boleh kosong';
              }
              if (!value.contains('@')) {
                return 'Format email tidak valid';
              }
              return null;
            },
          ),
          const SizedBox(height: 12), // Dikurangi
          
          // Input password
          TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleLogin(),
            style: const TextStyle(fontSize: 14), // Font lebih kecil
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: const TextStyle(fontSize: 14),
              prefixIcon: Icon(Icons.lock_outline, color: Colors.orange.shade600, size: 20),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: Colors.orange.shade600,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.orange.shade600, width: 2),
              ),
              filled: true,
              fillColor: Colors.orange.shade50,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), // Padding dikurangi
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password tidak boleh kosong';
              }
              if (value.length < 6) {
                return 'Password minimal 6 karakter';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  /// Widget untuk menampilkan pesan error
  Widget _buildErrorMessage() {
    if (_errorMessage.isEmpty) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.all(10), // Dikurangi
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade600, size: 18), // Dikurangi
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              _errorMessage,
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 12, // Dikurangi
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Widget untuk tombol submit (login/register)
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 44, // Dikurangi lagi
      child: ElevatedButton(
        onPressed: _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange.shade600,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: Colors.orange.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          _isRegisterMode ? 'Daftar' : 'Masuk',
          style: const TextStyle(
            fontSize: 14, // Dikurangi
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  /// Widget untuk tombol toggle mode (login/register)
  Widget _buildToggleModeButton() {
    return TextButton(
      onPressed: _toggleMode,
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12), // Dikurangi
          children: [
            TextSpan(
              text: _isRegisterMode 
                  ? 'Sudah punya akun? ' 
                  : 'Belum punya akun? ',
            ),
            TextSpan(
              text: _isRegisterMode ? 'Masuk' : 'Daftar',
              style: TextStyle(
                color: Colors.orange.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}