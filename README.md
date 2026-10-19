# Co-Detect — Asisten Kesehatan Cerdas & Skrining Mandiri

<p align="center">
  <img src="https://images.unsplash.com/photo-1584515979956-d9f6e5d09982?w=800&auto=format&fit=crop&q=80" alt="Co-Detect Banner" width="100%" style="border-radius: 12px;" />
</p>

<p align="center">
  <strong>Solusi Terpadu Skrining Gejala, Pemantauan Lansia, Analisis Kulit AI, dan Navigasi Fasilitas Kesehatan</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-blue" alt="Platform" />
  <img src="https://img.shields.io/badge/Status-Active%20Development-success" alt="Status" />
</p>

---

## 📌 Daftar Isi
1. [Tentang Co-Detect](#-tentang-co-detect)
2. [Fitur Utama](#-fitur-utama)
3. [Arsitektur & Struktur Direktori](#-arsitektur--struktur-direktori)
4. [Teknologi & Pustaka Utama](#-teknologi--pustaka-utama)
5. [Prasyarat & Persiapan Lingkungan](#-prasyarat--persiapan-lingkungan)
6. [Langkah Instalasi & Menjalankan](#-langkah-instalasi--menjalankan)
7. [Konfigurasi Izin (Permissions)](#-konfigurasi-izin-permissions)
8. [Panduan Penggunaan Fitur](#-panduan-penggunaan-fitur)

---

## 📖 Tentang Co-Detect

**Co-Detect** adalah aplikasi kesehatan mobile berbasis Flutter yang dirancang untuk membantu masyarakat dalam melakukan deteksi dini kesehatan mandiri, memantau kondisi anggota keluarga lanjut usia, mengakses panduan medis terpercaya, serta terhubung dengan fasilitas kesehatan terdekat secara cepat dan efisien.

Aplikasi ini menggabungkan antarmuka modern yang ramah pengguna, mode aksesibilitas khusus lansia (*Senior-Friendly Mode*), kecerdasan buatan (*AI Assistant & Skin Scanner*), serta kemampuan menghasilkan laporan rekam medis berformat PDF yang dapat langsung dicetak atau dibagikan ke tenaga medis.

---

## ✨ Fitur Utama

### 1. 🩺 Skrining Mandiri COVID-19 & Tanya Gejala
- **Kuesioner Interaktif**: Pertanyaan terstruktur seputar gejala umum (demam, batuk, anosmia, sesak napas) dan riwayat kontak erat.
- **Kalkulasi Risiko Otomatis**: Menghasilkan klasifikasi risiko (Aman vs Terindikasi) secara instan.
- **Rekomendasi Medis Personal**: Panduan langkah berikutnya seperti isolasi mandiri, konsumsi vitamin, atau rujukan PCR/Antigen.
- **Riwayat Pemeriksaan**: Menyimpan hasil skrining sebelumnya untuk pemantauan tren kesehatan berkala.

### 2. 🧓 Pantau Lansia (Elderly Health Tracker)
- **Pemantauan Tanda Vital**: Catatan harian tekanan darah (*systolic/diastolic*), detak jantung (BPM), saturasi oksigen darah (SpO2), dan suhu tubuh (°C).
- **Profil Anggota Keluarga**: Kelola data lansia yang dipantau lengkap dengan riwayat penyakit penyerta (komorbiditas).
- **Panggilan Darurat SOS**: Tombol sekali tekan untuk menghubungi nomor darurat (Ambulans 119) atau kontak darurat keluarga terpilih.
- **Tren Kesehatan**: Indikator status normal, waspada, atau bahaya berdasarkan angka vital terbaru.

### 3. 🔬 AI Skin Scan (Pemeriksaan Kesehatan Kulit)
- **Unggah / Ambil Foto**: Ambil foto area kulit atau wajah menggunakan kamera perangkat atau galeri.
- **Simulasi Analisis Visual**: Deteksi tipe kulit (Normal, Berminyak, Kering, Kombinasi) serta deteksi anomali/ruam.
- **Skor & Rekomendasi**: Menampilkan persentase kecocokan kondisi kulit beserta rekomendasi kandungan perawatan yang tepat.

### 4. 🤖 Dr. Co-Detect AI & Layanan Pesan
- **Konsultasi Cerdas**: Asisten virtual siap pakai yang memberikan jawaban seputar keluhan kesehatan, aturan obat dasar, dan protokol isolasi.
- **Quick Action Chips**: Tombol cepat untuk topik keluhan darurat (Demam & Batuk, Sesak Napas, Aturan Obat, Lansia Binaan).
- **Pusat Notifikasi**: Penerimaan notifikasi verifikasi vaksin, jadwal pengingat obat, dan pengumuman kesehatan.

### 5. 🏥 Direktori Rumah Sakit & Navigasi GPS
- **Pencarian RS Rujukan Terdekat**: Menggunakan geolokasi perangkat untuk menghitung jarak nyata (km) ke faskes rujukan.
- **Integrasi Google Maps**: Membuka rute navigasi langsung menuju rumah sakit yang dipilih.
- **Pemesanan Janji Temu (Booking Faskes)**: Formulir registrasi rawat jalan / tes swab / dokter spesialis langsung dari aplikasi.
- **Panggilan Langsung Faskes**: Hubungi IGD / call center rumah sakit dalam sekali sentuh.

### 6. 💉 Info Vaksinasi & Edukasi Kesehatan
- **Jadwal & Dosis Vaksin**: Panduan lengkap dosis 1, dosis 2, dan booster berserta efek samping (KIPI) dan penanganannya.
- **Video Edukasi**: Kumpulan materi video interaktif edukasi pencegahan penyakit dan tips kesehatan harian.
- **Tips Gaya Hidup Sehat**: Artikel ringkas mengenai imunitas, nutrisi seimbang, dan kebersihan diri.

### 7. 📄 Ekspor Laporan PDF & Berbagi
- **Laporan PDF Resmi**: Cetak dokumen medis hasil skrining atau riwayat kesehatan lansia dengan kop dokumen formal.
- **Berbagi Mudah**: Kirim ringkasan hasil pemeriksaan ke dokter atau keluarga melalui WhatsApp, Telegram, atau email via *Share Plus*.

### 8. ♿ Aksesibilitas & Pengaturan Fleksibel
- **Senior-Friendly Mode**: Memperbesar skala teks hingga 1.15x dan memperjelas tombol serta kontras warna bagi pengguna usia lanjut.
- **Tema Gelap & Terang**: Mendukung Dark Mode untuk kenyamanan mata di malam hari.
- **Keamanan Profil**: Fitur privasi seperti menyembunyikan NIK dan perlindungan akun.

---

## 📂 Arsitektur & Struktur Direktori

```text
co_detect/
├── android/                   # Konfigurasi native platform Android
├── ios/                       # Konfigurasi native platform iOS
├── web/                       # Konfigurasi platform Web
├── assets/                    # Gambar, ikon, dan dokumen statis (opsional)
├── lib/
│   ├── main.dart              # Entry-point aplikasi & konfigurasi tema/aksesibilitas
│   ├── pages/
│   │   └── result_page.dart   # Halaman visualisasi hasil analisis scan kulit
│   ├── screens/
│   │   ├── main_nav_screen.dart                 # Bottom navigation bar (Home, Pesan, Profil, Sistem)
│   │   ├── home_screen.dart                     # Beranda utama, menu 4x2, dan kartu statistik
│   │   ├── screening_screen.dart                # Kuesioner skrining mandiri gejala
│   │   ├── screening_result_screen.dart         # Hasil evaluasi skrining mandiri
│   │   ├── elderly_tracker_screen.dart          # Pelacakan tanda vital & SOS darurat lansia
│   │   ├── skin_scan_screen.dart                # Pemindaian foto kamera / galeri
│   │   ├── hospital_list_screen.dart            # Daftar faskes & hitung jarak geolokasi
│   │   ├── hospital_map_screen.dart             # Tampilan peta faskes
│   │   ├── messages_screen.dart                 # Chatbot AI medis & notifikasi sistem
│   │   ├── vaccine_info_screen.dart             # Info jenis vaksin, dosis, dan efek samping
│   │   ├── health_tips_screen.dart              # Kumpulan tips kesehatan & imunitas
│   │   ├── edu_video_screen.dart                # Edukasi video kesehatan interaktif
│   │   ├── profile_screen.dart                  # Profil pengguna, QR health pass, riwayat medis
│   │   ├── system_settings_screen.dart          # Pengaturan sistem, bahasa, privasi & lisensi
│   │   ├── login_screen.dart                    # Halaman masuk akun
│   │   ├── register_screen.dart                 # Halaman pendaftaran akun baru
│   │   └── computer_test_assessment_screen.dart # Lembar asesmen kompetensi
│   ├── services/
│   │   ├── user_session.dart            # Pengelola state pengguna lokal (SharedPreferences)
│   │   ├── report_export_service.dart   # Generator dokumen PDF & sharing
│   │   ├── location_service.dart        # Layanan GPS & jarak koordinat
│   │   └── map_launcher.dart            # Peluncur deep link Google Maps & Panggilan
│   ├── theme/
│   │   ├── app_colors.dart              # Palet warna konsisten
│   │   └── app_theme.dart               # Konfigurasi Light & Dark ThemeData
│   └── widgets/
│       ├── app_status_bar.dart          # Mock status bar konsisten
│       ├── hospital_booking_dialog.dart # Modal formulir pendaftaran faskes
│       └── user_avatar.dart             # Komponen avatar foto pengguna
├── pubspec.yaml               # Metadata dependensi paket Flutter
└── README.md                  # Dokumentasi proyek
```

---

## 🛠 Teknologi & Pustaka Utama

| Paket | Versi | Fungsi |
|---|---|---|
| [flutter](https://flutter.dev) | SDK >=3.13.5 | Framework UI lintas platform utama |
| [geolocator](https://pub.dev/packages/geolocator) | `^14.1.1` | Pengambilan koordinat GPS & perhitungan jarak ke faskes |
| [url_launcher](https://pub.dev/packages/url_launcher) | `^6.3.3` | Membuka tautan eksternal (Google Maps, panggilan telepon 119) |
| [image_picker](https://pub.dev/packages/image_picker) | `^1.2.4` | Mengambil foto dari kamera atau galeri untuk scan kulit |
| [pdf](https://pub.dev/packages/pdf) & [printing](https://pub.dev/packages/printing) | `^3.13.1` / `^5.15.1` | Membuat tata letak dokumen PDF medis & dialog pencetakan |
| [share_plus](https://pub.dev/packages/share_plus) | `^13.3.1` | Membagikan teks & berkas laporan ke aplikasi pihak ketiga |
| [shared_preferences](https://pub.dev/packages/shared_preferences) | `^2.5.6` | Penyimpanan lokal untuk profil pengguna, data lansia, & preferensi |
| [cupertino_icons](https://pub.dev/packages/cupertino_icons) | `^1.0.8` | Ikon pelengkap bergaya iOS |

---

## 📋 Prasyarat & Persiapan Lingkungan

Pastikan perangkat Anda telah terpasang:
1. **Flutter SDK** (versi 3.13.5 atau yang lebih baru).
2. **Dart SDK** (termasuk di dalam paket Flutter).
3. **Android Studio** / **VS Code** dengan ekstensi Flutter & Dart.
4. **Android SDK / Emulator** atau perangkat fisik dengan mode *Developer Options* & *USB Debugging* aktif.

Cek kesiapan lingkungan dengan perintah:
```bash
flutter doctor
```

---

## 🚀 Langkah Instalasi & Menjalankan

1. **Clone repository ini** (atau buka direktori proyek):
   ```bash
   cd co_detect
   ```

2. **Unduh semua paket dependensi**:
   ```bash
   flutter pub get
   ```

3. **Pastikan perangkat/emulator terhubung**:
   ```bash
   flutter devices
   ```

4. **Jalankan aplikasi**:
   ```bash
   flutter run
   ```

5. **Membangun rilis produksi (APK Android)**:
   ```bash
   flutter build apk --release
   ```
   *File output akan berada di: `build/app/outputs/flutter-apk/app-release.apk`*

---

## 🔒 Konfigurasi Izin (Permissions)

Untuk mengaktifkan seluruh fitur secara optimal, aplikasi memerlukan izin berikut:

### Android (`android/app/src/main/AndroidManifest.xml`)
```xml
<!-- Lokasi (Menghitung jarak ke Faskes / Peta) -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />

<!-- Kamera & Galeri (Scan Kulit AI) -->
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />

<!-- Panggilan Telepon (Panggilan Darurat SOS / Faskes) -->
<uses-permission android:name="android.permission.CALL_PHONE" />

<!-- Akses Jaringan Internet -->
<uses-permission android:name="android.permission.INTERNET" />
```

### iOS (`ios/Runner/Info.plist`)
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Co-Detect memerlukan lokasi Anda untuk menampilkan rumah sakit rujukan terdekat.</string>
<key>NSCameraUsageDescription</key>
<string>Co-Detect memerlukan akses kamera untuk memindai kondisi kulit.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Co-Detect memerlukan galeri untuk memilih foto evaluasi kesehatan.</string>
```

---

## 📱 Panduan Penggunaan Fitur

1. **Skrining Mandiri**: Buka tab **Home** > klik **Tanya Gejala** > jawab pertanyaan skrining > simpan & unduh PDF jika diperlukan.
2. **Pantau Lansia**: Klik menu **Pantau Lansia** di Home > pilih anggota keluarga > catat tanda vital terbaru atau tekan tombol merah **SOS Darurat** untuk bantuan mendesak.
3. **Pindai Kulit**: Pilih menu **Cek Kulit** > pilih Kamera atau Galeri > tekan *Mulai Analisis* > baca hasil klasifikasi dan saran perawatan.
4. **Cari Faskes**: Pilih menu **Daftar RS** > izinkan akses lokasi > telusuri jarak terdekat > tekan *Petunjuk Arah* (membuka Google Maps) atau *Booking Antrean*.
5. **Mode Ramah Lansia**: Buka tab **Lainnya (Sistem)** > aktifkan toggle **Mode Ramah Lansia** untuk tampilan teks yang lebih besar dan mudah dibaca.

---

## 📄 Lisensi & Kontribusi

Proyek ini dikembangkan untuk tujuan edukasi, kesehatan preventif, dan asisten digital masyarakat. Segala bentuk kontribusi, perbaikan *bug*, serta usulan fitur baru sangat dipersilakan melalui *Pull Request* atau *Issue*.

*Catatan: Aplikasi ini berfungsi sebagai alat bantu skrining awal dan asisten kesehatan pribadi, bukan sebagai pengganti diagnosis resmi tenaga medis profesional.*
