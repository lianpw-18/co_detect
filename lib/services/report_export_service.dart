import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

const PdfColor _rosePrimary = PdfColor.fromInt(0xFFE11D48);
const PdfColor _roseDark = PdfColor.fromInt(0xFF9F1239);
const PdfColor _roseLight = PdfColor.fromInt(0xFFFFF1F2);
const PdfColor _roseBorder = PdfColor.fromInt(0xFFFECDD3);

class ReportExportService {
  static final ReportExportService instance = ReportExportService._internal();
  ReportExportService._internal();

  // ==========================================
  // 1. SKRINING MANDIRI COVID-19
  // ==========================================

  /// Bagikan hasil skrining via teks (WhatsApp, Telegram, dll)
  Future<void> shareCovidScreeningText({
    required bool isExposed,
    required String userName,
  }) async {
    final status = isExposed
        ? '⚠️ PERINGATAN: Terindikasi Terpapar Gejala Covid-19'
        : '✅ AMAN: Tidak Terpapar Gejala Covid-19';

    final advice = isExposed
        ? 'Disarankan segera melakukan isolasi mandiri, cek swab PCR/Antigen di faskes terdekat, dan konsultasikan ke dokter.'
        : 'Kondisi Anda saat ini terpantau baik. Tetap terapkan protokol kesehatan 5M dan konsumsi vitamin.';

    final text = '''
*HASIL SKRINING MANDIRI KESEHATAN*
Aplikasi: Co-Detect Health Assistant
Tanggal: ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}

Nama Pasien: $userName
Status: $status

*Rekomendasi Medis:*
$advice

_Dibuat secara otomatis oleh Co-Detect Health Assistant._
''';

    // ignore: deprecated_member_use
    await Share.share(
      text,
      subject: 'Laporan Skrining Kesehatan - $userName',
    );
  }

  /// Cetak / Unduh Laporan Skrining Covid-19 dalam bentuk PDF Resmi
  Future<void> printCovidScreeningPdf({
    required bool isExposed,
    required String userName,
    String? userNik,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (pw.Context context) {
          final now = DateTime.now();
          final dateStr =
              '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';

          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header Kop Surat
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'CO-DETECT HEALTHCARE',
                        style: pw.TextStyle(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blue900,
                        ),
                      ),
                      pw.Text(
                        'Sistem Skrining Cerdas & Telekesehatan',
                        style: const pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ],
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.blue50,
                      borderRadius: pw.BorderRadius.circular(6),
                      border: pw.Border.all(color: PdfColors.blue300),
                    ),
                    child: pw.Text(
                      'SURAT HASIL SKRINING',
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue800,
                      ),
                    ),
                  ),
                ],
              ),
              pw.Divider(thickness: 1.5, color: PdfColors.blue800),
              pw.SizedBox(height: 16),

              // Data Pasien
              pw.Text(
                'DATA IDENTITAS PASIEN',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.grey800,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  children: [
                    _buildPdfRow('Nama Lengkap', userName),
                    _buildPdfRow('NIK / Identitas', userNik ?? '3271045209840003'),
                    _buildPdfRow('Tanggal Pemeriksaan', dateStr),
                    _buildPdfRow('Metode Pemeriksaan', 'Skrining Gejala Mandiri Online'),
                  ],
                ),
              ),

              pw.SizedBox(height: 24),

              // Hasil Pemeriksaan Banner
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: isExposed ? PdfColors.red50 : PdfColors.green50,
                  borderRadius: pw.BorderRadius.circular(10),
                  border: pw.Border.all(
                    color: isExposed ? PdfColors.red300 : PdfColors.green300,
                    width: 1.5,
                  ),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text(
                      isExposed ? 'HASIL: BERISIKO TERPAPAR' : 'HASIL: RISIKO RENDAH / AMAN',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: isExposed ? PdfColors.red900 : PdfColors.green900,
                      ),
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text(
                      isExposed
                          ? 'Berdasarkan jawaban kuisioner, Anda mengalami indikasi gejala Covid-19.'
                          : 'Tidak ditemukan indikasi gejala klinis terpapar Covid-19 saat ini.',
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey800),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 24),

              // Rekomendasi Tindakan
              pw.Text(
                'REKOMENDASI & TINDAK LANJUT',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.grey800,
                ),
              ),
              pw.SizedBox(height: 8),
              if (isExposed) ...[
                _buildBulletPoint('Lakukan isolasi mandiri selama 10-14 hari di rumah.'),
                _buildBulletPoint('Kunjungi Faskes terdekat untuk tes Swab Antigen / RT-PCR konfirmasi.'),
                _buildBulletPoint('Pantau saturasi oksigen (SpO2) dan suhu tubuh harian.'),
                _buildBulletPoint('Hubungi telemedicine atau IGD Rumah Sakit jika timbul sesak nafas berat.'),
              ] else ...[
                _buildBulletPoint('Tetap patuhi protokol kesehatan 5M di tempat umum.'),
                _buildBulletPoint('Jaga daya tahan tubuh dengan nutrisi seimbang & istirahat cukup.'),
                _buildBulletPoint('Lakukan vaksinasi booster bila jadwal Anda telah tiba.'),
              ],

              pw.Spacer(),

              // Tanda tangan & disclaimer
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        '*Dokumen ini diterbitkan secara elektronik oleh Co-Detect.',
                        style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                      ),
                      pw.Text(
                        'Hasil skrining bersifat evaluasi awal dan bukan diagnosis definitif.',
                        style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                      ),
                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Text(
                        'Sistem Validasi Co-Detect',
                        style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.SizedBox(height: 35),
                      pw.Text(
                        '[TERVERIFIKASI SISTEM]',
                        style: pw.TextStyle(
                          fontSize: 9,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blue800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Laporan_Skrining_Covid_$userName.pdf',
    );
  }

  // ==========================================
  // 2. KLASIFIKASI KULIT AI (SKIN CLASSIFICATION)
  // ==========================================

  /// Bagikan hasil klasifikasi kulit ke WhatsApp / Media Sosial
  Future<void> shareSkinClassificationText({
    required String dominantType,
    required Map<String, dynamic> predictionResult,
    required String userName,
  }) async {
    final breakdown = predictionResult.entries
        .map((e) => '• ${e.key}: ${e.value.toString()}%')
        .join('\n');

    final text = '''
✨ *HASIL ANALISIS KULIT AI - CO-DETECT* ✨
Nama: $userName
Tipe Kulit Dominan: *$dominantType*

*Rincian Analisis:*
$breakdown

Lihat panduan perawatan dan bahan skincare aktif yang disarankan di aplikasi Co-Detect!
''';

    // ignore: deprecated_member_use
    await Share.share(
      text,
      subject: 'Hasil Analisis Kulit - $dominantType',
    );
  }

  /// Cetak / Unduh Laporan Kulit AI dalam bentuk PDF Lengkap
  Future<void> printSkinClassificationPdf({
    required String dominantType,
    required Map<String, dynamic> predictionResult,
    required String userName,
    String? imagePath,
  }) async {
    final pdf = pw.Document();

    pw.MemoryImage? userImage;
    if (imagePath != null && !kIsWeb) {
      try {
        final file = File(imagePath);
        if (await file.exists()) {
          final bytes = await file.readAsBytes();
          userImage = pw.MemoryImage(bytes);
        }
      } catch (_) {}
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (pw.Context context) {
          final now = DateTime.now();
          final dateStr =
              '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';

          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'DERMATOLOGY AI REPORT',
                        style: pw.TextStyle(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                          color: _roseDark,
                        ),
                      ),
                      pw.Text(
                        'Co-Detect Skin Health & Skincare Advisor',
                        style: const pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ],
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: pw.BoxDecoration(
                      color: _roseLight,
                      borderRadius: pw.BorderRadius.circular(6),
                      border: pw.Border.all(color: _roseBorder),
                    ),
                    child: pw.Text(
                      'TANGGAL: $dateStr',
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                        color: _roseDark,
                      ),
                    ),
                  ),
                ],
              ),
              pw.Divider(thickness: 1.5, color: _roseDark),
              pw.SizedBox(height: 14),

              // User Info & Image Card
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (userImage != null) ...[
                    pw.Container(
                      width: 80,
                      height: 80,
                      decoration: pw.BoxDecoration(
                        borderRadius: pw.BorderRadius.circular(8),
                        border: pw.Border.all(color: PdfColors.grey300),
                      ),
                      child: pw.ClipRRect(
                        horizontalRadius: 8,
                        verticalRadius: 8,
                        child: pw.Image(userImage, fit: pw.BoxFit.cover),
                      ),
                    ),
                    pw.SizedBox(width: 14),
                  ],
                  pw.Expanded(
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(10),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.grey100,
                        borderRadius: pw.BorderRadius.circular(8),
                      ),
                      child: pw.Column(
                        children: [
                          _buildPdfRow('Nama Pengguna', userName),
                          _buildPdfRow('Metode Input', 'Pemindaian Wajah Kamera AI'),
                          _buildPdfRow('Tipe Dominan', dominantType.toUpperCase()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 16),

              // Rincian Persentase Tipe Kulit
              pw.Text(
                'HASIL DISTRIBUSI KEYAKINAN MODEL AI (CONFIDENCE LEVEL)',
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.grey800,
                ),
              ),
              pw.SizedBox(height: 8),

              ...predictionResult.entries.map((entry) {
                final double score = (entry.value is num)
                    ? (entry.value as num).toDouble()
                    : double.tryParse(entry.value.toString()) ?? 0.0;
                final isDom = entry.key.toLowerCase() == dominantType.toLowerCase();

                return pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 3),
                  child: pw.Row(
                    children: [
                      pw.SizedBox(
                        width: 110,
                        child: pw.Text(
                          entry.key,
                          style: pw.TextStyle(
                            fontSize: 11,
                            fontWeight: isDom ? pw.FontWeight.bold : pw.FontWeight.normal,
                            color: isDom ? _roseDark : PdfColors.grey800,
                          ),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Container(
                          height: 10,
                          decoration: pw.BoxDecoration(
                            color: PdfColors.grey200,
                            borderRadius: pw.BorderRadius.circular(5),
                          ),
                          child: pw.Align(
                            alignment: pw.Alignment.centerLeft,
                            child: pw.Container(
                              width: (score / 100) * 280,
                              decoration: pw.BoxDecoration(
                                color: isDom ? _rosePrimary : PdfColors.blue500,
                                borderRadius: pw.BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                      ),
                      pw.SizedBox(width: 12),
                      pw.SizedBox(
                        width: 45,
                        child: pw.Text(
                          '${score.toStringAsFixed(1)}%',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                            color: isDom ? _roseDark : PdfColors.grey800,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              pw.SizedBox(height: 18),

              // Rekomendasi Skincare Routine
              pw.Text(
                'PANDUAN PERAWATAN SESUAI TIPE $dominantType',
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.grey800,
                ),
              ),
              pw.SizedBox(height: 8),
              _buildBulletPoint('Pembersih Wajah: Gunakan formula gentle pH seimbang.'),
              _buildBulletPoint('Pelembap: Gunakan moisturizer yang mengunci hidrasi kulit.'),
              _buildBulletPoint('Sunscreen: Wajib aplikasikan sunscreen minimal SPF 30+ setiap pagi.'),
              _buildBulletPoint('Eksfoliasi: Batasi chemical exfoliation maksimal 1-2x seminggu.'),

              pw.Spacer(),

              // Footer Disclaimer
              pw.Divider(thickness: 1, color: PdfColors.grey300),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Co-Detect AI Dermatology • Dokumen ini dibuat otomatis untuk referensi perawatan kulit.',
                    style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                  ),
                  pw.Text(
                    'Halaman 1 dari 1',
                    style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Laporan_Kulit_${userName}_$dominantType.pdf',
    );
  }

  // Helper widget PDF
  static pw.Widget _buildPdfRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2.5),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildBulletPoint(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('• ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Expanded(
            child: pw.Text(
              text,
              style: const pw.TextStyle(fontSize: 9.5, color: PdfColors.grey800),
            ),
          ),
        ],
      ),
    );
  }
}
