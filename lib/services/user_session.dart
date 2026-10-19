import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ElderlyMember {
  final String id;
  final String name;
  final String age;
  final String relation;
  final String status;
  final String comorbidity;

  const ElderlyMember({
    required this.id,
    required this.name,
    required this.age,
    required this.relation,
    required this.status,
    required this.comorbidity,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'relation': relation,
        'status': status,
        'comorbidity': comorbidity,
      };

  factory ElderlyMember.fromJson(Map<String, dynamic> json) => ElderlyMember(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        age: json['age'] ?? '',
        relation: json['relation'] ?? '',
        status: json['status'] ?? '',
        comorbidity: json['comorbidity'] ?? '',
      );
}

class ScreeningHistoryItem {
  final String date;
  final String title;
  final String result;
  final bool isSafe;
  final String notes;

  const ScreeningHistoryItem({
    required this.date,
    required this.title,
    required this.result,
    required this.isSafe,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
        'date': date,
        'title': title,
        'result': result,
        'isSafe': isSafe,
        'notes': notes,
      };

  factory ScreeningHistoryItem.fromJson(Map<String, dynamic> json) =>
      ScreeningHistoryItem(
        date: json['date'] ?? '',
        title: json['title'] ?? '',
        result: json['result'] ?? '',
        isSafe: json['isSafe'] ?? false,
        notes: json['notes'] ?? '',
      );
}

class VitalSignRecord {
  final String id;
  final String memberId;
  final String memberName;
  final String date;
  final int systolic;
  final int diastolic;
  final int heartRate;
  final double temperature;
  final int oxygenSaturation;
  final int bloodSugar;
  final String notes;

  const VitalSignRecord({
    required this.id,
    required this.memberId,
    required this.memberName,
    required this.date,
    required this.systolic,
    required this.diastolic,
    required this.heartRate,
    required this.temperature,
    required this.oxygenSaturation,
    required this.bloodSugar,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'memberId': memberId,
        'memberName': memberName,
        'date': date,
        'systolic': systolic,
        'diastolic': diastolic,
        'heartRate': heartRate,
        'temperature': temperature,
        'oxygenSaturation': oxygenSaturation,
        'bloodSugar': bloodSugar,
        'notes': notes,
      };

  factory VitalSignRecord.fromJson(Map<String, dynamic> json) => VitalSignRecord(
        id: json['id'] ?? '',
        memberId: json['memberId'] ?? 'self',
        memberName: json['memberName'] ?? 'Pengguna',
        date: json['date'] ?? '',
        systolic: (json['systolic'] as num?)?.toInt() ?? 120,
        diastolic: (json['diastolic'] as num?)?.toInt() ?? 80,
        heartRate: (json['heartRate'] as num?)?.toInt() ?? 75,
        temperature: (json['temperature'] as num?)?.toDouble() ?? 36.5,
        oxygenSaturation: (json['oxygenSaturation'] as num?)?.toInt() ?? 98,
        bloodSugar: (json['bloodSugar'] as num?)?.toInt() ?? 100,
        notes: json['notes'] ?? '',
      );
}

class MedicationReminder {
  final String id;
  final String memberId;
  final String memberName;
  final String medicineName;
  final String dosage;
  final String timeOfDay;
  final bool isTaken;
  final String notes;

  const MedicationReminder({
    required this.id,
    required this.memberId,
    required this.memberName,
    required this.medicineName,
    required this.dosage,
    required this.timeOfDay,
    this.isTaken = false,
    required this.notes,
  });

  MedicationReminder copyWith({bool? isTaken}) {
    return MedicationReminder(
      id: id,
      memberId: memberId,
      memberName: memberName,
      medicineName: medicineName,
      dosage: dosage,
      timeOfDay: timeOfDay,
      isTaken: isTaken ?? this.isTaken,
      notes: notes,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'memberId': memberId,
        'memberName': memberName,
        'medicineName': medicineName,
        'dosage': dosage,
        'timeOfDay': timeOfDay,
        'isTaken': isTaken,
        'notes': notes,
      };

  factory MedicationReminder.fromJson(Map<String, dynamic> json) =>
      MedicationReminder(
        id: json['id'] ?? '',
        memberId: json['memberId'] ?? 'self',
        memberName: json['memberName'] ?? 'Pengguna',
        medicineName: json['medicineName'] ?? '',
        dosage: json['dosage'] ?? '',
        timeOfDay: json['timeOfDay'] ?? '08:00',
        isTaken: json['isTaken'] ?? false,
        notes: json['notes'] ?? '',
      );
}

class HospitalAppointment {
  final String id;
  final String hospitalName;
  final String polyName;
  final String doctorName;
  final String patientName;
  final String date;
  final String timeSlot;
  final String queueNumber;
  final String status;

  const HospitalAppointment({
    required this.id,
    required this.hospitalName,
    required this.polyName,
    required this.doctorName,
    required this.patientName,
    required this.date,
    required this.timeSlot,
    required this.queueNumber,
    this.status = 'Terkonfirmasi',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'hospitalName': hospitalName,
        'polyName': polyName,
        'doctorName': doctorName,
        'patientName': patientName,
        'date': date,
        'timeSlot': timeSlot,
        'queueNumber': queueNumber,
        'status': status,
      };

  factory HospitalAppointment.fromJson(Map<String, dynamic> json) =>
      HospitalAppointment(
        id: json['id'] ?? '',
        hospitalName: json['hospitalName'] ?? '',
        polyName: json['polyName'] ?? '',
        doctorName: json['doctorName'] ?? '',
        patientName: json['patientName'] ?? '',
        date: json['date'] ?? '',
        timeSlot: json['timeSlot'] ?? '',
        queueNumber: json['queueNumber'] ?? '',
        status: json['status'] ?? 'Terkonfirmasi',
      );
}

class UserSession extends ChangeNotifier {
  static final UserSession instance = UserSession._internal();

  UserSession._internal();

  SharedPreferences? _prefs;

  String _name = 'Mrs Adah';
  String _email = 'lianpertiwa@gmail.com';
  String _phone = '+628170247210';
  String _nik = '3271045209840003';
  String _bloodType = 'O+';
  String _dateOfBirth = '15 Mei 1965';
  bool _isGuest = false;

  // Preferences
  bool _isDarkMode = false;
  bool _isSeniorFriendlyMode = false;

  List<ElderlyMember> _elderlyMembers = [];
  List<ScreeningHistoryItem> _screeningHistories = [];
  List<VitalSignRecord> _vitalSignRecords = [];
  List<MedicationReminder> _medicationReminders = [];
  List<HospitalAppointment> _hospitalAppointments = [];

  // Getters
  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get nik => _nik;
  String get bloodType => _bloodType;
  String get dateOfBirth => _dateOfBirth;
  bool get isGuest => _isGuest;
  bool get isDarkMode => _isDarkMode;
  bool get isSeniorFriendlyMode => _isSeniorFriendlyMode;

  List<ElderlyMember> get elderlyMembers => List.unmodifiable(_elderlyMembers);
  List<ScreeningHistoryItem> get screeningHistories =>
      List.unmodifiable(_screeningHistories);
  List<VitalSignRecord> get vitalSignRecords =>
      List.unmodifiable(_vitalSignRecords);
  List<MedicationReminder> get medicationReminders =>
      List.unmodifiable(_medicationReminders);
  List<HospitalAppointment> get hospitalAppointments =>
      List.unmodifiable(_hospitalAppointments);

  String get greetingName {
    if (_isGuest) return 'Tamu';
    if (_name.isEmpty) return 'Pengguna';
    return _name;
  }

  /// Initialize persistent storage and load saved state
  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _loadFromPrefs();
    } catch (e) {
      debugPrint('Error initializing SharedPreferences: $e');
      _initDefaultMockData();
    }
  }

  void _loadFromPrefs() {
    if (_prefs == null) {
      _initDefaultMockData();
      return;
    }

    _name = _prefs!.getString('user_name') ?? 'Mrs Adah';
    _email = _prefs!.getString('user_email') ?? 'lianpertiwa@gmail.com';
    _phone = _prefs!.getString('user_phone') ?? '+628170247210';
    _nik = _prefs!.getString('user_nik') ?? '3271045209840003';
    _bloodType = _prefs!.getString('user_blood_type') ?? 'O+';
    _dateOfBirth = _prefs!.getString('user_dob') ?? '15 Mei 1965';
    _isGuest = _prefs!.getBool('user_is_guest') ?? false;
    _isDarkMode = _prefs!.getBool('pref_dark_mode') ?? false;
    _isSeniorFriendlyMode = _prefs!.getBool('pref_senior_mode') ?? false;

    // Load Elderly Members
    final elderlyRaw = _prefs!.getString('elderly_members');
    if (elderlyRaw != null) {
      try {
        final List decoded = jsonDecode(elderlyRaw);
        _elderlyMembers =
            decoded.map((e) => ElderlyMember.fromJson(e)).toList();
      } catch (_) {
        _elderlyMembers = _defaultElderlyMembers();
      }
    } else {
      _elderlyMembers = _defaultElderlyMembers();
    }

    // Load Screening History
    final screeningRaw = _prefs!.getString('screening_histories');
    if (screeningRaw != null) {
      try {
        final List decoded = jsonDecode(screeningRaw);
        _screeningHistories =
            decoded.map((e) => ScreeningHistoryItem.fromJson(e)).toList();
      } catch (_) {
        _screeningHistories = _defaultScreeningHistories();
      }
    } else {
      _screeningHistories = _defaultScreeningHistories();
    }

    // Load Vitals
    final vitalsRaw = _prefs!.getString('vital_records');
    if (vitalsRaw != null) {
      try {
        final List decoded = jsonDecode(vitalsRaw);
        _vitalSignRecords =
            decoded.map((e) => VitalSignRecord.fromJson(e)).toList();
      } catch (_) {
        _vitalSignRecords = _defaultVitalRecords();
      }
    } else {
      _vitalSignRecords = _defaultVitalRecords();
    }

    // Load Medication Reminders
    final medsRaw = _prefs!.getString('medication_reminders');
    if (medsRaw != null) {
      try {
        final List decoded = jsonDecode(medsRaw);
        _medicationReminders =
            decoded.map((e) => MedicationReminder.fromJson(e)).toList();
      } catch (_) {
        _medicationReminders = _defaultMedicationReminders();
      }
    } else {
      _medicationReminders = _defaultMedicationReminders();
    }

    // Load Appointments
    final apptRaw = _prefs!.getString('hospital_appointments');
    if (apptRaw != null) {
      try {
        final List decoded = jsonDecode(apptRaw);
        _hospitalAppointments =
            decoded.map((e) => HospitalAppointment.fromJson(e)).toList();
      } catch (_) {
        _hospitalAppointments = _defaultAppointments();
      }
    } else {
      _hospitalAppointments = _defaultAppointments();
    }

    notifyListeners();
  }

  void _initDefaultMockData() {
    _elderlyMembers = _defaultElderlyMembers();
    _screeningHistories = _defaultScreeningHistories();
    _vitalSignRecords = _defaultVitalRecords();
    _medicationReminders = _defaultMedicationReminders();
    _hospitalAppointments = _defaultAppointments();
  }

  Future<void> _saveToPrefs() async {
    if (_prefs == null) return;
    try {
      await _prefs!.setString('user_name', _name);
      await _prefs!.setString('user_email', _email);
      await _prefs!.setString('user_phone', _phone);
      await _prefs!.setString('user_nik', _nik);
      await _prefs!.setString('user_blood_type', _bloodType);
      await _prefs!.setString('user_dob', _dateOfBirth);
      await _prefs!.setBool('user_is_guest', _isGuest);
      await _prefs!.setBool('pref_dark_mode', _isDarkMode);
      await _prefs!.setBool('pref_senior_mode', _isSeniorFriendlyMode);

      await _prefs!.setString(
        'elderly_members',
        jsonEncode(_elderlyMembers.map((e) => e.toJson()).toList()),
      );
      await _prefs!.setString(
        'screening_histories',
        jsonEncode(_screeningHistories.map((e) => e.toJson()).toList()),
      );
      await _prefs!.setString(
        'vital_records',
        jsonEncode(_vitalSignRecords.map((e) => e.toJson()).toList()),
      );
      await _prefs!.setString(
        'medication_reminders',
        jsonEncode(_medicationReminders.map((e) => e.toJson()).toList()),
      );
      await _prefs!.setString(
        'hospital_appointments',
        jsonEncode(_hospitalAppointments.map((e) => e.toJson()).toList()),
      );
    } catch (e) {
      debugPrint('Error saving to SharedPreferences: $e');
    }
  }

  List<ElderlyMember> _defaultElderlyMembers() => [
        const ElderlyMember(
          id: '1',
          name: 'Hj. Maryati',
          age: '70 tahun',
          relation: 'Ibu',
          status: 'Sehat & Terpantau',
          comorbidity: 'Hipertensi Ringan',
        ),
        const ElderlyMember(
          id: '2',
          name: 'H. Suwandi',
          age: '74 tahun',
          relation: 'Ayah',
          status: 'Jadwal Kontrol 10 Okt',
          comorbidity: 'Diabetes Mellitus',
        ),
      ];

  List<ScreeningHistoryItem> _defaultScreeningHistories() => [
        const ScreeningHistoryItem(
          date: '05 Okt 2026, 09:15 WIB',
          title: 'Skrining Mandiri Covid-19',
          result: 'Risiko Rendah',
          isSafe: true,
          notes:
              'Tidak ditemukan gejala infeksi. Tetap patuhi protokol kesehatan.',
        ),
        const ScreeningHistoryItem(
          date: '28 Sep 2026, 14:30 WIB',
          title: 'Skrining Gejala Lansia Binaan',
          result: 'Normal',
          isSafe: true,
          notes: 'Suhu tubuh normal (36.5°C), saturasi oksigen 98%.',
        ),
      ];

  List<VitalSignRecord> _defaultVitalRecords() => [
        const VitalSignRecord(
          id: 'v1',
          memberId: '1',
          memberName: 'Hj. Maryati',
          date: 'Hari ini, 07:30 WIB',
          systolic: 125,
          diastolic: 82,
          heartRate: 74,
          temperature: 36.6,
          oxygenSaturation: 98,
          bloodSugar: 110,
          notes: 'Kondisi stabil setelah sarapan.',
        ),
        const VitalSignRecord(
          id: 'v2',
          memberId: '2',
          memberName: 'H. Suwandi',
          date: 'Kemarin, 08:00 WIB',
          systolic: 135,
          diastolic: 88,
          heartRate: 78,
          temperature: 36.8,
          oxygenSaturation: 97,
          bloodSugar: 142,
          notes: 'Gula darah puasa sedikit naik, batasi asupan manis.',
        ),
      ];

  List<MedicationReminder> _defaultMedicationReminders() => [
        const MedicationReminder(
          id: 'm1',
          memberId: '1',
          memberName: 'Hj. Maryati',
          medicineName: 'Amlodipine 5mg',
          dosage: '1 tablet sesudah makan',
          timeOfDay: '08:00 WIB',
          isTaken: true,
          notes: 'Obat penurun tensi darah harian.',
        ),
        const MedicationReminder(
          id: 'm2',
          memberId: '2',
          memberName: 'H. Suwandi',
          medicineName: 'Metformin 500mg',
          dosage: '1 tablet bersama sarapan',
          timeOfDay: '08:30 WIB',
          isTaken: false,
          notes: 'Untuk kontrol gula darah.',
        ),
        const MedicationReminder(
          id: 'm3',
          memberId: 'self',
          memberName: 'Lian Pertiwi',
          medicineName: 'Vitamin C & Zinc',
          dosage: '1 kapsul setelah makan siang',
          timeOfDay: '13:00 WIB',
          isTaken: false,
          notes: 'Suplemen daya tahan tubuh.',
        ),
      ];

  List<HospitalAppointment> _defaultAppointments() => [
        const HospitalAppointment(
          id: 'apt-001',
          hospitalName: 'RS Muhammadiyah Bandung',
          polyName: 'Poli Penyakit Dalam',
          doctorName: 'dr. H. Hendra Setiawan, Sp.PD',
          patientName: 'H. Suwandi',
          date: '24 Okt 2026',
          timeSlot: '09:00 - 10:00 WIB',
          queueNumber: 'B-14',
          status: 'Terkonfirmasi',
        ),
      ];

  // Actions
  void login({required String emailOrUsername, String? name}) {
    final trimmed = emailOrUsername.trim();
    if (name != null && name.trim().isNotEmpty) {
      _name = name.trim();
      _email = trimmed.contains('@') ? trimmed : '$trimmed@gmail.com';
    } else if (trimmed.contains('@')) {
      _email = trimmed;
      final userPart = trimmed.split('@').first;
      if (userPart.toLowerCase() == 'lianpertiwa') {
        _name = 'Lian Pertiwi';
      } else {
        _name = _formatDisplayName(userPart);
      }
    } else {
      _name = trimmed.isNotEmpty ? trimmed : 'Pengguna';
      _email = '$trimmed@gmail.com';
    }
    _isGuest = false;
    _saveToPrefs();
    notifyListeners();
  }

  void register({required String name, required String email, String? phone}) {
    _name = name.trim().isNotEmpty ? name.trim() : 'Pengguna';
    _email = email.trim().isNotEmpty ? email.trim() : 'user@codetect.app';
    if (phone != null && phone.trim().isNotEmpty) {
      _phone = phone.trim();
    }
    _isGuest = false;
    _saveToPrefs();
    notifyListeners();
  }

  void loginAsGuest() {
    _name = 'Tamu';
    _email = 'tamu@codetect.app';
    _isGuest = true;
    _saveToPrefs();
    notifyListeners();
  }

  void updateProfile({
    String? name,
    String? email,
    String? phone,
    String? nik,
    String? bloodType,
    String? dateOfBirth,
  }) {
    if (name != null && name.trim().isNotEmpty) _name = name.trim();
    if (email != null && email.trim().isNotEmpty) _email = email.trim();
    if (phone != null && phone.trim().isNotEmpty) _phone = phone.trim();
    if (nik != null && nik.trim().isNotEmpty) _nik = nik.trim();
    if (bloodType != null && bloodType.trim().isNotEmpty) {
      _bloodType = bloodType.trim();
    }
    if (dateOfBirth != null && dateOfBirth.trim().isNotEmpty) {
      _dateOfBirth = dateOfBirth.trim();
    }
    _saveToPrefs();
    notifyListeners();
  }

  void addElderlyMember(ElderlyMember member) {
    _elderlyMembers.add(member);
    _saveToPrefs();
    notifyListeners();
  }

  void removeElderlyMember(String id) {
    _elderlyMembers.removeWhere((item) => item.id == id);
    _saveToPrefs();
    notifyListeners();
  }

  void addScreeningHistory(ScreeningHistoryItem item) {
    _screeningHistories.insert(0, item);
    _saveToPrefs();
    notifyListeners();
  }

  void addVitalSignRecord(VitalSignRecord record) {
    _vitalSignRecords.insert(0, record);
    _saveToPrefs();
    notifyListeners();
  }

  void addMedicationReminder(MedicationReminder reminder) {
    _medicationReminders.add(reminder);
    _saveToPrefs();
    notifyListeners();
  }

  void toggleMedicationTaken(String id) {
    final index = _medicationReminders.indexWhere((m) => m.id == id);
    if (index != -1) {
      final current = _medicationReminders[index];
      _medicationReminders[index] =
          current.copyWith(isTaken: !current.isTaken);
      _saveToPrefs();
      notifyListeners();
    }
  }

  void deleteMedicationReminder(String id) {
    _medicationReminders.removeWhere((m) => m.id == id);
    _saveToPrefs();
    notifyListeners();
  }

  void bookHospitalAppointment(HospitalAppointment appointment) {
    _hospitalAppointments.insert(0, appointment);
    _saveToPrefs();
    notifyListeners();
  }

  void toggleDarkMode(bool enabled) {
    _isDarkMode = enabled;
    _saveToPrefs();
    notifyListeners();
  }

  void toggleSeniorFriendlyMode(bool enabled) {
    _isSeniorFriendlyMode = enabled;
    _saveToPrefs();
    notifyListeners();
  }

  static String _formatDisplayName(String raw) {
    final clean = raw.replaceAll(RegExp(r'[._\d-]'), ' ').trim();
    if (clean.isEmpty) return 'Pengguna';
    return clean
        .split(' ')
        .where((s) => s.isNotEmpty)
        .map((s) => '${s[0].toUpperCase()}${s.substring(1).toLowerCase()}')
        .join(' ');
  }
}
