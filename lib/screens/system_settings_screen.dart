import 'package:flutter/material.dart';
import '../services/user_session.dart';
import '../theme/app_colors.dart';
import '../widgets/app_status_bar.dart';

class SystemSettingsScreen extends StatefulWidget {
  const SystemSettingsScreen({super.key});

  @override
  State<SystemSettingsScreen> createState() => _SystemSettingsScreenState();
}

class _SystemSettingsScreenState extends State<SystemSettingsScreen> {
  bool _is2FAEnabled = false;
  String _selectedLanguage = 'Bahasa Indonesia';

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
                      }
                    },
                  ),
                  const Text(
                    'Sistem',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                children: [
                  // Section 1: Informasi Umum
                  const Text(
                    'Informasi Umum',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuTile(
                    icon: Icons.person_search_outlined,
                    title: 'Profil Terkait',
                    subtitle: 'Kelola akun keluarga & lansia terhubung',
                    onTap: () => _showLinkedProfilesSheet(context),
                  ),
                  const SizedBox(height: 8),
                  _buildMenuTile(
                    icon: Icons.phone_in_talk_outlined,
                    title: 'Nomor Darurat Terdekat (119)',
                    subtitle: 'Hotline ambulans & faskes siaga Covid-19',
                    onTap: () => _showEmergencyDialog(context),
                  ),
                  const SizedBox(height: 8),
                  _buildMenuTile(
                    icon: Icons.info_outline,
                    title: 'Tentang Co-Detect',
                    subtitle: 'Informasi aplikasi & pengembang UAS IMK',
                    onTap: () => _showAboutDialog(context),
                  ),
                  const SizedBox(height: 8),
                  _buildMenuTile(
                    icon: Icons.language_outlined,
                    title: 'Pilihan Bahasa',
                    subtitle: _selectedLanguage,
                    onTap: () => _showLanguageDialog(context),
                  ),

                  const SizedBox(height: 24),

                  // Section 2: Keamanan
                  const Text(
                    'Keamanan',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuTile(
                    icon: Icons.lock_outline,
                    title: 'Ganti Kata Sandi',
                    subtitle: 'Perbarui kata sandi akun',
                    onTap: () => _showChangePasswordDialog(context),
                  ),
                  const SizedBox(height: 8),
                  _buildMenuTile(
                    icon: Icons.security_outlined,
                    title: 'Aktifkan Keamanan Ganda (2FA)',
                    subtitle: _is2FAEnabled ? 'Aktif (Aman)' : 'Belum Aktif',
                    badge: _is2FAEnabled ? 'AKTIF' : null,
                    badgeColor: const Color(0xFF16A34A),
                    onTap: () => _showTwoFactorAuthDialog(context),
                  ),
                  const SizedBox(height: 8),
                  _buildMenuTile(
                    icon: Icons.help_outline,
                    title: 'Pusat Bantuan & FAQ',
                    subtitle: 'Tanya jawab seputar skrining & vaksin',
                    onTap: () => _showFaqDialog(context),
                  ),
                  const SizedBox(height: 24),

                  // Section 3: Tampilan & Aksesibilitas
                  const Text(
                    'Tampilan & Aksesibilitas',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListenableBuilder(
                    listenable: UserSession.instance,
                    builder: (context, _) {
                      final session = UserSession.instance;
                      return Column(
                        children: [
                          Material(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(14),
                            child: SwitchListTile(
                              secondary: const Icon(
                                Icons.elderly_rounded,
                                color: Color(0xFF0D9488),
                                size: 24,
                              ),
                              title: const Text(
                                'Mode Ramah Lansia',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              subtitle: const Text(
                                'Perbesar font & perjelas kontras elemen aplikasi',
                                style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                              ),
                              value: session.isSeniorFriendlyMode,
                              activeThumbColor: const Color(0xFF0D9488),
                              onChanged: (val) {
                                session.toggleSeniorFriendlyMode(val);
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          Material(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(14),
                            child: SwitchListTile(
                              secondary: const Icon(
                                Icons.dark_mode_outlined,
                                color: Color(0xFF6366F1),
                                size: 24,
                              ),
                              title: const Text(
                                'Mode Gelap (Dark Mode)',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              subtitle: const Text(
                                'Tampilan gelap nyaman untuk penglihatan malam hari',
                                style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                              ),
                              value: session.isDarkMode,
                              activeThumbColor: const Color(0xFF6366F1),
                              onChanged: (val) {
                                session.toggleDarkMode(val);
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    String? subtitle,
    String? badge,
    Color? badgeColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: const Color(0xFFF1F5F9),
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        leading: Icon(icon, color: const Color(0xFF475569), size: 22),
        title: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: (badgeColor ?? const Color(0xFF16A34A)).withValues(
                    alpha: 0.15,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: badgeColor ?? const Color(0xFF16A34A),
                  ),
                ),
              ),
          ],
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              )
            : null,
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: AppColors.textMuted,
        ),
        onTap: onTap,
      ),
    );
  }

  // ==================== 1. PROFIL TERKAIT ====================
  void _showLinkedProfilesSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) {
        final session = UserSession.instance;
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
              const SizedBox(height: 16),
              const Text(
                'Profil Terkait & Anggota Keluarga',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Akun dan lansia binaan yang terdaftar pada perangkat ini',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              // Profil Utama
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF86EFAC)),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Color(0xFF16A34A),
                      radius: 20,
                      child: Icon(Icons.person, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                session.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.5,
                                  color: Color(0xFF166534),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF16A34A),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Akun Utama',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            session.email,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF166534),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.check_circle,
                      color: Color(0xFF16A34A),
                      size: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Lansia Binaan / Anggota Lain
              ...session.elderlyMembers.map(
                (member) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Color(0xFFE2E8F0),
                        radius: 18,
                        child: Icon(
                          Icons.elderly,
                          color: Color(0xFF475569),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${member.name} (${member.relation})',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              '${member.age} • ${member.status}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          minimumSize: const Size(0, 32),
                          side: const BorderSide(color: Color(0xFF22C55E)),
                        ),
                        onPressed: () {
                          Navigator.pop(sheetCtx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Beralih ke pemantauan: ${member.name}',
                              ),
                              backgroundColor: const Color(0xFF22C55E),
                            ),
                          );
                        },
                        child: const Text(
                          'Pilih',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF16A34A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF22C55E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(sheetCtx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Untuk menambah lansia baru, gunakan menu Profil > Lansia Binaan.',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Tambah Anggota Keluarga'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==================== 2. NOMOR DARURAT ====================
  void _showEmergencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.emergency_outlined, color: Color(0xFFEF4444)),
            SizedBox(width: 8),
            Text('Nomor Darurat Covid-19', style: TextStyle(fontSize: 17)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hubungi nomor darurat terdekat jika mengalami gejala darurat atau butuh ambulans:',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 14),
            _buildContactRow(
              ctx,
              name: 'Hotline Kemenkes RI',
              number: '119 Ext 9',
              icon: Icons.phone_in_talk,
              color: const Color(0xFFEF4444),
            ),
            const SizedBox(height: 10),
            _buildContactRow(
              ctx,
              name: 'Layanan Ambulans Gawat Darurat',
              number: '118',
              icon: Icons.local_hospital,
              color: const Color(0xFF0284C7),
            ),
            const SizedBox(height: 10),
            _buildContactRow(
              ctx,
              name: 'Satgas Penanganan Covid-19',
              number: '119',
              icon: Icons.shield_outlined,
              color: const Color(0xFF16A34A),
            ),
            const SizedBox(height: 10),
            _buildContactRow(
              ctx,
              name: 'Palang Merah Indonesia (PMI)',
              number: '021-7992325',
              icon: Icons.medical_services_outlined,
              color: const Color(0xFFD97706),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF22C55E),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(
    BuildContext context, {
    required String name,
    required String number,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  number,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.call, size: 18),
            color: color,
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Menghubungkan ke $name ($number)...'),
                  backgroundColor: color,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ==================== 3. TENTANG CO-DETECT ====================
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.coronavirus_outlined, color: Color(0xFF22C55E)),
            SizedBox(width: 8),
            Text('Tentang Co-Detect', style: TextStyle(fontSize: 17)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.health_and_safety,
                    color: Color(0xFF16A34A),
                    size: 32,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CO-DETECT',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            color: Color(0xFF166534),
                          ),
                        ),
                        Text(
                          'Lansia Care & Covid-19 Screening',
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
            const SizedBox(height: 14),
            const Text(
              'Aplikasi deteksi dini gejala Covid-19 dan pemantauan kesehatan digital ramah keluarga, dirancang khusus untuk memprioritaskan keselamatan lansia.',
              style: TextStyle(
                fontSize: 12.5,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            const Text(
              '• Versi Aplikasi: 1.0.0 (Release)\n'
              '• Desain Antarmuka: UAS Interaksi Manusia & Komputer (IMK)\n'
              '• Framework: Flutter 3 & Dart SDK\n'
              '• Hak Cipta © 2026 Co-Detect Dev Team',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF22C55E),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // ==================== 4. PILIHAN BAHASA ====================
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Pilih Bahasa', style: TextStyle(fontSize: 17)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: _selectedLanguage == 'Bahasa Indonesia'
                  ? const Color(0xFFDCFCE7)
                  : const Color(0xFFF8FAFC),
              title: const Text('Bahasa Indonesia'),
              trailing: _selectedLanguage == 'Bahasa Indonesia'
                  ? const Icon(Icons.check, color: Color(0xFF16A34A))
                  : null,
              onTap: () {
                setState(() => _selectedLanguage = 'Bahasa Indonesia');
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Bahasa diubah ke Bahasa Indonesia'),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: _selectedLanguage == 'English (US)'
                  ? const Color(0xFFDCFCE7)
                  : const Color(0xFFF8FAFC),
              title: const Text('English (US)'),
              trailing: _selectedLanguage == 'English (US)'
                  ? const Icon(Icons.check, color: Color(0xFF16A34A))
                  : null,
              onTap: () {
                setState(() => _selectedLanguage = 'English (US)');
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Language changed to English (US)'),
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  // ==================== 5. GANTI KATA SANDI ====================
  void _showChangePasswordDialog(BuildContext context) {
    final oldPassCtrl = TextEditingController();
    final newPassCtrl = TextEditingController();
    final confirmPassCtrl = TextEditingController();
    bool obscure = true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Row(
              children: [
                Icon(Icons.lock_reset_rounded, color: Color(0xFF16A34A)),
                SizedBox(width: 8),
                Text('Ganti Kata Sandi', style: TextStyle(fontSize: 17)),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: oldPassCtrl,
                    obscureText: obscure,
                    decoration: InputDecoration(
                      labelText: 'Kata Sandi Lama',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 18,
                        ),
                        onPressed: () {
                          setDialogState(() => obscure = !obscure);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: newPassCtrl,
                    obscureText: obscure,
                    decoration: const InputDecoration(
                      labelText: 'Kata Sandi Baru (min. 6 karakter)',
                      prefixIcon: Icon(Icons.vpn_key_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: confirmPassCtrl,
                    obscureText: obscure,
                    decoration: const InputDecoration(
                      labelText: 'Konfirmasi Sandi Baru',
                      prefixIcon: Icon(Icons.check_circle_outline),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22C55E),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (oldPassCtrl.text.isEmpty || newPassCtrl.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Harap lengkapi semua kolom sandi'),
                        backgroundColor: Color(0xFFEF4444),
                      ),
                    );
                    return;
                  }
                  if (newPassCtrl.text.length < 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Kata sandi baru minimal 6 karakter'),
                        backgroundColor: Color(0xFFEF4444),
                      ),
                    );
                    return;
                  }
                  if (newPassCtrl.text != confirmPassCtrl.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Konfirmasi kata sandi tidak cocok'),
                        backgroundColor: Color(0xFFEF4444),
                      ),
                    );
                    return;
                  }

                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Kata sandi berhasil diperbarui!'),
                      backgroundColor: Color(0xFF22C55E),
                    ),
                  );
                },
                child: const Text('Perbarui'),
              ),
            ],
          );
        },
      ),
    );
  }

  // ==================== 6. DUA FAKTOR (2FA) ====================
  void _showTwoFactorAuthDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Row(
              children: [
                Icon(Icons.security_rounded, color: Color(0xFF0284C7)),
                SizedBox(width: 8),
                Text('Keamanan Ganda (2FA)', style: TextStyle(fontSize: 17)),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Otentikasi Dua Faktor (2FA) melindungi akun Anda dengan kode verifikasi OTP saat masuk perangkat baru.',
                  style: TextStyle(fontSize: 12.5),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Status 2FA:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Switch(
                        value: _is2FAEnabled,
                        activeThumbColor: const Color(0xFF22C55E),
                        onChanged: (val) {
                          setDialogState(() {
                            _is2FAEnabled = val;
                          });
                          setState(() {
                            _is2FAEnabled = val;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                if (_is2FAEnabled)
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.verified_user,
                          color: Color(0xFF16A34A),
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'OTP akan dikirim ke WhatsApp / SMS nomor aktif Anda.',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF166534),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22C55E),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _is2FAEnabled
                            ? 'Keamanan Ganda (2FA) berhasil diaktifkan!'
                            : 'Keamanan Ganda (2FA) dinonaktifkan.',
                      ),
                      backgroundColor: _is2FAEnabled
                          ? const Color(0xFF22C55E)
                          : const Color(0xFF64748B),
                    ),
                  );
                },
                child: const Text('Simpan'),
              ),
            ],
          );
        },
      ),
    );
  }

  // ==================== 7. PUSAT BANTUAN & FAQ ====================
  void _showFaqDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.help_center_outlined, color: Color(0xFF16A34A)),
            SizedBox(width: 8),
            Text('Pusat Bantuan & FAQ', style: TextStyle(fontSize: 17)),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildFaqItem(
                  question: 'Apa fungsi utama aplikasi Co-Detect?',
                  answer:
                      'Co-Detect dirancang untuk membantu deteksi dini mandiri risiko penularan Covid-19 serta mempermudah keluarga memantau status kesehatan lansia yang rentan komorbid.',
                ),
                _buildFaqItem(
                  question: 'Bagaimana cara mengisi skrining gejala?',
                  answer:
                      'Masuk ke menu Beranda, lalu pilih "Tanya Gejala". Jawab pertanyaan seputar kondisi demam, batuk, anosmia, dan riwayat kontak secara jujur.',
                ),
                _buildFaqItem(
                  question: 'Apakah hasil skrining menggantikan tes PCR/Swab?',
                  answer:
                      'Tidak. Skrining mandiri berfungsi sebagai penilaian awal (triage). Jika berisiko tinggi, segera periksakan diri ke fasilitas kesehatan terdekat.',
                ),
                _buildFaqItem(
                  question: 'Bagaimana cara memantau lansia keluarga?',
                  answer:
                      'Buka menu Profil > Lansia Binaan > tekan "+ Tambah". Anda dapat mendaftarkan riwayat penyakit penyerta dan memantau status hariannya.',
                ),
                _buildFaqItem(
                  question: 'Ke mana harus melapor jika kondisi darurat?',
                  answer:
                      'Gunakan menu "Nomor Darurat Terdekat (119)" untuk langsung terhubung dengan hotline tanggap darurat Covid-19 atau ambulans 118.',
                ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF22C55E),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem({required String question, required String answer}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: const Color(0xFF16A34A),
          title: Text(
            question,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Text(
                answer,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
