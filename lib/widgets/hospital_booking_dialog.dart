import 'dart:math';
import 'package:flutter/material.dart';
import '../services/user_session.dart';
import '../theme/app_colors.dart';

class HospitalBookingSheet extends StatefulWidget {
  final String hospitalName;

  const HospitalBookingSheet({super.key, required this.hospitalName});

  static void show(BuildContext context, String hospitalName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => HospitalBookingSheet(hospitalName: hospitalName),
    );
  }

  @override
  State<HospitalBookingSheet> createState() => _HospitalBookingSheetState();
}

class _HospitalBookingSheetState extends State<HospitalBookingSheet> {
  final List<String> _polies = [
    'Poli Penyakit Dalam & Geriatri',
    'Poli Paru & Saluran Pernapasan',
    'Poli Umum & Skrining',
    'Sentra Vaksinasi',
  ];

  final Map<String, List<String>> _doctorsPerPoly = {
    'Poli Penyakit Dalam & Geriatri': [
      'dr. H. Hendra Setiawan, Sp.PD',
      'dr. Maya Kartika, Sp.PD-KGer',
    ],
    'Poli Paru & Saluran Pernapasan': [
      'dr. Fajar Nugraha, Sp.P',
      'dr. Rina Suryani, Sp.P',
    ],
    'Poli Umum & Skrining': [
      'dr. Ahmad Maulana',
      'dr. Siti Nurhaliza',
    ],
    'Sentra Vaksinasi': [
      'Tim Medis Sentra Vaksinasi RS',
    ],
  };

  final List<String> _timeSlots = [
    '08:30 - 09:30 WIB',
    '10:00 - 11:00 WIB',
    '13:00 - 14:00 WIB',
    '15:30 - 16:30 WIB',
  ];

  late String _selectedPoly;
  late String _selectedDoctor;
  late String _selectedTimeSlot;
  late String _selectedPatient;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  HospitalAppointment? _confirmedAppointment;

  @override
  void initState() {
    super.initState();
    _selectedPoly = _polies.first;
    _selectedDoctor = _doctorsPerPoly[_selectedPoly]!.first;
    _selectedTimeSlot = _timeSlots.first;

    final session = UserSession.instance;
    _selectedPatient = session.name;
  }

  void _confirmBooking() {
    final randomQueue = 'A-${Random().nextInt(30) + 1}';
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    final dateStr =
        '${_selectedDate.day} ${months[_selectedDate.month - 1]} ${_selectedDate.year}';

    final appointment = HospitalAppointment(
      id: 'APT-${DateTime.now().millisecondsSinceEpoch}',
      hospitalName: widget.hospitalName,
      polyName: _selectedPoly,
      doctorName: _selectedDoctor,
      patientName: _selectedPatient,
      date: dateStr,
      timeSlot: _selectedTimeSlot,
      queueNumber: randomQueue,
      status: 'Terkonfirmasi',
    );

    UserSession.instance.bookHospitalAppointment(appointment);

    setState(() {
      _confirmedAppointment = appointment;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 20,
        right: 20,
        top: 16,
      ),
      child: _confirmedAppointment == null
          ? _buildBookingForm(context)
          : _buildBookingSuccessTicket(context, _confirmedAppointment!),
    );
  }

  Widget _buildBookingForm(BuildContext context) {
    final session = UserSession.instance;
    final patientOptions = [
      session.name,
      ...session.elderlyMembers.map((m) => '${m.name} (${m.relation})'),
    ];

    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    final dateDisplay =
        '${_selectedDate.day} ${months[_selectedDate.month - 1]} ${_selectedDate.year}';

    return SingleChildScrollView(
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
                  color: Color(0xFFE0F2FE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: Color(0xFF0284C7),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ambil Antrean / Booking Jadwal',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      widget.hospitalName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 1. Pilih Pasien
          const Text(
            'Nama Pasien',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: patientOptions.contains(_selectedPatient)
                    ? _selectedPatient
                    : patientOptions.first,
                isExpanded: true,
                items: patientOptions.map((name) {
                  return DropdownMenuItem(
                    value: name,
                    child: Text(name, style: const TextStyle(fontSize: 13)),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedPatient = val);
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 14),

          // 2. Pilih Poli
          const Text(
            'Poliklinik Tujuan',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedPoly,
                isExpanded: true,
                items: _polies.map((p) {
                  return DropdownMenuItem(
                    value: p,
                    child: Text(p, style: const TextStyle(fontSize: 13)),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedPoly = val;
                      _selectedDoctor = _doctorsPerPoly[val]!.first;
                    });
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 14),

          // 3. Pilih Dokter
          const Text(
            'Dokter Spesialis',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedDoctor,
                isExpanded: true,
                items: _doctorsPerPoly[_selectedPoly]!.map((d) {
                  return DropdownMenuItem(
                    value: d,
                    child: Text(d, style: const TextStyle(fontSize: 13)),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedDoctor = val);
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 14),

          // 4. Pilih Tanggal & Sesi Waktu
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tanggal Periksa',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 30)),
                        );
                        if (picked != null) {
                          setState(() => _selectedDate = picked);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(dateDisplay, style: const TextStyle(fontSize: 12)),
                            const Icon(Icons.date_range, size: 16, color: Color(0xFF0284C7)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sesi Waktu',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedTimeSlot,
                          isExpanded: true,
                          items: _timeSlots.map((slot) {
                            return DropdownMenuItem(
                              value: slot,
                              child: Text(slot, style: const TextStyle(fontSize: 11.5)),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedTimeSlot = val);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Tombol Konfirmasi Booking
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              onPressed: _confirmBooking,
              icon: const Icon(Icons.confirmation_number_outlined, size: 18),
              label: const Text(
                'Konfirmasi & Dapatkan Nomor Antrean',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingSuccessTicket(BuildContext context, HospitalAppointment ticket) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            color: Color(0xFFDCFCE7),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 32),
        ),
        const SizedBox(height: 12),
        const Text(
          'Nomor Antrean Berhasil Diterbitkan!',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const Text(
          'Silakan tunjukkan tiket digital ini di loket pendaftaran faskes.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 18),

        // Virtual Ticket Box
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              Text(
                ticket.hospitalName,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0284C7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      'NOMOR ANTREAN',
                      style: TextStyle(fontSize: 10, color: Colors.white70, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      ticket.queueNumber,
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _buildTicketRow('Pasien', ticket.patientName),
              _buildTicketRow('Poli', ticket.polyName),
              _buildTicketRow('Dokter', ticket.doctorName),
              _buildTicketRow('Jadwal', '${ticket.date} • ${ticket.timeSlot}'),
              _buildTicketRow('Kode Tiket', ticket.id),
            ],
          ),
        ),
        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          height: 46,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Simpan & Selesai', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildTicketRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
