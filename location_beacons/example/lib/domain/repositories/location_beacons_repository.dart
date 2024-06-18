import 'dart:async';

import 'package:location_beacons/location_beacons.dart';
import 'package:location_beacons_example/domain/types/location_beacons_types.dart';
import 'package:location_beacons_example/domain/types/position_item_type.dart';
import 'package:location_beacons_example/resources/messages_strings.dart';

class LocationBeaconsRepository {
  final OnLog onLog;

  LocationBeaconsRepository({required this.onLog});

  StreamSubscription<ServiceStatus>? _serviceStatusStreamSubscription;
  StreamSubscription<Position>? _positionStreamSubscription;
  var _positionStreamStarted = false;

  bool get isListening => !(_positionStreamSubscription == null ||
      _positionStreamSubscription!.isPaused);

  bool get isPositionStreamStarted => _positionStreamStarted;

  bool get isPositionStreamPaused =>
      _positionStreamSubscription != null &&
      _positionStreamSubscription!.isPaused;

  void dispose() {
    _serviceStatusStreamSubscription?.cancel();
    _positionStreamSubscription?.cancel();
  }

  void togglePositionStreamStarted() {
    _positionStreamStarted = !_positionStreamStarted;
  }

  Future<bool> handlePermission() async {
    final serviceEnabled = await LocationBeacons.isLocationServiceEnabled();

    if (!serviceEnabled) {
      onLog(PositionItemType.log, locationServicesDisabledMessage);
      return false;
    }

    var permission = await LocationBeacons.checkPermission();
    if (permission.isDenied) {
      permission = await LocationBeacons.requestPermission();
      if (permission.isDenied) {
        onLog(PositionItemType.log, permissionDeniedMessage);
        return false;
      }
    }

    if (permission.isPermanentlyDenied) {
      onLog(PositionItemType.log, permissionDeniedForeverMessage);
      return false;
    }

    onLog(PositionItemType.log, permissionGrantedMessage);

    return true;
  }

  void toggleServiceStatusStream() {
    if (_serviceStatusStreamSubscription != null) {
      return;
    }
    final serviceStatusStream = LocationBeacons.getServiceStatusStream();
    _serviceStatusStreamSubscription = serviceStatusStream.handleError((error) {
      _serviceStatusStreamSubscription?.cancel();
      _serviceStatusStreamSubscription = null;
    }).listen((serviceStatus) {
      final String serviceStatusMessage;
      if (serviceStatus.isEnabled) {
        if (_positionStreamStarted) {
          toggleListening();
        }
        serviceStatusMessage = 'enabled';
      } else {
        if (_positionStreamSubscription != null) {
          _positionStreamSubscription?.cancel();
          _positionStreamSubscription = null;
          onLog(PositionItemType.log, positionStreamCancelledMessage);
        }
        serviceStatusMessage = 'disabled';
      }
      onLog(PositionItemType.log,
          'Location service has been $serviceStatusMessage');
    });
  }

  void toggleListening() {
    if (_positionStreamSubscription == null) {
      final positionStream = LocationBeacons.getPositionStream();
      _positionStreamSubscription = positionStream.handleError((error) {
        _positionStreamSubscription?.cancel();
        _positionStreamSubscription = null;
      }).listen((position) {
        onLog(PositionItemType.position, position.toString());
      });
      _positionStreamSubscription?.pause();
    }

    final String statusDisplayValue;
    if (_positionStreamSubscription!.isPaused) {
      _positionStreamSubscription?.resume();
      statusDisplayValue = 'resumed';
    } else {
      _positionStreamSubscription?.pause();
      statusDisplayValue = 'paused';
    }
    onLog(PositionItemType.log, 'Position stream has been $statusDisplayValue');
  }

  Future<void> getCurrentPositions() async {
    final hasPermission = await handlePermission();
    if (!hasPermission) {
      return;
    }
    LocationBeacons.getCurrentPosition().then((position) {
      onLog(PositionItemType.position, position.toString());
    }).ignore();
  }

  Future<void> getLastKnownPosition() async {
    final position = await LocationBeacons.getLastKnownPosition();
    if (position != null) {
      onLog(PositionItemType.position, position.toString());
    } else {
      onLog(PositionItemType.log, positionLastKnownMessage);
    }
  }

  Future<void> getLocationAccuracy() async {
    final accuracy = await LocationBeacons.getLocationAccuracy();
    onLog(PositionItemType.log, '${accuracy.name} location accuracy granted');
  }

  Future<void> requestTemporaryFullAccuracy() async {
    final status = await LocationBeacons.requestTemporaryFullAccuracy(
      purposeKey: 'TemporaryPreciseAccuracy',
    );
    onLog(PositionItemType.log, '${status.name} location accuracy granted');
  }

  Future<void> openAppSettings() async {
    final opened = await LocationBeacons.openAppSettings();
    final displayValue =
        opened ? openedAppSettingsMessage : openErrorAppSettingsMessage;
    onLog(PositionItemType.log, displayValue);
  }

  Future<void> openLocationSettings() async {
    final opened = await LocationBeacons.openLocationSettings();
    final displayValue = opened
        ? openedLocationSettingsMessage
        : openErrorLocationSettingsMessage;
    onLog(PositionItemType.log, displayValue);
  }
}
