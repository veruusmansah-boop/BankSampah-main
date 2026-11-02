import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

const Color kGreenColor = Color(0xFF2E7D32);

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  // Koordinat Pusat Kota Ternate
  final LatLng _centerTernate = const LatLng(0.7893, 127.3842);

  // Daftar Lokasi Bank Sampah & TPS (Berdasarkan Data Anda)
  final List<Map<String, dynamic>> _lokasiList = [
    {
      'nama': 'Bank Sampah Andalan (DLH)',
      'alamat': 'Kantor DLH, Marikurubu, Ternate Tengah',
      'lat': 0.7950,
      'lng': 127.3750,
      'icon': Icons.business,
      'color': Colors.blue,
      'tipe': 'Pusat Bank Sampah',
    },
    {
      'nama': 'Bank Sampah Makugasa',
      'alamat': 'Lapangan Kayu Merah, Ternate Selatan',
      'lat': 0.7750,
      'lng': 127.3850,
      'icon': Icons.recycling,
      'color': Colors.green,
      'tipe': 'Bank Sampah',
    },
    {
      'nama': 'Bank Sampah Kantor Lurah Fitu',
      'alamat': 'Kantor Lurah Fitu, Ternate Selatan',
      'lat': 0.7680,
      'lng': 127.3800,
      'icon': Icons.account_balance,
      'color': Colors.green,
      'tipe': 'Bank Sampah',
    },
    {
      'nama': 'Bank Sampah Kalumata',
      'alamat': 'Kelurahan Kalumata, Ternate Selatan',
      'lat': 0.7893,
      'lng': 127.3842,
      'icon': Icons.home_work,
      'color': Colors.green,
      'tipe': 'Bank Sampah',
    },
    {
      'nama': 'Bank Sampah Taman Nukila',
      'alamat': 'Taman Nukila, Ternate',
      'lat': 0.7820,
      'lng': 127.3880,
      'icon': Icons.park,
      'color': Colors.orange,
      'tipe': 'Mobil/Lapak Minggu',
    },
    {
      'nama': 'TPS 3R Ake Tubo',
      'alamat': 'Jl. Ake Tubo, Tubo, Ternate Utara',
      'lat': 0.8100,
      'lng': 127.3700,
      'icon': Icons.delete_sweep,
      'color': Colors.red,
      'tipe': 'Fasilitas Daur Ulang',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peta Sebaran Sampah Ternate'),
        backgroundColor: kGreenColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // PETA INTERAKTIF
          Expanded(
            flex: 3,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: _centerTernate,
                initialZoom: 14.0,
              ),
              children: [
                TileLayer(
                  // Menggunakan tile CartoDB Voyager agar lebih mirip Google Maps
                  urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
                  subdomains: const ['a', 'b', 'c', 'd'],
                  userAgentPackageName: 'com.example.regreen',
                ),
                
                // MARKER LOKASI
                MarkerLayer(
                  markers: _lokasiList.map((lokasi) {
                    return Marker(
                      point: LatLng(lokasi['lat'], lokasi['lng']),
                      width: 40,
                      height: 40,
                      child: GestureDetector(
                        onTap: () {
                          _showLocationInfo(lokasi);
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: lokasi['color'],
                              size: 45,
                            ),
                            Positioned(
                              top: 6,
                              child: Icon(
                                lokasi['icon'],
                                color: Colors.white,
                                size: 16,
                              ),
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

          // DAFTAR LOKASI DI BAWAH PETA
          Expanded(
            flex: 2,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _lokasiList.length,
              itemBuilder: (context, index) {
                final lokasi = _lokasiList[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: lokasi['color'].withOpacity(0.2),
                      child: Icon(lokasi['icon'], color: lokasi['color']),
                    ),
                    title: Text(lokasi['nama'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${lokasi['tipe']} • ${lokasi['alamat']}', maxLines: 2, overflow: TextOverflow.ellipsis),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: () {
                      _showLocationInfo(lokasi);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk menampilkan pop-up info lokasi
  void _showLocationInfo(Map<String, dynamic> lokasi) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(lokasi['icon'], color: lokasi['color']),
            const SizedBox(width: 8),
            Expanded(child: Text(lokasi['nama'], style: const TextStyle(fontSize: 16))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: lokasi['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                lokasi['tipe'],
                style: TextStyle(color: lokasi['color'], fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            const SizedBox(height: 12),
            Text(lokasi['alamat'], style: const TextStyle(fontSize: 14)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}