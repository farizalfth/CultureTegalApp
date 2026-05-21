# CultureTegalApp 🏛️

CultureTegalApp adalah aplikasi mobile berbasis Flutter yang dirancang untuk memperkenalkan, melestarikan, dan mengeksplorasi kekayaan budaya, UMKM, dan event di wilayah Tegal. Aplikasi ini bertujuan untuk menjadi pusat informasi digital bagi masyarakat lokal maupun wisatawan.

## 🚀 Fitur Utama

- **Eksplorasi Budaya**: Informasi mendalam mengenai situs budaya dan sejarah di Tegal.
- **Manajemen Event**: Daftar acara budaya dan kegiatan lokal yang akan datang.
- **Dukungan UMKM**: Katalog produk dan usaha mikro, kecil, dan menengah asli Tegal.
- **Berita & Artikel**: Berita terkini seputar perkembangan budaya di Tegal.
- **Sistem Ulasan**: Pengguna dapat memberikan ulasan dan rating pada lokasi atau produk.
- **Autentikasi**: Login dan registrasi yang aman, termasuk integrasi Google Sign-In.
- **Pencarian Cerdas**: Memudahkan pengguna menemukan konten budaya atau UMKM tertentu.

## 🛠️ Teknologi yang Digunakan

- **Framework**: [Flutter](https://flutter.dev/) (SDK ^3.10.3)
- **State Management**: [GetX](https://pub.dev/packages/get)
- **Backend Service**: [Supabase](https://supabase.com/) (Database & Auth)
- **Local Storage**: [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)
- **Environment Management**: [Flutter Dotenv](https://pub.dev/packages/flutter_dotenv)

## 📁 Struktur Proyek (GetX Pattern)

```text
lib/app/
├── data/           # Model & Provider
├── modules/        # Fitur (Home, Event, UMKM, Auth, dll.)
│   ├── home/
│   ├── event/
│   ├── umkm/
│   ├── explore/
│   └── ...
├── routes/         # Manajemen navigasi
└── widgets/        # Komponen UI yang dapat digunakan kembali
```

## ⚙️ Persiapan Instalasi

1.  **Clone repositori ini:**
    ```bash
    git clone <url-repositori-anda>
    ```
2.  **Instal dependensi:**
    ```bash
    flutter pub get
    ```
3.  **Konfigurasi Environment:**
    Buat file `.env` di direktori root dan tambahkan kredensial Supabase Anda:
    ```env
    SUPABASE_URL=your_supabase_url
    SUPABASE_ANON_KEY=your_supabase_anon_key
    ```
4.  **Jalankan aplikasi:**
    ```bash
    flutter run
    ```

Dibuat dengan ❤️ untuk Tegal.
