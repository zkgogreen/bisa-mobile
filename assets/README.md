# Assets Folder

Folder ini berisi semua aset yang digunakan dalam aplikasi BisaBasa.

## 📁 Struktur Folder

### 🖼️ `images/`
Tempat menyimpan gambar-gambar seperti:
- Foto profil mentor
- Ilustrasi untuk halaman onboarding
- Background images
- Screenshots untuk tutorial
- Logo dan branding

**Format yang disarankan:** PNG, JPG, SVG
**Penamaan:** gunakan snake_case (contoh: `mentor_profile.png`)

### 🎯 `icons/`
Tempat menyimpan ikon-ikon custom seperti:
- Custom app icons
- Feature icons
- Category icons
- Achievement badges

**Format yang disarankan:** PNG, SVG
**Ukuran:** Multiple sizes (24x24, 48x48, 72x72, 96x96)

### 🎬 `animations/`
Tempat menyimpan file animasi seperti:
- Lottie animations (.json)
- GIF files
- Animated illustrations

**Format yang disarankan:** JSON (Lottie), GIF

### 🔤 `fonts/`
Tempat menyimpan font custom (jika diperlukan):
- Custom typography
- Icon fonts
- Brand fonts

**Format yang disarankan:** TTF, OTF

## 📝 Cara Menggunakan Assets

### 1. Menambahkan Gambar
```dart
Image.asset('assets/images/nama_gambar.png')
```

### 2. Menambahkan Icon
```dart
Image.asset('assets/icons/nama_icon.png')
```

### 3. Menggunakan dalam Container/Decoration
```dart
Container(
  decoration: BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/images/background.png'),
      fit: BoxFit.cover,
    ),
  ),
)
```

## ⚠️ Catatan Penting

1. **Ukuran File:** Pastikan ukuran file tidak terlalu besar untuk performa aplikasi
2. **Format:** Gunakan format yang tepat (PNG untuk transparansi, JPG untuk foto)
3. **Penamaan:** Gunakan nama yang deskriptif dan konsisten
4. **Optimasi:** Kompres gambar sebelum menambahkan ke project
5. **Resolusi:** Sediakan multiple resolusi untuk different screen densities

## 🔄 Update pubspec.yaml

Setelah menambahkan file baru, pastikan untuk menjalankan:
```bash
flutter pub get
```

Dan restart aplikasi untuk memuat assets yang baru ditambahkan.