import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'state/app_state.dart';
import 'pages/home_page.dart';
import 'pages/progress_overview_page.dart';
import 'pages/leaderboard_page.dart';
import 'pages/main_navigation.dart';

import 'pages/vocabulary_page.dart';
import 'pages/quiz_page.dart';
import 'pages/onboarding_page.dart';
import 'pages/word_match_page.dart';
import 'pages/grammar_rush_page.dart';
import 'pages/memory_cards_page.dart';
import 'pages/spelling_bee_page.dart';
import 'pages/games_page.dart';
import 'pages/courses_list_page.dart';
import 'pages/course_detail_page.dart';
import 'pages/lesson_page.dart';
import 'pages/course_quiz_page.dart';
import 'pages/module_summary_page.dart';
import 'pages/mentor_page.dart';
import 'pages/mentor_detail_page.dart';
import 'pages/login_page.dart';
import 'providers/auth_provider.dart';

/// Entry point aplikasi BisaBasa
/// Aplikasi pembelajaran bahasa Inggris dengan sistem autentikasi sederhana
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('🚀 Memulai aplikasi BisaBasa...');
  
  runApp(const BisaBasaApp());
}

/// Widget utama aplikasi BisaBasa
/// Menggunakan Material 3 design dengan tema modern
class BisaBasaApp extends StatelessWidget {
  const BisaBasaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // State management untuk aplikasi
        ChangeNotifierProvider(create: (context) => AppState()),
        
        // Authentication provider untuk login/logout
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: MaterialApp.router(
        title: 'BisaBasa - English Learning',
        debugShowCheckedModeBanner: false,
        
        // Tema aplikasi dengan Material 3
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6750A4),
            brightness: Brightness.light,
          ),
          
          // Konfigurasi AppBar
          appBarTheme: const AppBarTheme(
            centerTitle: false,
            elevation: 0,
            scrolledUnderElevation: 1,
          ),
          
          // Konfigurasi Card
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          
          // Konfigurasi Button
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          
          // Konfigurasi Input Field
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
          ),
          
          // Animasi transisi halaman
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
              TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
              TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
            },
          ),
        ),
        
        // Konfigurasi routing
        routerConfig: _router,
      ),
    );
  }
}

/// Konfigurasi router untuk navigasi aplikasi
/// Menggunakan GoRouter untuk navigasi yang smooth dan modern
final GoRouter _router = GoRouter(
  // Route awal aplikasi
  initialLocation: '/',
  
  routes: [
    // Root route - redirect ke dashboard atau login
    GoRoute(
      path: '/',
      redirect: (context, state) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        return authProvider.isLoggedIn ? '/dashboard' : '/login';
      },
    ),
    
    // Shell route untuk main navigation (hanya untuk user yang sudah login)
    ShellRoute(
      builder: (context, state, child) {
        return MainNavigation(child: child);
      },
      routes: [
        // Dashboard - halaman utama
        GoRoute(
          path: '/dashboard',
          pageBuilder: (context, state) => _buildPage(
            state: state,
            child: const HomePage(),
          ),
        ),
        
        // Courses - daftar kursus
        GoRoute(
          path: '/courses',
          pageBuilder: (context, state) => _buildPage(
            state: state,
            child: const CoursesListPage(),
          ),
          routes: [
            // Detail kursus
            GoRoute(
              path: '/:courseId',
              pageBuilder: (context, state) => _buildPage(
                state: state,
                child: CourseDetailPage(
                  courseId: state.pathParameters['courseId']!,
                ),
              ),
              routes: [
                // Module routes
                GoRoute(
                  path: '/modules/:moduleId',
                  pageBuilder: (context, state) => _buildPage(
                    state: state,
                    child: LessonPage(
                      courseId: state.pathParameters['courseId']!,
                      moduleId: state.pathParameters['moduleId']!,
                      // lessonId is null for module overview
                    ),
                  ),
                  routes: [
                    // Lesson detail
                    GoRoute(
                      path: '/lessons/:lessonId',
                      pageBuilder: (context, state) => _buildPage(
                        state: state,
                        child: LessonPage(
                          courseId: state.pathParameters['courseId']!,
                          moduleId: state.pathParameters['moduleId']!,
                          lessonId: state.pathParameters['lessonId']!,
                        ),
                      ),
                    ),
                    // Module quiz
                    GoRoute(
                      path: '/quiz',
                      pageBuilder: (context, state) => _buildPage(
                        state: state,
                        child: CourseQuizPage(
                          courseId: state.pathParameters['courseId']!,
                          moduleId: state.pathParameters['moduleId']!,
                        ),
                      ),
                    ),
                    // Module summary
                    GoRoute(
                      path: '/summary',
                      pageBuilder: (context, state) => _buildPage(
                        state: state,
                        child: ModuleSummaryPage(
                          courseId: state.pathParameters['courseId']!,
                          moduleId: state.pathParameters['moduleId']!,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        
        // Games - halaman permainan
        GoRoute(
          path: '/games',
          pageBuilder: (context, state) => _buildPage(
            state: state,
            child: const GamesPage(),
          ),
          routes: [
            // Word Match Game
            GoRoute(
              path: '/word-match',
              pageBuilder: (context, state) => _buildPage(
                state: state,
                child: const WordMatchPage(),
              ),
            ),
            // Grammar Rush Game
            GoRoute(
              path: '/grammar-rush',
              pageBuilder: (context, state) => _buildPage(
                state: state,
                child: const GrammarRushPage(),
              ),
            ),
            // Memory Cards Game
            GoRoute(
              path: '/memory-cards',
              pageBuilder: (context, state) => _buildPage(
                state: state,
                child: const MemoryCardsPage(),
              ),
            ),
            // Spelling Bee Game
            GoRoute(
              path: '/spelling-bee',
              pageBuilder: (context, state) => _buildPage(
                state: state,
                child: const SpellingBeePage(),
              ),
            ),
          ],
        ),
        
        // Progress - halaman progress
        GoRoute(
          path: '/progress',
          pageBuilder: (context, state) => _buildPage(
            state: state,
            child: const ProgressOverviewPage(),
          ),
        ),

        
        // Vocabulary - halaman kosakata
        GoRoute(
          path: '/vocabulary',
          pageBuilder: (context, state) => _buildPage(
            state: state,
            child: const VocabularyPage(),
          ),
        ),
        
        // Quiz - halaman kuis
        GoRoute(
          path: '/quiz',
          pageBuilder: (context, state) => _buildPage(
            state: state,
            child: const QuizPage(),
          ),
        ),
        
        // Mentor - halaman mentor
        GoRoute(
          path: '/mentor',
          pageBuilder: (context, state) => _buildPage(
            state: state,
            child: const MentorPage(),
          ),
          routes: [
            // Detail mentor
            GoRoute(
              path: '/:mentorId',
              pageBuilder: (context, state) => _buildPage(
                state: state,
                child: MentorDetailPage(
                  mentorId: state.pathParameters['mentorId']!,
                ),
              ),
            ),
          ],
        ),
        
        // Leaderboard - papan peringkat
        GoRoute(
          path: '/leaderboard',
          pageBuilder: (context, state) => _buildPage(
            state: state,
            child: const LeaderboardPage(),
          ),
        ),
      ],
    ),
    
    // Login page - di luar shell route
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => _buildPage(
        state: state,
        child: const LoginPage(),
        transition: _slideUpTransition,
      ),
    ),
    
    // Onboarding page
    GoRoute(
      path: '/onboarding',
      pageBuilder: (context, state) => _buildPage(
        state: state,
        child: const OnboardingPage(),
        transition: _fadeTransition,
      ),
    ),
  ],
  
  // Redirect logic untuk authentication
  redirect: (context, state) {
    final currentLocation = state.matchedLocation;
    
    print('🔄 Redirect check: location=$currentLocation (LOGIN BYPASS MODE)');
    
    // BYPASS LOGIN: Langsung redirect ke dashboard jika di root atau login
    if (currentLocation == '/' || currentLocation == '/login') {
      print('🚀 Bypass login, redirect ke /dashboard');
      return '/dashboard';
    }
    
    print('✅ No redirect needed');
    return null; // Tidak ada redirect
  },
);

/// Helper function untuk membuat page dengan transisi
CustomTransitionPage _buildPage({
  required GoRouterState state,
  required Widget child,
  Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)? transition,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: transition ?? _fadeTransition,
  );
}

/// Transisi fade untuk halaman
Widget _fadeTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return FadeTransition(
    opacity: animation,
    child: child,
  );
}

/// Transisi slide up untuk halaman login
Widget _slideUpTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOut,
    )),
    child: child,
  );
}