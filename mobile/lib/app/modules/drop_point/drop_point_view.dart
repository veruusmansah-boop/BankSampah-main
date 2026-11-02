import 'package:flutter/material.dart';

class DropPointView extends StatefulWidget {
  const DropPointView({super.key});

  @override
  State<DropPointView> createState() => _DropPointViewState();
}

class _DropPointViewState extends State<DropPointView> {
  final Color green = const Color(0xFF08752D);
  final Color lightGreen = const Color(0xFFE1F6E5);
  final Color background = const Color(0xFFF3F6FF);

  String searchQuery = '';
  int selectedFilter = 0;

  final List<Map<String, dynamic>> locations = [
    {
      'name': 'Bank Sampah Jati Metro',
      'address': 'Jl. Jati Lurus No. 88, Ternate Selatan',
      'distance': '1.2 km',
      'hours': 'Tutup pukul 17:00 WIT',
      'types': ['Plastik', 'Kertas', 'Logam', 'Minyak Jelantah'],
      'open': true,
    },
    {
      'name': 'REGREEN Eco Hub Kalumata',
      'address': 'Kalumata, Ternate Selatan',
      'distance': '2.4 km',
      'hours': 'Buka pukul 08:00 WIT',
      'types': ['Plastik', 'Kertas', 'Kardus'],
      'open': true,
    },
    {
      'name': 'Bank Sampah Gamalama',
      'address': 'Area pusat Kota Ternate',
      'distance': '3.1 km',
      'hours': 'Buka pukul 09:00 WIT',
      'types': ['Plastik', 'Logam', 'Kertas'],
      'open': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredLocations = locations.where((location) {
      final name = location['name'].toString().toLowerCase();
      return name.contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: background,
      // Tidak ada bottomNavigationBar di sini.
      // Navigasi utama tetap diatur oleh halaman induk.
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSearch(),
                    const SizedBox(height: 12),
                    _buildFilters(),
                    const SizedBox(height: 14),
                    _buildMap(),
                    const SizedBox(height: 12),
                    _buildActionButtons(),
                    const SizedBox(height: 18),
                    _buildSectionTitle(),
                    const SizedBox(height: 10),
                    if (filteredLocations.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(child: Text('Lokasi tidak ditemukan')),
                      )
                    else
                      ...filteredLocations.map(
                        (location) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _buildLocationCard(location),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // HEADER
  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: lightGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.recycling, color: green, size: 27),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'REGREEN',
                  style: TextStyle(
                    color: green,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
                const Text(
                  'Drop Point',
                  style: TextStyle(
                    color: Color(0xFF293448),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _showMessage('Belum ada notifikasi'),
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          CircleAvatar(
            radius: 18,
            backgroundColor: lightGreen,
            child: Icon(Icons.person, color: green),
          ),
        ],
      ),
    );
  }

  // SEARCH
  Widget _buildSearch() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        onChanged: (value) {
          setState(() => searchQuery = value);
        },
        decoration: InputDecoration(
          hintText: 'Cari bank sampah atau drop box terdekat',
          hintStyle: const TextStyle(fontSize: 12),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: IconButton(
            onPressed: () => _showMessage('Filter pencarian'),
            icon: Icon(Icons.tune, color: green),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  // FILTER
  Widget _buildFilters() {
    const filters = ['< 5 km', 'Buka Sekarang', 'Terima Jelantah'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(filters.length, (index) {
          final selected = selectedFilter == index;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                setState(() => selectedFilter = index);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: selected ? lightGreen : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: selected
                        ? const Color(0xFFB6E8C1)
                        : const Color(0xFFE6EAF1),
                  ),
                ),
                child: Text(
                  filters[index],
                  style: TextStyle(
                    color: selected ? green : Colors.blueGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // PETA ILUSTRASI
  Widget _buildMap() {
    return Container(
      height: 218,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFE6EDFF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: MapBackgroundPainter())),
          const Positioned(
            left: 42,
            top: 28,
            child: _MapMarker(
              icon: Icons.storefront,
              color: Colors.white,
              iconColor: Color(0xFF3B9860),
            ),
          ),
          const Positioned(
            left: 108,
            top: 70,
            child: _MapMarker(
              icon: Icons.location_on,
              color: Colors.white,
              iconColor: Color(0xFF08752D),
            ),
          ),
          const Positioned(
            left: 124,
            top: 120,
            child: _MapMarker(
              icon: Icons.location_on,
              color: Color(0xFF08752D),
              iconColor: Colors.white,
            ),
          ),
          const Positioned(
            left: 66,
            top: 98,
            child: _MapMarker(
              icon: Icons.location_on,
              color: Colors.white,
              iconColor: Color(0xFF08752D),
            ),
          ),
          Positioned(
            left: 65,
            top: 107,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: green,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Lokasi Saya • Jati Metro • 1.2 km',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            right: 10,
            top: 12,
            child: Column(
              children: [
                _mapControl(Icons.add, () {
                  _showMessage('Perbesar peta');
                }),
                const SizedBox(height: 5),
                _mapControl(Icons.remove, () {
                  _showMessage('Perkecil peta');
                }),
                const SizedBox(height: 10),
                _mapControl(Icons.my_location, () {
                  _showMessage('Lokasi GPS belum diaktifkan');
                }),
              ],
            ),
          ),
          Positioned(
            left: 10,
            bottom: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '3 Bank Sampah di sekitarmu',
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapControl(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 34,
          height: 34,
          child: Icon(icon, size: 19, color: green),
        ),
      ),
    );
  }

  // TOMBOL AKSI
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _actionButton(
            icon: Icons.navigation,
            label: 'Navigasi Langsung',
            color: Colors.white,
            textColor: green,
            onTap: () => _showMessage('Pilih lokasi untuk navigasi'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _actionButton(
            icon: Icons.local_shipping_outlined,
            label: 'Jemput Sampah',
            color: green,
            textColor: Colors.white,
            onTap: () => _showMessage('Fitur jemput sampah dipilih'),
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 13),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 17, color: textColor),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // JUDUL LOKASI
  Widget _buildSectionTitle() {
    return Row(
      children: [
        Icon(Icons.location_on_outlined, color: green, size: 21),
        const SizedBox(width: 5),
        const Expanded(
          child: Text(
            'Lokasi Terdekat',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF263247),
            ),
          ),
        ),
        Text(
          'Urutkan: Terdekat',
          style: TextStyle(
            color: green,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // KARTU LOKASI
  Widget _buildLocationCard(Map<String, dynamic> location) {
    final types = List<String>.from(location['types'] as List);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.recycling, color: green, size: 24),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location['name'].toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      location['address'].toString(),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${location['open'] == true ? 'Buka' : 'Tutup'} • ${location['hours']}',
                      style: TextStyle(
                        fontSize: 10,
                        color: location['open'] == true ? green : Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  location['distance'].toString(),
                  style: TextStyle(
                    color: green,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: types.map((type) {
              final isOil = type == 'Minyak Jelantah';

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: isOil
                      ? const Color(0xFFD9F8DF)
                      : const Color(0xFFEAF0FC),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  type,
                  style: TextStyle(
                    fontSize: 9,
                    color: isOil ? green : const Color(0xFF43536B),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _cardButton(
                  label: 'Rute Petunjuk',
                  icon: Icons.alt_route,
                  color: const Color(0xFFE1EAFF),
                  textColor: const Color(0xFF1645A0),
                  onTap: () =>
                      _showMessage('Rute ke ${location['name']} dipilih'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _cardButton(
                  label: 'Setor Mandiri',
                  icon: Icons.recycling,
                  color: green,
                  textColor: Colors.white,
                  onTap: () => _showMessage(
                    'Setor mandiri ke ${location['name']} dipilih',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cardButton({
    required String label,
    required IconData icon,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 11),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: textColor),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }
}

// ILUSTRASI PETA
class _MapMarker extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color iconColor;

  const _MapMarker({
    required this.icon,
    required this.color,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Icon(icon, color: iconColor, size: 15),
    );
  }
}

class MapBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = const Color(0xFFE6EDFF);

    final parkPaint = Paint()..color = const Color(0xFFB8DCB5);

    final roadBorderPaint = Paint()
      ..color = const Color(0xFFC8D4C7)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final roadPaint = Paint()
      ..color = const Color(0xFFF9F9F3)
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );

    final park = Path()
      ..moveTo(0, size.height * 0.1)
      ..lineTo(size.width * 0.3, size.height * 0.2)
      ..lineTo(size.width * 0.2, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(park, parkPaint);

    final road1 = Path()
      ..moveTo(0, size.height * 0.48)
      ..lineTo(size.width, size.height * 0.68);

    final road2 = Path()
      ..moveTo(size.width * 0.48, 0)
      ..lineTo(size.width * 0.32, size.height);

    canvas.drawPath(road1, roadBorderPaint);
    canvas.drawPath(road1, roadPaint);
    canvas.drawPath(road2, roadBorderPaint);
    canvas.drawPath(road2, roadPaint);
  }

  @override
  bool shouldRepaint(covariant MapBackgroundPainter oldDelegate) {
    return false;
  }
}
