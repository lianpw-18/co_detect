import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';
import '../services/map_launcher.dart';
import '../theme/app_colors.dart';
import '../widgets/app_status_bar.dart';
import '../widgets/user_avatar.dart';
import '../widgets/hospital_booking_dialog.dart';
import 'hospital_map_screen.dart';

class HospitalListScreen extends StatefulWidget {
  const HospitalListScreen({super.key});

  @override
  State<HospitalListScreen> createState() => _HospitalListScreenState();
}

class _HospitalListScreenState extends State<HospitalListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'Semua';

  List<HospitalModel> _allHospitals = [];
  Position? _currentPosition;
  bool _isLocating = false;
  String? _locationStatusMessage;

  final List<String> _categories = [
    'Semua',
    'RS Rujukan',
    'Sentra Vaksin',
    'Puskesmas',
  ];

  @override
  void initState() {
    super.initState();
    _allHospitals = LocationService.instance.calculateAndSortHospitals(
      hospitals: LocationService.instance.defaultHospitals,
    );
    _requestLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _requestLocation() async {
    setState(() {
      _isLocating = true;
      _locationStatusMessage = 'Mendeteksi titik koordinat GPS Anda...';
    });

    final position = await LocationService.instance.determinePosition();

    if (mounted) {
      setState(() {
        _isLocating = false;
        _currentPosition = position;
        if (position != null) {
          _locationStatusMessage =
              'GPS Aktif (${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)})';
          _allHospitals = LocationService.instance.calculateAndSortHospitals(
            hospitals: LocationService.instance.defaultHospitals,
            userPosition: position,
          );
        } else {
          _locationStatusMessage =
              LocationService.instance.errorMessage ?? 'GPS tidak aktif (estimasi default)';
          _allHospitals = LocationService.instance.calculateAndSortHospitals(
            hospitals: LocationService.instance.defaultHospitals,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter berdasarkan search query dan kategori
    final filtered = _allHospitals.where((hospital) {
      final matchesSearch = hospital.name
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          hospital.address.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          hospital.category.toLowerCase().contains(_searchQuery.toLowerCase());

      if (!matchesSearch) return false;

      if (_selectedCategory == 'Semua') return true;
      if (_selectedCategory == 'RS Rujukan') {
        return hospital.category.toLowerCase().contains('rujukan');
      }
      if (_selectedCategory == 'Sentra Vaksin') {
        return hospital.category.toLowerCase().contains('vaksin');
      }
      if (_selectedCategory == 'Puskesmas') {
        return hospital.name.toLowerCase().contains('puskesmas') ||
            hospital.category.toLowerCase().contains('puskesmas');
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
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
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Faskes & RS Terdekat',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  const UserAvatar(
                    radius: 17,
                    imageUrl:
                        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100&h=100&fit=crop&crop=faces',
                  ),
                ],
              ),
            ),

            // GPS Real-Time Status Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: _buildGpsStatusBanner(),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
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
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari nama RS, rujukan, puskesmas...',
                    hintStyle: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 13,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Color(0xFF0284C7),
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 13,
                    ),
                  ),
                ),
              ),
            ),

            // Category Filter Pills
            SizedBox(
              height: 38,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (ctx, i) => const SizedBox(width: 8),
                itemBuilder: (ctx, i) {
                  final cat = _categories[i];
                  final isSelected = _selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = cat;
                        });
                      }
                    },
                    selectedColor: const Color(0xFF0284C7),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFF0284C7)
                          : const Color(0xFFE2E8F0),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // List of Hospitals
            Expanded(
              child: filtered.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: _requestLocation,
                      color: const Color(0xFF0284C7),
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemCount: filtered.length,
                        separatorBuilder: (ctx, i) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final hospital = filtered[index];
                          return _buildHospitalCard(hospital, index);
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGpsStatusBanner() {
    final bool isSuccess = _currentPosition != null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: isSuccess
            ? const Color(0xFFF0FDF4)
            : (_isLocating ? const Color(0xFFEFF6FF) : const Color(0xFFFFFBEB)),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSuccess
              ? const Color(0xFFBBF7D0)
              : (_isLocating ? const Color(0xFFBFDBFE) : const Color(0xFFFDE68A)),
        ),
      ),
      child: Row(
        children: [
          if (_isLocating) ...[
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF0284C7),
              ),
            ),
          ] else ...[
            Icon(
              isSuccess ? Icons.my_location_rounded : Icons.location_off_rounded,
              size: 16,
              color: isSuccess
                  ? const Color(0xFF16A34A)
                  : const Color(0xFFD97706),
            ),
          ],
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _locationStatusMessage ?? 'Menyiapkan geolokasi...',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: isSuccess
                    ? const Color(0xFF15803D)
                    : (_isLocating ? const Color(0xFF1D4ED8) : const Color(0xFFB45309)),
              ),
            ),
          ),
          InkWell(
            onTap: _isLocating ? null : _requestLocation,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              child: Text(
                isSuccess ? 'Perbarui' : 'Aktifkan',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isSuccess ? const Color(0xFF16A34A) : const Color(0xFF0284C7),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalCard(HospitalModel hospital, int rank) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      elevation: 0,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => HospitalMapScreen(
                hospitalName: hospital.name,
                address: hospital.address,
                distance: hospital.formattedDistance,
                beds: hospital.beds,
                phone: hospital.phone,
                latitude: hospital.latitude,
                longitude: hospital.longitude,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar Faskes dengan Overlay Badge Jarak
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
                    child: Image.network(
                      hospital.image,
                      height: 125,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Container(
                        height: 125,
                        color: const Color(0xFFE0F2FE),
                        child: const Icon(
                          Icons.local_hospital_rounded,
                          size: 40,
                          color: Color(0xFF0284C7),
                        ),
                      ),
                    ),
                  ),

                  // Tag Jarak Akurat Real-Time
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A).withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.near_me_rounded,
                            size: 13,
                            color: Color(0xFF38BDF8),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            hospital.formattedDistance,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Badge Peringkat Terdekat (Urutan 1, 2)
                  if (rank < 2)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF16A34A),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          rank == 0 ? 'Paling Dekat' : 'Terdekat ke-2',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // Detail Informasi RS
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hospital.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hospital.address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Badges: Kategori, Jam Buka & Bed
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            hospital.hours,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF166534),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            hospital.beds,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF1D4ED8),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    const SizedBox(height: 10),

                    // Tombol Booking Antrean
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F766E),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          HospitalBookingSheet.show(context, hospital.name);
                        },
                        icon: const Icon(Icons.confirmation_number_outlined, size: 16),
                        label: const Text(
                          'Ambil Antrean / Booking Poliklinik',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Tombol Aksi Langsung: Google Maps & Detail
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF0284C7),
                              side: const BorderSide(color: Color(0xFFBAE6FD)),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              MapLauncher.openGoogleMapsDirection(
                                context: context,
                                name: hospital.name,
                                address: hospital.address,
                                latitude: hospital.latitude,
                                longitude: hospital.longitude,
                              );
                            },
                            icon: const Icon(Icons.directions, size: 16),
                            label: const Text(
                              'Rute Maps',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => HospitalMapScreen(
                                    hospitalName: hospital.name,
                                    address: hospital.address,
                                    distance: hospital.formattedDistance,
                                    beds: hospital.beds,
                                    phone: hospital.phone,
                                    latitude: hospital.latitude,
                                    longitude: hospital.longitude,
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              'Lihat Detail',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off_rounded,
              size: 56,
              color: Color(0xFF94A3B8),
            ),
            const SizedBox(height: 12),
            const Text(
              'Faskes Tidak Ditemukan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Coba ubah kata kunci pencarian atau ganti kategori filter.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                  _selectedCategory = 'Semua';
                });
              },
              child: const Text('Reset Pencarian'),
            ),
          ],
        ),
      ),
    );
  }
}
