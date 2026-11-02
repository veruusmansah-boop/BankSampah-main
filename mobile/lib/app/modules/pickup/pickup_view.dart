import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../history/history_store.dart'; 
import '../history/history_view.dart';

const _bg = Color(0xFFF7F8FF);
const _dark = Color(0xFF1B5E20);
const _green = Color(0xFF2E7D32);
const _mint = Color(0xFF8CEB8C);
const _blueSoft = Color(0xFFDCE4FA);
const _blueIcon = Color(0xFF3B4A6B);
const _lavender = Color(0xFFE6EBFA);
const _ink = Color(0xFF1A1C24);
const _muted = Color(0xFF5F6670);
const _garis = Color(0xFFE0E3EC);

const _namaHari = ['SENIN', 'SELASA', 'RABU', 'KAMIS', 'JUMAT', 'SABTU', 'MINGGU'];
const _namaBulan = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];

String _ribuan(int v) {
  final s = v.abs().toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
    b.write(s[i]);
  }
  return b.toString();
}

String _rp(int v) => 'Rp ${_ribuan(v)}';

BoxDecoration _kartu([Color warna = Colors.white]) => BoxDecoration(
  color: warna,
  borderRadius: BorderRadius.circular(20),
  boxShadow: const [BoxShadow(color: Color(0x0F1A1C24), blurRadius: 12, offset: Offset(0, 4))],
);

class _Kategori {
  const _Kategori(this.nama, this.harga, this.icon);
  final String nama;
  final int harga;
  final IconData icon;
}

class _Sesi {
  const _Sesi(this.label, this.icon);
  final String label;
  final IconData icon;
}

class PickupView extends StatefulWidget {
  const PickupView({super.key, this.onTabSelected, this.showBottomNav = true});
  final ValueChanged<int>? onTabSelected;
  final bool showBottomNav;

  @override
  State<PickupView> createState() => _PickupViewState();
}

class _PickupViewState extends State<PickupView> {
  static const _kategoriList = [
    _Kategori('Kertas & Karton', 3000, Icons.description_outlined),
    _Kategori('Plastik Daur Ulang', 4200, Icons.local_drink_outlined),
    _Kategori('Logam & Kaleng', 7500, Icons.inventory_2_outlined),
    _Kategori('Jelantah & Kaca', 5000, Icons.water_drop_outlined),
  ];
  static const _sesiList = [
    _Sesi('Pagi (09:00 - 12:00)', Icons.wb_sunny_outlined),
    _Sesi('Sore (14:00 - 17:00)', Icons.wb_twilight),
  ];
  static const _namaTab = ['Beranda', 'Jemput', 'Katalog', 'Riwayat', 'Drop Point'];
  static const _ikonTab = [Icons.eco_outlined, Icons.local_shipping_outlined, Icons.recycling, Icons.receipt_long_outlined, Icons.location_on_outlined];
  static const int _minBerat = 2;
  static const int _maxBerat = 500;

  late final List<DateTime> _hari = List.generate(7, (i) {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day).add(Duration(days: i + 1));
  });

  int _kategori = 0;
  int _berat = 15;
  int _tanggal = 0;
  int _sesi = 0;
  final _catatan = TextEditingController();

  String _selectedAddress = 'Jl. Revolusi No. 42, Kalumata, Ternate';
  String _selectedLocationName = 'Rumah Utama';

  int get _estimasi => _berat * _kategoriList[_kategori].harga;

  @override
  void dispose() {
    _catatan.dispose();
    super.dispose();
  }

  void _ubahBerat(int delta) {
    setState(() => _berat = (_berat + delta).clamp(_minBerat, _maxBerat).toInt());
  }

  void _pindahTab(int i) {
    if (i == 1) return;
    if (widget.onTabSelected != null) {
      widget.onTabSelected!(i);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${_namaTab[i]}: navigasi belum tersambung')));
    }
  }

  void _jemput() {
    final k = _kategoriList[_kategori];
    final d = _hari[_tanggal];
    final catatan = _catatan.text.trim();

    HistoryStore.addHistory(
      category: k.nama,
      weight: _berat,
      estimate: _estimasi,
      address: '$_selectedLocationName - $_selectedAddress',
      date: '${_namaHari[d.weekday - 1]}, ${d.day} ${_namaBulan[d.month - 1]}',
      session: _sesiList[_sesi].label,
      note: catatan.isEmpty ? null : catatan,
    );

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Pengajuan Terkirim'),
        content: Text(
          '${k.nama} • $_berat kg\n'
          'Estimasi ${_rp(_estimasi)}\n'
          '${_namaHari[d.weekday - 1]}, ${d.day} ${_namaBulan[d.month - 1]} • ${_sesiList[_sesi].label}\n'
          'Lokasi: $_selectedAddress'
          '${catatan.isEmpty ? '' : '\nCatatan: $catatan'}',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryView()),
              );
            },
            child: const Text('Lihat Riwayat'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      bottomNavigationBar: widget.showBottomNav
          ? BottomNavigationBar(
              currentIndex: 1,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedItemColor: _green,
              unselectedItemColor: _ink,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              onTap: _pindahTab,
              items: [
                for (var i = 0; i < _namaTab.length; i++)
                  BottomNavigationBarItem(icon: Icon(_ikonTab[i]), label: _namaTab[i]),
              ],
            )
          : null,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            const _TopBar(),
            const SizedBox(height: 14),
            _headerLangkah(),
            const SizedBox(height: 20),
            _bagianKategori(),
            const SizedBox(height: 20),
            _bagianBerat(),
            const SizedBox(height: 16),
            _bagianEstimasi(),
            const SizedBox(height: 24),
            _bagianJadwal(),
            const SizedBox(height: 24),
            _bagianLokasi(),
            const SizedBox(height: 24),
            _bagianCatatan(),
            const SizedBox(height: 24),
            SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _jemput,
                icon: const Icon(Icons.local_shipping_outlined),
                label: const Text('Jemput Sekarang'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _dark,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'Gratis biaya penjemputan mitra untuk bobot di atas 10 kg',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: _muted),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerLangkah() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: _mint, borderRadius: BorderRadius.circular(20)),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.eco_outlined, size: 14, color: _dark),
              SizedBox(width: 4),
              Text('LANGKAH 1 DARI 2', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: _dark)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Formulir Jemput Sampah', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: _ink)),
                  SizedBox(height: 2),
                  Text('Konversikan sampah terpilah menjadi saldo bernilai', style: TextStyle(fontSize: 13, color: _muted)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: _blueSoft),
              // UBAH MENJADI 100%
              child: const Text('100%', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: _green)),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          // UBAH VALUE MENJADI 1.0
          child: const LinearProgressIndicator(
            value: 1.0,
            minHeight: 8,
            backgroundColor: _blueSoft,
            valueColor: AlwaysStoppedAnimation(_dark),
          ),
        ),
      ],
    );
  }

  Widget _bagianKategori() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _JudulBagian(icon: Icons.category_outlined, teks: '1. Pilih Kategori Sampah', kanan: 'Bisa pilih 1 kategori utama'),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _kategoriList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            mainAxisExtent: 120,
          ),
          itemBuilder: (_, i) {
            final k = _kategoriList[i];
            final aktif = i == _kategori;
            return InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => setState(() => _kategori = i),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: _kartu(aktif ? _mint : Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(color: aktif ? Colors.white : _blueSoft, borderRadius: BorderRadius.circular(12)),
                          child: Icon(k.icon, size: 22, color: aktif ? _green : _blueIcon),
                        ),
                        if (aktif)
                          Container(
                            width: 22,
                            height: 22,
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: _dark),
                            child: const Icon(Icons.check, size: 14, color: Colors.white),
                          ),
                      ],
                    ),
                    const Spacer(),
                    Text(k.nama, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: aktif ? _dark : _ink)),
                    const SizedBox(height: 2),
                    Text('${_rp(k.harga)} / kg', style: TextStyle(fontSize: 12, color: aktif ? _dark : _muted)),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _bagianBerat() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _kartu(),
      child: Column(
        children: [
          const _JudulBagian(icon: Icons.hourglass_empty, teks: '2. Perkiraan Berat Sampah', kanan: 'Min. 2 kg', kananRedup: true),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
            decoration: BoxDecoration(color: _lavender, borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _BulatBtn(icon: Icons.remove, onTap: () => _ubahBerat(-1)),
                    const SizedBox(width: 20),
                    Text('$_berat', style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w800, color: _dark)),
                    const SizedBox(width: 4),
                    const Padding(
                      padding: EdgeInsets.only(top: 14),
                      child: Text('KG', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: _blueIcon)),
                    ),
                    const SizedBox(width: 20),
                    _BulatBtn(icon: Icons.add, terisi: true, onTap: () => _ubahBerat(1)),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (final d in const [1, 5, 10])
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => _ubahBerat(d),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                            child: Text('+$d kg', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _ink)),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bagianEstimasi() {
    final k = _kategoriList[_kategori];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: _mint, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.payments_outlined, size: 20, color: _green),
              ),
              const SizedBox(width: 10),
              const Expanded(child: Text('Estimasi Saldo Masuk', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _dark))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Text('${_rp(k.harga)} / kg', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _dark)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Total Perkiraan:', style: TextStyle(fontSize: 14, color: _dark)),
              const Spacer(),
              Text(_rp(_estimasi), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: _dark)),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, size: 16, color: _dark),
              SizedBox(width: 8),
              Expanded(child: Text('Harga final akan ditimbang ulang secara presisi oleh kurir REGREEN di lokasi Anda.', style: TextStyle(fontSize: 12, color: _dark))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bagianJadwal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _JudulBagian(icon: Icons.calendar_today_outlined, teks: '3. Jadwal Penjemputan'),
        const SizedBox(height: 12),
        SizedBox(
          height: 88,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _hari.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final d = _hari[i];
              final aktif = i == _tanggal;
              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => setState(() => _tanggal = i),
                child: Container(
                  width: 96,
                  decoration: _kartu(aktif ? _mint : Colors.white),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_namaHari[d.weekday - 1], style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: aktif ? _dark : _muted)),
                      Text('${d.day}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: _ink)),
                      Text(_namaBulan[d.month - 1], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: aktif ? _dark : _muted)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            for (var i = 0; i < _sesiList.length; i++) ...[
              if (i > 0) const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => setState(() => _sesi = i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    decoration: _kartu(i == _sesi ? _mint : Colors.white),
                    child: Column(
                      children: [
                        Icon(_sesiList[i].icon, color: i == _sesi ? _dark : _blueIcon),
                        const SizedBox(height: 6),
                        Text(_sesiList[i].label, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: i == _sesi ? _dark : _ink)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  // =====================================================================
  // BAGIAN LOKASI DENGAN PETA SEBARAN DAN RUTE
  // =====================================================================
  Widget _bagianLokasi() {
    // Data Bank Sampah & TPS di Ternate
    final List<Map<String, dynamic>> bankSampahList = [
      {'nama': 'Bank Sampah Andalan (DLH)', 'alamat': 'Marikurubu, Ternate Tengah', 'lat': 0.7950, 'lng': 127.3750, 'status': 1, 'icon': Icons.business},
      {'nama': 'Bank Sampah Makugasa', 'alamat': 'Lapangan Kayu Merah', 'lat': 0.7750, 'lng': 127.3850, 'status': 1, 'icon': Icons.recycling},
      {'nama': 'Bank Sampah Fitu', 'alamat': 'Kantor Lurah Fitu', 'lat': 0.7680, 'lng': 127.3800, 'status': 2, 'icon': Icons.account_balance},
      {'nama': 'Bank Sampah Kalumata', 'alamat': 'Kel. Kalumata', 'lat': 0.7893, 'lng': 127.3842, 'status': 1, 'icon': Icons.home_work}, 
      {'nama': 'Bank Sampah Taman Nukila', 'alamat': 'Taman Nukila', 'lat': 0.7820, 'lng': 127.3880, 'status': 1, 'icon': Icons.park},
      {'nama': 'TPS 3R Ake Tubo', 'alamat': 'Tubo, Ternate Utara', 'lat': 0.8100, 'lng': 127.3700, 'status': 2, 'icon': Icons.delete_sweep},
    ];

    // Fungsi untuk menentukan warna berdasarkan status dari HistoryStore
    Color getStatusColor(Map<String, dynamic> bank) {
      if (HistoryStore.isLocationInProcess(bank['nama'])) {
        return Colors.orange; // Sedang Diproses
      }
      if (bank['status'] == 1) return Colors.green;
      if (bank['status'] == 2) return Colors.red;
      return Colors.orange;
    }

    // Fungsi untuk menentukan teks status
    String getStatusText(Map<String, dynamic> bank) {
      if (HistoryStore.isLocationInProcess(bank['nama'])) {
        return 'Sedang Diproses';
      }
      if (bank['status'] == 1) return 'Sudah Diambil';
      if (bank['status'] == 2) return 'Belum Diambil';
      return 'Sedang Diproses';
    }

    // Fungsi untuk menampilkan Pop-up Peta Sebaran
    void showMapDialog() {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Peta Sebaran Bank Sampah'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FlutterMap(
                options: const MapOptions(
                  initialCenter: LatLng(0.7893, 127.3842), // Pusat Ternate
                  initialZoom: 13.0,
                ),
                children: [
                  // PETA GRATIS (OPENSTREETMAP)
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.regreen',
                  ),
                  
                  // Garis Rute Truk
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: const [
                          LatLng(0.7950, 127.3750), // DLH
                          LatLng(0.8100, 127.3700), // Ake Tubo
                          LatLng(0.7893, 127.3842), // Kalumata
                          LatLng(0.7820, 127.3880), // Nukila
                          LatLng(0.7680, 127.3800), // Fitu
                        ],
                        strokeWidth: 3.0,
                        color: Colors.blueAccent,
                      ),
                    ],
                  ),

                  // Marker Lokasi
                  MarkerLayer(
                    markers: bankSampahList.map((bank) {
                      final markerColor = getStatusColor(bank);
                      
                      return Marker(
                        point: LatLng(bank['lat'], bank['lng']),
                        width: 40,
                        height: 40,
                        child: GestureDetector(
                          onTap: () {
                            // Menampilkan pop-up detail lokasi
                            showDialog(
                              context: ctx,
                              builder: (innerCtx) => AlertDialog(
                                title: Text(bank['nama']),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.circle, size: 12, color: markerColor),
                                        const SizedBox(width: 8),
                                        Text(getStatusText(bank), 
                                          style: TextStyle(color: markerColor, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(bank['alamat']),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(innerCtx),
                                    child: const Text('Tutup'),
                                  ),
                                  // Tombol hanya muncul jika status BUKAN sedang diproses DAN belum diambil
                                  if (!HistoryStore.isLocationInProcess(bank['nama']) && bank['status'] == 2) 
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _selectedLocationName = bank['nama'];
                                          _selectedAddress = bank['alamat'];
                                        });
                                        Navigator.pop(innerCtx); // Tutup pop-up detail
                                        Navigator.pop(ctx); // Tutup peta
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Lokasi ${bank['nama']} dipilih untuk penjemputan.')),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(backgroundColor: _green),
                                      child: const Text('Pilih Lokasi Ini'),
                                    ),
                                ],
                              ),
                            );
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(Icons.location_on, color: markerColor, size: 45),
                              Positioned(
                                top: 6,
                                child: Icon(bank['icon'], color: Colors.white, size: 16),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Tutup')),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _JudulBagian(
          icon: Icons.location_on_outlined,
          teks: '4. Lokasi Penjemputan',
          kanan: 'Lihat Peta Sebaran', // <-- TOMBOL BARU
          onKananTap: showMapDialog, // Panggil fungsi pop-up peta
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: _kartu(),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(color: _blueSoft, borderRadius: BorderRadius.circular(14)),
                    child: const Icon(Icons.home_outlined, color: _blueIcon),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: _lavender, borderRadius: BorderRadius.circular(8)),
                          child: Text(_selectedLocationName, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _green)),
                        ),
                        const SizedBox(height: 4),
                        Text(_selectedAddress, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _ink)),
                        const Text('Kota Ternate, Maluku Utara', style: TextStyle(fontSize: 12, color: _muted)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // KOTAK PETA (Jika diklik, buka peta sebaran)
              GestureDetector(
                onTap: showMapDialog, // Panggil fungsi pop-up peta
                child: Container(
                  height: 110,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.grey[300], // Placeholder
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 6)]),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.location_on, size: 16, color: Colors.red),
                        SizedBox(width: 4),
                        Text('Pin Terpilih Akurat', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _ink)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bagianCatatan() {
    OutlineInputBorder garis(Color warna, [double lebar = 1]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: warna, width: lebar),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _JudulBagian(icon: Icons.edit_note, teks: '5. Catatan Tambahan Petugas'),
        const SizedBox(height: 12),
        TextField(
          controller: _catatan,
          minLines: 3,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'cth. Sampah kardus sudah diikat rapi di teras depan pagar hitam.',
            hintStyle: const TextStyle(color: _muted, fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(14),
            border: garis(_garis),
            enabledBorder: garis(_garis),
            focusedBorder: garis(_green, 1.5),
          ),
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: _green, borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.eco, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 10),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('REGREEN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1, color: _green)),
            Text('Jemput Sampah', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, height: 1.1, color: _ink)),
          ],
        ),
        const Spacer(),
        const Icon(Icons.notifications_none, color: _ink, size: 26),
        const SizedBox(width: 12),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFCFE8CF), border: Border.all(color: Colors.white, width: 2)),
          child: const Icon(Icons.person, size: 24, color: _green),
        ),
      ],
    );
  }
}

class _JudulBagian extends StatelessWidget {
  const _JudulBagian({required this.icon, required this.teks, this.kanan, this.kananRedup = false, this.onKananTap});

  final IconData icon;
  final String teks;
  final String? kanan;
  final bool kananRedup;
  final VoidCallback? onKananTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: _green),
        const SizedBox(width: 8),
        Expanded(child: Text(teks, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _ink))),
        if (kanan != null)
          InkWell(
            onTap: onKananTap,
            child: Text(kanan!, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: kananRedup ? _muted : _green)),
          ),
      ],
    );
  }
}

class _BulatBtn extends StatelessWidget {
  const _BulatBtn({required this.icon, required this.onTap, this.terisi = false});

  final IconData icon;
  final VoidCallback onTap;
  final bool terisi;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(shape: BoxShape.circle, color: terisi ? _dark : Colors.white),
        child: Icon(icon, color: terisi ? Colors.white : _ink, size: 26),
      ),
    );
  }
}