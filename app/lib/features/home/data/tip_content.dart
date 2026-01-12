class TipContent {
  final String title;
  final String body;
  final List<String> bullets;

  const TipContent({
    required this.title,
    required this.body,
    this.bullets = const [],
  });
}

/// Konten detail tips (lokal, tanpa backend)
const Map<String, TipContent> tipContents = {
  'plastik': TipContent(
    title: 'Pisahkan Plastik',
    body:
        'Cuci botol dan kemasan plastik, pisahkan tutup dan label jika bisa. Keringkan sebelum disetor agar tidak berjamur dan tidak menetes.',
    bullets: [
      'Botol: lepas tutup, bilas, keringkan.',
      'Plastik multilayer (sachet): kumpulkan terpisah jika tidak diterima.',
      'Hindari mencampur plastik berminyak dengan plastik bersih.',
    ],
  ),
  'kardus': TipContent(
    title: 'Lipat & Keringkan Kardus',
    body:
        'Kardus lebih mudah diangkut jika dilipat rapi. Pastikan bebas dari sisa makanan atau minyak.',
    bullets: [
      'Lipat dan ikat supaya tidak makan tempat.',
      'Jauhkan dari air/lembap agar tidak berjamur.',
      'Pisahkan kardus berminyak (mis. bekas pizza) ke sampah residu.',
    ],
  ),
  'kaca-kaleng': TipContent(
    title: 'Kaca & Kaleng Aman',
    body:
        'Pisahkan kaca dan kaleng, bersihkan cepat, lalu kumpulkan di wadah keras untuk menghindari pecahan.',
    bullets: [
      'Bilas kaleng/kaca, keringkan sebentar.',
      'Gunakan kardus/ember untuk menaruh pecahan kaca.',
      'Tutup kaleng tajam dengan selotip atau pipihkan hati-hati.',
    ],
  ),
};
