import 'package:flutter/material.dart';
import '../../data/tip_content.dart';

class TipDetailScreen extends StatelessWidget {
  final String tipId;
  const TipDetailScreen({super.key, required this.tipId});

  @override
  Widget build(BuildContext context) {
    final content = tipContents[tipId];

    return Scaffold(
      appBar: AppBar(
        title: Text(content?.title ?? 'Tips'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: content == null
            ? const Center(
                child: Text(
                  'Konten tidak ditemukan.',
                  style: TextStyle(color: Color(0xFF6B7280)),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      content.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      content.body,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: Color(0xFF4B5563),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (content.bullets.isNotEmpty) ...[
                      const Text(
                        'Langkah praktis:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...content.bullets.map(
                        (b) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• ',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF4B5563))),
                              Expanded(
                                child: Text(
                                  b,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                    color: Color(0xFF4B5563),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
      ),
    );
  }
}
