import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/app_status_bar.dart';
import '../widgets/user_avatar.dart';

class EduVideoScreen extends StatefulWidget {
  const EduVideoScreen({super.key});

  @override
  State<EduVideoScreen> createState() => _EduVideoScreenState();
}

class _EduVideoScreenState extends State<EduVideoScreen> {
  final Set<String> _likedVideos = {};
  final Set<String> _savedVideos = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
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
                    'Video Edukasi',
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  const Text(
                    'Breaking News',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Breaking news banners (Interactive)
                  Row(
                    children: [
                      Expanded(
                        child: _buildBannerCard(
                          title: 'CEGAH KANKER\nC.E.R.D.I.K',
                          subtitle: 'Edukasi Kemenkes RI',
                          imageUrl:
                              'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=300&h=200&fit=crop',
                          color: const Color(0xFF1E3A8A),
                          duration: '06:30',
                          description:
                              'Panduan pola hidup sehat C.E.R.D.I.K (Cek kesehatan berkala, Enyahkan asap rokok, Rajin aktivitas fisik, Diet seimbang, Istirahat cukup, Kelola stres) dari Kementerian Kesehatan RI.',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildBannerCard(
                          title: 'Pola Hidup Bugar\nSaat Isolasi',
                          subtitle: 'Tips Dokter Spesialis',
                          imageUrl:
                              'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=300&h=200&fit=crop',
                          color: const Color(0xFF047857),
                          duration: '09:15',
                          description:
                              'Rekomendasi aktivitas fisik ringan dan teknik pernapasan untuk menjaga kebugaran tubuh serta menjaga saturasi oksigen tetap stabil selama menjalani isolasi mandiri di rumah.',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Trending Videos!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Hal dan makanan yang disarankan untuk dikonsumsi di masa pandemi Covid-19',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildVideoCard(
                    title: '5 Superfood Tingkatkan Imun Tubuh Melawan Virus',
                    channel: 'Co-Detect Health Channel',
                    duration: '08:45',
                    views: '124K views • 2 hari lalu',
                    thumbUrl:
                        'https://images.unsplash.com/photo-1498837167922-ddd27525d352?w=400&h=250&fit=crop',
                    description:
                        'Makanan kaya antioksidan dan vitamin esensial yang sangat dianjurkan untuk dikonsumsi harian, terutama bagi lansia guna memperkuat daya tahan alami tubuh.',
                  ),
                  const SizedBox(height: 14),
                  _buildVideoCard(
                    title: 'Cara Tepat Mencuci Hidung & Berkumur Saat Isoman',
                    channel: 'Dokter Tanggap Covid',
                    duration: '05:12',
                    views: '89K views • 5 hari lalu',
                    thumbUrl:
                        'https://images.unsplash.com/photo-1584515979956-d9f6e5d09982?w=400&h=250&fit=crop',
                    description:
                        'Tutorial praktis teknik cuci hidung menggunakan cairan saline steril (NaCl 0.9%) dan obat kumur povidone-iodine untuk membersihkan rongga nasofaring.',
                  ),
                  const SizedBox(height: 14),
                  _buildVideoCard(
                    title: 'Latihan Pernapasan Proning untuk Menaikkan Saturasi',
                    channel: 'Satgas Penanganan Covid',
                    duration: '11:20',
                    views: '350K views • 1 minggu lalu',
                    thumbUrl:
                        'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=250&fit=crop',
                    description:
                        'Posisi proning (tengkurap terarah) yang terbukti klinis membantu membuka kantung udara paru-paru dan mendistribusikan oksigen lebih optimal saat sesak napas ringan.',
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerCard({
    required String title,
    required String subtitle,
    required String imageUrl,
    required Color color,
    required String duration,
    required String description,
  }) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          _showVideoPlayerSheet(
            title: title.replaceAll('\n', ' - '),
            channel: subtitle,
            thumbUrl: imageUrl,
            duration: duration,
            description: description,
          );
        },
        child: Container(
          height: 160,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color,
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
              colorFilter: const ColorFilter.mode(
                Colors.black45,
                BlendMode.darken,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'VIDEO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 13.5,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoCard({
    required String title,
    required String channel,
    required String duration,
    required String views,
    required String thumbUrl,
    required String description,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          _showVideoPlayerSheet(
            title: title,
            channel: channel,
            thumbUrl: thumbUrl,
            duration: duration,
            description: description,
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF1F5F9)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(
                      thumbUrl,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, error, stackTrace) => Container(
                        height: 160,
                        color: Colors.grey[300],
                        child: const Icon(Icons.videocam, size: 40),
                      ),
                    ),
                  ),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        duration,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          channel,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('•', style: TextStyle(color: Colors.grey)),
                        const SizedBox(width: 8),
                        Text(
                          views,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
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

  // ==================== INTERACTIVE VIDEO PLAYER SHEET ====================
  void _showVideoPlayerSheet({
    required String title,
    required String channel,
    required String thumbUrl,
    required String duration,
    required String description,
  }) {
    bool isPlaying = true;
    double progress = 0.25;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final isLiked = _likedVideos.contains(title);
            final isSaved = _savedVideos.contains(title);

            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(height: 14),

                  // Video Player Simulation Screen
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: NetworkImage(thumbUrl),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          isPlaying ? Colors.transparent : Colors.black45,
                          BlendMode.darken,
                        ),
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Center Play / Pause button
                        IconButton(
                          iconSize: 52,
                          icon: Icon(
                            isPlaying
                                ? Icons.pause_circle_filled_rounded
                                : Icons.play_circle_fill_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setSheetState(() {
                              isPlaying = !isPlaying;
                            });
                          },
                        ),
                        // Bottom control bar
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.transparent, Colors.black87],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(16),
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  isPlaying ? '02:14' : '00:00',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      thumbShape: const RoundSliderThumbShape(
                                        enabledThumbRadius: 6,
                                      ),
                                      trackHeight: 3,
                                      activeTrackColor: const Color(0xFF22C55E),
                                      inactiveTrackColor: Colors.white30,
                                      thumbColor: const Color(0xFF22C55E),
                                    ),
                                    child: Slider(
                                      value: progress,
                                      onChanged: (val) {
                                        setSheetState(() => progress = val);
                                      },
                                    ),
                                  ),
                                ),
                                Text(
                                  duration,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Video Title & Channel
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    channel,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF16A34A),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Action Buttons (Like, Bookmark, Share)
                  Row(
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isLiked
                              ? const Color(0xFFFEE2E2)
                              : const Color(0xFFF1F5F9),
                          foregroundColor: isLiked
                              ? const Color(0xFFDC2626)
                              : const Color(0xFF475569),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          setSheetState(() {
                            if (isLiked) {
                              _likedVideos.remove(title);
                            } else {
                              _likedVideos.add(title);
                            }
                          });
                          setState(() {});
                        },
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          size: 16,
                        ),
                        label: Text(isLiked ? 'Disukai' : 'Suka'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSaved
                              ? const Color(0xFFDCFCE7)
                              : const Color(0xFFF1F5F9),
                          foregroundColor: isSaved
                              ? const Color(0xFF166534)
                              : const Color(0xFF475569),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          setSheetState(() {
                            if (isSaved) {
                              _savedVideos.remove(title);
                            } else {
                              _savedVideos.add(title);
                            }
                          });
                          setState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isSaved
                                    ? 'Dihapus dari daftar simpan'
                                    : 'Video disimpan ke daftar favorit!',
                              ),
                              backgroundColor: const Color(0xFF22C55E),
                            ),
                          );
                        },
                        icon: Icon(
                          isSaved ? Icons.bookmark : Icons.bookmark_border,
                          size: 16,
                        ),
                        label: Text(isSaved ? 'Tersimpan' : 'Simpan'),
                      ),
                      const Spacer(),
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFFF1F5F9),
                        ),
                        icon: const Icon(Icons.share_outlined, size: 20),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Membagikan video: $title'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Video Description Box
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Text(
                      description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF22C55E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Tutup Video'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
