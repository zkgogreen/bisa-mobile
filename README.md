# 🌟 BisaBasa - Aplikasi Pembelajaran Bahasa

Aplikasi pembelajaran bahasa modern yang dibangun dengan Flutter, menampilkan UI yang responsif dan pengalaman pengguna yang menarik.

## ✨ Fitur Utama

### 🎯 Pembelajaran Interaktif
- **Courses**: Kursus bahasa terstruktur dengan berbagai level
- **Games**: Permainan edukatif (Memory Cards, Word Match, Grammar Rush)
- **Quizzes**: Kuis interaktif untuk menguji pemahaman
- **Progress Tracking**: Pelacakan kemajuan belajar real-time

### 👨‍🏫 Sistem Mentor
- **Mentor Personal**: Bimbingan dari mentor berpengalaman
- **Live Sessions**: Sesi pembelajaran langsung
- **Chat Support**: Komunikasi dengan mentor

### 🏆 Gamifikasi
- **Leaderboard**: Kompetisi dengan pengguna lain
- **Achievement System**: Sistem pencapaian dan badge
- **Progress Visualization**: Visualisasi kemajuan yang menarik

### 🔐 Authentication System
- **Firebase Auth**: Login dengan Google (Production)
- **Mock Auth**: Sistem authentication dummy (Development)
- **Auto Fallback**: Otomatis beralih jika Firebase bermasalah

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.0+
- Dart 3.0+
- Web browser (untuk web development)

### Installation

1. **Clone repository**
```bash
git clone <repository-url>
cd bisabasa
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run aplikasi**
```bash
# Development mode (Mock Authentication)
flutter run -d web

# Atau untuk platform lain
flutter run -d android
flutter run -d ios
```

### 🔥 Firebase Setup (Opsional)

Untuk menggunakan Firebase Authentication, ikuti panduan lengkap di [FIREBASE_SETUP.md](./FIREBASE_SETUP.md).

## 🏗️ Arsitektur Project

```
lib/
├── main.dart                 # Entry point aplikasi
├── firebase_options.dart     # Konfigurasi Firebase
├── data/                     # Data statis dan mock
│   ├── course_data.dart
│   └── mentor_data.dart
├── models/                   # Model data
│   ├── course.dart
│   ├── lesson.dart
│   ├── mentor.dart
│   ├── quiz_question.dart
│   └── word.dart
├── pages/                    # Halaman UI
│   ├── main_navigation.dart  # Navigation utama
│   ├── home_page.dart
│   ├── courses_list_page.dart
│   ├── games_page.dart
│   ├── mentor_page.dart
│   ├── progress_page.dart
│   ├── leaderboard_page.dart
│   ├── login_page.dart       # Firebase login
│   ├── mock_login_page.dart  # Mock login
│   └── ...
├── providers/                # State management
│   ├── auth_provider.dart    # Firebase auth
│   └── mock_auth_provider.dart # Mock auth
├── services/                 # Business logic
│   ├── auth_service.dart
│   └── mock_auth_service.dart
└── state/                    # Global state
    └── app_state.dart
```

## 🎨 Design System

### Material 3 Design
- **Color Scheme**: Purple-based dengan aksen modern
- **Typography**: Roboto dengan hierarki yang jelas
- **Components**: Card, Button, AppBar dengan konsistensi tinggi

### Responsive Design
- **Mobile First**: Optimized untuk mobile
- **Web Responsive**: Adaptif untuk berbagai ukuran layar
- **Cross Platform**: Konsisten di Android, iOS, dan Web

## 🔧 Development

### Hot Reload
```bash
# Jalankan dengan hot reload
flutter run -d web --hot
```

### Build untuk Production
```bash
# Web
flutter build web

# Android
flutter build apk

# iOS
flutter build ios
```

### Testing
```bash
# Unit tests
flutter test

# Widget tests
flutter test test/widget_test.dart
```

## 📱 Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| 🌐 Web | ✅ Fully Supported | Primary platform |
| 📱 Android | ✅ Supported | Native performance |
| 🍎 iOS | ✅ Supported | Native performance |
| 💻 Desktop | 🔄 In Progress | Windows, macOS, Linux |

## 🛠️ Tech Stack

- **Framework**: Flutter 3.0+
- **Language**: Dart 3.0+
- **State Management**: Provider
- **Authentication**: Firebase Auth + Mock System
- **Navigation**: GoRouter
- **UI**: Material 3 Design
- **Icons**: Material Icons + Cupertino Icons

## 🤝 Contributing

1. Fork repository
2. Buat feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push ke branch (`git push origin feature/amazing-feature`)
5. Buat Pull Request

## 📄 License

Project ini menggunakan MIT License. Lihat file `LICENSE` untuk detail.

## 🆘 Troubleshooting

### Common Issues

1. **Firebase Error**: Lihat [FIREBASE_SETUP.md](./FIREBASE_SETUP.md)
2. **Build Error**: Jalankan `flutter clean && flutter pub get`
3. **Web Error**: Pastikan menggunakan browser modern

### Support

- 📧 Email: support@bisabasa.com
- 💬 Discord: [BisaBasa Community](https://discord.gg/bisabasa)
- 📖 Docs: [Documentation](https://docs.bisabasa.com)

---

**Made with ❤️ using Flutter**
