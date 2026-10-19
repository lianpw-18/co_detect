import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/app_status_bar.dart';
import '../widgets/user_avatar.dart';
import '../services/report_export_service.dart';
import '../services/user_session.dart';
import 'main_nav_screen.dart';

// Alias untuk kompatibilitas jika dipanggil sebagai ResultPage
typedef ResultPage = ScreeningResultScreen;

class ScreeningResultScreen extends StatelessWidget {
  final bool isExposed;

  const ScreeningResultScreen({
    super.key,
    this.isExposed = false,
  });

  @override
  Widget build(BuildContext context) {
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
                    onPressed: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const MainNavScreen(),
                          ),
                        );
                      }
                    },
                  ),
                  const Text(
                    'Back',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
            const SizedBox(height: 8),
            const Text(
              'Hasil Tanya Gejala',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 36),
            // Result Speech Box
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 36,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8C8A3),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFF2E2E2E),
                          width: 2.5,
                        ),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Left top quotation
                          const Positioned(
                            top: -24,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Text(
                                '“',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF2E2E2E),
                                  height: 1,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              isExposed
                                  ? 'Dengan Seluruh Pertanyaan Yang Anda Jawab Anda Terpapar Covid-19'
                                  : 'Dengan Seluruh Pertanyaan Yang Anda Jawab Anda Tidak Terpapar Covid-19',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.4,
                              ),
                            ),
                          ),
                          // Bottom quotation
                          const Positioned(
                            bottom: -28,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Text(
                                '„',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF2E2E2E),
                                  height: 1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 36),
                    // Recommendation Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isExposed
                            ? const Color(0xFFFFF1F2)
                            : const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isExposed
                              ? const Color(0xFFFECDD3)
                              : const Color(0xFFBBF7D0),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isExposed
                                ? Icons.warning_amber_rounded
                                : Icons.check_circle_outline,
                            color: isExposed
                                ? const Color(0xFFE11D48)
                                : const Color(0xFF16A34A),
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              isExposed
                                  ? 'Segera lakukan isolasi mandiri dan konsultasikan ke dokter atau faskes terdekat.'
                                  : 'Tetap jaga protokol kesehatan, cuci tangan teratur, dan kenakan masker.',
                              style: TextStyle(
                                fontSize: 13,
                                color: isExposed
                                    ? const Color(0xFF9F1239)
                                    : const Color(0xFF166534),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Action Buttons: Share & Download PDF
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF0284C7),
                              side: const BorderSide(color: Color(0xFFBAE6FD)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              ReportExportService.instance.shareCovidScreeningText(
                                isExposed: isExposed,
                                userName: UserSession.instance.greetingName,
                              );
                            },
                            icon: const Icon(Icons.share_rounded, size: 18),
                            label: const Text(
                              'Bagikan Hasil',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0284C7),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              ReportExportService.instance.printCovidScreeningPdf(
                                isExposed: isExposed,
                                userName: UserSession.instance.name,
                                userNik: UserSession.instance.nik,
                              );
                            },
                            icon: const Icon(Icons.picture_as_pdf_rounded, size: 18),
                            label: const Text(
                              'Cetak / PDF',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
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
                        child: const Text(
                          'Kembali ke Beranda',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
