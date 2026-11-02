# 🌿 REGREEN API Documentation

Dokumentasi API untuk aplikasi REGREEN. API ini dibangun menggunakan Laravel 11 dan Laravel Sanctum untuk autentikasi.

##  Base URL
- **Localhost (Postman/Thunder Client):** `http://127.0.0.1:8000/api`
- **Local Network (Flutter Emulator/HP):** `http://192.168.X.X:8000/api` *(Ganti dengan IP komputer kalian, cek pakai `ipconfig` di CMD)*

## 🔐 Authentication
Endpoint yang bertanda **[Protected]** membutuhkan autentikasi.
Tambahkan Header berikut pada setiap request:
- **Key:** `Authorization`
- **Value:** `Bearer <TOKEN_KALIAN>`

---

## 1. Autentikasi (Auth)

### 1.1 Register User
- **Method:** `POST`
- **URL:** `/register`
- **Body (JSON):**
  ```json
  {
      "nama": "Nama Lengkap",
      "username": "username_unik",
      "email": "email@contoh.com",
      "password": "password123",
      "password_confirmation": "password123",
      "no_hp": "08123456789"
  }