import 'package:flutter/services.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:location_beacons_android/types/cell_position.dart';
import 'package:location_beacons_platform_interface/location_beacons_platform_interface.dart';

final class LocationBeaconsAndroid extends LocationBeaconsPlatform {
  static const MethodChannel _channel =
      MethodChannel('location_beacons_android');

  final _geolocatorAndroid = GeolocatorAndroid();

  static void registerWith() {
    LocationBeaconsPlatform.instance = LocationBeaconsAndroid();
  }

  @override
  Future<void> init(String apiKey) async {
    try {
      await _channel.invokeMethod('init', apiKey);
    } on PlatformException catch (e) {
      final error = _handlePlatformException(e);

      throw error;
    }
  }

  @override
  Future<LocationPermission> checkPermission() {
    return _geolocatorAndroid.checkPermission();
  }

  @override
  Future<LocationPermission> requestPermission() {
    return _geolocatorAndroid.requestPermission();
  }

  @override
  Future<CellPosition?> getLastKnownPosition({
    bool forceLocationManager = false,
  }) async {
    try {
      final parameters = <String, dynamic>{
        'forceLocationManager': forceLocationManager
      };
      final positionMap =
          await _channel.invokeMethod('getLastKnownPosition', parameters);
      return positionMap != null ? CellPosition.fromMap(positionMap) : null;
    } on PlatformException catch (e) {
      final error = _handlePlatformException(e);

      throw error;
    }
  }

  @override
  Future<bool> isLocationServiceEnabled() async => _channel
      .invokeMethod<bool>('isLocationServiceEnabled')
      .then((value) => value ?? false);

  Exception _handlePlatformException(PlatformException exception) {
    switch (exception.code) {
      case 'ACTIVITY_MISSING':
        return ActivityMissingException(exception.message);
      case 'LOCATION_SERVICES_DISABLED':
        return const LocationServiceDisabledException();
      case 'LOCATION_SUBSCRIPTION_ACTIVE':
        return const AlreadySubscribedException();
      case 'PERMISSION_DEFINITIONS_NOT_FOUND':
        return PermissionDefinitionsNotFoundException(exception.message);
      case 'PERMISSION_DENIED':
        return PermissionDeniedException(exception.message);
      case 'PERMISSION_REQUEST_IN_PROGRESS':
        return PermissionRequestInProgressException(exception.message);
      case 'LOCATION_UPDATE_FAILURE':
        return PositionUpdateException(exception.message);
      default:
        return exception;
    }
  }
}
