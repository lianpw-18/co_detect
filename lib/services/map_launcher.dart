import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MapLauncher {
  static Future<void> openGoogleMaps({
    required BuildContext context,
    required String name,
    required String address,
    double? latitude,
    double? longitude,
  }) async {
    Uri googleMapsUrl;
    Uri geoUrl;

    if (latitude != null && longitude != null) {
      final label = Uri.encodeComponent(name);
      googleMapsUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
      );
      geoUrl = Uri.parse('geo:$latitude,$longitude?q=$latitude,$longitude($label)');
    } else {
      final query = Uri.encodeComponent('$name, $address');
      googleMapsUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$query',
      );
      geoUrl = Uri.parse('geo:0,0?q=$query');
    }

    try {
      bool launched = false;
      if (await canLaunchUrl(googleMapsUrl)) {
        launched = await launchUrl(
          googleMapsUrl,
          mode: LaunchMode.externalApplication,
        );
      }
      if (!launched && await canLaunchUrl(geoUrl)) {
        launched = await launchUrl(geoUrl);
      }
      if (!launched) {
        await launchUrl(googleMapsUrl, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Membuka Google Maps untuk $name...'),
            backgroundColor: const Color(0xFF0284C7),
          ),
        );
      }
    }
  }

  static Future<void> openGoogleMapsDirection({
    required BuildContext context,
    required String name,
    required String address,
    double? latitude,
    double? longitude,
  }) async {
    Uri url;
    if (latitude != null && longitude != null) {
      url = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude',
      );
    } else {
      final destination = Uri.encodeComponent('$name, $address');
      url = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$destination',
      );
    }

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(url, mode: LaunchMode.platformDefault);
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Menuju rute Google Maps untuk $name...'),
            backgroundColor: const Color(0xFF0284C7),
          ),
        );
      }
    }
  }
}
