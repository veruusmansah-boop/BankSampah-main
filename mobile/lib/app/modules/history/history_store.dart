class HistoryStore {
  // List untuk menyimpan data riwayat
  static final List<Map<String, dynamic>> historyList = [
    // Data dummy awal
    {
      'id': '#REG-20240524-03',
      'status': 'Sudah dikonfirmasi',
      'statusColor': 0xFF4CAF50, // Hijau
      'date': '24 Mei 2024 • 14:15 WIT',
      'category': 'KATEGORI & BOBOT',
      'weight': '12.5 kg (Koran Bekas & Kaleng Logam)',
      'pickupPoint': 'TITIK JEMPUT',
      'address': 'Jl. Revolusi No. 42, Kalumata, Ternate',
      'note': null,
      'estimate': '+ Rp 37.500',
      'buttonText': 'Unduh Struk',
      'isProcess': false,
    },
    {
      'id': '#REG-20240519-11',
      'status': 'Sudah dikonfirmasi',
      'statusColor': 0xFF4CAF50,
      'date': '19 Mei 2024 • 09:00 WIT',
      'category': 'KATEGORI & BOBOT',
      'weight': '8.0 kg (Minyak Jelantah & Kardus Box)',
      'pickupPoint': 'LOKASI DROP/JEMPUT',
      'address': 'Kantor Eco Hub Ternate Tengah',
      'note': null,
      'estimate': '+ Rp 28.000',
      'buttonText': 'Unduh Struk',
      'isProcess': false,
    },
  ];

  // Fungsi untuk menambahkan data dari halaman Jemput
  static void addHistory({
    required String category,
    required int weight,
    required int estimate,
    required String address,
    required String date,
    required String session,
    String? note,
  }) {
    final now = DateTime.now();
    final id = '#REG-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${(historyList.length + 1).toString().padLeft(2, '0')}';

    // Format Rupiah manual
    String formatRp(int val) {
      final s = val.toString();
      final b = StringBuffer();
      for (var i = 0; i < s.length; i++) {
        if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
        b.write(s[i]);
      }
      return 'Rp $b';
    }

    historyList.insert(0, {
      'id': id,
      'status': 'Masih dalam proses',
      'statusColor': 0xFFFF9800, // Orange
      'date': '$date • $session',
      'category': 'KATEGORI & BOBOT',
      'weight': '$weight kg ($category)',
      'pickupPoint': 'TITIK JEMPUT',
      'address': address,
      'note': note,
      'estimate': formatRp(estimate),
      'buttonText': 'Pantau Kurir',
      'isProcess': true,
    });
  }

  // --- FUNGSI UNTUK CEK STATUS LOKASI ---
  static bool isLocationInProcess(String lokasiName) {
    return historyList.any((item) => 
      item['isProcess'] == true && 
      (item['address'] as String).contains(lokasiName)
    );
  }

  // --- FUNGSI UNTUK RINGKASAN DINAMIS ---
  static double get totalWeight {
    double total = 0;
    for (var item in historyList) {
      // Ambil angka dari string "15 kg (Kertas)" -> 15
      final weightStr = item['weight'].toString().split(' ')[0];
      total += double.tryParse(weightStr) ?? 0;
    }
    return total;
  }

  static int get totalIncome {
    int total = 0;
    for (var item in historyList) {
      if (item['isProcess'] == false) {
        // Ambil angka dari string "Rp 45.000" -> 45000
        final est = item['estimate'].toString().replaceAll(RegExp(r'[^0-9]'), '');
        total += int.tryParse(est) ?? 0;
      }
    }
    return total;
  }

  static int get totalDone {
    return historyList.where((item) => item['isProcess'] == false).length;
  }
}