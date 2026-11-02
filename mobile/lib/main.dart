import 'package:flutter/material.dart';

// 1. Import AuthStore agar bisa memuat sesi
import 'app/modules/auth/auth_store.dart'; 
import 'app/modules/splash/splash_view.dart';

void main() async {
  // 2. Wajib dipanggil jika ada proses async sebelum runApp
  WidgetsFlutterBinding.ensureInitialized();
  
  // 3. Muat sesi user yang tersimpan di HP/Browser
  await AuthStore.loadSession();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'REGREEN',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const SplashView(),
    );
  }
}