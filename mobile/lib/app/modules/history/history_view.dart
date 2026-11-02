import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'history_store.dart';
import 'receipt_view.dart'; // Pastikan file ini sudah dibuat

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  String _selectedFilter = 'Semua';
  final ScreenshotController _screenshotController = ScreenshotController();

  List<Map<String, dynamic>> get _filteredItems {
    if (_selectedFilter == 'Semua') {
      return HistoryStore.historyList;
    } else if (_selectedFilter == 'Dalam Proses') {
      return HistoryStore.historyList.where((item) => item['isProcess'] == true).toList();
    } else {
      return HistoryStore.historyList.where((item) => item['isProcess'] == false).toList();
    }
  }

  // Format Rupiah
  String _formatRp(int val) {
    final s = val.toString();
    final b = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
      b.write(s[i]);
    }
    return 'Rp $b';
  }

  void _showActionMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green[800], behavior: SnackBarBehavior.floating),
    );
  }

  void _showTrackCourierDialog(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.local_shipping, color: Colors.green),
            const SizedBox(width: 8),
            Text('Lacak $id', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.local_shipping, size: 60, color: Colors.green),
            const SizedBox(height: 16),
            const Text('Kurir sedang dalam perjalanan menuju lokasi Anda.', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            const LinearProgressIndicator(value: 0.6, backgroundColor: Colors.grey, color: Colors.green),
            const SizedBox(height: 8),
            const Text('Estimasi tiba: 15-20 menit lagi', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Tutup')),
        ],
      ),
    );
  }

  // FUNGSI UNTUK MENAMPILKAN STRUK (SIMULASI UNDUH DI WEB)
  Future<void> _simpanStruk(Map<String, dynamic> item) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Screenshot(
              controller: _screenshotController,
              child: ReceiptView(
                id: item['id'],
                tanggal: item['date'],
                berat: item['weight'],
                harga: 'Sesuai Katalog',
                total: item['estimate'],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Tutup'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      // Karena ini dijalankan di Web (Chrome), kita hanya simulasikan
                      final image = await _screenshotController.capture();
                      if (image != null) {
                        if (ctx.mounted) Navigator.pop(ctx);
                        _showActionMessage('Struk berhasil diunduh (Simulasi Web)!');
                      }
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Simpan ke Galeri'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green[800]),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredItems;
    final totalItems = HistoryStore.historyList.length;
    final processItems = HistoryStore.historyList.where((e) => e['isProcess'] == true).length;
    final doneItems = HistoryStore.historyList.where((e) => e['isProcess'] == false).length;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Riwayat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () => _showActionMessage('Tidak ada notifikasi baru')),
          const CircleAvatar(backgroundImage: NetworkImage('https://via.placeholder.com/150'), radius: 16),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // RINGKASAN DINAMIS
          Container(
            color: Colors.green[800],
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.green[700], borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('RINGKASAN RIWAYAT', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
                        child: const Text('Bulan Ini', style: TextStyle(color: Colors.white, fontSize: 10)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummaryItem(Icons.scale, 'Total Bobot', '${HistoryStore.totalWeight} kg'),
                      _buildSummaryItem(Icons.check_circle, 'Selesai', '${HistoryStore.totalDone} Kali'),
                      _buildSummaryItem(Icons.account_balance_wallet, 'Pendapatan', _formatRp(HistoryStore.totalIncome)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // FILTER
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Semua ($totalItems)', isSelected: _selectedFilter == 'Semua', onTap: () => setState(() => _selectedFilter = 'Semua')),
                  const SizedBox(width: 8),
                  _buildFilterChip('Dalam Proses ($processItems)', isSelected: _selectedFilter == 'Dalam Proses', onTap: () => setState(() => _selectedFilter = 'Dalam Proses')),
                  const SizedBox(width: 8),
                  _buildFilterChip('Selesai ($doneItems)', isSelected: _selectedFilter == 'Selesai', onTap: () => setState(() => _selectedFilter = 'Selesai')),
                ],
              ),
            ),
          ),

          // LIST RIWAYAT
          Expanded(
            child: filteredList.isEmpty
                ? const Center(child: Text('Tidak ada riwayat untuk kategori ini.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      final color = Color(item['statusColor']);
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(item['id'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                                    child: Row(
                                      children: [
                                        Icon(item['isProcess'] ? Icons.schedule : Icons.check_circle, size: 12, color: color),
                                        const SizedBox(width: 4),
                                        Text(item['status'], style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(item['date'], style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                              const Divider(height: 20),
                              Text(item['category'], style: TextStyle(fontSize: 10, color: Colors.grey[500], fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              Text(item['weight'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              if (item['pickupPoint'] != null) ...[
                                Text(item['pickupPoint'], style: TextStyle(fontSize: 10, color: Colors.grey[500], fontWeight: FontWeight.bold)),
                                const SizedBox(height: 2),
                                Text(item['address'], style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                                const SizedBox(height: 8),
                              ],
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item['isProcess'] ? 'Estimasi Nilai' : 'Saldo Diterima', style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                                      Text(item['estimate'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: item['isProcess'] ? Colors.black87 : Colors.green[800])),
                                    ],
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (item['isProcess']) {
                                        _showTrackCourierDialog(item['id']);
                                      } else {
                                        _simpanStruk(item); // <-- PANGGIL FUNGSI SIMPAN STRUK
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: item['isProcess'] ? Colors.green[800] : Colors.grey[200],
                                      foregroundColor: item['isProcess'] ? Colors.white : Colors.black87,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    ),
                                    child: Text(item['buttonText'], style: const TextStyle(fontSize: 11)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildFilterChip(String label, {bool isSelected = false, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(color: isSelected ? Colors.green[800] : Colors.grey[200], borderRadius: BorderRadius.circular(20)),
        child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontSize: 11, fontWeight: FontWeight.w500)),
      ),
    );
  }
}