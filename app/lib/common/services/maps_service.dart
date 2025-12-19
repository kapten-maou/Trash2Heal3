import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


/// Maps Service for Google Maps utilities
class MapsService {
  static final MapsService _instance = MapsService._internal();
  factory MapsService() => _instance;
  MapsService._internal();

  // ============================================
  // LOCATION PERMISSIONS
  // ============================================

  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check location permission status
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Request location permission
  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  /// Check and request location permission if needed
  Future<bool> ensureLocationPermission() async {
    // Check if location service is enabled
    bool serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    // Check permission
    LocationPermission permission = await checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  // ============================================
  // GET CURRENT LOCATION
  // ============================================

  /// Get current position
  Future<Position?> getCurrentPosition() async {
    try {
      final hasPermission = await ensureLocationPermission();
      if (!hasPermission) return null;

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error getting current position: $e');
      return null;
    }
  }

  /// Get current LatLng
  Future<LatLng?> getCurrentLatLng() async {
    final position = await getCurrentPosition();
    if (position == null) return null;

    return LatLng(position.latitude, position.longitude);
  }

  // ============================================
  // LOCATION STREAM
  // ============================================

  /// Stream location updates
  Stream<Position> getPositionStream({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int distanceFilter = 10, // meters
  }) {
    final locationSettings = LocationSettings(
      accuracy: accuracy,
      distanceFilter: distanceFilter,
    );

    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  // ============================================
  // DISTANCE CALCULATION
  // ============================================

  /// Calculate distance between two points (in meters)
  double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  /// Calculate distance between two LatLng
  double calculateDistanceLatLng(LatLng point1, LatLng point2) {
    return calculateDistance(
      point1.latitude,
      point1.longitude,
      point2.latitude,
      point2.longitude,
    );
  }

  /// Format distance for display
  String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toInt()} m';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(1)} km';
    }
  }

  // ============================================
  // BEARING & DIRECTION
  // ============================================

  /// Calculate bearing between two points
  double calculateBearing(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    return Geolocator.bearingBetween(lat1, lon1, lat2, lon2);
  }

  /// Get direction name from bearing
  String getDirectionFromBearing(double bearing) {
    if (bearing >= 337.5 || bearing < 22.5) return 'Utara';
    if (bearing >= 22.5 && bearing < 67.5) return 'Timur Laut';
    if (bearing >= 67.5 && bearing < 112.5) return 'Timur';
    if (bearing >= 112.5 && bearing < 157.5) return 'Tenggara';
    if (bearing >= 157.5 && bearing < 202.5) return 'Selatan';
    if (bearing >= 202.5 && bearing < 247.5) return 'Barat Daya';
    if (bearing >= 247.5 && bearing < 292.5) return 'Barat';
    return 'Barat Laut';
  }

  // ============================================
  // GEOCODING
  // ============================================

  /// Get address from coordinates (Reverse Geocoding)
  Future<String?> getAddressFromLatLng(LatLng position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) return null;

      final place = placemarks.first;
      
      return [
        place.street,
        place.subLocality,
        place.locality,
        place.subAdministrativeArea,
        place.administrativeArea,
        place.postalCode,
      ].where((e) => e != null && e.isNotEmpty).join(', ');
    } catch (e) {
      print('Error getting address: $e');
      return null;
    }
  }

  /// Get coordinates from address (Geocoding)
  Future<LatLng?> getLatLngFromAddress(String address) async {
    try {
      final locations = await locationFromAddress(address);

      if (locations.isEmpty) return null;

      final location = locations.first;
      return LatLng(location.latitude, location.longitude);
    } catch (e) {
      print('Error getting location from address: $e');
      return null;
    }
  }

  // ============================================
  // CAMERA POSITION
  // ============================================

  /// Create camera position from LatLng
  CameraPosition createCameraPosition(
    LatLng position, {
    double zoom = 15.0,
    double bearing = 0.0,
    double tilt = 0.0,
  }) {
    return CameraPosition(
      target: position,
      zoom: zoom,
      bearing: bearing,
      tilt: tilt,
    );
  }

  /// Calculate bounds to include multiple points
  LatLngBounds calculateBounds(List<LatLng> points) {
    assert(points.isNotEmpty, 'Points list cannot be empty');

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (var point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  // ============================================
  // MARKERS
  // ============================================

  /// Create marker
  Marker createMarker({
    required String markerId,
    required LatLng position,
    String? title,
    String? snippet,
    BitmapDescriptor? icon,
    VoidCallback? onTap,
  }) {
    return Marker(
      markerId: MarkerId(markerId),
      position: position,
      infoWindow: InfoWindow(
        title: title,
        snippet: snippet,
      ),
      icon: icon ?? BitmapDescriptor.defaultMarker,
      onTap: onTap,
    );
  }

  /// Create circle overlay
  Circle createCircle({
    required String circleId,
    required LatLng center,
    required double radius,
    int strokeWidth = 2,
    int fillColor = 0x220000FF,
    int strokeColor = 0xFF0000FF,
  }) {
    return Circle(
      circleId: CircleId(circleId),
      center: center,
      radius: radius,
      strokeWidth: strokeWidth,
      fillColor: Color(fillColor),
      strokeColor: Color(strokeColor),
    );
  }

  /// Create polyline
  Polyline createPolyline({
    required String polylineId,
    required List<LatLng> points,
    int color = 0xFF0000FF,
    int width = 5,
  }) {
    return Polyline(
      polylineId: PolylineId(polylineId),
      points: points,
      color: Color(color),
      width: width,
    );
  }

  // ============================================
  // EXTERNAL NAVIGATION
  // ============================================

  /// Open location in Google Maps app
  Future<bool> openInGoogleMaps(LatLng destination) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=${destination.latitude},${destination.longitude}';
    
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return false;
  }

  /// Open location in Waze app
  Future<bool> openInWaze(LatLng destination) async {
    final url = 'https://waze.com/ul?ll=${destination.latitude},${destination.longitude}&navigate=yes';
    
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return false;
  }

  /// Show navigation options
  Future<bool> showNavigationOptions(
    LatLng destination, {
    String? destinationName,
  }) async {
    // Try Google Maps first
    final googleMapsOpened = await openInGoogleMaps(destination);
    return googleMapsOpened;
  }

  // ============================================
  // HELPERS
  // ============================================

  /// Check if point is within radius of center
  bool isWithinRadius(
    LatLng point,
    LatLng center,
    double radiusInMeters,
  ) {
    final distance = calculateDistanceLatLng(point, center);
    return distance <= radiusInMeters;
  }

  /// Calculate midpoint between two locations
  LatLng calculateMidpoint(LatLng point1, LatLng point2) {
    return LatLng(
      (point1.latitude + point2.latitude) / 2,
      (point1.longitude + point2.longitude) / 2,
    );
  }

  /// Calculate ETA based on distance and speed
  /// Returns duration in minutes
  int calculateETA({
    required double distanceInMeters,
    double averageSpeedKmH = 30.0, // Default city speed
  }) {
    final distanceInKm = distanceInMeters / 1000;
    final timeInHours = distanceInKm / averageSpeedKmH;
    return (timeInHours * 60).ceil(); // Convert to minutes
  }

  /// Format ETA for display
  String formatETA(int minutes) {
    if (minutes < 60) {
      return '$minutes menit';
    } else {
      final hours = minutes ~/ 60;
      final mins = minutes % 60;
      if (mins == 0) {
        return '$hours jam';
      }
      return '$hours jam $mins menit';
    }
  }
}

// ============================================
// PROVIDER (for Riverpod)
// ============================================



/// Maps Service provider
final mapsServiceProvider = Provider<MapsService>((ref) {
  return MapsService();
});