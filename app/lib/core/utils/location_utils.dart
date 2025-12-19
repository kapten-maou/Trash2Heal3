import 'dart:math';
import '../constants/app_values.dart';

/// Location & Distance Utility Functions
class LocationUtils {
  LocationUtils._();

  // ============================================
  // DISTANCE CALCULATIONS
  // ============================================

  /// Calculate distance between two coordinates using Haversine formula
  /// Returns distance in meters
  static double calculateDistance({
    required double lat1,
    required double lng1,
    required double lat2,
    required double lng2,
  }) {
    const earthRadius = 6371000.0; // Earth's radius in meters

    final dLat = _toRadians(lat2 - lat1);
    final dLng = _toRadians(lng2 - lng1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final distance = earthRadius * c;

    return distance;
  }

  /// Calculate distance in kilometers
  static double calculateDistanceKm({
    required double lat1,
    required double lng1,
    required double lat2,
    required double lng2,
  }) {
    return calculateDistance(
          lat1: lat1,
          lng1: lng1,
          lat2: lat2,
          lng2: lng2,
        ) /
        1000;
  }

  /// Check if location is within radius (geofencing)
  static bool isWithinRadius({
    required double centerLat,
    required double centerLng,
    required double targetLat,
    required double targetLng,
    required double radiusMeters,
  }) {
    final distance = calculateDistance(
      lat1: centerLat,
      lng1: centerLng,
      lat2: targetLat,
      lng2: targetLng,
    );

    return distance <= radiusMeters;
  }

  /// Check if courier is within pickup location (for task completion)
  static bool isCourierAtLocation({
    required double courierLat,
    required double courierLng,
    required double pickupLat,
    required double pickupLng,
  }) {
    return isWithinRadius(
      centerLat: pickupLat,
      centerLng: pickupLng,
      targetLat: courierLat,
      targetLng: courierLng,
      radiusMeters: AppValues.geofenceThresholdMeters,
    );
  }

  // ============================================
  // COORDINATE UTILITIES
  // ============================================

  /// Validate latitude (-90 to 90)
  static bool isValidLatitude(double lat) {
    return lat >= -90 && lat <= 90;
  }

  /// Validate longitude (-180 to 180)
  static bool isValidLongitude(double lng) {
    return lng >= -180 && lng <= 180;
  }

  /// Validate coordinates
  static bool isValidCoordinates(double lat, double lng) {
    return isValidLatitude(lat) && isValidLongitude(lng);
  }

  /// Format coordinates for display
  static String formatCoordinates(double lat, double lng, {int decimals = 6}) {
    return '${lat.toStringAsFixed(decimals)}, ${lng.toStringAsFixed(decimals)}';
  }

  /// Parse coordinates from string ("lat,lng")
  static Map<String, double>? parseCoordinates(String coordString) {
    try {
      final parts = coordString.split(',');
      if (parts.length != 2) return null;

      final lat = double.parse(parts[0].trim());
      final lng = double.parse(parts[1].trim());

      if (!isValidCoordinates(lat, lng)) return null;

      return {'lat': lat, 'lng': lng};
    } catch (e) {
      return null;
    }
  }

  // ============================================
  // BEARING & DIRECTION
  // ============================================

  /// Calculate bearing between two points (0-360 degrees)
  static double calculateBearing({
    required double lat1,
    required double lng1,
    required double lat2,
    required double lng2,
  }) {
    final dLng = _toRadians(lng2 - lng1);
    final lat1Rad = _toRadians(lat1);
    final lat2Rad = _toRadians(lat2);

    final y = sin(dLng) * cos(lat2Rad);
    final x =
        cos(lat1Rad) * sin(lat2Rad) - sin(lat1Rad) * cos(lat2Rad) * cos(dLng);

    final bearing = _toDegrees(atan2(y, x));
    return (bearing + 360) % 360;
  }

  /// Get direction text from bearing
  static String getDirection(double bearing) {
    if (bearing >= 337.5 || bearing < 22.5) return 'Utara';
    if (bearing >= 22.5 && bearing < 67.5) return 'Timur Laut';
    if (bearing >= 67.5 && bearing < 112.5) return 'Timur';
    if (bearing >= 112.5 && bearing < 157.5) return 'Tenggara';
    if (bearing >= 157.5 && bearing < 202.5) return 'Selatan';
    if (bearing >= 202.5 && bearing < 247.5) return 'Barat Daya';
    if (bearing >= 247.5 && bearing < 292.5) return 'Barat';
    if (bearing >= 292.5 && bearing < 337.5) return 'Barat Laut';
    return 'Unknown';
  }

  // ============================================
  // GOOGLE MAPS
  // ============================================

  /// Generate Google Maps URL for navigation
  static String getGoogleMapsUrl({
    required double lat,
    required double lng,
    String? label,
  }) {
    if (label != null) {
      return 'https://www.google.com/maps/search/?api=1&query=$lat,$lng&query_place_id=$label';
    }
    return 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
  }

  /// Generate Google Maps directions URL
  static String getGoogleMapsDirectionsUrl({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
  }) {
    return 'https://www.google.com/maps/dir/?api=1&origin=$originLat,$originLng&destination=$destLat,$destLng&travelmode=driving';
  }

  /// Generate static map image URL
  static String getStaticMapUrl({
    required double lat,
    required double lng,
    int zoom = 15,
    String size = '600x400',
    String? apiKey,
  }) {
    final markers = 'markers=color:red%7C$lat,$lng';
    final center = 'center=$lat,$lng';
    final zoomParam = 'zoom=$zoom';
    final sizeParam = 'size=$size';
    final key = apiKey != null ? '&key=$apiKey' : '';

    return 'https://maps.googleapis.com/maps/api/staticmap?$center&$zoomParam&$sizeParam&$markers$key';
  }

  // ============================================
  // ZONE DETECTION (for pickup slots)
  // ============================================

  /// Determine zone ID based on coordinates
  /// This is a simplified example - in production, use proper geofencing
  static String determineZone(double lat, double lng) {
    // Example: Simple grid-based zones for Jakarta
    // Zone format: "zone_lat_lng" (rounded to 2 decimals)
    final zoneLat = (lat * 100).floor() / 100;
    final zoneLng = (lng * 100).floor() / 100;

    return 'zone_${zoneLat}_$zoneLng';
  }

  /// Get zone name (for display)
  static String getZoneName(String zoneId) {
    // In production, map zoneId to actual zone names
    // For now, return formatted zoneId
    return zoneId.replaceAll('_', ' ').toUpperCase();
  }

  // ============================================
  // BOUNDS & VIEWPORT
  // ============================================

  /// Calculate bounds for multiple coordinates
  static Map<String, double> calculateBounds(
      List<Map<String, double>> coordinates) {
    if (coordinates.isEmpty) {
      return {
        'minLat': 0,
        'maxLat': 0,
        'minLng': 0,
        'maxLng': 0,
      };
    }

    double minLat = coordinates[0]['lat']!;
    double maxLat = coordinates[0]['lat']!;
    double minLng = coordinates[0]['lng']!;
    double maxLng = coordinates[0]['lng']!;

    for (final coord in coordinates) {
      final lat = coord['lat']!;
      final lng = coord['lng']!;

      if (lat < minLat) minLat = lat;
      if (lat > maxLat) maxLat = lat;
      if (lng < minLng) minLng = lng;
      if (lng > maxLng) maxLng = lng;
    }

    return {
      'minLat': minLat,
      'maxLat': maxLat,
      'minLng': minLng,
      'maxLng': maxLng,
    };
  }

  /// Calculate center point from bounds
  static Map<String, double> calculateCenter(Map<String, double> bounds) {
    return {
      'lat': (bounds['minLat']! + bounds['maxLat']!) / 2,
      'lng': (bounds['minLng']! + bounds['maxLng']!) / 2,
    };
  }

  // ============================================
  // PRIVATE HELPERS
  // ============================================

  static double _toRadians(double degrees) {
    return degrees * pi / 180;
  }

  static double _toDegrees(double radians) {
    return radians * 180 / pi;
  }

  // ============================================
  // ADDRESS HELPERS
  // ============================================

  /// Generate short address label
  static String generateAddressLabel(String address, {int maxLength = 30}) {
    if (address.length <= maxLength) return address;
    return '${address.substring(0, maxLength)}...';
  }

  /// Check if address has coordinates
  static bool hasCoordinates(double? lat, double? lng) {
    if (lat == null || lng == null) return false;
    return isValidCoordinates(lat, lng);
  }
}
