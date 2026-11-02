# 📱 REGREEN - Bank Sampah Digital Berbasis Aplikasi Mobile

Dokumen ini memastikan pembagian tugas yang adil, terukur, dan mudah dilacak di GitHub. Setiap anggota memiliki "wilayah kekuasaan" masing-masing dengan beban kerja yang seimbang antara UI dan logika, sesuai dengan proposal project Pemrograman Mobile.

**Status saat ini:** Struktur folder utama (`mobile/`, `backend/`, `database/`, `documentation/`) sudah dibuat dan di-push ke repository. Library `GetX` telah dihapus dan diganti dengan **State Management bawaan Flutter (`StatefulWidget` & `Navigator`)** sesuai arahan dosen. Tahap selanjutnya adalah mengisi tiap file sesuai PIC (Person In Charge) dan branch yang tertera di bawah.

---

## 📑 Daftar Isi
1. [👥 Ringkasan Tim](#-ringkasan-tim)
2. [📁 Struktur Folder](#-struktur-folder)
3. [🗂️ Kepemilikan Folder](#️-kepemilikan-folder)
4. [📊 Detail Tanggung Jawab per Anggota](#-detail-tanggung-jawab-per-anggota)
5. [🌿 Branch yang Harus Dibuat per Anggota](#-branch-yang-harus-dibuat-per-anggota)
6. [📖 Panduan Git & Membuat Branch](#-panduan-git--membuat-branch)
7. [⚠️ Catatan Penting](#️-catatan-penting)

---

## 👥 Ringkasan Tim
| No | Nama | NIM | Role | Fokus Utama |
|----|------|-----|------|-------------|
| 1 | Nesa | 07352411131 | Project Manager / System Analyst | Koordinasi tim, dokumentasi, Splash Screen, Bottom Navigation, Git Management. |
| 2 | Fatika | 07352411150 | UI/UX Designer & Frontend | Design system, implementasi halaman Login, Register, dan Profil + integrasi API. |
| 3 | Hadjija | 07352411056 | Mobile Developer | Implementasi halaman Beranda (Dashboard Saldo) dan Jemput Sampah (Formulir) + integrasi API. |
| 4 | Radit | 07352311071 | Mobile Developer | Implementasi halaman Katalog Sampah dan Riwayat Transaksi, state management saldo + integrasi API. |
| 5 | Vergiawan | 07352311081 | Backend & Database Dev | Laravel REST API, MySQL Database, Testing API (Prioritas MVP Nasabah). |
| 6 | Muhajjir | 07352411107 | QA & DevOps | Implementasi halaman Drop Point (Peta), Testing, Build APK, Dokumentasi Teknis + integrasi API. |

---

## 📁 Struktur Folder
Kode PIC pada tree: **NES** = Nesa, **FAT** = Fatika, **HAD** = Hadjija, **RAD** = Radit, **VER** = Vergiawan, **MUH** = Muhajjir.

```text
REGREEN/
├── mobile/                          # Project Flutter Utama
│   ├── pubspec.yaml                 # Dependencies (Tanpa GetX, pakai bawaan Flutter)
│   ├── design/                      # Aset UI/UX & Gambar (Figma/AI Studio) [FAT & NES]
│   └── lib/
│       ├── main.dart                # Entry point (MaterialApp) [NES]
│       ├── main_navigation_view.dart# Bottom Navigation (Wadah utama) [NES]
│       └── app/
│           └── modules/
│               ├── auth/            # Login & Register [FAT]
│               │   ├── login_view.dart
│               │   └── register_view.dart
│               ├── profile/         # Profil Pengguna [FAT]
│               │   └── profile_view.dart
│               ├── home/            # Beranda / Dashboard [HAD]
│               │   └── home_view.dart
│               ├── pickup/          # Jemput Sampah [HAD]
│               │   └── pickup_view.dart
│               ├── catalog/         # Katalog Jenis Sampah [RAD]
│               │   └── catalog_view.dart
│               ├── history/         # Riwayat Transaksi [RAD]
│               │   └── history_view.dart
│               ├── drop_point/      # Peta Lokasi Drop Point [MUH]
│               │   └── drop_point_view.dart
│               └── splash/          # Splash Screen [NES]
│                   └── splash_view.dart
│
├── backend/                         # Project Laravel REST API [VER]
│   ├── app/Http/Controllers/        # API Controllers
│   ├── routes/api.php               # Endpoint API
│   └── database/migrations/         # Struktur Tabel MySQL
│
├── database/                        # File dump.sql & ERD [VER]
├── documentation/                   # Proposal, User Manual, Laporan, API Docs [NES & MUH]
└── README.md                        # Dokumen ini [NES]
```

## 🗂️ Kepemilikan Folder
| Folder | PIC | Tanggung Jawab |
|--------|-----|----------------|
| `mobile/lib/main.dart` & `main_navigation_view.dart` | Nesa | Entry point & Wadah Bottom Navigation (5 Tab). |
| `mobile/lib/app/modules/splash/` | Nesa | Layar pembuka dengan timer 3 detik. |
| `mobile/lib/app/modules/auth/` | Fatika | UI Login, Register, validasi form, dan logika "Lock 3x gagal". |
| `mobile/lib/app/modules/profile/` | Fatika | UI Data profil nasabah dan pengaturan. |
| `mobile/lib/app/modules/home/` | Hadjija | Dashboard total saldo, poin hijau, dan menu layanan cepat. |
| `mobile/lib/app/modules/pickup/` | Hadjija | Formulir multi-langkah (pilih sampah, berat, jadwal, lokasi). |
| `mobile/lib/app/modules/catalog/` | Radit | Daftar jenis sampah, filter kategori, dan estimasi harga. |
| `mobile/lib/app/modules/history/` | Radit | Riwayat transaksi, filter status, dan unduh struk digital. |
| `mobile/lib/app/modules/drop_point/` | Muhajjir | Integrasi Google Maps/Leaflet untuk lokasi bank sampah terdekat. |
| `backend/` & `database/` | Vergiawan | Pembuatan Endpoint API (Auth, Dashboard, Sampah, Penjemputan, Riwayat, Drop Point) & MySQL. |
| `documentation/` & Testing | Nesa & Muhajjir | Penyusunan laporan, README, dan pengujian fungsional aplikasi. |


## 📊 Detail Tanggung Jawab per Anggota

### 1. Nesa (Project Manager / System Analyst)
- **Fokus:** Koordinasi, Git Management, dan Fondasi Aplikasi.
- **File:** `main.dart`, `main_navigation_view.dart`, `splash_view.dart`.
- **Output:** Alur navigasi aplikasi berjalan lancar (Splash ➡️ Login ➡️ Bottom Nav), struktur Git rapi, tidak ada *merge conflict*.

### 2. Fatika (UI/UX Designer & Frontend)
- **Fokus:** Implementasi desain ke kode Flutter untuk modul Autentikasi & Profil.
- **File:** `login_view.dart`, `register_view.dart`, `profile_view.dart`.
- **Output:** Tampilan sesuai desain Figma/AI Studio, validasi form berfungsi, dan integrasi dengan API Login/Register dari Vergiawan.

### 3. Hadjija (Mobile Developer)
- **Fokus:** Fitur inti transaksi nasabah.
- **File:** `home_view.dart`, `pickup_view.dart`.
- **Output:** Dashboard menampilkan data saldo (dari API), formulir jemput sampah bisa menyimpan data (estimasi) ke database.

### 4. Radit (Mobile Developer)
- **Fokus:** Informasi harga dan transparansi transaksi.
- **File:** `catalog_view.dart`, `history_view.dart`.
- **Output:** Katalog menampilkan data dari API, riwayat transaksi menampilkan mutasi saldo dengan rapi.

### 5. Vergiawan (Backend & Database Developer)
- **Fokus:** Menyediakan data untuk tim Flutter.
- **File:** Semua file di folder `backend/` dan `database/`.
- **Output:** REST API yang teruji di Postman untuk modul Nasabah (MVP), database MySQL yang ternormalisasi.

### 6. Muhajjir (QA & DevOps)
- **Fokus:** Fitur Peta, Kualitas, dan Rilis.
- **File:** `drop_point_view.dart`, dokumentasi testing, proses build APK.
- **Output:** Peta lokasi berfungsi, aplikasi bebas bug kritis, dan file APK siap presentasi.

---

## 🌿 Branch yang Harus Dibuat per Anggota
**ATURAN EMAS:** 🚫 **DILARANG** push langsung ke branch `main`. Selalu buat branch fitur sendiri.

Format penamaan: `feature/[nama-fitur]-[nama-panggilan]`

| Anggota | Nama Branch yang Harus Dibuat | Cakupan Pekerjaan |
|---------|-------------------------------|-------------------|
| **Fatika** | `feature/auth-profile-fatika` | Login, Register, Profil |
| **Hadjija** | `feature/home-pickup-hadjija` | Beranda, Jemput Sampah |
| **Radit** | `feature/catalog-history-radit` | Katalog, Riwayat Transaksi |
| **Muhajjir** | `feature/drop-point-muhajjir` | Drop Point (Peta), Testing |
| **Vergiawan**| `feature/backend-api-vergiawan`| Laravel API & Database |

---

## 📖 Panduan Git & Membuat Branch
Ikuti langkah ini agar kode tidak bentrok:

### Langkah 1: Clone Repository (Jika belum)
```bash
git clone https://github.com/nesarahman/BankSampah.git
cd BankSampah/mobile
flutter pub get
```
### Langkah 2: Pastikan Branch Utama Terbaru
Sebelum membuat branch baru, pastikan kamu sudah di branch `main` yang terbaru:
```bash
git checkout main
git pull origin main
```
### Langkah 3: Buat Branch Fitur Sendiri
Contoh untuk Fatika:
```bash
git checkout -b feature/auth-profile-fatika
```
### Langkah 4: Kerjakan Kode & Commit
Kerjakan **hanya** file di folder milikmu. Commit dengan pesan yang jelas:
```bash
git add .
git commit -m "feat: implementasi UI halaman login dan validasi form"
```
### Langkah 5: Push Branch ke GitHub
```bash
git push origin feature/auth-profile-fatika
```
### Langkah 6: Buat Pull Request (PR)
1. Buka repository di GitHub.
2. Klik **Compare & pull request**.
3. Pastikan `base: main` ← `compare: feature/auth-profile-fatika`.
4. Isi deskripsi singkat, lalu klik **Create pull request**.
5. **Nesa (PM)** akan me-review dan melakukan *Merge* ke `main`.
---

## ⚠️ Catatan Penting
1. **State Management:** Sesuai arahan dosen, **JANGAN gunakan GetX**. Gunakan `StatefulWidget`, `setState()`, dan `Navigator` bawaan Flutter.
2. **Password Simulasi:** Untuk testing login sementara, gunakan password: `regreen123`.
3. **Komunikasi:** Jika ada file di luar folder tugasmu yang perlu diubah, **diskusikan dulu** di grup WhatsApp sebelum di-commit.
4. **Flutter Clean:** Jika setelah `git pull` muncul banyak error merah, jalankan `flutter clean` lalu `flutter pub get` di folder `mobile/`.

---
*Dokumen ini dikelola oleh Nesa (Project Manager). Terakhir diperbarui: Oktober 2026.*