import 'package:flutter/material.dart';
import '../auth/login_view.dart'; // <-- IMPORT LOGIN VIEW

const _bg = Color(0xFFF7F8FF);
const _dark = Color(0xFF1B5E20);
const _green = Color(0xFF2E7D32);
const _mint = Color(0xFF8CEB8C);
const _mintSoft = Color(0xFFCFF5CF);
const _ink = Color(0xFF1A1C24);
const _muted = Color(0xFF5F6670);

class CourierView extends StatefulWidget {
  const CourierView({super.key});

  @override
  State<CourierView> createState() => _CourierViewState();
}

class _CourierViewState extends State<CourierView> {
  // 1. Data Dummy Tugas Penjemputan
  List<Map<String, dynamic>> _tasks = [
    {
      'id': '#REG-001',
      'nama': 'Budi Santoso',
      'alamat': 'Jl. Revolusi No. 42, Kalumata',
      'kategori': 'Plastik & Kertas',
      'berat_estimasi': '15 kg',
      'status': 'Menunggu', // Status: Menunggu, Diambil, Selesai
      'waktu': 'Hari ini, 10:00 WIT',
    },
    {
      'id': '#REG-002',
      'nama': 'Siti Aminah',
      'alamat': 'Kel. Akehuda, Ternate Utara',
      'kategori': 'Minyak Jelantah',
      'berat_estimasi': '5 Liter',
      'status': 'Menunggu',
      'waktu': 'Hari ini, 13:00 WIT',
    },
    {
      'id': '#REG-003',
      'nama': 'Andi Wijaya',
      'alamat': 'Jl. Sultan Babullah, Ternate Selatan',
      'kategori': 'Logam & Kaleng',
      'berat_estimasi': '10 kg',
      'status': 'Menunggu',
      'waktu': 'Besok, 09:00 WIT',
    },
  ];

  // Statistik Ringkasan
  int get _tugasBaru => _tasks.where((t) => t['status'] == 'Menunggu').length;
  int get _tugasJalan => _tasks.where((t) => t['status'] == 'Diambil').length;
  int get _tugasSelesai => _tasks.where((t) => t['status'] == 'Selesai').length;
  int get _pendapatan => _tugasSelesai * 15000; // Simulasi: Rp 15.000 per tugas selesai

  // 2. Fungsi Menerima Tugas (Alur: Menerima Permintaan)
  void _terimaTugas(int index) {
    setState(() {
      _tasks[index]['status'] = 'Diambil';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tugas ${_tasks[index]['id']} diterima! Silakan menuju lokasi.'), backgroundColor: _green),
    );
  }

  // 3. Fungsi Konfirmasi Berat & Selesai (Alur: Konfirmasi Berat -> Transaksi Dicatat)
  void _selesaikanTugas(int index) {
    final TextEditingController weightController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Konfirmasi Berat Sampah'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Masukkan berat aktual sampah yang ditimbang (kg):'),
            const SizedBox(height: 12),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Contoh: 15.5',
                border: OutlineInputBorder(),
                suffixText: 'kg',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              final weight = double.tryParse(weightController.text) ?? 0;
              if (weight > 0) {
                setState(() {
                  _tasks[index]['status'] = 'Selesai';
                  _tasks[index]['berat_aktual'] = '$weight kg';
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tugas selesai! Berat sampah telah dikonfirmasi.'), backgroundColor: _green),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: _green),
            child: const Text('Konfirmasi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: const Text('Dashboard Mitra Kurir', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: _green,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Tombol Logout (Sudah Diperbaiki)
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Kembali ke halaman Login dan hapus semua riwayat navigasi
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginView()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BAGIAN 1: RINGKASAN STATISTIK
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [_green, _dark], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: _green.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat('$_tugasBaru', 'Tugas Baru'),
                      Container(width: 1, height: 40, color: Colors.white30),
                      _buildStat('$_tugasJalan', 'Sedang Jalan'),
                      Container(width: 1, height: 40, color: Colors.white30),
                      _buildStat('$_tugasSelesai', 'Selesai'),
                    ],
                  ),
                  const Divider(color: Colors.white30, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.account_balance_wallet, color: Colors.white70, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Pendapatan Hari Ini: Rp ${_pendapatan.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // BAGIAN 2: DAFTAR TUGAS PENJEMPUTAN
            const Text('Daftar Penjemputan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _ink)),
            const SizedBox(height: 12),
            
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                final isMenunggu = task['status'] == 'Menunggu';
                final isDiambil = task['status'] == 'Diambil';
                final isSelesai = task['status'] == 'Selesai';

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isSelesai ? Colors.grey.shade300 : _green.withOpacity(0.3)),
                    boxShadow: const [BoxShadow(color: Color(0x0F1A1C24), blurRadius: 10, offset: Offset(0, 4))],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(task['id'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: _muted)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isMenunggu ? Colors.orange.shade100 : (isDiambil ? Colors.blue.shade100 : _mintSoft),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                task['status'],
                                style: TextStyle(
                                  color: isMenunggu ? Colors.orange.shade900 : (isDiambil ? Colors.blue.shade900 : _dark),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(task['nama'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _ink)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 16, color: _muted),
                            const SizedBox(width: 4),
                            Expanded(child: Text(task['alamat'], style: const TextStyle(fontSize: 13, color: _muted))),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          children: [
                            _buildInfoChip(Icons.recycling, task['kategori']),
                            const SizedBox(width: 8),
                            _buildInfoChip(Icons.scale, task['berat_estimasi']),
                            const Spacer(),
                            Text(task['waktu'], style: const TextStyle(fontSize: 11, color: _muted)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // TOMBOL AKSI SESUAI STATUS
                        if (isMenunggu)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => _terimaTugas(index),
                              icon: const Icon(Icons.check_circle_outline, size: 18),
                              label: const Text('Terima Tugas & Jalan'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          )
                        else if (isDiambil)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => _selesaikanTugas(index),
                              icon: const Icon(Icons.scale, size: 18),
                              label: const Text('Konfirmasi Berat & Selesai'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade700,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          )
                        else
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Selesai (Berat: ${task['berat_aktual']})',
                              style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: _bg, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: _muted),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 11, color: _ink, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}