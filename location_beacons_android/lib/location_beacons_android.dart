import 'dart:async';

import 'package:flutter/services.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:location_beacons_android/types/cell_position.dart';
import 'package:location_beacons_platform_interface/location_beacons_platform_interface.dart';

final class LocationBeaconsAndroid extends LocationBeaconsPlatform {
  static const _channel = MethodChannel('location_beacons_android');

  static const _eventChannel =
      EventChannel('location_beacons_android/position_updates');

  static const _serviceStatusEventChannel =
      EventChannel('location_beacons_android/service_status_updates');

  final _geolocatorAndroid = GeolocatorAndroid();

  Stream<Position>? _positionStream;
  Stream<ServiceStatus>? _serviceStatusStream;

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

  @override
  Future<LocationAccuracyStatus> getLocationAccuracy() async {
    return LocationAccuracyStatus.reduced;
  }

  @override
  Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
  }) async {
    try {
      Future<dynamic> positionFuture;

      final timeLimit = locationSettings?.timeLimit;

      if (timeLimit != null) {
        positionFuture = _channel
            .invokeMethod(
              'getCurrentPosition',
              locationSettings?.toJson(),
            )
            .timeout(timeLimit);
      } else {
        positionFuture = _channel.invokeMethod(
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
    if (_serviceStatusStream != null) {
      return _serviceStatusStream!;
    }

    final serviceStatusStream =
        _serviceStatusEventChannel.receiveBroadcastStream();

    _serviceStatusStream = serviceStatusStream
        .map((event) => ServiceStatus.values[event as int])
        .handleError((error) {
      _serviceStatusStream = null;
      if (error is PlatformException) {
        final exception = _handlePlatformException(error);
        throw exception;
      } else {
        throw error;
      }
    });

    return _serviceStatusStream!;
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
          sink.addError(TimeoutException(
            'Time limit reached while waiting for position update.',
            timeLimit,
          ));
          sink.close();
        },
      );
    }

    _positionStream = positionStream
        .map<Position>(
            (event) => CellPosition.fromMap(event.cast<String, dynamic>()))
        .handleError((error) {
      if (error is PlatformException) {
        final exception = _handlePlatformException(error);
        throw exception;
      } else {
        throw error;
      }
    });

    return _positionStream!;
  }

  @override
  Future<LocationAccuracyStatus> requestTemporaryFullAccuracy({
    required String purposeKey,
  }) async {
    return LocationAccuracyStatus.reduced;
  }

  @override
  Future<bool> openAppSettings() async {
    return _geolocatorAndroid.openAppSettings();
  }

  @override
  Future<bool> openLocationSettings() async {
    return _geolocatorAndroid.openLocationSettings();
  }

  Stream<dynamic> _wrapStream(Stream<dynamic> incoming) {
    return incoming.asBroadcastStream(onCancel: (subscription) {
      subscription.cancel();
      _positionStream = null;
    });
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
