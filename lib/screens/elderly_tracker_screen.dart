import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/user_session.dart';
import '../theme/app_colors.dart';
import '../widgets/app_status_bar.dart';

class ElderlyTrackerScreen extends StatefulWidget {
  const ElderlyTrackerScreen({super.key});

  @override
  State<ElderlyTrackerScreen> createState() => _ElderlyTrackerScreenState();
}

class _ElderlyTrackerScreenState extends State<ElderlyTrackerScreen> {
  String _selectedMemberId = '1';

  @override
  void initState() {
    super.initState();
    final members = UserSession.instance.elderlyMembers;
    if (members.isNotEmpty) {
      _selectedMemberId = members.first.id;
    }
  }

  void _triggerEmergencySos() async {
    final session = UserSession.instance;
    final member = session.elderlyMembers.firstWhere(
      (m) => m.id == _selectedMemberId,
      orElse: () => session.elderlyMembers.isNotEmpty
          ? session.elderlyMembers.first
          : const ElderlyMember(
              id: '0',
              name: 'Anggota Keluarga',
              age: '',
              relation: '',
              status: '',
              comorbidity: '',
            ),
    );

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Color(0xFFDC2626), size: 28),
            SizedBox(width: 10),
            Text(
              'Panggilan Darurat SOS',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFDC2626),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mengaktifkan protokol darurat untuk ${member.name} (${member.relation}).',
              style: const TextStyle(fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFECACA)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pilihan Tindakan Cepat:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF991B1B),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '• Hubungi Ambulans Nasional 119\n• Hubungi Kontak Keluarga (${'+628170247210'})\n• Kirim Lokasi GPS via Pesan/WhatsApp',
                    style: TextStyle(fontSize: 11.5, color: Color(0xFF7F1D1D), height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text('Batal', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              Navigator.of(dialogCtx).pop();
              final uri = Uri.parse('tel:119');
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
            },
            icon: const Icon(Icons.call, size: 16),
            label: const Text('Panggil 119', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showAddVitalDialog() {
    final systolicCtrl = TextEditingController(text: '120');
    final diastolicCtrl = TextEditingController(text: '80');
    final sugarCtrl = TextEditingController(text: '105');
    final spo2Ctrl = TextEditingController(text: '98');
    final tempCtrl = TextEditingController(text: '36.5');
    final hrCtrl = TextEditingController(text: '75');
    final notesCtrl = TextEditingController();

    final session = UserSession.instance;
    final currentMember = session.elderlyMembers.firstWhere(
      (m) => m.id == _selectedMemberId,
      orElse: () => session.elderlyMembers.first,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
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
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFDCFCE7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.favorite_rounded, color: Color(0xFF16A34A), size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Catat Tanda Vital Baru',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Pasien: ${currentMember.name}',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _buildNumericField('Tensi Sistolik', systolicCtrl, 'mmHg', '120'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildNumericField('Tensi Diastolik', diastolicCtrl, 'mmHg', '80'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildNumericField('Gula Darah', sugarCtrl, 'mg/dL', '100'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildNumericField('Saturasi O2', spo2Ctrl, '%', '98'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildNumericField('Suhu Badan', tempCtrl, '°C', '36.5'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildNumericField('Detak Jantung', hrCtrl, 'bpm', '75'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesCtrl,
                  decoration: InputDecoration(
                    labelText: 'Catatan Tambahan (opsional)',
                    hintText: 'Misal: Tensi diukur setelah minum obat pagi',
                    labelStyle: const TextStyle(fontSize: 12),
                    hintStyle: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      final sys = int.tryParse(systolicCtrl.text) ?? 120;
                      final dia = int.tryParse(diastolicCtrl.text) ?? 80;
                      final sugar = int.tryParse(sugarCtrl.text) ?? 100;
                      final spo2 = int.tryParse(spo2Ctrl.text) ?? 98;
                      final temp = double.tryParse(tempCtrl.text) ?? 36.5;
                      final hr = int.tryParse(hrCtrl.text) ?? 75;

                      final record = VitalSignRecord(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        memberId: currentMember.id,
                        memberName: currentMember.name,
                        date: 'Hari ini, ${TimeOfDay.now().format(context)}',
                        systolic: sys,
                        diastolic: dia,
                        heartRate: hr,
                        temperature: temp,
                        oxygenSaturation: spo2,
                        bloodSugar: sugar,
                        notes: notesCtrl.text.trim().isNotEmpty
                            ? notesCtrl.text.trim()
                            : 'Pencatatan tanda vital berkala',
                      );

                      UserSession.instance.addVitalSignRecord(record);
                      Navigator.of(ctx).pop();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tanda vital berhasil disimpan!'),
                          backgroundColor: Color(0xFF16A34A),
                        ),
                      );
                    },
                    child: const Text('Simpan Rekam Vital', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNumericField(
    String label,
    TextEditingController controller,
    String unit,
    String hint,
  ) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        suffixText: unit,
        hintText: hint,
        labelStyle: const TextStyle(fontSize: 12),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        isDense: true,
      ),
    );
  }

  void _showAddMedicineDialog() {
    final nameCtrl = TextEditingController();
    final dosageCtrl = TextEditingController(text: '1 tablet sesudah makan');
    final timeCtrl = TextEditingController(text: '08:00 WIB');
    final notesCtrl = TextEditingController();

    final session = UserSession.instance;
    final currentMember = session.elderlyMembers.firstWhere(
      (m) => m.id == _selectedMemberId,
      orElse: () => session.elderlyMembers.first,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
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
              const Text(
                'Tambah Jadwal Minum Obat',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'Untuk: ${currentMember.name}',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Nama Obat',
                  hintText: 'Misal: Amlodipine 5mg / Vitamin D3',
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: dosageCtrl,
                      decoration: InputDecoration(
                        labelText: 'Dosis & Aturan',
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: timeCtrl,
                      decoration: InputDecoration(
                        labelText: 'Jam Minum',
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: notesCtrl,
                decoration: InputDecoration(
                  labelText: 'Keterangan Tambahan',
                  hintText: 'Misal: Diminum sesudah makan pagi',
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (nameCtrl.text.trim().isEmpty) return;

                    final reminder = MedicationReminder(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      memberId: currentMember.id,
                      memberName: currentMember.name,
                      medicineName: nameCtrl.text.trim(),
                      dosage: dosageCtrl.text.trim(),
                      timeOfDay: timeCtrl.text.trim(),
                      notes: notesCtrl.text.trim(),
                    );

                    UserSession.instance.addMedicationReminder(reminder);
                    Navigator.of(ctx).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Jadwal obat berhasil ditambahkan!'),
                        backgroundColor: Color(0xFF16A34A),
                      ),
                    );
                  },
                  child: const Text('Simpan Jadwal Obat', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            const AppStatusBar(),
            // Top App Bar
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 18),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Text(
                    'Pemantauan Lansia & Keluarga',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Bantuan Darurat SOS',
                    icon: const Icon(Icons.emergency_rounded, color: Color(0xFFDC2626), size: 26),
                    onPressed: _triggerEmergencySos,
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListenableBuilder(
                listenable: UserSession.instance,
                builder: (context, _) {
                  final session = UserSession.instance;
                  final members = session.elderlyMembers;

                  if (members.isEmpty) {
                    return const Center(
                      child: Text('Belum ada data lansia binaan.'),
                    );
                  }

                  final selectedMember = members.firstWhere(
                    (m) => m.id == _selectedMemberId,
                    orElse: () => members.first,
                  );

                  final vitals = session.vitalSignRecords
                      .where((v) => v.memberId == selectedMember.id)
                      .toList();

                  final latestVital = vitals.isNotEmpty ? vitals.first : null;

                  final meds = session.medicationReminders
                      .where((m) => m.memberId == selectedMember.id)
                      .toList();

                  final takenMeds = meds.where((m) => m.isTaken).length;

                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // 1. Elderly Member Chips Selector
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: members.map((m) {
                            final isSelected = m.id == _selectedMemberId;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text('${m.name} (${m.relation})'),
                                selected: isSelected,
                                selectedColor: AppColors.primaryLight,
                                labelStyle: TextStyle(
                                  color: isSelected ? AppColors.primaryDark : AppColors.textSecondary,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  fontSize: 12.5,
                                ),
                                side: BorderSide(
                                  color: isSelected ? AppColors.primary : const Color(0xFFCBD5E1),
                                ),
                                onSelected: (val) {
                                  if (val) {
                                    setState(() {
                                      _selectedMemberId = m.id;
                                    });
                                  }
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // 2. Member Status Card & Quick SOS
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0F766E), Color(0xFF0D9488)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0F766E).withValues(alpha: 0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.person, color: Colors.white, size: 24),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        selectedMember.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        'Usia ${selectedMember.age} • ${selectedMember.comorbidity}',
                                        style: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.85),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.25),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    selectedMember.status,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFEF4444),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: _triggerEmergencySos,
                                    icon: const Icon(Icons.sos_rounded, size: 18),
                                    label: const Text(
                                      'Tombol Darurat SOS',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: const Color(0xFF0F766E),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: _showAddVitalDialog,
                                    icon: const Icon(Icons.add_circle_outline, size: 18),
                                    label: const Text(
                                      'Catat Tanda Vital',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 3. Vital Signs Grid
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Tanda Vital Terakhir',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          if (latestVital != null)
                            Text(
                              latestVital.date,
                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      if (latestVital != null) ...[
                        Row(
                          children: [
                            Expanded(
                              child: _buildVitalCard(
                                title: 'Tekanan Darah',
                                value: '${latestVital.systolic}/${latestVital.diastolic}',
                                unit: 'mmHg',
                                status: latestVital.systolic > 140
                                    ? 'Waspada Tinggi'
                                    : 'Normal Terkontrol',
                                icon: Icons.favorite_rounded,
                                color: const Color(0xFFE11D48),
                                bgColor: const Color(0xFFFFF1F2),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildVitalCard(
                                title: 'Gula Darah',
                                value: '${latestVital.bloodSugar}',
                                unit: 'mg/dL',
                                status: latestVital.bloodSugar > 130
                                    ? 'Sedikit Naik'
                                    : 'Normal',
                                icon: Icons.water_drop_rounded,
                                color: const Color(0xFF0284C7),
                                bgColor: const Color(0xFFE0F2FE),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _buildVitalCard(
                                title: 'Saturasi Oksigen',
                                value: '${latestVital.oxygenSaturation}',
                                unit: '%',
                                status: latestVital.oxygenSaturation >= 95
                                    ? 'Aman Optimal'
                                    : 'Perlu Oksigen',
                                icon: Icons.air_rounded,
                                color: const Color(0xFF16A34A),
                                bgColor: const Color(0xFFDCFCE7),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildVitalCard(
                                title: 'Suhu Tubuh',
                                value: '${latestVital.temperature}',
                                unit: '°C',
                                status: latestVital.temperature > 37.5 ? 'Demam' : 'Suhu Normal',
                                icon: Icons.thermostat_rounded,
                                color: const Color(0xFFD97706),
                                bgColor: const Color(0xFFFEF3C7),
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Center(
                            child: TextButton.icon(
                              onPressed: _showAddVitalDialog,
                              icon: const Icon(Icons.add, color: AppColors.primary),
                              label: const Text('Belum ada rekam tanda vital. Tekan untuk mencatat.'),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 22),

                      // 4. Medication Checklist Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Jadwal Minum Obat',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '$takenMeds dari ${meds.length} obat diminum hari ini',
                                style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                          TextButton.icon(
                            onPressed: _showAddMedicineDialog,
                            icon: const Icon(Icons.add, size: 16),
                            label: const Text('Tambah Obat', style: TextStyle(fontSize: 12)),
                            style: TextButton.styleFrom(foregroundColor: AppColors.primaryDark),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: meds.isEmpty ? 0 : takenMeds / meds.length,
                          backgroundColor: const Color(0xFFE2E8F0),
                          color: AppColors.primary,
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 12),

                      if (meds.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Center(
                            child: Text(
                              'Belum ada jadwal obat untuk lansia ini.',
                              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                            ),
                          ),
                        )
                      else
                        ...meds.map((med) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: med.isTaken
                                    ? const Color(0xFFBBF7D0)
                                    : const Color(0xFFE2E8F0),
                              ),
                            ),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: med.isTaken,
                                  activeColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  onChanged: (_) {
                                    session.toggleMedicationTaken(med.id);
                                  },
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        med.medicineName,
                                        style: TextStyle(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.bold,
                                          decoration: med.isTaken
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                          color: med.isTaken
                                              ? AppColors.textMuted
                                              : AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${med.dosage} • ${med.timeOfDay}',
                                        style: const TextStyle(
                                          fontSize: 11.5,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      if (med.notes.isNotEmpty)
                                        Text(
                                          med.notes,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.textMuted,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 18, color: Color(0xFF94A3B8)),
                                  onPressed: () {
                                    session.deleteMedicationReminder(med.id);
                                  },
                                ),
                              ],
                            ),
                          );
                        }),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalCard({
    required String title,
    required String value,
    required String unit,
    required String status,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
