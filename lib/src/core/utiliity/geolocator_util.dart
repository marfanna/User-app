import 'dart:math';

class GeolocatorUtil {
  /// Calculates the distance between two points in kilometers.
  static double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    const double radiusOfEarth = 6371; // In kilometers
    final double dLat = _degreesToRadians(endLatitude - startLatitude);
    final double dLng = _degreesToRadians(endLongitude - startLongitude);

    final double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(startLatitude)) *
            cos(_degreesToRadians(endLatitude)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return radiusOfEarth * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}
