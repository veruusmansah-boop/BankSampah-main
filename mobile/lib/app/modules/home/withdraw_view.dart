import 'package:flutter/material.dart';

const _green = Color(0xFF2E7D32);
const _dark = Color(0xFF1B5E20);
const _bg = Color(0xFFF7F8FF);
const _ink = Color(0xFF1A1C24);
const _muted = Color(0xFF5F6670);

class WithdrawView extends StatefulWidget {
  const WithdrawView({super.key});

  @override
  State<WithdrawView> createState() => _WithdrawViewState();
}

class _WithdrawViewState extends State<WithdrawView> {
  final TextEditingController _amountController = TextEditingController();
  String _selectedMethod = 'Bank BCA';
  int _selectedQuickAmount = 0;

  final List<Map<String, dynamic>> _methods = [
    {'name': 'Bank BCA', 'icon': Icons.account_balance, 'color': Colors.blue},
    {'name': 'Bank Mandiri', 'icon': Icons.account_balance, 'color': Colors.orange},
    {'name': 'DANA', 'icon': Icons.wallet, 'color': Colors.blueAccent},
    {'name': 'OVO', 'icon': Icons.wallet, 'color': Colors.purple},
    {'name': 'GoPay', 'icon': Icons.wallet, 'color': Colors.green},
  ];

  final List<int> _quickAmounts = [50000, 100000, 200000, 350000];

  String _formatRp(int val) {
    final s = val.toString();
    final b = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
      b.write(s[i]);
    }
    return 'Rp $b';
  }

  void _processWithdraw() {
    final amount = int.tryParse(_amountController.text) ?? 0;
    
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan nominal yang valid!'), backgroundColor: Colors.red),
      );
      return;
    }

    if (amount > 348500) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saldo tidak mencukupi!'), backgroundColor: Colors.red),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Konfirmasi Tarik Saldo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.account_balance_wallet, size: 60, color: _green),
            const SizedBox(height: 16),
            Text(
              _formatRp(amount),
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: _ink),
            ),
            const SizedBox(height: 8),
            Text(
              'Akan ditransfer ke $_selectedMethod',
              style: const TextStyle(color: _muted),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Penarikan saldo berhasil diproses!'),
                  backgroundColor: _green,
                ),
              );
              Navigator.pop(context); 
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
        title: const Text('Tarik Saldo', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: _green,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [_green, _dark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: _green.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
                ],
              ),
              child: Column(
                children: [
                  const Text('Saldo Saat Ini', style: TextStyle(fontSize: 14, color: Colors.white70)),
                  const SizedBox(height: 8),
                  const Text('Rp 348.500', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline, size: 14, color: Colors.white),
                            SizedBox(width: 4),
                            Text('Minimal tarik: Rp 10.000', style: TextStyle(fontSize: 11, color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            const Text('Masukkan Nominal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: _ink)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [BoxShadow(color: Color(0x0F1A1C24), blurRadius: 10)],
              ),
              child: Row(
                children: [
                  const Text('Rp', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _muted)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: _ink),
                      decoration: const InputDecoration(
                        hintText: '0',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 28),
                        border: InputBorder.none,
                      ),
                      onChanged: (val) {
                        setState(() => _selectedQuickAmount = 0);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _quickAmounts.map((amount) {
                final isSelected = _selectedQuickAmount == amount;
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedQuickAmount = amount;
                      _amountController.text = amount.toString();
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? _green : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isSelected ? _green : Colors.grey.shade300),
                    ),
                    child: Text(
                      _formatRp(amount),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : _ink,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            const Text('Metode Penarikan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: _ink)),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _methods.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final method = _methods[index];
                final isSelected = _selectedMethod == method['name'];
                return InkWell(
                  onTap: () => setState(() => _selectedMethod = method['name']),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? _green : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: isSelected ? [BoxShadow(color: _green.withOpacity(0.1), blurRadius: 10)] : [],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: (method['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(method['icon'], color: method['color']),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            method['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle, color: _green)
                        else
                          const Icon(Icons.circle_outlined, color: Colors.grey),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Biaya Admin', style: TextStyle(color: _muted)),
                      const Text('Rp 0', style: TextStyle(fontWeight: FontWeight.bold, color: _green)),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Diterima', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        _amountController.text.isEmpty 
                            ? 'Rp 0' 
                            : _formatRp(int.tryParse(_amountController.text) ?? 0),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: _green),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _processWithdraw,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  shadowColor: _green.withOpacity(0.4),
                ),
                child: const Text('Tarik Sekarang', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}