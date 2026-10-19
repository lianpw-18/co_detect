import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/report_export_service.dart';
import '../services/user_session.dart';
import '../screens/main_nav_screen.dart';
import '../screens/skin_scan_screen.dart';

class ResultPage extends StatelessWidget {
  final Map<String, dynamic> predictionResult;
  final String? imagePath;

  const ResultPage({
    super.key,
    this.predictionResult = const {
      'Normal': 40.3,
      'Oily': 20.9,
      'Dry': 20.4,
      'Combination': 18.4,
    },
    this.imagePath,
  });

  double _getScore(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Color _getColorForSkinType(String type) {
    switch (type.toLowerCase()) {
      case 'oily':
      case 'berminyak':
        return const Color(0xFF0284C7);
      case 'dry':
      case 'kering':
        return const Color(0xFFF59E0B);
      case 'combination':
      case 'kombinasi':
        return const Color(0xFF8B5CF6);
      case 'normal':
      default:
        return const Color(0xFF10B981);
    }
  }

  IconData _getIconForSkinType(String type) {
    switch (type.toLowerCase()) {
      case 'oily':
      case 'berminyak':
        return Icons.water_drop_rounded;
      case 'dry':
      case 'kering':
        return Icons.grain_rounded;
      case 'combination':
      case 'kombinasi':
        return Icons.layers_rounded;
      case 'normal':
      default:
        return Icons.spa_rounded;
    }
  }

  String _getDescription(String type) {
    switch (type.toLowerCase()) {
      case 'oily':
      case 'berminyak':
        return 'Produksi sebum berlebih pada wajah. Pori-pori cenderung tampak lebih besar dan area T-zone sering terlihat berkilau.';
      case 'dry':
      case 'kering':
        return 'Kulit memproduksi lebih sedikit sebum dan kekurangan kelembapan. Rentan terasa kencang, kasar, atau bersisik.';
      case 'combination':
      case 'kombinasi':
        return 'Perpaduan tipe kulit, di mana area T-zone (dahi, hidung, dagu) cenderung berminyak sementara area pipi normal atau kering.';
      case 'normal':
      default:
        return 'Kondisi kulit seimbang, tidak terlalu berminyak maupun terlalu kering. Pori-pori halus dan elastisitas kulit terjaga optimal.';
    }
  }

  List<Map<String, String>> _getRecommendations(String type) {
    switch (type.toLowerCase()) {
      case 'oily':
      case 'berminyak':
        return [
          {
            'title': 'Pembersih Berbusa Lembut',
            'desc': 'Gunakan gel cleanser berbasis Salicylic Acid (BHA).',
          },
          {
            'title': 'Pelembap Water-based',
            'desc': 'Pilih formula gel ringan bebas minyak (oil-free).',
          },
          {
            'title': 'Sunscreen Matte / Gel',
            'desc': 'Gunakan sunscreen bertekstur cair yang mengontrol minyak.',
          },
        ];
      case 'dry':
      case 'kering':
        return [
          {
            'title': 'Hydrating Cleanser',
            'desc': 'Gunakan pembersih krim yang tidak membuat kulit tertarik.',
          },
          {
            'title': 'Rich Moisturizer',
            'desc': 'Gunakan pelembap dengan Ceramide & Hyaluronic Acid.',
          },
          {
            'title': 'Dewy Sunscreen',
            'desc': 'Gunakan sunscreen dengan kandungan pelembap ekstra.',
          },
        ];
      case 'combination':
      case 'kombinasi':
        return [
          {
            'title': 'Pembersih pH Seimbang',
            'desc': 'Gunakan gentle cleanser yang menjaga kelembapan kulit.',
          },
          {
            'title': 'Dual Moisture Approach',
            'desc': 'Gunakan lotion ringan di T-zone dan krim di area pipi.',
          },
          {
            'title': 'Broad-Spectrum SPF',
            'desc': 'Gunakan sunscreen non-komedogenik setiap pagi.',
          },
        ];
      case 'normal':
      default:
        return [
          {
            'title': 'Gentle Cleanser',
            'desc': 'Pertahankan keseimbangan alami dengan pembersih lembut.',
          },
          {
            'title': 'Lightweight Hydrator',
            'desc': 'Gunakan pelembap ringan untuk menjaga kelembapan harian.',
          },
          {
            'title': 'Daily UV Protection',
            'desc': 'Gunakan sunscreen SPF 30+ / PA++++ setiap hari.',
          },
        ];
    }
  }

  List<String> _getIngredients(String type) {
    switch (type.toLowerCase()) {
      case 'oily':
      case 'berminyak':
        return ['Salicylic Acid', 'Niacinamide', 'Zinc PCA', 'Tea Tree'];
      case 'dry':
      case 'kering':
        return ['Hyaluronic Acid', 'Ceramides', 'Glycerin', 'Squalane'];
      case 'combination':
      case 'kombinasi':
        return ['Niacinamide', 'Centella Asiatica', 'Hyaluronic Acid', 'Green Tea'];
      case 'normal':
      default:
        return ['Vitamin C', 'Hyaluronic Acid', 'Peptides', 'Niacinamide'];
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sort predictions from highest to lowest
    final sortedEntries = predictionResult.entries.toList()
      ..sort((a, b) => _getScore(b.value).compareTo(_getScore(a.value)));

    final dominantEntry = sortedEntries.isNotEmpty
        ? sortedEntries.first
        : const MapEntry('Normal', 0.0);
    final dominantType = dominantEntry.key;
    final dominantScore = _getScore(dominantEntry.value);
    final primaryColor = _getColorForSkinType(dominantType);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: AppColors.textPrimary,
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const MainNavScreen()),
              );
            }
          },
        ),
        title: const Text(
          'Hasil Klasifikasi Kulit',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            color: AppColors.textSecondary,
            tooltip: 'Bagikan',
            onPressed: () {
              ReportExportService.instance.shareSkinClassificationText(
                dominantType: dominantType,
                predictionResult: predictionResult,
                userName: UserSession.instance.greetingName,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_rounded),
            color: AppColors.textSecondary,
            tooltip: 'Unduh PDF',
            onPressed: () {
              ReportExportService.instance.printSkinClassificationPdf(
                dominantType: dominantType,
                predictionResult: predictionResult,
                userName: UserSession.instance.name,
                imagePath: imagePath,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            color: AppColors.textSecondary,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (ctx) => Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tentang Klasifikasi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Hasil analisis dihitung menggunakan model kecerdasan buatan (AI) berbasis citra kulit. Persentase menunjukkan tingkat keyakinan (confidence level) dari masing-masing tipe kulit.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text(
                            'Mengerti',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Analyzed Image Card (jika ada input foto)
            if (imagePath != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: SizedBox(
                        width: 72,
                        height: 72,
                        child: kIsWeb
                            ? Image.network(imagePath!, fit: BoxFit.cover)
                            : Image.file(File(imagePath!), fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDCFCE7),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.check_circle_rounded,
                                      size: 12,
                                      color: Color(0xFF16A34A),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Berhasil Dianalisis',
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF166534),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Foto Kulit Terpindai',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Area T-Zone & pori wajah terdeteksi',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Dominant Result Hero Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryColor,
                    primaryColor.withValues(alpha: 0.82),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.28),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'TIPE KULIT DOMINAN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      _getIconForSkinType(dominantType),
                      size: 38,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    dominantType,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${dominantScore.toStringAsFixed(1)}% Keyakinan',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _getDescription(dominantType),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        height: 1.45,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Prediction Breakdown Section
            const Text(
              'Distribusi Prediksi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFEDF2F7)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: sortedEntries.asMap().entries.map((item) {
                  final index = item.key;
                  final entry = item.value;
                  final typeName = entry.key;
                  final score = _getScore(entry.value);
                  final color = _getColorForSkinType(typeName);
                  final percent = (score / 100).clamp(0.0, 1.0);

                  return Column(
                    children: [
                      if (index > 0) const Divider(height: 24, thickness: 0.8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              _getIconForSkinType(typeName),
                              size: 18,
                              color: color,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      typeName,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      '${score.toStringAsFixed(1)}%',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: color,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: LinearProgressIndicator(
                                    value: percent,
                                    minHeight: 8,
                                    backgroundColor: const Color(0xFFF1F5F9),
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(color),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // Recommended Care Routine Section
            const Text(
              'Rekomendasi Perawatan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: _getRecommendations(dominantType).map((rec) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFEDF2F7)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              rec['title'] ?? '',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              rec['desc'] ?? '',
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 12),

            // Recommended Ingredients Section
            const Text(
              'Kandungan Aktif yang Disarankan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _getIngredients(dominantType).map((ingredient) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: primaryColor.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Text(
                    ingredient,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Export & Share Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFE11D48),
                      side: const BorderSide(color: Color(0xFFFECDD3)),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      ReportExportService.instance.shareSkinClassificationText(
                        dominantType: dominantType,
                        predictionResult: predictionResult,
                        userName: UserSession.instance.greetingName,
                      );
                    },
                    icon: const Icon(Icons.share_rounded, size: 18),
                    label: const Text(
                      'Bagikan Hasil',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE11D48),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      ReportExportService.instance.printSkinClassificationPdf(
                        dominantType: dominantType,
                        predictionResult: predictionResult,
                        userName: UserSession.instance.name,
                        imagePath: imagePath,
                      );
                    },
                    icon: const Icon(Icons.picture_as_pdf_rounded, size: 18),
                    label: const Text(
                      'Cetak / PDF',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Action Buttons: Uji Ulang & Kembali ke Dashboard
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const SkinScanScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                label: const Text(
                  'Uji Ulang / Scan Baru',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const MainNavScreen(),
                    ),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.home_rounded, size: 18),
                label: const Text(
                  'Kembali ke Dashboard',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

