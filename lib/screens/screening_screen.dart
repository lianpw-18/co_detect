import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/app_status_bar.dart';
import '../widgets/user_avatar.dart';
import 'screening_result_screen.dart';

class ScreeningScreen extends StatefulWidget {
  const ScreeningScreen({super.key});

  @override
  State<ScreeningScreen> createState() => _ScreeningScreenState();
}

class _ScreeningScreenState extends State<ScreeningScreen> {
  final List<String> _questions = [
    'Apakah anda kehilangan penciuman dan perasa?',
    'Apakah anda mengalami demam di atas 38°C selama beberapa hari?',
    'Apakah anda mengalami batuk kering terus-menerus dan sesak nafas?',
    'Apakah anda merasakan kelelahan ekstrim yang tidak biasa?',
    'Apakah dalam 14 hari terakhir anda pernah kontak erat dengan pasien positif Covid-19?',
  ];

  int _currentIndex = 0;
  int _yesCount = 0;

  void _answer(bool isYes) {
    if (isYes) {
      _yesCount++;
    }

    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      // Selesai skrining
      final isExposed = _yesCount >= 2;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ScreeningResultScreen(isExposed: isExposed),
        ),
      );
    }
  }

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
                    onPressed: () => Navigator.of(context).pop(),
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
              'Pertanyaan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                'Pertanyaan ${_currentIndex + 1} dari ${_questions.length}',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const Spacer(),
            // Speech Bubble Question Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  CustomPaint(
                    painter: _BubblePainter(),
                    child: Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(minHeight: 140),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 36,
                      ),
                      child: Text(
                        _questions[_currentIndex],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Buttons Ya & Tidak
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildAnswerButton(
                        label: 'Ya',
                        onTap: () => _answer(true),
                      ),
                      const SizedBox(width: 40),
                      _buildAnswerButton(
                        label: 'Tidak',
                        onTap: () => _answer(false),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(flex: 2),
            // Bottom Indicator
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_questions.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: index == _currentIndex ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: index == _currentIndex
                          ? AppColors.primary
                          : const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 80,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF2E2E2E), width: 1.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E2E2E),
            ),
          ),
        ),
      ),
    );
  }
}

class _BubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD4A373)
      ..style = PaintingStyle.fill;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height - 18),
      const Radius.circular(20),
    );
    canvas.drawRRect(rrect, paint);

    // Speech tail pointing down-left
    final path = Path()
      ..moveTo(size.width * 0.35, size.height - 18)
      ..lineTo(size.width * 0.45, size.height)
      ..lineTo(size.width * 0.48, size.height - 18)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
