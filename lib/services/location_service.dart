import 'dart:math' as math;

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../app_state.dart';
import '../data/database.dart';

class LocationResult {
  const LocationResult({
    required this.latitude,
    required this.longitude,
    this.stationName,
    this.city,
  });

  final double latitude;
  final double longitude;
  final String? stationName;

  /// Municipality from reverse geocoding, e.g. "Prievidza".
  final String? city;
}

/// Resolves the current position, matches a known fuel station and enriches the
/// name with the city ("Shell" → "Shell Prievidza").
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

    String? baseName;
    if (nearest != null && nearestDistance <= 150) {
      baseName = nearest.name;
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
        if (distance <= 400) baseName = last.stationName;
      }
    }

    final city = await _reverseCity(position.latitude, position.longitude);

    // A bare brand ("Shell") gains the city; a name that already contains it,
    // or a full name with a branch ("Shell PD"), is kept as it is.
    var name = baseName;
    if (name != null && city != null) {
      final lowerName = name.toLowerCase();
      final lowerCity = city.toLowerCase();
      final bareBrand = !name.contains(' ');
      if (bareBrand && !lowerName.contains(lowerCity)) {
        name = '$name $city';
      }
    }
    name ??= city;

    return LocationResult(
      latitude: position.latitude,
      longitude: position.longitude,
      stationName: name,
      city: city,
    );
  }

  Future<String?> _reverseCity(double latitude, double longitude) async {
    try {
      final placemarks = await Geocoding()
          .placemarkFromCoordinates(latitude, longitude)
          .timeout(const Duration(seconds: 6));
      if (placemarks.isEmpty) return null;
      final place = placemarks.first;
      final candidates = [
        place.locality,
        place.subAdministrativeArea,
        place.subLocality,
      ];
      for (final candidate in candidates) {
        final text = candidate?.trim() ?? '';
        if (text.isNotEmpty) return text;
      }
    } catch (_) {
      // Geocoding needs Google Play services and a network; ignore failures.
    }
    return null;
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
