# 🔥 Firebase Setup Guide - BisaBasa App

Panduan lengkap untuk mengkonfigurasi Firebase pada aplikasi BisaBasa Flutter.

## 📋 Prerequisites

- Flutter SDK (3.0+)
- Akun Google/Firebase
- Node.js (untuk Firebase CLI)

## 🚀 Langkah-langkah Setup

### 1. Buat Project Firebase

1. Buka [Firebase Console](https://console.firebase.google.com/)
2. Klik **"Create a project"** atau **"Add project"**
3. Masukkan nama project: `bisabasa-app` (atau sesuai keinginan)
4. Aktifkan Google Analytics (opsional)
5. Pilih region yang sesuai

### 2. Setup Authentication

1. Di Firebase Console, pilih **Authentication**
2. Klik tab **"Sign-in method"**
3. Aktifkan **Google** sebagai provider:
   - Klik Google → Enable
   - Masukkan email support project
   - Simpan konfigurasi

### 3. Setup Web App

1. Di Project Overview, klik ikon **Web** (`</>`)
2. Masukkan nickname: `bisabasa-web`
3. **Centang** "Also set up Firebase Hosting" (opsional)
4. Klik **"Register app"**
5. **PENTING**: Salin konfigurasi Firebase yang muncul

### 4. Update Konfigurasi di Flutter

Ganti isi file `lib/firebase_options.dart` dengan konfigurasi dari Firebase Console:

```dart
// File: lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // 🌐 WEB CONFIGURATION - GANTI DENGAN KONFIGURASI ANDA
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_API_KEY_HERE',
    appId: 'YOUR_APP_ID_HERE',
    messagingSenderId: 'YOUR_SENDER_ID_HERE',
    projectId: 'YOUR_PROJECT_ID_HERE',
    authDomain: 'YOUR_PROJECT_ID.firebaseapp.com',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
    measurementId: 'YOUR_MEASUREMENT_ID_HERE',
  );

  // 📱 ANDROID CONFIGURATION (jika diperlukan)
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: 'YOUR_ANDROID_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
  );

  // 🍎 iOS CONFIGURATION (jika diperlukan)
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
    iosBundleId: 'com.example.bisabasa',
  );

  // 💻 MACOS CONFIGURATION (jika diperlukan)
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'YOUR_MACOS_API_KEY',
    appId: 'YOUR_MACOS_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
    iosBundleId: 'com.example.bisabasa',
  );

  // 🪟 WINDOWS CONFIGURATION (jika diperlukan)
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'YOUR_WINDOWS_API_KEY',
    appId: 'YOUR_WINDOWS_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
  );
}
```

### 5. Authorized Domains

Untuk web deployment, tambahkan domain Anda:

1. Di Firebase Console → **Authentication** → **Settings**
2. Scroll ke **Authorized domains**
3. Tambahkan domain yang diperlukan:
   - `localhost` (untuk development)
   - Domain production Anda

## 🔧 Testing Setup

### Mode Development (Mock Authentication)

Aplikasi secara otomatis menggunakan MockAuthProvider jika Firebase gagal diinisialisasi:

```bash
flutter run -d web
```

### Mode Production (Firebase Authentication)

Setelah konfigurasi Firebase benar:

```bash
flutter build web
python -m http.server 8080 --directory build/web
```

## 🛠️ Troubleshooting

### Error: PlatformException

**Penyebab**: Konfigurasi Firebase tidak valid atau tidak lengkap

**Solusi**:
1. Periksa kembali `firebase_options.dart`
2. Pastikan semua field terisi dengan benar
3. Verifikasi project ID di Firebase Console

### Error: Blank Page

**Penyebab**: JavaScript error atau Firebase initialization gagal

**Solusi**:
1. Buka Developer Tools (F12) di browser
2. Periksa Console untuk error
3. Aplikasi akan otomatis fallback ke MockAuthProvider

### Error: Auth Domain

**Penyebab**: Domain tidak diauthorize di Firebase

**Solusi**:
1. Tambahkan domain di Firebase Console
2. Untuk localhost: tambahkan `localhost`
3. Untuk production: tambahkan domain lengkap

## 📚 Fitur Authentication

### Google Sign-In (Production)
- Login dengan akun Google
- Otomatis mendapat foto profil dan nama
- Session management

### Mock Authentication (Development)
- Simulasi login tanpa Firebase
- Data user dummy untuk testing
- Guest mode tersedia

## 🔄 Fallback System

Aplikasi memiliki sistem fallback otomatis:

```dart
// Jika Firebase gagal, otomatis gunakan MockAuthProvider
try {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(BisaBasaApp(useFirebase: true));
} catch (e) {
  print('Firebase initialization failed: $e');
  print('Falling back to MockAuthProvider');
  runApp(BisaBasaApp(useFirebase: false));
}
```

## 📞 Support

Jika mengalami masalah:
1. Periksa dokumentasi Firebase
2. Verifikasi konfigurasi di Firebase Console
3. Test dengan MockAuthProvider terlebih dahulu

---

**Happy Coding! 🚀**