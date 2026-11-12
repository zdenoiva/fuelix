import 'dart:math' as math;

import 'package:geolocator/geolocator.dart';

import '../app_state.dart';
import '../data/database.dart';

class LocationResult {
  const LocationResult({
    required this.latitude,
    required this.longitude,
    this.stationName,
  });

  final double latitude;
  final double longitude;
  final String? stationName;
}

/// Resolves the current position and tries to match a known fuel station.
class LocationService {
  LocationService._();

  static final LocationService instance = LocationService._();

  Future<LocationResult?> locate({required int vehicleId}) async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    final Position position;
    try {
      position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 12),
        ),
      );
    } catch (_) {
      return null;
    }

    final db = AppState.instance.db;
    final stations = await db.select(db.stations).get();
    Station? nearest;
    var nearestDistance = double.infinity;
    for (final station in stations) {
      if (station.latitude == null || station.longitude == null) continue;
      final distance = _distanceMeters(
        position.latitude,
        position.longitude,
        station.latitude!,
        station.longitude!,
      );
      if (distance < nearestDistance) {
        nearestDistance = distance;
        nearest = station;
      }
    }

    String? name;
    if (nearest != null && nearestDistance <= 150) {
      name = nearest.name;
    } else {
      // Reuse the station of the previous fill-up when it was logged nearby.
      final last = await AppState.instance.repo.lastFillUp(vehicleId);
      if (last?.latitude != null &&
          last?.longitude != null &&
          last!.stationName.isNotEmpty) {
        final distance = _distanceMeters(
          position.latitude,
          position.longitude,
          last.latitude!,
          last.longitude!,
        );
        if (distance <= 400) name = last.stationName;
      }
    }

    return LocationResult(
      latitude: position.latitude,
      longitude: position.longitude,
      stationName: name,
    );
  }

  double _distanceMeters(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadius = 6371000.0;
    final dLat = _radians(lat2 - lat1);
    final dLon = _radians(lon2 - lon1);
    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_radians(lat1)) *
            math.cos(_radians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    return earthRadius * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }

  double _radians(double degrees) => degrees * math.pi / 180;
}
