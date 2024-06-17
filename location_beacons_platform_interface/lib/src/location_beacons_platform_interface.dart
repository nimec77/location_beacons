import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:geolocator/geolocator.dart';

abstract base class LocationBeaconsPlatform extends PlatformInterface {
  /// Constructs a LocationBeaconsPlatform.
  LocationBeaconsPlatform() : super(token: _token);

  static final Object _token = Object();

  static LocationBeaconsPlatform _instance = _PlaceholderImplementation();

  /// The default instance of [LocationBeaconsPlatform] to use.
  ///
  /// Defaults to [_PlaceholderImplementation].
  static LocationBeaconsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [LocationBeaconsPlatform] when
  /// they register themselves.
  static set instance(LocationBeaconsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<LocationPermission> checkPermission() {
    throw UnimplementedError('checkPermission() has not been implemented.');
  }

  Future<LocationPermission> requestPermission() {
    throw UnimplementedError('requestPermission() has not been implemented.');
  }

  Future<bool> isLocationServiceEnabled() {
    throw UnimplementedError(
        'isLocationServiceEnabled() has not been implemented.');
  }

  Future<Position?> getLastKnownPosition() {
    throw UnimplementedError(
        'getLastKnownPosition() has not been implemented.');
  }

  Future<Position> getCurrentPosition({LocationSettings? locationSettings}) {
    throw UnimplementedError('getCurrentPosition() has not been implemented.');
  }

  Stream<ServiceStatus> getServiceStatusStream() {
    throw UnimplementedError(
        'getServiceStatusStream() has not been implemented.');
  }

  Stream<Position> getPositionStream({LocationSettings? locationSettings}) {
    throw UnimplementedError('getPositionStream() has not been implemented.');
  }

  Future<LocationAccuracyStatus> requestTemporaryFullAccuracy({
    required String purposeKey,
  }) async {
    throw UnimplementedError(
        'requestTemporaryFullAccuracy() has not been implemented.');
  }

  Future<LocationAccuracyStatus> getLocationAccuracy() async {
    throw UnimplementedError(
        'getLocationAccuracyStatus() has not been implemented.');
  }

  Future<bool> openAppSettings() async {
    throw UnimplementedError('openAppSettings() has not been implemented.');
  }

  Future<bool> openLocationSettings() async {
    throw UnimplementedError(
        'openLocationSettings() has not been implemented.');
  }

  double distanceBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return GeolocatorPlatform.instance.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  double bearingBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return GeolocatorPlatform.instance.bearingBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }
}

final class _PlaceholderImplementation extends LocationBeaconsPlatform {}
