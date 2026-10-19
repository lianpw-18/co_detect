import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class HospitalModel {
  final String id;
  final String name;
  final String address;
  final String category;
  final String hours;
  final String beds;
  final String phone;
  final String image;
  final double latitude;
  final double longitude;
  double? distanceInKm;

  HospitalModel({
    required this.id,
    required this.name,
    required this.address,
    required this.category,
    required this.hours,
    required this.beds,
    required this.phone,
    required this.image,
    required this.latitude,
    required this.longitude,
    this.distanceInKm,
  });

  String get formattedDistance {
    if (distanceInKm == null) return 'Menghitung...';
    if (distanceInKm! < 1.0) {
      final meters = (distanceInKm! * 1000).round();
      return '$meters m';
    }
    return '${distanceInKm!.toStringAsFixed(1)} km';
  }
}

class LocationService {
  static final LocationService instance = LocationService._internal();
  LocationService._internal();

  Position? _currentPosition;
  bool _isLoading = false;
  String? _errorMessage;

  Position? get currentPosition => _currentPosition;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Master Data Faskes & RS Rujukan dengan Koordinat Nyata
  final List<HospitalModel> _defaultHospitals = [
    HospitalModel(
      id: 'rs_muhammadiyah',
      name: 'RS Muhammadiyah Bandung',
      address: 'Jl. KH. Ahmad Dahlan No.53, Turangga, Kec. Lengkong, Kota Bandung',
      category: 'RS Rujukan Covid-19 & Faskes Utama',
      hours: 'Buka 24 Jam',
      beds: '14 Bed Kosong',
      phone: '(022) 7301062',
      image:
          'https://images.unsplash.com/photo-1587351021759-3e566b6af7cc?w=400&h=250&fit=crop',
      latitude: -6.93278,
      longitude: 107.62569,
    ),
    HospitalModel(
      id: 'rs_immanuel',
      name: 'RS Immanuel Bandung',
      address: 'Jl. Raya Kopo No.161, Situsaeur, Kec. Bojongloa Kidul, Kota Bandung',
      category: 'RS Rujukan & Trauma Center',
      hours: 'Buka 24 Jam',
      beds: '8 Bed Kosong',
      phone: '(022) 5201656',
      image:
          'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=400&h=250&fit=crop',
      latitude: -6.93922,
      longitude: 107.59562,
    ),
    HospitalModel(
      id: 'rs_hasan_sadikin',
      name: 'RSUP Dr. Hasan Sadikin (RSHS)',
      address: 'Jl. Pasteur No.38, Pasteur, Kec. Sukajadi, Kota Bandung',
      category: 'RS Rujukan Utama Nasional & Covid-19',
      hours: 'Buka 24 Jam',
      beds: '26 Bed Kosong',
      phone: '(022) 2034953',
      image:
          'https://images.unsplash.com/photo-1512678080530-7760d81faba6?w=400&h=250&fit=crop',
      latitude: -6.89271,
      longitude: 107.59828,
    ),
    HospitalModel(
      id: 'rs_borromeus',
      name: 'RS Santo Borromeus',
      address: 'Jl. Ir. H. Juanda No.100, Lebakgede, Kecamatan Coblong, Kota Bandung',
      category: 'RS Rujukan Swasta Siaga',
      hours: 'Buka 24 Jam',
      beds: '11 Bed Kosong',
      phone: '(022) 2552000',
      image:
          'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?w=400&h=250&fit=crop',
      latitude: -6.89235,
      longitude: 107.61632,
    ),
    HospitalModel(
      id: 'rsud_bandung',
      name: 'RSUD Kota Bandung',
      address: 'Jl. Rumah Sakit No.22, Pakemitan, Kec. Cinambo, Kota Bandung',
      category: 'RS Rujukan Daerah Covid-19',
      hours: 'Buka 24 Jam',
      beds: '19 Bed Kosong',
      phone: '(022) 7811794',
      image:
          'https://images.unsplash.com/photo-1538108149393-fbbd81895907?w=400&h=250&fit=crop',
      latitude: -6.91185,
      longitude: 107.69752,
    ),
    HospitalModel(
      id: 'puskesmas_garuda',
      name: 'Puskesmas Garuda Bandung',
      address: 'Jl. Dadali No.81, Garuda, Kec. Andir, Kota Bandung',
      category: 'Sentra Vaksin & Faskes Tingkat 1',
      hours: '08.00 - 15.00 WIB',
      beds: 'Vaksin Tersedia',
      phone: '(022) 6011913',
      image:
          'https://images.unsplash.com/photo-1579684385127-1ef15d508118?w=400&h=250&fit=crop',
      latitude: -6.91684,
      longitude: 107.58156,
    ),
  ];

  List<HospitalModel> get defaultHospitals =>
      _defaultHospitals.map((h) => HospitalModel(
            id: h.id,
            name: h.name,
            address: h.address,
            category: h.category,
            hours: h.hours,
            beds: h.beds,
            phone: h.phone,
            image: h.image,
            latitude: h.latitude,
            longitude: h.longitude,
            distanceInKm: h.distanceInKm,
          )).toList();

  Future<Position?> determinePosition() async {
    _isLoading = true;
    _errorMessage = null;

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _errorMessage = 'Layanan lokasi (GPS) belum aktif di perangkat Anda.';
        _isLoading = false;
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _errorMessage = 'Izin akses lokasi ditolak oleh pengguna.';
          _isLoading = false;
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _errorMessage =
            'Izin akses lokasi ditolak secara permanen. Mohon aktifkan di Pengaturan.';
        _isLoading = false;
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      _currentPosition = position;
      _isLoading = false;
      return position;
    } catch (e) {
      if (kDebugMode) {
        print('Location error: $e');
      }
      _errorMessage = 'Tidak dapat mengambil lokasi: $e';
      _isLoading = false;
      return null;
    }
  }

  /// Menghitung jarak faskes dari posisi user dan mengurutkannya dari yang terdekat
  List<HospitalModel> calculateAndSortHospitals({
    required List<HospitalModel> hospitals,
    Position? userPosition,
  }) {
    final list = List<HospitalModel>.from(hospitals);

    if (userPosition != null) {
      for (var hospital in list) {
        final distanceInMeters = Geolocator.distanceBetween(
          userPosition.latitude,
          userPosition.longitude,
          hospital.latitude,
          hospital.longitude,
        );
        hospital.distanceInKm = distanceInMeters / 1000.0;
      }

      list.sort((a, b) {
        final distA = a.distanceInKm ?? 999999.0;
        final distB = b.distanceInKm ?? 999999.0;
        return distA.compareTo(distB);
      });
    } else {
      // Default estimasi jika GPS belum aktif (titik acuan pusat kota Bandung)
      const double centerLat = -6.9175;
      const double centerLng = 107.6191;
      for (var hospital in list) {
        final distanceInMeters = Geolocator.distanceBetween(
          centerLat,
          centerLng,
          hospital.latitude,
          hospital.longitude,
        );
        hospital.distanceInKm = distanceInMeters / 1000.0;
      }
      list.sort((a, b) => (a.distanceInKm ?? 0).compareTo(b.distanceInKm ?? 0));
    }

    return list;
  }
}
