import 'package:flutter/material.dart';

// Import Halaman Login (Dikerjakan oleh Fatika)
import '../auth/login_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _pindahHalaman();
  }

  void _pindahHalaman() async {
    // Tunggu 3 detik untuk animasi splash
    await Future.delayed(const Duration(seconds: 3));

    // Pastikan widget masih aktif (mounted) sebelum melakukan navigasi
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E7D32), // Warna Hijau REGREEN
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            // Icon / Logo REGREEN
            Icon(Icons.eco, size: 80, color: Colors.white),
            SizedBox(height: 20),

            // Nama Aplikasi
            Text(
              'REGREEN',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 10),

            // Slogan REGREEN
            Text(
              'Ubah Sampahmu jadi Berkah',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            SizedBox(height: 40),

            // Indikator Loading
            CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
          ],
        ),
      ),
    );
  }
}
