import 'package:flutter/material.dart';
import '../services/map_launcher.dart';
import '../theme/app_colors.dart';
import '../widgets/app_status_bar.dart';
import '../widgets/hospital_booking_dialog.dart';

class HospitalMapScreen extends StatefulWidget {
  final String hospitalName;
  final String address;
  final String distance;
  final String? beds;
  final String? phone;
  final double? latitude;
  final double? longitude;

  const HospitalMapScreen({
    super.key,
    required this.hospitalName,
    required this.address,
    required this.distance,
    this.beds = '12 Bed Kosong',
    this.phone = '(022) 7301062',
    this.latitude,
    this.longitude,
  });

  @override
  State<HospitalMapScreen> createState() => _HospitalMapScreenState();
}

class _HospitalMapScreenState extends State<HospitalMapScreen> {
  double _zoomLevel = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // 1. Interactive Stylized Map Background Canvas
            Positioned.fill(
              child: GestureDetector(
                onDoubleTap: () {
                  setState(() {
                    _zoomLevel = _zoomLevel == 1.0 ? 1.4 : 1.0;
                  });
                },
                child: AnimatedScale(
                  scale: _zoomLevel,
                  duration: const Duration(milliseconds: 300),
                  child: _buildStylizedMapCanvas(),
                ),
              ),
            ),

            // 2. Top Bar with back button & title
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  const AppStatusBar(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.map_outlined,
                                size: 18,
                                color: Color(0xFF0284C7),
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Peta & Lokasi Faskes',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        // Direct Open in Google Maps button
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF1E293B),
                            elevation: 3,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            MapLauncher.openGoogleMaps(
                              context: context,
                              name: widget.hospitalName,
                              address: widget.address,
                            );
                          },
                          icon: const Icon(
                            Icons.open_in_new_rounded,
                            size: 16,
                            color: Color(0xFF0284C7),
                          ),
                          label: const Text(
                            'Maps',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 3. Floating Map Controls (Zoom, Re-center)
            Positioned(
              right: 16,
              bottom: 270,
              child: Column(
                children: [
                  FloatingActionButton.small(
                    heroTag: 'zoomIn',
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.textPrimary,
                    onPressed: () {
                      setState(() {
                        if (_zoomLevel < 1.8) _zoomLevel += 0.2;
                      });
                    },
                    child: const Icon(Icons.add),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton.small(
                    heroTag: 'zoomOut',
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.textPrimary,
                    onPressed: () {
                      setState(() {
                        if (_zoomLevel > 0.8) _zoomLevel -= 0.2;
                      });
                    },
                    child: const Icon(Icons.remove),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton.small(
                    heroTag: 'myLocation',
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF0284C7),
                    onPressed: () {
                      setState(() {
                        _zoomLevel = 1.0;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Lokasi dipusatkan ke rute faskes'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    child: const Icon(Icons.my_location),
                  ),
                ],
              ),
            ),

            // 4. Bottom Detail Card
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 16,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F2FE),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.local_hospital_rounded,
                            color: Color(0xFF0284C7),
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.hospitalName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFDCFCE7),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      '24 Jam',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF166534),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.address,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    const SizedBox(height: 12),
                    // Quick stats: Distance & Bed
                    Row(
                      children: [
                        _buildInfoBadge(
                          icon: Icons.navigation_rounded,
                          label: 'Jarak',
                          value: widget.distance,
                          color: const Color(0xFF16A34A),
                        ),
                        const SizedBox(width: 12),
                        _buildInfoBadge(
                          icon: Icons.hotel_rounded,
                          label: 'Kapasitas',
                          value: widget.beds ?? '12 Bed Kosong',
                          color: const Color(0xFF0284C7),
                        ),
                        const SizedBox(width: 12),
                        _buildInfoBadge(
                          icon: Icons.verified_user_rounded,
                          label: 'Rujukan',
                          value: 'Siaga Covid',
                          color: const Color(0xFF7C3AED),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Booking Antrean Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F766E),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          HospitalBookingSheet.show(context, widget.hospitalName);
                        },
                        icon: const Icon(Icons.confirmation_number_outlined, size: 18),
                        label: const Text(
                          'Ambil Antrean / Booking Poliklinik',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Main Action Buttons
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0284C7),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 2,
                            ),
                            onPressed: () {
                              MapLauncher.openGoogleMapsDirection(
                                context: context,
                                name: widget.hospitalName,
                                address: widget.address,
                                latitude: widget.latitude,
                                longitude: widget.longitude,
                              );
                            },
                            icon: const Icon(Icons.directions, size: 20),
                            label: const Text(
                              'Petunjuk Arah (Maps)',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF16A34A),
                              side: const BorderSide(
                                color: Color(0xFF22C55E),
                                width: 1.5,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Menghubungi IGD ${widget.hospitalName} (${widget.phone})...',
                                  ),
                                  backgroundColor: const Color(0xFF16A34A),
                                ),
                              );
                            },
                            icon: const Icon(Icons.call, size: 18),
                            label: const Text(
                              'Telepon',
                              style: TextStyle(
                                fontSize: 13,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBadge({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 12, color: color),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(fontSize: 10, color: color),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // Visual simulation of a beautiful vector map with roads, route line, user position, and hospital pin
  Widget _buildStylizedMapCanvas() {
    return Container(
      color: const Color(0xFFE5E7EB),
      child: Stack(
        children: [
          // Background Map Grid / Blocks
          Positioned.fill(
            child: CustomPaint(
              painter: _MapGridPainter(),
            ),
          ),

          // User Location Pin (Blue pulsating dot)
          Positioned(
            left: 100,
            top: 360,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: const Text(
                    'Lokasi Anda',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0284C7),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0284C7).withValues(alpha: 0.4),
                        blurRadius: 10,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Hospital Destination Pin (Prominent Marker)
          Positioned(
            right: 90,
            top: 200,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.local_hospital,
                        color: Color(0xFFEF4444),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.hospitalName,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                const Icon(
                  Icons.location_on,
                  color: Color(0xFFEF4444),
                  size: 44,
                  shadows: [
                    Shadow(color: Colors.black38, blurRadius: 8, offset: Offset(0, 4)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 24
      ..style = PaintingStyle.stroke;

    final secondaryRoadPaint = Paint()
      ..color = const Color(0xFFF3F4F6)
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke;

    final routePaint = Paint()
      ..color = const Color(0xFF38BDF8)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final parkPaint = Paint()
      ..color = const Color(0xFFD1FAE5)
      ..style = PaintingStyle.fill;

    // Draw green parks
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(20, 120, size.width * 0.35, 110),
        const Radius.circular(12),
      ),
      parkPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.55, 330, size.width * 0.4, 90),
        const Radius.circular(12),
      ),
      parkPaint,
    );

    // Main Roads
    canvas.drawLine(Offset(0, size.height * 0.45), Offset(size.width, size.height * 0.35), roadPaint);
    canvas.drawLine(Offset(size.width * 0.4, 0), Offset(size.width * 0.45, size.height), roadPaint);
    canvas.drawLine(Offset(0, size.height * 0.25), Offset(size.width, size.height * 0.2), secondaryRoadPaint);
    canvas.drawLine(Offset(size.width * 0.75, 0), Offset(size.width * 0.7, size.height), secondaryRoadPaint);

    // Connecting Route Path (from User to Hospital)
    final path = Path();
    path.moveTo(110, 370);
    path.lineTo(size.width * 0.42, 360);
    path.lineTo(size.width * 0.42, 230);
    path.lineTo(size.width - 110, 230);
    canvas.drawPath(path, routePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
