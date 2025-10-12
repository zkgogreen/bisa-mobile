import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'state/app_state.dart';
import 'pages/dashboard_page.dart';
import 'pages/lessons_page.dart';
import 'pages/vocabulary_page.dart';
import 'pages/quiz_page.dart';
import 'pages/progress_page.dart';
import 'pages/class_detail_page.dart';
import 'pages/onboarding_page.dart';
import 'pages/word_match_page.dart';
import 'pages/grammar_rush_page.dart';
import 'pages/memory_cards_page.dart';
import 'pages/courses_list_page.dart';
import 'pages/course_detail_page.dart';
import 'pages/lesson_page.dart';
import 'pages/course_quiz_page.dart';
import 'pages/module_summary_page.dart';

void main() {
  runApp(const BisaBasaApp());
}

class BisaBasaApp extends StatelessWidget {
  const BisaBasaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp.router(
        title: 'BisaBasa - English Learning',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6750A4),
            brightness: Brightness.light,
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
          ),
          // Add page transition animations
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
        routerConfig: _router,
      ),
    );
  }
}

// Router configuration with smooth transitions
final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: '/onboarding',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const OnboardingPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/dashboard',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const DashboardPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            )),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/class-detail',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const ClassDetailPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            )),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/lessons',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const LessonsPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            )),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/vocabulary',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const VocabularyPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            SlideTransition(
          position: animation.drive(
            Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(
              CurveTween(curve: Curves.easeInOut),
            ),
          ),
          child: child,
        ),
      ),
    ),
    GoRoute(
      path: '/quiz',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const QuizPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            ScaleTransition(
          scale: animation.drive(
            Tween(begin: 0.8, end: 1.0).chain(
              CurveTween(curve: Curves.easeInOut),
            ),
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        ),
      ),
    ),
    GoRoute(
      path: '/progress',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const ProgressPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            SlideTransition(
          position: animation.drive(
            Tween(begin: const Offset(0.0, 1.0), end: Offset.zero).chain(
              CurveTween(curve: Curves.easeInOut),
            ),
          ),
          child: child,
        ),
      ),
    ),
    GoRoute(
      path: '/word-match',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const WordMatchPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            ScaleTransition(
          scale: animation.drive(
            Tween(begin: 0.8, end: 1.0).chain(
              CurveTween(curve: Curves.elasticOut),
            ),
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        ),
      ),
    ),
    GoRoute(
      path: '/grammar-rush',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const GrammarRushPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            SlideTransition(
          position: animation.drive(
            Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(
              CurveTween(curve: Curves.easeInOut),
            ),
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        ),
      ),
    ),
    GoRoute(
      path: '/memory-cards',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const MemoryCardsPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            RotationTransition(
          turns: animation.drive(
            Tween(begin: 0.1, end: 0.0).chain(
              CurveTween(curve: Curves.easeInOut),
            ),
          ),
          child: ScaleTransition(
            scale: animation.drive(
              Tween(begin: 0.8, end: 1.0).chain(
                CurveTween(curve: Curves.elasticOut),
              ),
            ),
            child: child,
          ),
        ),
      ),
    ),
    // Course routes
    GoRoute(
      path: '/courses',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const CoursesListPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            SlideTransition(
          position: animation.drive(
            Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(
              CurveTween(curve: Curves.easeInOut),
            ),
          ),
          child: child,
        ),
      ),
    ),
    GoRoute(
      path: '/courses/:courseId',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: CourseDetailPage(courseId: state.pathParameters['courseId']!),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            SlideTransition(
          position: animation.drive(
            Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(
              CurveTween(curve: Curves.easeInOut),
            ),
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        ),
      ),
    ),
    GoRoute(
      path: '/courses/:courseId/modules/:moduleId',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: LessonPage(
          courseId: state.pathParameters['courseId']!,
          moduleId: state.pathParameters['moduleId']!,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            SlideTransition(
          position: animation.drive(
            Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(
              CurveTween(curve: Curves.easeInOut),
            ),
          ),
          child: child,
        ),
      ),
    ),
    GoRoute(
      path: '/courses/:courseId/modules/:moduleId/lessons/:lessonId',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: LessonPage(
          courseId: state.pathParameters['courseId']!,
          moduleId: state.pathParameters['moduleId']!,
          lessonId: state.pathParameters['lessonId'],
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            SlideTransition(
          position: animation.drive(
            Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(
              CurveTween(curve: Curves.easeInOut),
            ),
          ),
          child: child,
        ),
      ),
    ),
    GoRoute(
      path: '/courses/:courseId/modules/:moduleId/summary',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: ModuleSummaryPage(
          courseId: state.pathParameters['courseId']!,
          moduleId: state.pathParameters['moduleId']!,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(0.0, 0.3), end: Offset.zero).chain(
                CurveTween(curve: Curves.easeOutCubic),
              ),
            ),
            child: child,
          ),
        ),
      ),
    ),
    GoRoute(
      path: '/courses/:courseId/modules/:moduleId/quiz',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: CourseQuizPage(
          courseId: state.pathParameters['courseId']!,
          moduleId: state.pathParameters['moduleId']!,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            ScaleTransition(
          scale: animation.drive(
            Tween(begin: 0.8, end: 1.0).chain(
              CurveTween(curve: Curves.elasticOut),
            ),
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        ),
      ),
    ),
  ],
);