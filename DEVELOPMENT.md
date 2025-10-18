# 🛠️ Development Guide - BisaBasa

Panduan development untuk kontributor dan developer yang ingin mengembangkan aplikasi BisaBasa.

## 🏗️ Setup Development Environment

### 1. Prerequisites
```bash
# Pastikan Flutter terinstall
flutter --version

# Pastikan Dart terinstall
dart --version

# Install dependencies
flutter pub get
```

### 2. IDE Setup

#### VS Code (Recommended)
Install extensions:
- Flutter
- Dart
- Firebase
- GitLens

#### Android Studio
- Flutter plugin
- Dart plugin

### 3. Environment Variables

Buat file `.env` di root project (opsional):
```env
# Development settings
FLUTTER_ENV=development
ENABLE_FIREBASE=false
DEBUG_MODE=true
```

## 🔄 Development Workflow

### 1. Branch Strategy
```bash
# Main branches
main          # Production ready code
develop       # Development integration
feature/*     # New features
bugfix/*      # Bug fixes
hotfix/*      # Critical fixes
```

### 2. Commit Convention
```bash
# Format: type(scope): description
feat(auth): add Google sign-in
fix(ui): resolve navigation bug
docs(readme): update installation guide
style(format): fix code formatting
refactor(state): improve provider structure
test(unit): add authentication tests
```

### 3. Development Commands

#### Quick Start
```bash
# Development dengan hot reload
flutter run -d web --hot

# Development dengan debug info
flutter run -d web --debug --verbose
```

#### Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/auth_test.dart

# Run with coverage
flutter test --coverage
```

#### Code Quality
```bash
# Analyze code
flutter analyze

# Format code
dart format .

# Fix common issues
dart fix --apply
```

## 📁 Project Structure Deep Dive

### Core Architecture

```
lib/
├── main.dart                    # App entry point
├── firebase_options.dart        # Firebase config
│
├── data/                        # Static data & mocks
│   ├── course_data.dart         # Course definitions
│   └── mentor_data.dart         # Mentor profiles
│
├── models/                      # Data models
│   ├── course.dart              # Course model
│   ├── lesson.dart              # Lesson model
│   ├── mentor.dart              # Mentor model
│   ├── quiz_question.dart       # Quiz model
│   └── word.dart                # Word/vocabulary model
│
├── pages/                       # UI Pages
│   ├── main_navigation.dart     # Main app navigation
│   ├── auth/                    # Authentication pages
│   │   ├── login_page.dart      # Firebase login
│   │   └── mock_login_page.dart # Mock login
│   ├── learning/                # Learning modules
│   │   ├── home_page.dart
│   │   ├── courses_list_page.dart
│   │   ├── course_detail_page.dart
│   │   ├── lesson_page.dart
│   │   └── quiz_page.dart
│   ├── games/                   # Educational games
│   │   ├── games_page.dart
│   │   ├── memory_cards_page.dart
│   │   ├── word_match_page.dart
│   │   └── grammar_rush_page.dart
│   ├── mentor/                  # Mentor system
│   │   ├── mentor_page.dart
│   │   └── mentor_detail_page.dart
│   └── progress/                # Progress tracking
│       ├── progress_page.dart
│       ├── progress_overview_page.dart
│       └── leaderboard_page.dart
│
├── providers/                   # State management
│   ├── auth_provider.dart       # Firebase authentication
│   └── mock_auth_provider.dart  # Mock authentication
│
├── services/                    # Business logic
│   ├── auth_service.dart        # Auth business logic
│   └── mock_auth_service.dart   # Mock auth logic
│
└── state/                       # Global state
    └── app_state.dart           # Application state
```

## 🎨 UI/UX Guidelines

### Design System

#### Colors
```dart
// Primary colors
Color primaryColor = Color(0xFF6750A4);
Color secondaryColor = Color(0xFF625B71);
Color surfaceColor = Color(0xFFFFFBFE);
Color errorColor = Color(0xFFBA1A1A);
```

#### Typography
```dart
// Text styles
TextStyle headlineLarge = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.w400,
);
TextStyle bodyLarge = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
);
```

#### Spacing
```dart
// Standard spacing
double spacingXS = 4.0;
double spacingS = 8.0;
double spacingM = 16.0;
double spacingL = 24.0;
double spacingXL = 32.0;
```

### Component Guidelines

#### Cards
```dart
Card(
  elevation: 2,
  margin: EdgeInsets.all(spacingM),
  child: Padding(
    padding: EdgeInsets.all(spacingM),
    child: content,
  ),
)
```

#### Buttons
```dart
// Primary button
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
  ),
  onPressed: onPressed,
  child: Text('Button Text'),
)
```

## 🧪 Testing Strategy

### Unit Tests
```dart
// test/models/course_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:bisabasa/models/course.dart';

void main() {
  group('Course Model', () {
    test('should create course with valid data', () {
      final course = Course(
        id: '1',
        title: 'Basic English',
        description: 'Learn basic English',
      );
      
      expect(course.id, '1');
      expect(course.title, 'Basic English');
    });
  });
}
```

### Widget Tests
```dart
// test/widgets/course_card_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bisabasa/widgets/course_card.dart';

void main() {
  testWidgets('CourseCard displays course information', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CourseCard(course: mockCourse),
      ),
    );
    
    expect(find.text('Basic English'), findsOneWidget);
  });
}
```

### Integration Tests
```dart
// integration_test/app_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:bisabasa/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('App Integration Tests', () {
    testWidgets('complete user flow', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // Test login flow
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();
      
      // Test navigation
      await tester.tap(find.text('Courses'));
      await tester.pumpAndSettle();
    });
  });
}
```

## 🔧 Build & Deployment

### Development Build
```bash
# Web development
flutter run -d web --debug

# Android development
flutter run -d android --debug

# iOS development (macOS only)
flutter run -d ios --debug
```

### Production Build
```bash
# Web production
flutter build web --release

# Android production
flutter build apk --release
flutter build appbundle --release

# iOS production (macOS only)
flutter build ios --release
```

### Performance Optimization
```bash
# Analyze bundle size
flutter build web --analyze-size

# Profile performance
flutter run --profile -d web

# Memory profiling
flutter run --profile --trace-startup
```

## 🐛 Debugging

### Common Issues

#### Firebase Issues
```bash
# Clear Firebase cache
flutter clean
flutter pub get
```

#### Build Issues
```bash
# Clean build
flutter clean
flutter pub get
flutter pub deps

# Reset Flutter
flutter doctor
flutter upgrade
```

#### Web Issues
```bash
# Clear web cache
flutter clean
rm -rf build/web
flutter build web
```

### Debug Tools

#### Flutter Inspector
```bash
# Enable inspector
flutter run -d web --debug
# Open DevTools in browser
```

#### Performance Profiling
```bash
# CPU profiling
flutter run --profile
# Memory profiling
flutter run --profile --trace-startup
```

## 📊 Code Quality

### Linting Rules
File: `analysis_options.yaml`
```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - prefer_const_constructors
    - prefer_const_literals_to_create_immutables
    - avoid_print
    - prefer_single_quotes
```

### Code Formatting
```bash
# Format all files
dart format .

# Format specific file
dart format lib/main.dart

# Check formatting
dart format --output=none --set-exit-if-changed .
```

### Static Analysis
```bash
# Analyze code
flutter analyze

# Fix issues automatically
dart fix --apply
```

## 🤝 Contributing

### Pull Request Process

1. **Fork & Clone**
```bash
git clone https://github.com/your-username/bisabasa.git
cd bisabasa
```

2. **Create Feature Branch**
```bash
git checkout -b feature/amazing-feature
```

3. **Development**
```bash
# Make changes
# Add tests
# Update documentation
```

4. **Quality Check**
```bash
flutter analyze
flutter test
dart format .
```

5. **Commit & Push**
```bash
git add .
git commit -m "feat(feature): add amazing feature"
git push origin feature/amazing-feature
```

6. **Create Pull Request**
- Describe changes clearly
- Include screenshots for UI changes
- Reference related issues

### Code Review Checklist

- [ ] Code follows style guidelines
- [ ] Tests are included and passing
- [ ] Documentation is updated
- [ ] No breaking changes (or properly documented)
- [ ] Performance impact considered
- [ ] Accessibility guidelines followed

---

**Happy Development! 🚀**