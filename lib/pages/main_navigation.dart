import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/mock_auth_provider.dart';
import '../providers/auth_provider.dart';
import 'home_page.dart';
import 'progress_overview_page.dart';
import 'leaderboard_page.dart';
import 'courses_list_page.dart';
import 'games_page.dart';
import 'mentor_page.dart';

/// MainNavigation adalah wrapper utama yang mengelola navigasi dengan bottom navigation bar
/// Halaman ini menampung semua tab utama aplikasi dan mengelola perpindahan antar tab
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  // Index tab yang sedang aktif
  int _currentIndex = 0;

  // Daftar halaman yang akan ditampilkan di setiap tab
  final List<Widget> _pages = [
    const HomePage(),           // Tab 1: Home
    const CoursesListPage(),    // Tab 2: Courses
    const GamesPage(),          // Tab 3: Games
    const MentorPage(),         // Tab 4: Mentor
    const ProgressOverviewPage(), // Tab 5: Progress
    const LeaderboardPage(),    // Tab 6: Leaderboard
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<MockAuthProvider>(
        builder: (context, mockAuthProvider, child) {
          // Coba deteksi apakah AuthProvider tersedia
          AuthProvider? authProvider;
          bool isUsingFirebase = false;
          bool isLoggedIn = false;
          String? userPhotoURL;
          String userDisplayName = '';
          
          try {
            authProvider = Provider.of<AuthProvider>(context, listen: false);
            isUsingFirebase = true;
            isLoggedIn = authProvider.isLoggedIn;
            userPhotoURL = authProvider.userPhotoURL;
            userDisplayName = authProvider.userDisplayName;
          } catch (e) {
            // AuthProvider tidak tersedia, gunakan MockAuthProvider
            isUsingFirebase = false;
            isLoggedIn = mockAuthProvider.isLoggedIn;
            userPhotoURL = mockAuthProvider.userPhotoURL;
            userDisplayName = mockAuthProvider.userDisplayName;
          }
        return Scaffold(
          // AppBar dengan tombol login/logout
          appBar: AppBar(
            title: const Text(
              'BisaBasa',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF6750A4),
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            actions: [
              if (isLoggedIn) ...[
                // User sudah login - tampilkan avatar dan logout
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: userPhotoURL != null
                            ? NetworkImage(userPhotoURL!)
                            : null,
                        child: userPhotoURL == null
                            ? Text(
                                userDisplayName[0].toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        userDisplayName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          if (isUsingFirebase) {
                            await authProvider!.signOut();
                          } else {
                            await mockAuthProvider.signOut();
                          }
                        },
                        icon: const Icon(Icons.logout),
                        tooltip: 'Logout',
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // User belum login - tampilkan tombol login
                TextButton.icon(
                  onPressed: () {
                    // Pilih route berdasarkan provider yang aktif
                    final loginRoute = isUsingFirebase ? '/login' : '/mock-login';
                    context.push(loginRoute);
                  },
                  icon: const Icon(Icons.login),
                  label: const Text('Login'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF6750A4),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
          
          // Body menampilkan halaman sesuai tab yang dipilih
          body: IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),
      
      // Bottom Navigation Bar dengan 4 tab utama
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          // Shadow di atas bottom navigation
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF6750A4),
            unselectedItemColor: Colors.grey[600],
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 11,
            ),
            elevation: 0,
            items: [
              // Tab 1: Home
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _currentIndex == 0 
                        ? const Color(0xFF6750A4).withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _currentIndex == 0 ? Icons.home : Icons.home_outlined,
                    size: 24,
                  ),
                ),
                label: 'Home',
              ),
              
              // Tab 2: Courses
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _currentIndex == 1 
                        ? const Color(0xFF6750A4).withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _currentIndex == 1 ? Icons.book : Icons.book_outlined,
                    size: 24,
                  ),
                ),
                label: 'Courses',
              ),
              
              // Tab 3: Games
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _currentIndex == 2 
                        ? const Color(0xFF6750A4).withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _currentIndex == 2 ? Icons.games : Icons.games_outlined,
                    size: 24,
                  ),
                ),
                label: 'Games',
              ),
              
              // Tab 4: Mentor
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _currentIndex == 3 
                        ? const Color(0xFF6750A4).withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _currentIndex == 3 ? Icons.person : Icons.person_outlined,
                    size: 24,
                  ),
                ),
                label: 'Mentor',
              ),
              
              // Tab 5: Progress
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _currentIndex == 4 
                        ? const Color(0xFF6750A4).withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _currentIndex == 4 ? Icons.analytics : Icons.analytics_outlined,
                    size: 24,
                  ),
                ),
                label: 'Progress',
              ),
              
              // Tab 6: Leaderboard
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _currentIndex == 5 
                        ? const Color(0xFF6750A4).withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _currentIndex == 5 ? Icons.emoji_events : Icons.emoji_events_outlined,
                    size: 24,
                  ),
                ),
                label: 'Leaderboard',
              ),
            ],
          ),
        ),
      ),
        );
      },
    );
  }

  /// Fungsi yang dipanggil ketika user menekan tab di bottom navigation
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    
    // Haptic feedback untuk memberikan respons sentuhan
    _provideFeedback();
  }

  /// Memberikan haptic feedback ketika tab ditekan
  void _provideFeedback() {
    // Vibration ringan untuk memberikan feedback
    // HapticFeedback.lightImpact(); // Uncomment jika ingin haptic feedback
  }
}

/// Widget custom untuk tab yang lebih advanced (opsional untuk pengembangan future)
class CustomBottomNavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const CustomBottomNavItem({
    super.key,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isActive 
              ? const Color(0xFF6750A4).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? activeIcon : icon,
                key: ValueKey(isActive),
                color: isActive 
                    ? const Color(0xFF6750A4)
                    : Colors.grey[600],
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive 
                    ? const Color(0xFF6750A4)
                    : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}