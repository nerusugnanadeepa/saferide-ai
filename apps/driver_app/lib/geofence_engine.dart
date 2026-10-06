// AGENT 2: Driver App Geofence Engine
// Location: apps/driver_app/lib/geofence_engine.dart

import 'dart:math';

class GeofenceEngine {
  /// Haversine Formula: Calculates distance in meters between two GPS coordinates
  static double calculateDistanceMeters({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) {
    const double r = 6371000; // Earth radius in meters
    final double dLat = _toRadians(endLat - startLat);
    final double dLng = _toRadians(endLng - startLng);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(startLat)) *
            cos(_toRadians(endLat)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return r * c;
  }

  /// Checks if bus is within the registered stop geofence boundary (<= 50m)
  static bool isWithinStopGeofence(double distanceMeters, {double radiusMeters = 50.0}) {
    return distanceMeters <= radiusMeters;
  }

  static double _toRadians(double degree) {
    return degree * pi / 180.0;
  }
}
