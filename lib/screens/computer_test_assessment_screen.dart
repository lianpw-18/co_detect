import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/app_status_bar.dart';

class CompetencyItem {
  final int id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;

  const CompetencyItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
  });
}

class ComputerTestAssessmentScreen extends StatefulWidget {
  const ComputerTestAssessmentScreen({super.key});

  @override
  State<ComputerTestAssessmentScreen> createState() =>
      _ComputerTestAssessmentScreenState();
}

class _ComputerTestAssessmentScreenState
    extends State<ComputerTestAssessmentScreen> {
  // Candidate Metadata
  final String _docNo = 'FR.02-HRD.01(A)';
  final String _candidateName = 'Dila Rosa Apriliani';
  final String _position = 'Staff HRD';
  final String _testDate = '06 October 2026';
  final String _regNo = 'SG-20261006-18';
  final String _category = 'Staff';

  // Competency items from the reference UI
  final List<CompetencyItem> _competencies = const [
    CompetencyItem(
      id: 1,
      title: '1. Microsoft Excel & Rumus Dasar',
      subtitle: 'Pivot, VLOOKUP, IF, SUM, format tabel data',
      icon: Icons.table_chart_rounded,
      iconBg: Color(0xFFDCFCE7),
      iconColor: Color(0xFF16A34A),
    ),
    CompetencyItem(
      id: 2,
      title: '2. Microsoft Word & Dokumen Resmi',
      subtitle: 'Surat resmi, kop, formatting, mail merge',
      icon: Icons.description_rounded,
      iconBg: Color(0xFFE0F2FE),
      iconColor: Color(0xFF0284C7),
    ),
    CompetencyItem(
      id: 3,
      title: '3. PowerPoint & Presentasi',
      subtitle: 'Slide deck, animasi, desain presentasi',
      icon: Icons.co_present_rounded,
      iconBg: Color(0xFFFFEDD5),
      iconColor: Color(0xFFEA580C),
    ),
    CompetencyItem(
      id: 4,
      title: '4. Administrasi & Kearsipan',
      subtitle: 'Filing, pengarsipan, manajemen dokumen',
      icon: Icons.folder_open_rounded,
      iconBg: Color(0xFFF1F5F9),
      iconColor: Color(0xFF64748B),
    ),
    CompetencyItem(
      id: 5,
      title: '5. Petty Cash & Keuangan Dasar',
      subtitle: 'Kas kecil, reimbursement, laporan keuangan',
      icon: Icons.payments_rounded,
      iconBg: Color(0xFFCCFBF1),
      iconColor: Color(0xFF0D9488),
    ),
    CompetencyItem(
      id: 6,
      title: '6. Korespondensi Bisnis',
      subtitle: 'Email resmi, notulensi, tata bahasa bisnis',
      icon: Icons.mark_email_read_rounded,
      iconBg: Color(0xFFEDE9FE),
      iconColor: Color(0xFF7C3AED),
    ),
    CompetencyItem(
      id: 7,
      title: '7. Pelayanan Prima Kantor',
      subtitle: 'Etika kantor, SOP, komunikasi profesional',
      icon: Icons.support_agent_rounded,
      iconBg: Color(0xFFE0F2FE),
      iconColor: Color(0xFF0284C7),
    ),
  ];

  // Selected grades map: id -> 'A' | 'B' | 'C' | 'D'
  // Pre-filled with A (100) for item 1, B (80) for item 2 as shown in user's image
  final Map<int, String> _selectedGrades = {
    1: 'A',
    2: 'B',
  };

  final Map<String, int> _gradeScores = const {
    'A': 100,
    'B': 80,
    'C': 60,
    'D': 40,
  };

  final Map<String, Color> _gradeColors = const {
    'A': Color(0xFF16A34A),
    'B': Color(0xFF0284C7),
    'C': Color(0xFFD97706),
    'D': Color(0xFFDC2626),
  };

  final Map<String, Color> _gradeBgColors = const {
    'A': Color(0xFFDCFCE7),
    'B': Color(0xFFE0F2FE),
    'C': Color(0xFFFEF3C7),
    'D': Color(0xFFFEE2E2),
  };

  double get _averageScore {
    if (_selectedGrades.isEmpty) return 0.0;
    int total = 0;
    _selectedGrades.forEach((_, grade) {
      total += _gradeScores[grade] ?? 0;
    });
    return total / _selectedGrades.length;
  }

  String get _overallPredicate {
    final avg = _averageScore;
    if (_selectedGrades.isEmpty) return 'Belum Lengkap';
    if (avg >= 85) return 'Sangat Baik (LULUS)';
    if (avg >= 70) return 'Baik (LULUS)';
    if (avg >= 55) return 'Cukup (PERTIMBANGAN)';
    return 'Kurang (TIDAK LULUS)';
  }

  Color get _predicateColor {
    final avg = _averageScore;
    if (avg >= 85) return const Color(0xFF16A34A);
    if (avg >= 70) return const Color(0xFF0284C7);
    if (avg >= 55) return const Color(0xFFD97706);
    return const Color(0xFFDC2626);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            const AppStatusBar(),
            // Top Navigation & Back
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 18),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Text(
                    'Formulir Penilaian Staff',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Reset Penilaian',
                    icon: const Icon(Icons.refresh_rounded, size: 22),
                    onPressed: _showResetConfirmation,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                children: [
                  // 1. Blue Header Banner Card
                  _buildHeaderBanner(),
                  const SizedBox(height: 16),

                  // 2. Info Cards (Tanggal, Registrasi, Kategori)
                  _buildInfoCards(),
                  const SizedBox(height: 20),

                  // 3. Competency Evaluation Cards (Items 1 to 7)
                  ..._competencies.map((comp) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildCompetencyRow(comp),
                    );
                  }),
                  const SizedBox(height: 16),

                  // 4. Score Summary & Result Card
                  _buildScoreSummaryCard(),
                  const SizedBox(height: 20),

                  // 5. Submit & Action Buttons
                  _buildActionButtons(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== 1. BLUE HEADER BANNER ====================
  Widget _buildHeaderBanner() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D4ED8).withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo Circle Emblem
              Container(
                width: 46,
                height: 46,
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.stars_rounded,
                  color: Color(0xFF1D4ED8),
                  size: 30,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Formulir Penilaian Tes Komputer Staff',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Evaluasi 7 kompetensi administrasi & komputer perkantoran – Tahap 2 On-Site (Staff)',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Colors.white.withValues(alpha: 0.9),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Badges Row
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildHeaderBadge(label: 'No Dok', value: _docNo),
              _buildHeaderBadge(label: 'Kandidat', value: _candidateName),
              _buildHeaderBadge(label: 'Posisi', value: _position),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBadge({required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ==================== 2. INFO METADATA CARDS ====================
  Widget _buildInfoCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 600;
        if (isNarrow) {
          return Column(
            children: [
              _buildSingleInfoCard(
                title: 'Tanggal Tes',
                value: _testDate,
                icon: Icons.calendar_today_outlined,
              ),
              const SizedBox(height: 8),
              _buildSingleInfoCard(
                title: 'No. Registrasi',
                value: _regNo,
                icon: Icons.confirmation_number_outlined,
              ),
              const SizedBox(height: 8),
              _buildSingleInfoCard(
                title: 'Kategori Posisi',
                value: _category,
                icon: Icons.badge_outlined,
                showIconInValue: true,
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: _buildSingleInfoCard(
                title: 'Tanggal Tes',
                value: _testDate,
                icon: Icons.calendar_today_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSingleInfoCard(
                title: 'No. Registrasi',
                value: _regNo,
                icon: Icons.confirmation_number_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSingleInfoCard(
                title: 'Kategori Posisi',
                value: _category,
                icon: Icons.badge_outlined,
                showIconInValue: true,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSingleInfoCard({
    required String title,
    required String value,
    required IconData icon,
    bool showIconInValue = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              if (showIconInValue) ...[
                const Icon(
                  Icons.desktop_windows_outlined,
                  size: 15,
                  color: Color(0xFF2563EB),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==================== 3. COMPETENCY ROW WITH A/B/C/D BUTTONS ====================
  Widget _buildCompetencyRow(CompetencyItem comp) {
    final selectedGrade = _selectedGrades[comp.id];
    final score = selectedGrade != null ? _gradeScores[selectedGrade] : null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: selectedGrade != null
              ? (_gradeColors[selectedGrade] ?? const Color(0xFFE2E8F0)).withValues(alpha: 0.3)
              : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 500;

          final competencyInfo = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: comp.iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(comp.icon, color: comp.iconColor, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comp.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      comp.subtitle,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );

          final gradingControls = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildGradeButton(comp.id, 'A'),
              const SizedBox(width: 6),
              _buildGradeButton(comp.id, 'B'),
              const SizedBox(width: 6),
              _buildGradeButton(comp.id, 'C'),
              const SizedBox(width: 6),
              _buildGradeButton(comp.id, 'D'),
              const SizedBox(width: 16),
              // Numeric Score Label
              SizedBox(
                width: 38,
                child: Text(
                  score != null ? '$score' : '—',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: score != null
                        ? (_gradeColors[selectedGrade] ?? const Color(0xFF2563EB))
                        : AppColors.textMuted,
                  ),
                ),
              ),
            ],
          );

          if (isSmallScreen) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                competencyInfo,
                const SizedBox(height: 14),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                const SizedBox(height: 12),
                Center(child: gradingControls),
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: competencyInfo),
              const SizedBox(width: 16),
              gradingControls,
            ],
          );
        },
      ),
    );
  }

  Widget _buildGradeButton(int competencyId, String grade) {
    final isSelected = _selectedGrades[competencyId] == grade;
    final baseColor = _gradeColors[grade] ?? const Color(0xFF2563EB);
    final bgColor = _gradeBgColors[grade] ?? const Color(0xFFE0F2FE);

    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedGrades.remove(competencyId);
          } else {
            _selectedGrades[competencyId] = grade;
          }
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? bgColor : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? baseColor : const Color(0xFFCBD5E1),
            width: isSelected ? 2.0 : 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: baseColor.withValues(alpha: 0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          grade,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
            color: isSelected ? baseColor : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  // ==================== 4. SCORE SUMMARY CARD ====================
  Widget _buildScoreSummaryCard() {
    final gradedCount = _selectedGrades.length;
    final totalCount = _competencies.length;
    final avg = _averageScore;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Kalkulasi Nilai Otomatis',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '$gradedCount dari $totalCount Dinilai',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: gradedCount == totalCount
                      ? const Color(0xFF16A34A)
                      : const Color(0xFF2563EB),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Progress Indicator
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: totalCount > 0 ? gradedCount / totalCount : 0.0,
              minHeight: 8,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: AlwaysStoppedAnimation<Color>(
                gradedCount == totalCount
                    ? const Color(0xFF16A34A)
                    : const Color(0xFF2563EB),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Rata-rata Nilai:',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    gradedCount > 0 ? avg.toStringAsFixed(1) : '—',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: _predicateColor,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Status Kelulusan:',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _predicateColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _overallPredicate,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _predicateColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==================== 5. ACTION BUTTONS ====================
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: _submitAssessment,
            icon: const Icon(Icons.check_circle_outline, size: 20),
            label: const Text(
              'Simpan Penilaian',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.2),
              foregroundColor: const Color(0xFF475569),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Laporan siap dicetak atau diekspor ke PDF.'),
                  backgroundColor: Color(0xFF0284C7),
                ),
              );
            },
            icon: const Icon(Icons.print_outlined, size: 18),
            label: const Text(
              'Cetak',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  void _submitAssessment() {
    if (_selectedGrades.length < _competencies.length) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Penilaian Belum Lengkap'),
          content: Text(
            'Baru ${_selectedGrades.length} dari ${_competencies.length} kompetensi yang dinilai. Tetap simpan?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Lengkapi Dulu'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(ctx);
                _finalizeSave();
              },
              child: const Text('Ya, Simpan'),
            ),
          ],
        ),
      );
    } else {
      _finalizeSave();
    }
  }

  void _finalizeSave() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Hasil penilaian untuk $_candidateName berhasil disimpan! Rata-rata: ${_averageScore.toStringAsFixed(1)} ($_overallPredicate)',
        ),
        backgroundColor: const Color(0xFF16A34A),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showResetConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Reset Nilai?'),
        content: const Text(
          'Semua pilihan nilai A/B/C/D yang telah diisi akan dikosongkan kembali.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _selectedGrades.clear();
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Nilai berhasil di-reset.'),
                ),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
