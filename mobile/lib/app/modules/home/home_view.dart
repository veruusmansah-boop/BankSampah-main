import 'package:flutter/material.dart';
import '../auth/auth_store.dart'; 
import '../home/withdraw_view.dart'; // <-- IMPORT WITHDRAW VIEW

const _bg = Color(0xFFF7F8FF);
const _dark = Color(0xFF1B5E20);
const _green = Color(0xFF2E7D32);
const _mint = Color(0xFF8CEB8C);
const _mintSoft = Color(0xFFCFF5CF);
const _blueSoft = Color(0xFFDCE4FA);
const _blueIcon = Color(0xFF3B4A6B);
const _lavender = Color(0xFFE6EBFA);
const _ink = Color(0xFF1A1C24);
const _muted = Color(0xFF5F6670);
const _glass = Color(0x33FFFFFF);

String _ribuan(int v) {
  final s = v.abs().toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
    b.write(s[i]);
  }
  return b.toString();
}

BoxDecoration _kartu() => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(color: Color(0x0F1A1C24), blurRadius: 12, offset: Offset(0, 4)),
      ],
    );

class HomeView extends StatelessWidget {
  const HomeView({super.key, this.onTabSelected});

  final ValueChanged<int>? onTabSelected;

  static const _namaTab = ['Beranda', 'Jemput', 'Katalog', 'Riwayat', 'Drop Point', 'Profil'];

  void _pindah(BuildContext context, int tab) {
    if (tab == 0) return;
    if (onTabSelected != null) {
      onTabSelected!(tab);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_namaTab[tab]}: navigasi belum tersambung')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            // Kirim fungsi onTabSelected ke Header
            _Header(onTabSelected: onTabSelected),
            const SizedBox(height: 14),
            // Kirim fungsi onTabSelected ke Sapaan
            _Sapaan(onTabSelected: onTabSelected),
            const SizedBox(height: 14),
            _SaldoCard(
              onTarik: () {
                // ARAHKAN KE HALAMAN WITHDRAW VIEW
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WithdrawView()),
                );
              },
              onSetor: () => _pindah(context, 1),
            ),
            const SizedBox(height: 24),
            const Row(
              children: [
                Text('Layanan Cepat',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600, color: _ink)),
                Spacer(),
                Text('Ternate Aktif',
                    style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700, color: _green)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _Layanan(Icons.local_shipping_outlined, 'Jemput\nSampah',
                    _mintSoft, _green, () => _pindah(context, 1)),
                const SizedBox(width: 10),
                _Layanan(Icons.recycling, 'Jenis\nSampah', _blueSoft, _blueIcon,
                    () => _pindah(context, 2)),
                const SizedBox(width: 10),
                _Layanan(Icons.access_time, 'Riwayat\nCatatan', _blueSoft,
                    _blueIcon, () => _pindah(context, 3)),
                const SizedBox(width: 10),
                _Layanan(Icons.location_on_outlined, 'Drop Point', _mintSoft,
                    _green, () => _pindah(context, 4)),
              ],
            ),
            const SizedBox(height: 24),
            const _Edukasi(),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.history, color: _green, size: 22),
                const SizedBox(width: 8),
                const Text('Aktivitas Terakhir',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600, color: _ink)),
                const Spacer(),
                InkWell(
                  onTap: () => _pindah(context, 3),
                  child: const Text('Lihat Semua',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: _green)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const _Aktivitas(
              icon: Icons.local_shipping_outlined,
              iconBg: _mintSoft,
              iconColor: _green,
              judul: 'Plastik Botol & Kaleng',
              status: 'Selesai',
              statusBg: _mint,
              statusFg: _dark,
              info: '12.5kg  •  Kemarin, 14:20 WIT',
              nominal: '+Rp37.500',
              nominalColor: _green,
              catatan: '+150 Poin',
            ),
            const _Aktivitas(
              icon: Icons.payments_outlined,
              iconBg: _blueSoft,
              iconColor: _blueIcon,
              judul: 'Penarikan Saldo',
              status: 'Berhasil',
              statusBg: _blueSoft,
              statusFg: _blueIcon,
              info: '24 Mei 2024  •  Transfer Kilat',
              nominal: '-Rp150.000',
              nominalColor: _ink,
              catatan: 'Biaya Rp 0',
            ),
            const _Aktivitas(
              icon: Icons.water_drop_outlined,
              iconBg: _mintSoft,
              iconColor: _green,
              judul: 'Minyak Jelantah',
              status: 'Selesai',
              statusBg: _mint,
              statusFg: _dark,
              info: '8.0kg  •  19 Mei 2024',
              nominal: '+Rp28.000',
              nominalColor: _green,
              catatan: '+95 Poin',
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _lavender,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: _mint,
                    child: Icon(Icons.park_outlined, color: _dark),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Terima kasih, Warga Hijau!',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: _ink)),
                        SizedBox(height: 2),
                        Text(
                          'Aktivitas daur ulang Anda telah mencegah emisi '
                          'setara 42.8 kg CO₂ minggu ini.',
                          style: TextStyle(fontSize: 13, color: _muted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- Header
class _Header extends StatelessWidget {
  const _Header({this.onTabSelected});

  final ValueChanged<int>? onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _green,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.eco, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 10),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('REGREEN',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    color: _green)),
            Text('Beranda',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                    color: _ink)),
          ],
        ),
        const Spacer(),
        const Icon(Icons.notifications_none, color: _ink, size: 26),
        const SizedBox(width: 12),
        
        // FOTO PROFIL YANG BISA DIKLIK (INDEKS 5 = PROFIL)
        GestureDetector(
          onTap: () {
            if (onTabSelected != null) {
              onTabSelected!(5); // Pindah ke tab Profil (indeks 5)
            }
          },
          child: const _Foto(ukuran: 40),
        ),
      ],
    );
  }
}

class _Foto extends StatelessWidget {
  const _Foto({required this.ukuran, this.cincin = false});
  final double ukuran;
  final bool cincin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ukuran,
      height: ukuran,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFCFE8CF),
        border: Border.all(color: cincin ? _mint : Colors.white, width: cincin ? 3 : 2),
      ),
      child: Icon(Icons.person, size: ukuran * 0.6, color: _green),
    );
  }
}

class _Sapaan extends StatelessWidget {
  const _Sapaan({this.onTabSelected});

  final ValueChanged<int>? onTabSelected;

  @override
  Widget build(BuildContext context) {
    // 1. Ambil nama dan role dari sesi login
    final namaUser = AuthStore.currentUser?['nama'] ?? 'Pengguna';
    final roleUser = AuthStore.currentUser?['role'] ?? 'Nasabah';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 16, color: _ink),
                  SizedBox(width: 4),
                  Flexible(
                    child: Text('KOTA TERNATE, MALUKU UTARA',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.4,
                            color: _ink)),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // 2. Tampilkan nama user secara dinamis
              Text('Halo, $namaUser! 👋',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w600, color: _ink)),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // FOTO BESAR YANG BISA DIKLIK (INDEKS 5 = PROFIL)
            GestureDetector(
              onTap: () {
                if (onTabSelected != null) {
                  onTabSelected!(5); // Pindah ke tab Profil (indeks 5)
                }
              },
              child: const _Foto(ukuran: 60, cincin: true),
            ),
            Transform.translate(
              offset: const Offset(0, -10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _mint,
                  borderRadius: BorderRadius.circular(20),
                ),
                // 3. Tampilkan label role
                child: Text(roleUser == 'Nasabah' ? 'Eco Hero 🌱' : roleUser,
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w700, color: _dark)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ------------------------------------------------------------ Kartu saldo
class _SaldoCard extends StatelessWidget {
  const _SaldoCard({required this.onTarik, required this.onSetor});
  final VoidCallback onTarik;
  final VoidCallback onSetor;

  static const int _saldo = 348500;
  static const int _poin = 1420;

  @override
  Widget build(BuildContext context) {
    final tombol = ElevatedButton.styleFrom(
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: const StadiumBorder(),
      textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4A9A55), Color(0xFF2B6F36)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -40,
              bottom: -50,
              child: Container(
                width: 180,
                height: 180,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0x14FFFFFF),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.account_balance_wallet_outlined,
                                size: 20, color: Colors.white70),
                            SizedBox(width: 8),
                            Flexible(
                              child: Text('TOTAL SALDO SAMPAH',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.8,
                                      color: Colors.white70)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: _glass,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.eco_outlined,
                                size: 14, color: Colors.white),
                            const SizedBox(width: 4),
                            Text('${_ribuan(_poin)} Poin Hijau',
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text('Rp ${_ribuan(_saldo)}',
                        style: const TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.w800,
                            color: Colors.white)),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: _glass,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.recycling, size: 20, color: Colors.white),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text('Total Sampah Terkumpul',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.white70)),
                        ),
                        Text('124.5kg',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onTarik,
                          icon: const Icon(Icons.arrow_upward, size: 18),
                          label: const Text('Tarik Saldo'),
                          style: tombol.copyWith(
                            backgroundColor:
                                const WidgetStatePropertyAll(Colors.white),
                            foregroundColor:
                                const WidgetStatePropertyAll(_dark),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onSetor,
                          icon: const Icon(Icons.add_circle_outline, size: 18),
                          label: const Text('Setor Sampah'),
                          style: tombol.copyWith(
                            backgroundColor:
                                const WidgetStatePropertyAll(_glass),
                            foregroundColor:
                                const WidgetStatePropertyAll(Colors.white),
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
      ),
    );
  }
}

// ---------------------------------------------------------- Layanan cepat
class _Layanan extends StatelessWidget {
  const _Layanan(this.icon, this.label, this.tile, this.warnaIcon, this.onTap);
  final IconData icon;
  final String label;
  final Color tile;
  final Color warnaIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            child: Column(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: tile,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: warnaIcon, size: 26),
                ),
                const SizedBox(height: 8),
                Text(label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        height: 1.25,
                        color: _ink)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------- Edukasi
class _Edukasi extends StatelessWidget {
  const _Edukasi();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _kartu(),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _mintSoft,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.lightbulb_outline, size: 14, color: _dark),
                          SizedBox(width: 4),
                          Text('EDUKASI HARI INI',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: _dark)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Cara Tepat Memilah Sampah Plastik PET Agar Bernilai Tinggi',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                          color: _ink),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Pisahkan tutup botol dan lepaskan segel label sebelum '
                      'dipadatkan untuk menjaga kualitas daur ulang.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13, color: _muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFC9B79C),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.local_drink_outlined,
                    color: Colors.white, size: 40),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Icon(Icons.timer_outlined, size: 16, color: _ink),
              SizedBox(width: 6),
              Text('3 menit membaca',
                  style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600, color: _ink)),
              Spacer(),
              Text('Baca Selengkapnya',
                  style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700, color: _green)),
              SizedBox(width: 4),
              Icon(Icons.arrow_forward, size: 16, color: _green),
            ],
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------ Aktivitas terakhir
class _Aktivitas extends StatelessWidget {
  const _Aktivitas({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.judul,
    required this.status,
    required this.statusBg,
    required this.statusFg,
    required this.info,
    required this.nominal,
    required this.nominalColor,
    required this.catatan,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String judul;
  final String status;
  final Color statusBg;
  final Color statusFg;
  final String info;
  final String nominal;
  final Color nominalColor;
  final String catatan;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: _kartu(),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(judul,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: _ink)),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(status,
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: statusFg)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(info,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: _muted)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(nominal,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: nominalColor)),
              const SizedBox(height: 2),
              Text(catatan,
                  style: const TextStyle(fontSize: 11, color: _muted)),
            ],
          ),
        ],
      ),
    );
  }
}