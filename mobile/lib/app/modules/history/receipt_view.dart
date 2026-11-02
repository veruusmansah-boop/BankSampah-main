import 'package:flutter/material.dart';

class ReceiptView extends StatelessWidget {
  final String id;
  final String tanggal;
  final String berat;
  final String harga;
  final String total;

  const ReceiptView({
    super.key,
    required this.id,
    required this.tanggal,
    required this.berat,
    required this.harga,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.eco, size: 50, color: Colors.green),
          const SizedBox(height: 8),
          const Text('REGREEN', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
          const Text('Bank Sampah Digital', style: TextStyle(fontSize: 12, color: Colors.grey)),
          const Divider(height: 32, thickness: 2),
          
          _buildRow('ID Transaksi', id),
          _buildRow('Tanggal', tanggal),
          _buildRow('Berat Sampah', berat),
          _buildRow('Harga / kg', harga),
          const Divider(height: 32, thickness: 1, color: Colors.grey),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('TOTAL DITERIMA', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(total, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
            ],
          ),
          const SizedBox(height: 32),
          const Text('Terima kasih telah menyelamatkan bumi!', style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}