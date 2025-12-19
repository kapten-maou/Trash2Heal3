import 'package:flutter/material.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sampleMethods = [
      {
        'type': 'E-Wallet',
        'name': 'OVO',
        'masked': '••• 1234',
        'primary': true
      },
      {
        'type': 'Bank',
        'name': 'BCA',
        'masked': '**** 5678',
        'primary': false
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Metode Pembayaran'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Tersimpan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...sampleMethods.map(
            (m) => Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: m['primary'] == true
                      ? const Color(0xFF18A558)
                      : const Color(0xFFE5E7EB),
                ),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFF3F4F6),
                  child: Text(
                    (m['name'] as String).substring(0, 1),
                    style: const TextStyle(color: Color(0xFF111827)),
                  ),
                ),
                title: Text('${m['name']} (${m['type']})'),
                subtitle: Text(m['masked'] as String),
                trailing: m['primary'] == true
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Utama',
                          style: TextStyle(
                              fontSize: 11, color: Color(0xFF15803D)),
                        ),
                      )
                    : IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {},
                      ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tambah metode: coming soon')),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Tambah Metode Pembayaran'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF18A558),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}
