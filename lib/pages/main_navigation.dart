import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

/// Widget navigasi utama aplikasi
/// Menggunakan BottomNavigationBar untuk navigasi antar halaman
class MainNavigation extends StatefulWidget {
  final Widget child;

  const MainNavigation({
    super.key,
    required this.child,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  /// Daftar route untuk navigasi
  final List<String> _routes = [
    '/dashboard',
    '/courses',
    '/vocabulary',
    '/games',
    '/mentor',
    '/leaderboard',
  ];

  /// Daftar label untuk bottom navigation
  final List<String> _labels = [
    'Beranda',
    'Kursus',
    'Kosakata',
    'Games',
    'Mentor',
    'Ranking',
  ];

  /// Daftar icon untuk bottom navigation (dengan icon yang lebih jelas)
  final List<IconData> _icons = [
    Icons.home_outlined,
    Icons.school_outlined,
    Icons.book_outlined,
    Icons.games_outlined,
    Icons.person_outlined,
    Icons.leaderboard_outlined,
  ];

  /// Daftar selected icon untuk bottom navigation (dengan style filled)
  final List<IconData> _selectedIcons = [
    Icons.home,
    Icons.school,
    Icons.book,
    Icons.games,
    Icons.person,
    Icons.leaderboard,
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateCurrentIndex();
  }

  /// Update current index berdasarkan route saat ini
  void _updateCurrentIndex() {
    final currentLocation = GoRouterState.of(context).uri.path;
    
    // Cari index berdasarkan route yang cocok
    for (int i = 0; i < _routes.length; i++) {
      if (currentLocation.startsWith(_routes[i])) {
        if (_currentIndex != i) {
          setState(() {
            _currentIndex = i;
          });
        }
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer<AuthProvider>(
       builder: (context, authProvider, child) {
         return Scaffold(
           // App Bar
           appBar: null,
           
           // Drawer (hanya tampil jika user login)
           drawer: null,
           
           // Body content
           body: widget.child,
           
           // Bottom Navigation Bar (hanya tampil jika user login)
           bottomNavigationBar: authProvider.isLoggedIn 
               ? _buildBottomNavigationBar(colorScheme)
               : null,
         );
       },
     );
  }

  /// Build App Bar
  PreferredSizeWidget _buildAppBar(
    BuildContext context, 
    AuthProvider authProvider, 
    ColorScheme colorScheme,
  ) {
    // AppBar di-nonaktifkan: kembalikan ukuran 0 agar tidak terlihat
    return const PreferredSize(
      preferredSize: Size.fromHeight(0),
      child: SizedBox.shrink(),
    );
  }

  /// Build Navigation Drawer
  Widget _buildDrawer(BuildContext context, AuthProvider authProvider, ColorScheme colorScheme) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.primary,
                  colorScheme.primaryContainer,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: authProvider.userPhotoURL != null
                      ? NetworkImage(authProvider.userPhotoURL!)
                      : null,
                  backgroundColor: colorScheme.surface,
                  child: authProvider.userPhotoURL == null
                      ? Icon(
                          Icons.person,
                          size: 30,
                          color: colorScheme.primary,
                        )
                      : null,
                ),
                const SizedBox(height: 12),
                Text(
                  authProvider.userDisplayName ?? 'User',
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (authProvider.userEmail != null)
                  Text(
                    authProvider.userEmail!,
                    style: TextStyle(
                      color: colorScheme.onPrimary.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
          
          // Menu Items
          _buildDrawerItem(
            context,
            icon: Icons.quiz_outlined,
            title: 'Quiz',
            route: '/quiz',
            colorScheme: colorScheme,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.person_outline,
            title: 'Mentor',
            route: '/mentor',
            colorScheme: colorScheme,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.analytics_outlined,
            title: 'Progress',
            route: '/progress',
            colorScheme: colorScheme,
          ),
          
          const Divider(),
          
          // Settings and Logout
          _buildDrawerItem(
            context,
            icon: Icons.settings_outlined,
            title: 'Pengaturan',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Halaman pengaturan akan segera hadir!'),
                ),
              );
            },
            colorScheme: colorScheme,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.help_outline,
            title: 'Bantuan',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Halaman bantuan akan segera hadir!'),
                ),
              );
            },
            colorScheme: colorScheme,
          ),
          
          const Divider(),
          
          _buildDrawerItem(
            context,
            icon: Icons.logout_outlined,
            title: 'Keluar',
            onTap: () async {
              Navigator.pop(context);
              await _handleLogout(context, authProvider);
            },
            colorScheme: colorScheme,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  /// Build Drawer Item
  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? route,
    VoidCallback? onTap,
    required ColorScheme colorScheme,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? colorScheme.error : colorScheme.onSurface,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? colorScheme.error : colorScheme.onSurface,
        ),
      ),
      onTap: onTap ?? () {
        Navigator.pop(context);
        if (route != null) {
          context.go(route);
        }
      },
    );
  }

  /// Build Bottom Navigation Bar
  Widget _buildBottomNavigationBar(ColorScheme colorScheme) {
    return NavigationBar(
      selectedIndex: _currentIndex,
      onDestinationSelected: (index) {
        setState(() {
          _currentIndex = index;
        });
        context.go(_routes[index]);
      },
      elevation: 8,
      backgroundColor: colorScheme.surface,
      indicatorColor: colorScheme.primaryContainer,
      destinations: List.generate(_routes.length, (index) {
        return NavigationDestination(
          icon: Icon(
            _icons[index],
            color: colorScheme.onSurfaceVariant,
          ),
          selectedIcon: Icon(
            _selectedIcons[index],
            color: colorScheme.onPrimaryContainer,
          ),
          label: _labels[index],
        );
      }),
    );
  }

  /// Build Floating Action Button


  /// Handle logout
  Future<void> _handleLogout(BuildContext context, AuthProvider authProvider) async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await authProvider.signOut();
      if (context.mounted) {
        context.go('/login');
      }
    }
  }
}