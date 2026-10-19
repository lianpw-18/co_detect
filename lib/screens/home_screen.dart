import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/app_status_bar.dart';
import '../widgets/user_avatar.dart';
import '../services/user_session.dart';
import 'screening_screen.dart';
import 'health_tips_screen.dart';
import 'vaccine_info_screen.dart';
import 'hospital_list_screen.dart';
import 'hospital_map_screen.dart';
import 'edu_video_screen.dart';
import 'skin_scan_screen.dart';
import 'elderly_tracker_screen.dart';

class HomeScreen extends StatelessWidget {
  final Function(int)? onTabChange;

  const HomeScreen({super.key, this.onTabChange});

  String _formatRealTimeDate() {
    final now = DateTime.now();
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    final day = now.day;
    final month = months[now.month - 1];
    final year = now.year;
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return '$day $month $year, $hour.$minute WIB';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const AppStatusBar(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                children: [
                  // User Profile Greeting Header
                  Row(
                    children: [
                      const UserAvatar(
                        radius: 24,
                        imageUrl:
                            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=120&h=120&fit=crop&crop=faces',
                      ),
                      const SizedBox(width: 14),
                      ListenableBuilder(
                        listenable: UserSession.instance,
                        builder: (context, _) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hi, ${UserSession.instance.greetingName}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              StreamBuilder(
                                stream: Stream.periodic(
                                  const Duration(seconds: 10),
                                ),
                                builder: (context, _) {
                                  return Text(
                                    _formatRealTimeDate(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          if (onTabChange != null) {
                            onTabChange!(1); // Go to messages
                          }
                        },
                        icon: const Badge(
                          label: Text('2'),
                          child: Icon(
                            Icons.notifications_outlined,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Menu Feature Icons (4x2 Grid)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildMenuIconItem(
                            context: context,
                            title: 'Tanya\nGejala',
                            color: AppColors.menuTanyaGejala,
                            icon: Icons.assignment_outlined,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const ScreeningScreen(),
                                ),
                              );
                            },
                          ),
                          _buildMenuIconItem(
                            context: context,
                            title: 'Tips\nKesehatan',
                            color: AppColors.menuTipsKesehatan,
                            icon: Icons.favorite_border_rounded,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const HealthTipsScreen(),
                                ),
                              );
                            },
                          ),
                          _buildMenuIconItem(
                            context: context,
                            title: 'Video\nEdukasi',
                            color: AppColors.menuVideoEdukasi,
                            icon: Icons.play_circle_outline_rounded,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const EduVideoScreen(),
                                ),
                              );
                            },
                          ),
                          _buildMenuIconItem(
                            context: context,
                            title: 'Daftar\nRS',
                            color: AppColors.menuDaftarRs,
                            icon: Icons.local_hospital_outlined,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const HospitalListScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // 2nd row: Info Vaksin, Cek Kulit, Pantau Lansia
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildMenuIconItem(
                            context: context,
                            title: 'Info\nVaksin',
                            color: AppColors.menuInfoVaksin,
                            icon: Icons.vaccines_outlined,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const VaccineInfoScreen(),
                                ),
                              );
                            },
                          ),
                          _buildMenuIconItem(
                            context: context,
                            title: 'Cek\nKulit',
                            color: const Color(0xFFE11D48),
                            icon: Icons.face_retouching_natural_rounded,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const SkinScanScreen(),
                                ),
                              );
                            },
                          ),
                          _buildMenuIconItem(
                            context: context,
                            title: 'Pantau\nLansia',
                            color: const Color(0xFF0D9488),
                            icon: Icons.elderly_rounded,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const ElderlyTrackerScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 58),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Big COVID-19 Banner (Yellow Left + Blue Stats Right)
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Left Yellow Section
                            Expanded(
                              flex: 11,
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFFFD54F),
                                      Color(0xFFFFCA28),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'JAGA DIRI dan\nKELUARGA ANDA\ndari COVID-19',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFFC62828),
                                        height: 1.25,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(alpha: 0.9),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.wash_rounded,
                                            size: 22,
                                            color: Color(0xFFC62828),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(alpha: 0.9),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.masks_rounded,
                                            size: 22,
                                            color: Color(0xFF1565C0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Right Blue Stats Section
                            Expanded(
                              flex: 9,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 12,
                                ),
                                color: const Color(0xFFE0F2FE),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'KASUS COVID-19',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF0369A1),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    _StatItem(
                                      label: 'Positif',
                                      value: '1.996.115',
                                      color: Color(0xFFDC2626),
                                    ),
                                    _StatItem(
                                      label: 'Sembuh',
                                      value: '1.797.159',
                                      color: Color(0xFF16A34A),
                                    ),
                                    _StatItem(
                                      label: 'Meninggal',
                                      value: '54.662',
                                      color: Color(0xFF475569),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Call Center Hotline
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF86EFAC)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color(0xFF16A34A),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.phone_in_talk,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hotline Kemenkes 119 Ext 9',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.5,
                                  color: Color(0xFF14532D),
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Layanan bebas pulsa tanggap darurat Covid-19',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF166534),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Rumah Sakit Rujukan Cepat Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Faskes Rujukan Terdekat',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const HospitalListScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Lihat Semua',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Preview Card 1
                  _buildHospitalMiniCard(
                    context: context,
                    name: 'Muhammadiyah Hospital',
                    address: 'Jl. K.H. Ahmad Dahlan No.53, Bandung',
                    distance: '1.2 km',
                    is24Hours: true,
                  ),
                  const SizedBox(height: 10),
                  // Preview Card 2
                  _buildHospitalMiniCard(
                    context: context,
                    name: 'Immanuel Hospital',
                    address: 'Jl. Raya Kopo No.161, Bandung',
                    distance: '2.4 km',
                    is24Hours: true,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuIconItem({
    required BuildContext context,
    required String title,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalMiniCard({
    required BuildContext context,
    required String name,
    required String address,
    required String distance,
    required bool is24Hours,
  }) {
    return Material(
      color: const Color(0xFFF8FAFC),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => HospitalMapScreen(
                hospitalName: name,
                address: address,
                distance: distance,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.local_hospital,
                  color: Color(0xFF0284C7),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.map_outlined,
                        size: 11,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        distance,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '24 Jam',
                      style: TextStyle(
                        fontSize: 9.5,
                        color: Color(0xFF166534),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
