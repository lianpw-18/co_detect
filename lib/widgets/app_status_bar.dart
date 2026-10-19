import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppStatusBar extends StatefulWidget implements PreferredSizeWidget {
  const AppStatusBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(28);

  @override
  State<AppStatusBar> createState() => _AppStatusBarState();
}

class _AppStatusBarState extends State<AppStatusBar> {
  late Timer _timer;
  late String _timeString;

  @override
  void initState() {
    super.initState();
    _timeString = _formatTime();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (mounted) {
        setState(() {
          _timeString = _formatTime();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime() {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return '$hour.$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.statusBarGreen,
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _timeString,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.signal_cellular_4_bar, color: Colors.white, size: 14),
              SizedBox(width: 4),
              Icon(Icons.wifi, color: Colors.white, size: 14),
              SizedBox(width: 4),
              Icon(Icons.battery_full, color: Colors.white, size: 14),
            ],
          ),
        ],
      ),
    );
  }
}
