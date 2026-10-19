import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/app_status_bar.dart';
import '../widgets/user_avatar.dart';

class HealthTipItem {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String category;
  final String description;
  final String fullDetails;
  final List<String> steps;
  final String recommendation;

  const HealthTipItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.category,
    required this.description,
    required this.fullDetails,
    required this.steps,
    required this.recommendation,
  });
}

class HealthTipsScreen extends StatefulWidget {
  const HealthTipsScreen({super.key});

  @override
  State<HealthTipsScreen> createState() => _HealthTipsScreenState();
}

class _HealthTipsScreenState extends State<HealthTipsScreen> {
  String _selectedCategory = 'Semua';
  final Set<String> _completedTips = {};

  final List<HealthTipItem> _allTips = const [
    HealthTipItem(
      icon: Icons.directions_run_rounded,
      iconBg: Color(0xFFDCFCE7),
      iconColor: Color(0xFF16A34A),
      category: 'Fisik',
      title: 'Olahraga Secara Teratur',
      description:
          'Lakukan olahraga ringan hingga sedang minimal 30 menit setiap hari untuk menjaga imun tubuh tetap prima.',
      fullDetails:
          'Aktivitas fisik secara rutin meningkatkan sirkulasi sel imun dan antibodi di seluruh tubuh. Olahraga teratur juga membantu menurunkan hormon stres yang dapat melemahkan daya tahan tubuh terhadap infeksi virus.',
      steps: [
        'Lakukan jalan santai atau senam ringan 30 menit di pagi hari.',
        'Kombinasikan dengan berjemur sinar matahari pagi (jam 08.00–09.30).',
        'Lansia disarankan memilih gerakan peregangan dan mobilitas sendi ringan.',
        'Hindari latihan intensitas tinggi berlebih yang memicu keletihan berat.',
      ],
      recommendation:
          'Target: Minimal 150 menit per minggu (3-5 sesi olahraga teratur).',
    ),
    HealthTipItem(
      icon: Icons.wash_rounded,
      iconBg: Color(0xFFE0F2FE),
      iconColor: Color(0xFF0284C7),
      category: 'Kebersihan',
      title: 'Jaga Kebersihan Tangan',
      description:
          'Rajin mencuci tangan menggunakan sabun dan air mengalir minimal 20 detik atau gunakan hand sanitizer.',
      fullDetails:
          'Mencuci tangan dengan sabun efektif memecah lapisan lemak pelindung virus Covid-19 dan bakteri lain sehingga patogen mati dan terbilas bersih.',
      steps: [
        'Basahi tangan dengan air mengalir dan tuang sabun secukupnya.',
        'Gosok telapak, punggung tangan, dan sela-sela jari secara bergantian.',
        'Bersihkan ujung kuku dan putar kedua ibu jari.',
        'Bilas bersih dengan air dan keringkan dengan handuk bersih/tisu.',
        'Gunakan hand sanitizer dengan kadar alkohol minimal 70% bila tidak ada air.',
      ],
      recommendation:
          'Cuci tangan terutama sebelum menyentuh wajah, sebelum makan, dan setelah pulang dari luar rumah.',
    ),
    HealthTipItem(
      icon: Icons.restaurant_rounded,
      iconBg: Color(0xFFFEF3C7),
      iconColor: Color(0xFFD97706),
      category: 'Nutrisi',
      title: 'Konsumsi Makanan Bergizi',
      description:
          'Perbanyak makan sayur, buah-buahan kaya vitamin C & D, serta penuhi asupan cairan tubuh dengan cukup minum air putih.',
      fullDetails:
          'Nutrisi seimbang adalah fondasi utama pertahanan biologis tubuh. Vitamin C merangsang pembentukan sel darah putih, Vitamin D memperkuat kekebalan mukosa saluran pernapasan, dan Zink menghambat replikasi virus.',
      steps: [
        'Terapkan pola "Isi Piringku": 50% sayur & buah, 25% protein, 25% karbohidrat.',
        'Konsumsi buah tinggi vitamin C: jeruk, kiwi, pepaya, jambu biji.',
        'Penuhi vitamin D dari ikan laut, telur, jamur, serta susu terfortifikasi.',
        'Minum air putih minimal 8 gelas (sekitar 2 liter) setiap hari.',
        'Batasi konsumsi gorengan, makanan instan, dan gula berlebih.',
      ],
      recommendation:
          'Bagi lansia, pastikan tekstur makanan mudah dicerna dan kaya serat alami.',
    ),
    HealthTipItem(
      icon: Icons.masks_rounded,
      iconBg: Color(0xFFFEE2E2),
      iconColor: Color(0xFFDC2626),
      category: 'Protokol',
      title: 'Patuhi Protokol Kesehatan',
      description:
          'Selalu gunakan masker saat berada di luar rumah, jaga jarak aman minimal 1.5 meter, dan hindari kerumunan.',
      fullDetails:
          'Protokol 5M tetap menjadi benteng pertahanan eksternal paling efektif untuk memutus rantai transmisi aerosol dan droplet virus di ruang umum.',
      steps: [
        'Gunakan masker medis atau masker ganda dengan kerapatan yang baik.',
        'Ganti masker setiap 4 jam atau segera jika terasa lembap/kotor.',
        'Jaga jarak fisik minimal 1.5 - 2 meter dari orang lain.',
        'Hindari ruangan tertutup dengan ventilasi buruk dan kerumunan banyak orang.',
        'Segera mandi dan ganti baju setibanya di rumah setelah bepergian.',
      ],
      recommendation:
          'Wajib patuhi etika batuk/bersin dengan menutup hidung dan mulut menggunakan lipatan siku.',
    ),
    HealthTipItem(
      icon: Icons.bedtime_rounded,
      iconBg: Color(0xFFEDE9FE),
      iconColor: Color(0xFF7C3AED),
      category: 'Fisik',
      title: 'Istirahat dan Tidur Cukup',
      description:
          'Cukupi waktu istirahat dan tidur 7–8 jam setiap malam untuk membantu regenerasi sel dan menjaga daya tahan tubuh.',
      fullDetails:
          'Selama fase tidur nyenyak, sistem imun memproduksi dan melepaskan sitokin, yaitu protein yang bertugas mengenali dan menghancurkan sel asing yang terinfeksi.',
      steps: [
        'Tidur teratur 7 hingga 8 jam setiap malam pada jam yang sama.',
        'Hindari penggunaan ponsel/layar digital 30 menit sebelum tidur.',
        'Redupkan pencahayaan kamar tidur untuk memicu produksi hormon melatonin.',
        'Lansia dapat melengkapi dengan tidur siang singkat (power nap) 20-30 menit.',
      ],
      recommendation:
          'Kurang tidur kronis menurunkan efektivitas antibodi tubuh hingga 50%.',
    ),
    HealthTipItem(
      icon: Icons.vaccines_rounded,
      iconBg: Color(0xFFCCFBF1),
      iconColor: Color(0xFF0D9488),
      category: 'Vaksinasi',
      title: 'Lengkapi Vaksinasi & Booster',
      description:
          'Lengkapi dosis vaksinasi dan booster Covid-19 sesuai anjuran untuk perlindungan optimal dari risiko infeksi berat.',
      fullDetails:
          'Vaksin mengajarkan sistem imun mengenali materi genetik virus tanpa membuat Anda jatuh sakit. Vaksin booster sangat esensial untuk memulihkan kadar antibodi yang menurun seiring waktu.',
      steps: [
        'Pastikan dosis primer (Dosis 1 & 2) telah lengkap terverifikasi.',
        'Ambil vaksin booster sesuai jadwal dan rekomendasi usia faskes.',
        'Pantau sertifikat resmi melalui menu Sertifikat di profil Co-Detect.',
        'Konsultasikan dengan dokter spesialis jika memiliki komorbid bawaan sebelum vaksinasi.',
      ],
      recommendation:
          'Lansia adalah kelompok prioritas utama untuk mendapatkan perlindungan booster.',
    ),
    HealthTipItem(
      icon: Icons.self_improvement_rounded,
      iconBg: Color(0xFFFCE7F3),
      iconColor: Color(0xFFDB2777),
      category: 'Mental',
      title: 'Kelola Stres & Kesehatan Mental',
      description:
          'Kelola stres dengan aktivitas positif, meditasi, dan komunikasi hangat bersama keluarga agar imunitas tidak menurun.',
      fullDetails:
          'Stres berkepanjangan memicu hormon kortisol tinggi yang menekan limfosit T. Pikiran tenang dan perasaan bahagia memperkuat daya tahan alami tubuh.',
      steps: [
        'Lakukan relaksasi dan latihan pernapasan dalam (deep breathing) 10 menit.',
        'Batasi membaca berita negatif atau kabar hoaks yang memicu kecemasan.',
        'Jalin komunikasi rutin via telepon atau video call dengan sanak saudara.',
        'Lakukan hobi menyenangkan di rumah seperti berkebun, membaca, atau mendengarkan musik.',
      ],
      recommendation:
          'Kesehatan fisik bermula dari pikiran yang tenang dan positif.',
    ),
    HealthTipItem(
      icon: Icons.air_rounded,
      iconBg: Color(0xFFE0E7FF),
      iconColor: Color(0xFF4F46E5),
      category: 'Kebersihan',
      title: 'Jaga Ventilasi & Sirkulasi Udara',
      description:
          'Pastikan ruangan memiliki sirkulasi udara yang baik dengan membuka jendela secara berkala untuk meminimalkan penumpukan aerosol.',
      fullDetails:
          'Konsentrasi aerosol virus Covid-19 di dalam ruangan tertutup dapat bertahan hingga berjam-jam. Aliran udara segar secara drastis mengencerkan dan membuang partikel virus keluar.',
      steps: [
        'Buka pintu dan jendela secara silang (cross-ventilation) minimal 20-30 menit setiap pagi.',
        'Gunakan kipas angin atau exhaust fan untuk mendorong udara keluar.',
        'Jika menggunakan AC, bersihkan filter secara berkala dan usahakan ada ventilasi udara luar.',
        'Gunakan air purifier dengan filter HEPA jika sirkulasi alami terbatas.',
      ],
      recommendation:
          'Utamakan pertemuan keluarga di ruang terbuka dengan sirkulasi alami.',
    ),
    HealthTipItem(
      icon: Icons.cleaning_services_rounded,
      iconBg: Color(0xFFFFEDD5),
      iconColor: Color(0xFFEA580C),
      category: 'Kebersihan',
      title: 'Rutin Disinfeksi Benda Sekitar',
      description:
          'Bersihkan dan lakukan disinfeksi rutin pada permukaan benda yang sering disentuh, seperti smartphone, gagang pintu, dan meja.',
      fullDetails:
          'Permukaan benda mati yang sering disentuh bersama (high-touch surfaces) dapat menjadi media penularan tidak langsung jika tersentuh tangan lalu mengusap mata atau hidung.',
      steps: [
        'Bersihkan debu terlebih dahulu dengan kain lap basah bersabun.',
        'Semprotkan cairan disinfektan (alkohol 70% atau cairan pembersih standar).',
        'Fokuskan pada: layar handphone, remote TV, saklar lampu, gagang pintu, dan meja makan.',
        'Biarkan cairan disinfektan bekerja selama 1–2 menit sebelum dilap kering.',
      ],
      recommendation:
          'Bersihkan handphone setiap kali tiba di rumah setelah bepergian.',
    ),
    HealthTipItem(
      icon: Icons.medical_services_rounded,
      iconBg: Color(0xFFF1F5F9),
      iconColor: Color(0xFF475569),
      category: 'Protokol',
      title: 'Pantau Gejala & Cek Mandiri',
      description:
          'Segera lakukan isolasi mandiri dan konsultasikan ke dokter atau fasilitas kesehatan terdekat jika merasakan gejala mirip flu atau demam.',
      fullDetails:
          'Deteksi sedini mungkin mencegah perburukan gejala, terutama pada lansia yang memiliki risiko komplikasi lebih tinggi akibat penurunan saturasi oksigen tiba-tiba.',
      steps: [
        'Ukur suhu tubuh dan catat jika melebihi 37.5°C.',
        'Gunakan pulse oximeter untuk memantau saturasi oksigen (SpO2 normal: 95–100%).',
        'Gunakan menu "Tanya Gejala" di aplikasi Co-Detect untuk skrining mandiri.',
        'Segera hubungi faskes atau hotline darurat 119 jika saturasi turun di bawah 95% atau terasa sesak.',
      ],
      recommendation:
          'Sedia termometer, oximeter, dan obat-obatan rutin di rumah untuk lansia.',
    ),
  ];

  List<HealthTipItem> get _filteredTips {
    if (_selectedCategory == 'Semua') return _allTips;
    return _allTips.where((t) => t.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['Semua', 'Fisik', 'Kebersihan', 'Nutrisi', 'Protokol', 'Vaksinasi', 'Mental'];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const AppStatusBar(),
            // Top App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 18),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Text(
                    'Tips Kesehatan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  const UserAvatar(
                    radius: 16,
                    imageUrl:
                        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100&h=100&fit=crop&crop=faces',
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        fontFamily: 'Roboto',
                      ),
                      children: [
                        TextSpan(
                          text: 'TIPS ',
                          style: TextStyle(
                            color: Color(0xFFEF4444),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        TextSpan(
                          text: 'Agar Tetap Sehat di\nMasa Pandemi Covid-19',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tekan pada tips untuk melihat panduan lengkap & langkah praktis',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Category Filter Chips
                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, i) {
                        final cat = categories[i];
                        final isSelected = _selectedCategory == cat;
                        return ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          selectedColor: const Color(0xFF22C55E),
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                          ),
                          backgroundColor: const Color(0xFFF1F5F9),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          onSelected: (_) {
                            setState(() {
                              _selectedCategory = cat;
                            });
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Tips Items List
                  ..._filteredTips.map((tip) {
                    final isDone = _completedTips.contains(tip.title);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildInteractiveTipCard(tip, isDone),
                    );
                  }),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractiveTipCard(HealthTipItem tip, bool isDone) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => _showTipDetailSheet(context, tip),
        borderRadius: BorderRadius.circular(16),
        splashColor: tip.iconColor.withValues(alpha: 0.1),
        highlightColor: tip.iconColor.withValues(alpha: 0.05),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDone ? const Color(0xFF86EFAC) : const Color(0xFFF1F5F9),
              width: isDone ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: tip.iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(tip.icon, color: tip.iconColor, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            tip.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (isDone)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.check, size: 12, color: Color(0xFF16A34A)),
                                SizedBox(width: 2),
                                Text(
                                  'Diterapkan',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF16A34A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      tip.description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            tip.category,
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF475569),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Lihat Panduan',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: tip.iconColor,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 11,
                          color: tip.iconColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== TIP DETAIL SHEET ====================
  void _showTipDetailSheet(BuildContext context, HealthTipItem tip) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) {
        final isDone = _completedTips.contains(tip.title);
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.85,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              expand: false,
              builder: (_, scrollController) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  child: ListView(
                    controller: scrollController,
                    children: [
                      Center(
                        child: Container(
                          width: 44,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Header Row
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: tip.iconBg,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(tip.icon, color: tip.iconColor, size: 30),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Kategori: ${tip.category}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF475569),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  tip.title,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Penjelasan Utama
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Text(
                          tip.fullDetails,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textPrimary,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Langkah Praktis (Steps)
                      const Text(
                        'Langkah-Langkah Praktis:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...tip.steps.map((step) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 3),
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: tip.iconColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.check, size: 12, color: Colors.white),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                step,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  color: AppColors.textPrimary,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),

                      const SizedBox(height: 14),

                      // Anjuran & Rekomendasi Box
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFDE68A)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.lightbulb_outline, color: Color(0xFFD97706), size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                tip.recommendation,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF92400E),
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: isDone ? const Color(0xFFEF4444) : const Color(0xFF22C55E),
                                ),
                                foregroundColor: isDone ? const Color(0xFFEF4444) : const Color(0xFF16A34A),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  if (isDone) {
                                    _completedTips.remove(tip.title);
                                  } else {
                                    _completedTips.add(tip.title);
                                  }
                                });
                                Navigator.pop(sheetCtx);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isDone
                                          ? 'Status dibatalkan untuk "${tip.title}"'
                                          : 'Bagus! "${tip.title}" ditandai sudah Anda terapkan hari ini.',
                                    ),
                                    backgroundColor: isDone ? const Color(0xFF64748B) : const Color(0xFF22C55E),
                                  ),
                                );
                              },
                              icon: Icon(isDone ? Icons.close : Icons.task_alt, size: 18),
                              label: Text(isDone ? 'Batal Terapkan' : 'Terapkan Hari Ini'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: const Color(0xFFF1F5F9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.share_outlined, color: AppColors.textPrimary),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Membagikan tips: ${tip.title}...'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
