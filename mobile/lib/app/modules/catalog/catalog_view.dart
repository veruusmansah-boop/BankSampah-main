import 'package:flutter/material.dart';

class CatalogView extends StatefulWidget {
  const CatalogView({super.key});

  @override
  State<CatalogView> createState() => _CatalogViewState();
}

class _CatalogViewState extends State<CatalogView> {
  // 1. Tambahkan Controller untuk Search dan State untuk Filter
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _selectedCategory = "Semua";

  // Daftar item dipindahkan ke sini agar bisa diakses oleh fungsi filter
  final List<Map<String, dynamic>> catalogItems = [
    {
      'icon': Icons.delete_outline,
      'title': 'Kertas & Karton',
      'subtitle': 'Kardus, HVS, Koran, Majalah',
      'image': 'design/kertas.jpg',
      'imageLabel': 'Kondisi Kering & Rapi',
      'chips': [
        'Kardus Cokelat Tebal',
        'Kertas HVS Putih',
        'Koran & Majalah',
      ],
      'description':
          'Kardus bersih, kering, tidak terkena minyak atau air. Dilak rapi untuk mempermudah penimbangan...',
      'price': 'Rp 2.500 - Rp 3.800',
      'unit': '/kg',
      'tag': 'Kertas',
      'tagColor': Colors.green,
    },
    {
      'icon': Icons.local_drink,
      'title': 'Plastik Daur Ulang',
      'subtitle': 'PET, PP Cup, HDPE Jernigen',
      'image': 'design/plastik.jpg',
      'imageLabel': 'Harga Tertinggi',
      'chips': [
        'Botol Bersih (PET)',
        'Gelas Cup (PP)',
        'Jerigen & Tutup (HDPE)',
      ],
      'description':
          'Plastik bening dan berwarna dalam kondisi bersih, kosong tanpa sisa cairan, tutup telah dipisahkan...',
      'price': 'Rp 4.000 - Rp 7.500',
      'unit': '/kg',
      'tag': 'Plastik',
      'tagColor': Colors.green,
    },
    {
      'icon': Icons.science_outlined,
      'title': 'Logam & Gelas',
      'subtitle': 'Aluminium, Besi Scrap, Botol Kaca',
      'image': 'design/logam.jpg',
      'imageLabel': 'Nilai Tertinggi: Aluminium',
      'chips': ['Kaleng Aluminium', 'Besi Scrap', 'Botol Kaca Utuh'],
      'description':
          'Logam utuh tanpa campuran tanah atau karat berat. Botol kaca harus utuh tidak pecah agar...',
      'price': 'Rp 5.000 - Rp 14.000',
      'unit': '/kg',
      'tag': 'Logam',
      'tagColor': Colors.green,
    },
    {
      'icon': Icons.eco_outlined,
      'title': 'Organik & Minyak Jelantah',
      'subtitle': 'UCO (Used Cooking Oil), Kompos Daun',
      'image': 'design/jelantah.jpg',
      'imageLabel': 'Tersaring Bersih',
      'chips': ['Minyak Jelantah (UCO)', 'Kompos Daun & Sayur'],
      'description':
          'Minyak goreng bekas dalam jerigen/botol tertutup rapat dan telah disaring tanpa endapan...',
      'price': 'Rp 6.500',
      'unit': '/Liter',
      'tag': 'Organik & Lainnya',
      'tagColor': Colors.green,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // 2. Fungsi Logika untuk Memfilter Item
  List<Map<String, dynamic>> get _filteredItems {
    return catalogItems.where((item) {
      // Cek apakah cocok dengan kategori yang dipilih
      bool matchesCategory = _selectedCategory == "Semua" ||
          (item['tag'] as String).toLowerCase().contains(
                _selectedCategory.toLowerCase(),
              ) ||
          (item['title'] as String)
              .toLowerCase()
              .contains(_selectedCategory.toLowerCase());

      // Cek apakah cocok dengan teks pencarian (di title, subtitle, atau chips)
      bool matchesSearch = _searchQuery.isEmpty ||
          (item['title'] as String)
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          (item['subtitle'] as String)
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          (item['chips'] as List<String>).any((chip) =>
              chip.toLowerCase().contains(_searchQuery.toLowerCase()));

      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredItems;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Color(0xFF2E7D32),
            child: Icon(Icons.eco, color: Colors.white, size: 20),
          ),
        ),
        title: const Text(
          'Katalog Sampah',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Colors.black87,
            ),
            onPressed: () {},
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Color(0xFFE0E0E0),
              child: Icon(Icons.person, color: Colors.green, size: 18),
              radius: 16,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.eco, color: Colors.green[800], size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'PANDUAN NILAI EKONOMI',
                        style: TextStyle(
                          color: Colors.green[800],
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Katalog Jenis Sampah',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Kenali jenis sampah yang kami terima beserta estimasi harga beli terbaik hari ini.',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),

                  // 3. Search Bar dengan Controller & onChanged
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText:
                                  'Cari jenis sampah, cth: botol PET, kardus...',
                              hintStyle: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        if (_searchQuery.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = "";
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 4. Filter Chips dengan onTap
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip(
                          'Semua',
                          isSelected: _selectedCategory == 'Semua',
                          icon: Icons.grid_view,
                          onTap: () =>
                              setState(() => _selectedCategory = 'Semua'),
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          'Kertas',
                          isSelected: _selectedCategory == 'Kertas',
                          icon: Icons.description_outlined,
                          onTap: () =>
                              setState(() => _selectedCategory = 'Kertas'),
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          'Plastik',
                          isSelected: _selectedCategory == 'Plastik',
                          icon: Icons.local_drink,
                          onTap: () =>
                              setState(() => _selectedCategory = 'Plastik'),
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          'Logam',
                          isSelected: _selectedCategory == 'Logam',
                          icon: Icons.science_outlined,
                          onTap: () =>
                              setState(() => _selectedCategory = 'Logam'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Info Text Dinamis
                  Row(
                    children: [
                      Text(
                        'MENAMPILKAN ${filteredList.length} KATEGORI TERPILIH',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.green[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.circle, size: 4, color: Colors.green[800]),
                      const SizedBox(width: 8),
                      Text(
                        'Harga Diperbarui Hari Ini',
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Catalog Cards
            Padding(
              padding: const EdgeInsets.all(16),
              child: filteredList.isEmpty
                  // 5. Tampilan Jika Data Kosong (Tidak Ditemukan)
                  ? Container(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'Sampah tidak ditemukan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Coba kata kunci lain atau ubah filter.',
                            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    )
                  // Tampilkan List Card
                  : Column(
                      children: filteredList
                          .map((item) => _buildCatalogCard(item))
                          .toList(),
                    ),
            ),

            // Tips Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on, color: Colors.green[800], size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tips Maksimalkan Cuan',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Pilah sampah dari rumah dan pastikan dalam kondisi kering untuk mendapatkan nilai tukar timbangan tertinggi dari mitra kurir kami!',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // 6. Widget Filter Chip Ditambahkan Parameter onTap & isSelected
  Widget _buildFilterChip(
    String label, {
    bool isSelected = false,
    IconData? icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2E7D32) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF2E7D32) : Colors.grey[300]!,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 14,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
            if (icon != null) const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCatalogCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(item['icon'], color: Colors.green[800], size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        item['subtitle'],
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: (item['tagColor'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item['tag'],
                    style: TextStyle(
                      fontSize: 10,
                      color: item['tagColor'],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Image
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(12),
            ),
            child: Stack(
              children: [
                Image.asset(
                  item['image'],
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 180,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item['imageLabel'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Chips
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: (item['chips'] as List<String>).map((chip) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Text(
                    chip,
                    style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                  ),
                );
              }).toList(),
            ),
          ),

          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              item['description'],
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ),

          // Price & Button
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ESTIMASI NILAI BELI',
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: item['price'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                          TextSpan(
                            text: ' ${item['unit']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2E7D32),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}