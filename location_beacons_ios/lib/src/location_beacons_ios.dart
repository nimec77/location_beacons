import 'dart:async';

import 'package:flutter/services.dart';
import 'package:geolocator_apple/geolocator_apple.dart';
import 'package:location_beacons_platform_interface/location_beacons_platform_interface.dart';

final class LocationBeaconsIOS extends LocationBeaconsPlatform {
  static const _methodChannel = MethodChannel('location_beacons_ios');

  static const _eventChannel =
      EventChannel('location_beacons_ios/position_updates');

  final _geolocatorApple = GeolocatorApple();

  Stream<Position>? _positionStream;

  static void registerWith() {
    LocationBeaconsPlatform.instance = LocationBeaconsIOS();
  }

  @override
  Future<void> init(String apiKey) async {
    // No need to initialize anything on iOS
  }

  @override
  Future<LocationPermission> checkPermission() {
    return _geolocatorApple.checkPermission();
  }

  @override
  Future<LocationAccuracyStatus> requestTemporaryFullAccuracy({
    required String purposeKey,
  }) {
    return _geolocatorApple.requestTemporaryFullAccuracy(
      purposeKey: purposeKey,
    );
  }

  @override
  Future<LocationAccuracyStatus> getLocationAccuracy() {
    return _geolocatorApple.getLocationAccuracy();
  }

  @override
  Future<LocationPermission> requestPermission() {
    return _geolocatorApple.requestPermission();
  }

  @override
  Future<bool> isLocationServiceEnabled() {
    return _geolocatorApple.isLocationServiceEnabled();
  }

  @override
  Future<Position?> getLastKnownPosition({
    bool forceLocationManager = false,
  }) async {
    try {
      final parameters = <String, dynamic>{
        'forceLocationManager': forceLocationManager,
      };

      final positionMap =
          await _methodChannel.invokeMethod('getLastKnownPosition', parameters);

      return positionMap != null ? Position.fromMap(positionMap) : null;
    } on PlatformException catch (e) {
      final error = _handlePlatformException(e);

      throw error;
    }
  }

  @override
  Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
    bool forceLocationManager = false,
  }) async {
    try {
      Future<dynamic> positionFuture;

      final timeLimit = locationSettings?.timeLimit;

      if (timeLimit != null) {
        positionFuture = _methodChannel
            .invokeMethod(
              'getCurrentPosition',
              locationSettings?.toJson(),
            )
            .timeout(timeLimit);
      } else {
        positionFuture = _methodChannel.invokeMethod(
          'getCurrentPosition',
          locationSettings?.toJson(),
        );
      }

      final positionMap = await positionFuture;
      return Position.fromMap(positionMap);
    } on PlatformException catch (e) {
      final error = _handlePlatformException(e);

      throw error;
    }
  }

  @override
  Stream<ServiceStatus> getServiceStatusStream() {
    return _geolocatorApple.getServiceStatusStream();
  }

  @override
  Stream<Position> getPositionStream({
    LocationSettings? locationSettings,
  }) {
    if (_positionStream != null) {
      return _positionStream!;
    }
    final originalStream = _eventChannel.receiveBroadcastStream(
      locationSettings?.toJson(),
    );
    var positionStream = _wrapStream(originalStream);

    final timeLimit = locationSettings?.timeLimit;
    if (timeLimit != null) {
      positionStream = positionStream.timeout(
        timeLimit,
        onTimeout: (sink) {
          _positionStream = null;
          sink.addError(
            TimeoutException(
              'Time limit reached while waiting for position update.',
              timeLimit,
            ),
          );
          sink.close();
        },
      );
    }

    _positionStream = positionStream
        .map<Position>(
            (element) => Position.fromMap(element.cast<String, dynamic>()))
        .handleError(
      (error) {
        if (error is PlatformException) {
          error = _handlePlatformException(error);
        }
        throw error;
      },
    );
    return _positionStream!;
  }

  @override
  Future<bool> openAppSettings() {
    return _geolocatorApple.openAppSettings();
  }

  @override
  Future<bool> openLocationSettings() {
    return _geolocatorApple.openLocationSettings();
  }

  Stream<dynamic> _wrapStream(Stream<dynamic> incoming) {
    return incoming.asBroadcastStream(
      onCancel: (subscription) {
        subscription.cancel();
        _positionStream = null;
      },
    );
  }

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
