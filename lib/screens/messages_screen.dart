import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/app_status_bar.dart';
import '../widgets/user_avatar.dart';
import 'screening_screen.dart';
import 'hospital_list_screen.dart';
import 'skin_scan_screen.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final String time;
  final List<String>? actionButtons;
  final bool isEmergency;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
    this.actionButtons,
    this.isEmergency = false,
  });
}

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  final List<ChatMessage> _chatMessages = [
    const ChatMessage(
      text:
          'Halo! Saya Dr. Co-Detect AI, asisten medis virtual Anda. Saya dapat membantu menganalisis gejala awal, memberikan panduan isolasi mandiri, aturan obat darurat, atau merekomendasikan faskes terdekat.\n\nApa keluhan atau pertanyaan kesehatan Anda hari ini?',
      isUser: false,
      time: 'Baru saja',
      actionButtons: [
        'Demam & Batuk',
        'Sesak Napas',
        'Aturan Obat',
        'Lansia Binaan',
      ],
    ),
  ];

  final List<Map<String, dynamic>> _notifications = const [
    {
      'title': 'Berhasil Verifikasi',
      'body':
          'Sertifikat vaksinasi Covid-19 dosis 2 Anda berhasil diverifikasi oleh Kementerian Kesehatan dan sudah dapat diunduh.',
      'time': '12.30 WIB',
      'isRead': false,
    },
    {
      'title': 'Akun anda telah Login',
      'body':
          'Login berhasil terdeteksi dari perangkat Android pada hari ini. Jika bukan Anda yang melakukan ini, segera ganti kata sandi.',
      'time': '11.20 WIB',
      'isRead': true,
    },
    {
      'title': 'Jadwal Vaksinasi Tersedia',
      'body':
          'Sentra Vaksinasi RS Muhammadiyah membuka kuota baru untuk dosis booster. Segera daftarkan diri Anda sebelum kuota penuh.',
      'time': 'Kemarin',
      'isRead': true,
    },
    {
      'title': 'Peringatan Protokol Kesehatan',
      'body':
          'Zona tempat tinggal Anda saat ini berada dalam status PPKM Level 2. Tetap patuhi protokol kesehatan 5M.',
      'time': '3 hari lalu',
      'isRead': true,
    },
  ];

  final List<String> _quickPrompts = [
    'Saya demam 38.5°C dan meriang',
    'Dada terasa berat dan batuk kering',
    'Tips rawat lansia dengan hipertensi',
    'Kapan harus tes PCR / Antigen?',
    'Cara redakan sakit tenggorokan',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String query) {
    final text = query.trim();
    if (text.isEmpty) return;

    final now = TimeOfDay.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} WIB';

    setState(() {
      _chatMessages.add(ChatMessage(text: text, isUser: true, time: timeStr));
      _textController.clear();
      _isTyping = true;
    });

    _scrollToBottom();

    // AI Medical Response Simulation with clinical logic
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;

      final response = _generateMedicalResponse(text);

      setState(() {
        _isTyping = false;
        _chatMessages.add(
          ChatMessage(
            text: response['text'] as String,
            isUser: false,
            time: timeStr,
            actionButtons: response['actions'] as List<String>?,
            isEmergency: response['isEmergency'] as bool? ?? false,
          ),
        );
      });

      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Map<String, dynamic> _generateMedicalResponse(String query) {
    final q = query.toLowerCase();

    // Emergency red flags
    if (q.contains('sesak parah') ||
        q.contains('nyeri dada') ||
        q.contains('pingsan') ||
        q.contains('tidak sadar') ||
        q.contains('bibir biru') ||
        q.contains('kejang')) {
      return {
        'isEmergency': true,
        'text':
            '⚠️ PERINGATAN GAWAT DARURAT!\n\nGejala yang Anda deskripsikan merupakan tanda bahaya (red flag). Pasien harus SEGERA dievakuasi ke Instalasi Gawat Darurat (IGD) rumah sakit terdekat.\n\nLangkah Segera:\n1. Hubungi Layanan Darurat 119 / 112\n2. Longgarkan pakaian di sekitar dada dan leher\n3. Pastikan ventilasi udara terbuka bebas\n4. Jangan tinggalkan pasien sendirian.',
        'actions': ['Cari RS Terdekat', 'Panggil Ambulans 119'],
      };
    }

    if (q.contains('demam') || q.contains('meriang') || q.contains('panas')) {
      return {
        'isEmergency': false,
        'text':
            '🌡️ Penanganan Demam:\n\n1. Istirahat total dan perbanyak minum air hangat (minimal 2-2.5 liter/hari).\n2. Jika suhu tubuh di atas 38°C, Anda dapat mengonsumsi Paracetamol 500mg (1 tablet setiap 6-8 jam sesudah makan, maksimal 3-4 kali sehari jika demam berlanjut).\n3. Gunakan kompres air hangat di dahi atau lipatan ketiak.\n4. Pantau saturasi oksigen (SpO2) bila disertai batuk atau pilek.\n\nJika demam tidak kunjung reda dalam 3 hari, sangat disarankan periksa laboratorium darah di klinik/RS.',
        'actions': ['Mulai Skrining Mandiri', 'Daftar RS Terdekat'],
      };
    }

    if (q.contains('batuk') || q.contains('tenggorokan') || q.contains('flu')) {
      return {
        'isEmergency': false,
        'text':
            '🫁 Penanganan Batuk & Saluran Pernapasan:\n\n• Kumur air garam hangat 2-3 kali sehari untuk meredakan radang tenggorokan.\n• Konsumsi madu dan air perasan lemon hangat untuk melapisi mukosa tenggorokan.\n• Hindari makanan berminyak, es, dan ruangan berdebu.\n• Gunakan masker medis agar tidak menulari anggota keluarga lain.\n\nApakah batuk disertai sesak atau hilangnya indera penciuman (anosmia)?',
        'actions': ['Mulai Skrining Mandiri', 'Aturan Obat'],
      };
    }

    if (q.contains('lansia') || q.contains('hipertensi') || q.contains('darah tinggi') || q.contains('gula')) {
      return {
        'isEmergency': false,
        'text':
            '👵 Panduan Kesehatan Lansia Binaan:\n\n1. Catat tensi darah & gula darah setiap pagi sebelum beraktivitas di menu Profil > Rekam Medis Lansia.\n2. Pastikan obat rutin (seperti Amlodipine atau Metformin) diminum tepat waktu sesuai jadwal dokter.\n3. Batasi asupan natrium/garam dapur (maksimal 1 sendok teh per hari untuk penderita hipertensi).\n4. Ajak lansia jalan santai ringan 15-20 menit di pagi hari.',
        'actions': ['Cek Rekam Lansia', 'Pengingat Obat'],
      };
    }

    if (q.contains('kulit') || q.contains('ruam') || q.contains('gatal') || q.contains('bintik')) {
      return {
        'isEmergency': false,
        'text':
            '🔍 Pemeriksaan Lesi & Kondisi Kulit:\n\nAplikasi Co-Detect dilengkapi fitur pemindai gambar berbasis AI untuk membantu identifikasi awal ruam, kemerahan, atau lesi kulit.\n\nSilakan ambil foto area kulit yang bermasalah dengan pencahayaan yang cukup menggunakan menu Cek Kulit.',
        'actions': ['Buka AI Skin Scan'],
      };
    }

    if (q.contains('vaksin') || q.contains('booster')) {
      return {
        'isEmergency': false,
        'text':
            '💉 Informasi Vaksinasi:\n\nVaksinasi Covid-19 dosis primer dan booster aman serta efektif mengurangi risiko keparahan sakit. Pastikan kondisi tubuh dalam keadaan fit, tidak sedang demam di atas 37.5°C saat jadwal vaksinasi.',
        'actions': ['Lihat Jadwal Vaksin', 'Daftar Faskes'],
      };
    }

    // Default general response
    return {
      'isEmergency': false,
      'text':
          'Terima kasih atas pertanyaannya. Sebagai langkah pencegahan umum:\n\n1. Pastikan kecukupan cairan tubuh dan istirahat 7-8 jam.\n2. Lakukan skrining mandiri jika merasakan lebih dari 2 gejala infeksi saluran napas.\n3. Segera konsultasikan ke fasilitas kesehatan jika keluhan memberat atau menetap lebih dari 48 jam.',
      'actions': ['Mulai Skrining Mandiri', 'Daftar RS'],
    };
  }

  void _handleActionButton(String action) {
    if (action.contains('Skrining')) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ScreeningScreen()),
      );
    } else if (action.contains('RS') || action.contains('Faskes')) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const HospitalListScreen()),
      );
    } else if (action.contains('Skin') || action.contains('Kulit')) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const SkinScanScreen()),
      );
    } else {
      _sendMessage(action);
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

            // Top Header Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.smart_toy_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pusat Komunikasi & AI',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Konsultasi Dokter AI & Notifikasi',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const UserAvatar(
                    radius: 18,
                    imageUrl:
                        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100&h=100&fit=crop&crop=faces',
                  ),
                ],
              ),
            ),

            // Tab Bar Switcher
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(22),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                tabs: const [
                  Tab(
                    iconMargin: EdgeInsets.zero,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.health_and_safety_rounded, size: 16),
                        SizedBox(width: 6),
                        Text('Tanya AI Dokter'),
                      ],
                    ),
                  ),
                  Tab(
                    iconMargin: EdgeInsets.zero,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_rounded, size: 16),
                        SizedBox(width: 6),
                        Text('Notifikasi'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAiDoctorTab(),
                  _buildNotificationTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // TAB 1: TANYA AI DOKTER
  // ==========================================
  Widget _buildAiDoctorTab() {
    return Column(
      children: [
        // Sub-header indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: const Color(0xFFF8FAFC),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF16A34A),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Dr. Co-Detect AI • Asisten Medis Siaga 24 Jam',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF15803D),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  setState(() {
                    _chatMessages.removeRange(1, _chatMessages.length);
                  });
                },
                child: const Text(
                  'Bersihkan Chat',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Chat Message List
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: _chatMessages.length + (_isTyping ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _chatMessages.length && _isTyping) {
                return _buildTypingIndicator();
              }
              final msg = _chatMessages[index];
              return _buildChatBubble(msg);
            },
          ),
        ),

        // Quick Suggestion Chips
        Container(
          height: 38,
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: _quickPrompts.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final prompt = _quickPrompts[i];
              return ActionChip(
                backgroundColor: const Color(0xFFF1F5F9),
                side: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                label: Text(
                  prompt,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textPrimary,
                  ),
                ),
                onPressed: () => _sendMessage(prompt),
              );
            },
          ),
        ),

        // Input Field
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 6,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: TextField(
                    controller: _textController,
                    onSubmitted: _sendMessage,
                    decoration: const InputDecoration(
                      hintText: 'Tulis keluhan atau pertanyaan...',
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 11),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  onPressed: () => _sendMessage(_textController.text),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChatBubble(ChatMessage msg) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.82,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: msg.isUser
              ? AppColors.primary
              : msg.isEmergency
                  ? const Color(0xFFFEF2F2)
                  : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(msg.isUser ? 16 : 4),
            bottomRight: Radius.circular(msg.isUser ? 4 : 16),
          ),
          border: msg.isEmergency
              ? Border.all(color: const Color(0xFFEF4444), width: 1.5)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!msg.isUser)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      msg.isEmergency
                          ? Icons.warning_amber_rounded
                          : Icons.medical_services_rounded,
                      size: 14,
                      color: msg.isEmergency
                          ? const Color(0xFFDC2626)
                          : AppColors.primaryDark,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      msg.isEmergency
                          ? 'Peringatan Darurat'
                          : 'Dr. Co-Detect AI',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: msg.isEmergency
                            ? const Color(0xFFDC2626)
                            : AppColors.primaryDark,
                      ),
                    ),
                  ],
                ),
              ),
            Text(
              msg.text,
              style: TextStyle(
                fontSize: 13,
                height: 1.45,
                color: msg.isUser
                    ? Colors.white
                    : msg.isEmergency
                        ? const Color(0xFF991B1B)
                        : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  msg.time,
                  style: TextStyle(
                    fontSize: 10,
                    color: msg.isUser
                        ? Colors.white.withValues(alpha: 0.75)
                        : AppColors.textMuted,
                  ),
                ),
              ],
            ),
            if (msg.actionButtons != null && msg.actionButtons!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: msg.actionButtons!.map((act) {
                  return InkWell(
                    onTap: () => _handleActionButton(act),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 12,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            act,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: 8),
            Text(
              'Dr. Co-Detect sedang menganalisis...',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // TAB 2: NOTIFIKASI SISTEM
  // ==========================================
  Widget _buildNotificationTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        final msg = _notifications[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: msg['isRead'] == false
                  ? AppColors.primary.withValues(alpha: 0.4)
                  : Colors.transparent,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: msg['isRead'] == false
                          ? AppColors.primaryLight
                          : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.notifications_active_rounded,
                      size: 18,
                      color: msg['isRead'] == false
                          ? AppColors.primaryDark
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      msg['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Text(
                    msg['time'],
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 36),
                child: Text(
                  msg['body'],
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
