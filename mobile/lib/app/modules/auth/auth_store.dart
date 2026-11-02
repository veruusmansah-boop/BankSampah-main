import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStore {
  static Map<String, String>? currentUser;

  static const String _keyCurrentUser = 'current_user_session';
  static const String _keyAccounts = 'registered_accounts';

  // --- REGISTER ---
  static Future<bool> register({
    required String nama,
    required String email,
    required String password,
    String? noHp,
    String role = 'Nasabah',
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = email.trim().toLowerCase();

    String? accountsJson = prefs.getString(_keyAccounts);
    Map<String, dynamic> accounts =
        accountsJson != null ? jsonDecode(accountsJson) : {};

    if (accounts.containsKey(key)) {
      return false; // Email sudah terdaftar
    }

    accounts[key] = {
      'nama': nama,
      'email': key,
      'password': password,
      'noHp': noHp ?? '',
      'alamat': '', // Tambahan field alamat
      'role': role,
    };

    await prefs.setString(_keyAccounts, jsonEncode(accounts));
    return true;
  }

  // --- LOGIN ---
  static Future<Map<String, String>?> login({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = email.trim().toLowerCase();

    String? accountsJson = prefs.getString(_keyAccounts);
    if (accountsJson == null) return null;

    Map<String, dynamic> accounts = jsonDecode(accountsJson);
    final account = accounts[key];

    if (account != null && account['password'] == password) {
      currentUser = Map<String, String>.from(account);
      await prefs.setString(_keyCurrentUser, jsonEncode(currentUser));
      return currentUser;
    }
    return null;
  }

  // --- LOAD SESI ---
  static Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString(_keyCurrentUser);
    if (userJson != null) {
      currentUser = Map<String, String>.from(jsonDecode(userJson));
    }
  }

  // --- LOGOUT ---
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    currentUser = null;
    await prefs.remove(_keyCurrentUser);
  }

  // --- UPDATE PROFIL (Nama & No HP) ---
  static Future<void> updateProfile({
    required String newName,
    required String newPhone,
  }) async {
    if (currentUser == null) return;
    final prefs = await SharedPreferences.getInstance();
    final emailKey = currentUser!['email']!;

    currentUser!['nama'] = newName;
    currentUser!['noHp'] = newPhone;
    await prefs.setString(_keyCurrentUser, jsonEncode(currentUser));

    _updateLocalDatabase(prefs, emailKey, {'nama': newName, 'noHp': newPhone});
  }

  // --- UPDATE ALAMAT ---
  static Future<void> updateAddress(String newAddress) async {
    if (currentUser == null) return;
    final prefs = await SharedPreferences.getInstance();
    final emailKey = currentUser!['email']!;

    currentUser!['alamat'] = newAddress;
    await prefs.setString(_keyCurrentUser, jsonEncode(currentUser));

    _updateLocalDatabase(prefs, emailKey, {'alamat': newAddress});
  }

  // --- UPDATE PASSWORD ---
  static Future<bool> updatePassword(String oldPassword, String newPassword) async {
    if (currentUser == null) return false;
    
    // Cek apakah password lama cocok
    if (currentUser!['password'] != oldPassword) {
      return false; 
    }

    final prefs = await SharedPreferences.getInstance();
    final emailKey = currentUser!['email']!;

    currentUser!['password'] = newPassword;
    await prefs.setString(_keyCurrentUser, jsonEncode(currentUser));

    _updateLocalDatabase(prefs, emailKey, {'password': newPassword});
    return true;
  }

  // Helper untuk update database lokal
  static Future<void> _updateLocalDatabase(
      SharedPreferences prefs, String emailKey, Map<String, dynamic> newData) async {
    String? accountsJson = prefs.getString(_keyAccounts);
    if (accountsJson != null) {
      Map<String, dynamic> accounts = jsonDecode(accountsJson);
      if (accounts.containsKey(emailKey)) {
        accounts[emailKey].addAll(newData);
        await prefs.setString(_keyAccounts, jsonEncode(accounts));
      }
    }
  }
}