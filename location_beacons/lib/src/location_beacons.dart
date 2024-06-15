import 'package:geolocator/geolocator.dart';
import 'package:location_beacons_platform_interface/location_beacons_platform_interface.dart';

class LocationBeacons {
  static LocationBeaconsPlatform get _platform =>
      LocationBeaconsPlatform.instance;

  static Future<LocationPermission> checkPermission() async {
    return _platform.checkPermission();
  }

  static Future<LocationPermission> requestPermission() async {
    return _platform.requestPermission();
  }

  static Future<bool> isLocationServiceEnabled() async {
    return _platform.isLocationServiceEnabled();
  }

  static Future<Position?> getLastKnownPosition() async {
    return _platform.getLastKnownPosition();
  }

  static Future<Position> getCurrentPosition(
      {LocationSettings? locationSettings}) async {
    return _platform.getCurrentPosition(locationSettings: locationSettings);
  }

  static Stream<ServiceStatus> getServiceStatusStream() {
    return _platform.getServiceStatusStream();
  }

  static Stream<Position> getPositionStream({
    LocationSettings? locationSettings,
  }) {
    return _platform.getPositionStream(locationSettings: locationSettings);
  }

  static Future<LocationAccuracyStatus> requestTemporaryFullAccuracy({
    required String purposeKey,
  }) {
    return _platform.requestTemporaryFullAccuracy(purposeKey: purposeKey);
  }

  static Future<LocationAccuracyStatus> getLocationAccuracy() {
    return _platform.getLocationAccuracy();
  }

  static Future<bool> openAppSettings() {
    return _platform.openAppSettings();
  }

  static Future<bool> openLocationSettings() {
    return _platform.openLocationSettings();
  }

  static double distanceBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  static double bearingBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.bearingBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }
}
