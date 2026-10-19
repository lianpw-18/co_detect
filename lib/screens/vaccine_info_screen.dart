import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/app_status_bar.dart';
import '../widgets/user_avatar.dart';

class VaccineInfoScreen extends StatefulWidget {
  const VaccineInfoScreen({super.key});

  @override
  State<VaccineInfoScreen> createState() => _VaccineInfoScreenState();
}

class _VaccineInfoScreenState extends State<VaccineInfoScreen> {
  int _viewMode = 0; // 0 = Tabel Pas Layar, 1 = Tabel Lengkap (6 Kolom), 2 = Kartu Rinci
  String _selectedPlatformFilter = 'Semua';

  final List<Map<String, String>> _vaccines = const [
    {
      'name': 'Sinovac (CoronaVac)',
      'platform': 'Inactivated Virus',
      'dose': '2 dosis (0.5 ml)',
      'interval': '28 hari',
      'efficacy': '65.3%',
      'developer': 'Sinovac Biotech Ltd / Bio Farma',
      'storage': 'Suhu 2°C - 8°C (Kulkas Standar)',
      'notes': 'Vaksin pertama yang digunakan massal di Indonesia, aman untuk lansia & komorbid terkontrol.',
    },
    {
      'name': 'AstraZeneca',
      'platform': 'Viral Vector',
      'dose': '2 dosis (0.5 ml)',
      'interval': '8 - 12 minggu',
      'efficacy': '76.0%',
      'developer': 'Oxford University / AstraZeneca',
      'storage': 'Suhu 2°C - 8°C',
      'notes': 'Menggunakan vektor adenovirus simpanse yang tidak bereplikasi.',
    },
    {
      'name': 'Pfizer - BioNTech',
      'platform': 'mRNA',
      'dose': '2 dosis (0.3 ml)',
      'interval': '21 - 28 hari',
      'efficacy': '95.0%',
      'developer': 'Pfizer Inc. & BioNTech',
      'storage': 'Suhu Ultra Rendah (-90°C hingga -60°C)',
      'notes': 'Teknologi mRNA mutakhir dengan efikasi tinggi untuk pencegahan gejala berat.',
    },
    {
      'name': 'Moderna',
      'platform': 'mRNA',
      'dose': '2 dosis (0.5 ml)',
      'interval': '28 hari',
      'efficacy': '94.1%',
      'developer': 'ModernaTX, Inc.',
      'storage': 'Suhu -25°C hingga -15°C',
      'notes': 'Banyak digunakan sebagai booster tenaga kesehatan dan masyarakat umum.',
    },
    {
      'name': 'Sinopharm',
      'platform': 'Inactivated Virus',
      'dose': '2 dosis (0.5 ml)',
      'interval': '21 hari',
      'efficacy': '79.0%',
      'developer': 'Beijing Institute of Biological Products',
      'storage': 'Suhu 2°C - 8°C',
      'notes': 'Digunakan dalam program Vaksinasi Gotong Royong korporasi & mandiri.',
    },
    {
      'name': 'Novavax',
      'platform': 'Protein Subunit',
      'dose': '2 dosis (0.5 ml)',
      'interval': '21 hari',
      'efficacy': '90.4%',
      'developer': 'Novavax, Inc. / Serum Institute of India',
      'storage': 'Suhu 2°C - 8°C',
      'notes': 'Memanfaatkan protein lonjakan virus murni dengan adjuvant Matrix-M.',
    },
    {
      'name': 'Sputnik-V',
      'platform': 'Viral Vector',
      'dose': '2 dosis (0.5 ml)',
      'interval': '21 hari',
      'efficacy': '91.6%',
      'developer': 'Gamaleya Research Institute',
      'storage': 'Suhu beku (-18°C) atau cair (2°C - 8°C)',
      'notes': 'Menggunakan dua vektor adenovirus manusia berbeda (Ad26 dan Ad5).',
    },
    {
      'name': 'Janssen (J&J)',
      'platform': 'Viral Vector',
      'dose': '1 dosis tunggal',
      'interval': 'Dosis tunggal',
      'efficacy': '66.3%',
      'developer': 'Johnson & Johnson / Janssen',
      'storage': 'Suhu 2°C - 8°C',
      'notes': 'Cukup satu kali suntikan untuk membentuk kekebalan dasar lengkap.',
    },
  ];

  final List<String> _platforms = [
    'Semua',
    'Inactivated Virus',
    'Viral Vector',
    'mRNA',
    'Protein Subunit',
  ];

  List<Map<String, String>> get _filteredVaccines {
    if (_selectedPlatformFilter == 'Semua') return _vaccines;
    return _vaccines
        .where((v) => v['platform'] == _selectedPlatformFilter)
        .toList();
  }

  void _showVaccineDetailDialog(Map<String, String> vaccine) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4ADE80).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.vaccines_rounded,
                      color: Color(0xFF16A34A),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vaccine['name']!,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          vaccine['developer']!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Efikasi ${vaccine['efficacy']}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF166534),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              const SizedBox(height: 14),

              _buildDetailItem('Platform Teknologi', vaccine['platform']!),
              _buildDetailItem('Dosis Pemberian', vaccine['dose']!),
              _buildDetailItem('Interval Antar Dosis', vaccine['interval']!),
              _buildDetailItem('Tingkat Efikasi Uji Klinis', vaccine['efficacy']!),
              _buildDetailItem('Suhu Penyimpanan', vaccine['storage']!),
              _buildDetailItem('Catatan & Karakteristik', vaccine['notes']!),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4ADE80),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Tutup', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Color _getPlatformBadgeColor(String platform) {
    switch (platform) {
      case 'mRNA':
        return const Color(0xFF0284C7);
      case 'Viral Vector':
        return const Color(0xFF7C3AED);
      case 'Inactivated Virus':
        return const Color(0xFF0D9488);
      case 'Protein Subunit':
        return const Color(0xFFEA580C);
      default:
        return const Color(0xFF475569);
    }
  }

  Color _getPlatformBadgeBg(String platform) {
    switch (platform) {
      case 'mRNA':
        return const Color(0xFFE0F2FE);
      case 'Viral Vector':
        return const Color(0xFFEDE9FE);
      case 'Inactivated Virus':
        return const Color(0xFFCCFBF1);
      case 'Protein Subunit':
        return const Color(0xFFFFEDD5);
      default:
        return const Color(0xFFF1F5F9);
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredVaccines;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const AppStatusBar(),

            // Top App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 18),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Text(
                    'Info Vaksin',
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

            // Header Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        fontFamily: 'Roboto',
                      ),
                      children: [
                        TextSpan(
                          text: 'UPDATE! ',
                          style: TextStyle(color: Color(0xFF0284C7)),
                        ),
                        TextSpan(
                          text: '8 Jenis vaksin covid-19 ',
                        ),
                        TextSpan(
                          text: 'yang digunakan di Indonesia',
                          style: TextStyle(color: Color(0xFFF59E0B)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Daftar vaksin yang telah mendapat izin penggunaan darurat (EUA) oleh BPOM.',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),

            // Platform Filter Chips
            Container(
              height: 36,
              margin: const EdgeInsets.only(top: 8, bottom: 4),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _platforms.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final cat = _platforms[i];
                  final isSelected = _selectedPlatformFilter == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) {
                        setState(() => _selectedPlatformFilter = cat);
                      }
                    },
                    selectedColor: const Color(0xFF4ADE80),
                    backgroundColor: const Color(0xFFF8FAFC),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontSize: 11.5,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                    side: BorderSide(
                      color: isSelected ? const Color(0xFF4ADE80) : const Color(0xFFE2E8F0),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  );
                },
              ),
            ),

            // Mode Tampilan Toggle (Tabel Pas Layar, Tabel Lengkap 6-Kolom, Kartu)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                height: 38,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    _buildModeButton(0, 'Tabel Rapi', Icons.table_chart_rounded),
                    _buildModeButton(1, 'Tabel 6 Kolom', Icons.view_column_rounded),
                    _buildModeButton(2, 'Kartu', Icons.grid_view_rounded),
                  ],
                ),
              ),
            ),

            // Content Area
            Expanded(
              child: list.isEmpty
                  ? const Center(
                      child: Text('Tidak ada data vaksin untuk kategori ini.'),
                    )
                  : _buildActiveView(list),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeButton(int mode, String label, IconData icon) {
    final isSelected = _viewMode == mode;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _viewMode = mode),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 14,
                color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveView(List<Map<String, String>> list) {
    switch (_viewMode) {
      case 0:
        return _buildFittedTable(list);
      case 1:
        return _buildScrollableTable(list);
      case 2:
      default:
        return _buildCardView(list);
    }
  }

  // ==========================================================
  // VIEW 1: TABEL RAPI (FIT 100% LEBAR LAYAR, TIDAK TERPOTONG!)
  // ==========================================================
  Widget _buildFittedTable(List<Map<String, String>> list) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header Table Hijau Cerah
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFF4ADE80),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
                ),
                child: const Row(
                  children: [
                    SizedBox(
                      width: 24,
                      child: Text(
                        'No',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      flex: 6,
                      child: Text(
                        'Nama Vaksin',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      flex: 5,
                      child: Text(
                        'Platform',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    SizedBox(width: 6),
                    SizedBox(
                      width: 48,
                      child: Text(
                        'Efikasi',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Rows
              ...List.generate(list.length, (index) {
                final v = list[index];
                final isEven = index % 2 == 0;
                final badgeColor = _getPlatformBadgeColor(v['platform']!);
                final badgeBg = _getPlatformBadgeBg(v['platform']!);

                return InkWell(
                  onTap: () => _showVaccineDetailDialog(v),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: isEven ? const Color(0xFFF8FAFC) : Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: index == list.length - 1
                              ? Colors.transparent
                              : const Color(0xFFF1F5F9),
                        ),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 24,
                          child: Text(
                            '${index + 1}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                v['name']!,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                v['dose']!,
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          flex: 5,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: badgeBg,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                v['platform']!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  color: badgeColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        SizedBox(
                          width: 48,
                          child: Text(
                            v['efficacy']!,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF16A34A),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Center(
          child: Text(
            '💡 Ketuk baris mana saja untuk melihat rincian klinis vaksin.',
            style: TextStyle(fontSize: 11, color: AppColors.textMuted),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // ==========================================================
  // VIEW 2: TABEL LENGKAP 6 KOLOM DENGAN SCROLLBAR INTERAKTIF
  // ==========================================================
  Widget _buildScrollableTable(List<Map<String, String>> list) {
    return Column(
      children: [
        // Hint Geser
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFBBF7D0)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.swipe_right_rounded, size: 16, color: Color(0xFF16A34A)),
              SizedBox(width: 6),
              Text(
                'Geser tabel ke kanan untuk melihat Dosis, Interval, & Efikasi 👉',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF166534),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: DataTable(
                    columnSpacing: 18,
                    horizontalMargin: 12,
                    headingRowHeight: 44,
                    dataRowMinHeight: 46,
                    dataRowMaxHeight: 52,
                    headingRowColor: WidgetStateProperty.all(const Color(0xFF4ADE80)),
                    headingTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    columns: const [
                      DataColumn(label: Text('No')),
                      DataColumn(label: Text('Nama Vaksin')),
                      DataColumn(label: Text('Platform')),
                      DataColumn(label: Text('Dosis')),
                      DataColumn(label: Text('Interval')),
                      DataColumn(label: Text('Efikasi')),
                    ],
                    rows: List.generate(list.length, (index) {
                      final v = list[index];
                      final isEven = index % 2 == 0;
                      return DataRow(
                        color: WidgetStateProperty.all(
                          isEven ? const Color(0xFFF8FAFC) : Colors.white,
                        ),
                        cells: [
                          DataCell(Text('${index + 1}')),
                          DataCell(
                            InkWell(
                              onTap: () => _showVaccineDetailDialog(v),
                              child: Text(
                                v['name']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: _getPlatformBadgeBg(v['platform']!),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                v['platform']!,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: _getPlatformBadgeColor(v['platform']!),
                                ),
                              ),
                            ),
                          ),
                          DataCell(Text(v['dose']!)),
                          DataCell(Text(v['interval']!)),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                v['efficacy']!,
                                style: const TextStyle(
                                  color: Color(0xFF166534),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // VIEW 3: KARTU RINCI
  // ==========================================================
  Widget _buildCardView(List<Map<String, String>> list) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final v = list[index];
        final badgeColor = _getPlatformBadgeColor(v['platform']!);
        final badgeBg = _getPlatformBadgeBg(v['platform']!);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4ADE80),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      v['name']!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      v['efficacy']!,
                      style: const TextStyle(
                        color: Color(0xFF166534),
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Platform: ${v['platform']!}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: badgeColor,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Dosis: ${v['dose']!}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Interval: ${v['interval']!}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: const Color(0xFF0284C7),
                  ),
                  onPressed: () => _showVaccineDetailDialog(v),
                  icon: const Icon(Icons.info_outline, size: 14),
                  label: const Text('Detail Klinis', style: TextStyle(fontSize: 11.5)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
