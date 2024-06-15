import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_apple/geolocator_apple.dart';
import 'package:location_beacons_ios/location_beacons_ios.dart';

import 'method_channel_mock.dart';

Position get mockPosition => Position(
      latitude: 52.561270,
      longitude: 5.639382,
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        500,
        isUtc: true,
      ),
      altitude: 3000.0,
      altitudeAccuracy: 0.0,
      accuracy: 0.0,
      heading: 0.0,
      headingAccuracy: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      isMocked: false,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('$LocationBeaconsIOS', () {
    final log = <MethodCall>[];

    tearDown(log.clear);

    group('checkPermission: When checking for permission', () {
      test(
          // ignore: lines_longer_than_80_chars
          'Should receive whenInUse if permission is granted when App is in use',
          () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_apple',
          method: 'checkPermission',
          result: LocationPermission.whileInUse.index,
        );

        // Act
        final permission = await LocationBeaconsIOS().checkPermission();

        // Assert
        expect(
          permission,
          LocationPermission.whileInUse,
        );
      });

      test('Should receive always if permission is granted always', () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_apple',
          method: 'checkPermission',
          result: LocationPermission.always.index,
        );

        // Act
        final permission = await LocationBeaconsIOS().checkPermission();

        // Assert
        expect(
          permission,
          LocationPermission.always,
        );
      });

      test('Should receive denied if permission is denied', () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_apple',
          method: 'checkPermission',
          result: LocationPermission.denied.index,
        );

        // Act
        final permission = await LocationBeaconsIOS().checkPermission();

        // Assert
        expect(
          permission,
          LocationPermission.denied,
        );
      });

      test('Should receive deniedForEver if permission is denied for ever',
          () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_apple',
          method: 'checkPermission',
          result: LocationPermission.deniedForever.index,
        );

        // Act
        final permission = await LocationBeaconsIOS().checkPermission();

        // Assert
        expect(
          permission,
          LocationPermission.deniedForever,
        );
      });

      test('Should receive an exception when permission definitions not found',
          () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_apple',
          method: 'checkPermission',
          result: PlatformException(
            code: 'PERMISSION_DEFINITIONS_NOT_FOUND',
            message: 'Permission definitions are not found.',
            details: null,
          ),
        );

        // Act
        final permissionFuture = LocationBeaconsIOS().checkPermission();

        // Assert
        expect(
          permissionFuture,
          throwsA(
            isA<PermissionDefinitionsNotFoundException>().having(
              (e) => e.message,
              'description',
              'Permission definitions are not found.',
            ),
          ),
        );
      });
    });

    group(
        'requestTemporaryFullAccuracy: When requesting temporary full accuracy.',
        () {
      test(
          'Should receive reduced accuracy if Location Accuracy is pinned to'
          ' reduced', () async {
        // Arrange
        final methodChannel = MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_apple',
          method: 'requestTemporaryFullAccuracy',
          result: 0,
        );

        final expectedArguments = <String, dynamic>{
          'purposeKey': 'purposeKeyValue',
        };

        // Act
        final accuracy =
            await LocationBeaconsIOS().requestTemporaryFullAccuracy(
          purposeKey: 'purposeKeyValue',
        );

        // Assert
        expect(accuracy, LocationAccuracyStatus.reduced);

        expect(methodChannel.log, <Matcher>[
          isMethodCall(
            'requestTemporaryFullAccuracy',
            arguments: expectedArguments,
          ),
        ]);
      });

      test(
          'Should receive reduced accuracy if Location Accuracy is already set'
          ' to precise location accuracy', () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_apple',
          method: 'requestTemporaryFullAccuracy',
          result: 1,
        );

        // Act
        final accuracy = await LocationBeaconsIOS()
            .requestTemporaryFullAccuracy(purposeKey: 'purposeKey');

        // Assert
        expect(accuracy, LocationAccuracyStatus.precise);
      });
    });

    test('Should receive an exception when permission definitions not found',
        () async {
      // Arrange
      MethodChannelMock(
        channelName: 'flutter.baseflow.com/geolocator_apple',
        method: 'requestTemporaryFullAccuracy',
        result: PlatformException(
          code: 'PERMISSION_DEFINITIONS_NOT_FOUND',
          message: 'Permission definitions are not found.',
          details: null,
        ),
      );

      // Act
      final future = LocationBeaconsIOS()
          .requestTemporaryFullAccuracy(purposeKey: 'purposeKey');

      // Assert
      expect(
        future,
        throwsA(
          isA<PermissionDefinitionsNotFoundException>().having(
            (e) => e.message,
            'description',
            'Permission definitions are not found.',
          ),
        ),
      );
    });

    group('getLocationAccuracy: When requesting the Location Accuracy Status',
        () {
      test('Should receive reduced accuracy if Location Accuracy is reduced',
          () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_apple',
          method: 'getLocationAccuracy',
          result: 0,
        );

        // Act
        final locationAccuracy =
            await LocationBeaconsIOS().getLocationAccuracy();

        // Assert
        expect(locationAccuracy, LocationAccuracyStatus.reduced);
      });

      test('Should receive reduced accuracy if Location Accuracy is reduced',
          () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_apple',
          method: 'getLocationAccuracy',
          result: 1,
        );

        // Act
        final locationAccuracy =
            await LocationBeaconsIOS().getLocationAccuracy();

        // Assert
        expect(locationAccuracy, LocationAccuracyStatus.precise);
      });
    });

    group('requestPermission: When requesting for permission', () {
      test(
          // ignore: lines_longer_than_80_chars
          'Should receive whenInUse if permission is granted when App is in use',
          () async {
        // Arrange
        MethodChannelMock(
            channelName: 'flutter.baseflow.com/geolocator_apple',
            method: 'requestPermission',
            result: LocationPermission.whileInUse.index);

        // Act
        final permission = await LocationBeaconsIOS().requestPermission();

        // Assert
        expect(
          permission,
          LocationPermission.whileInUse,
        );
      });

      test('Should receive always if permission is granted always', () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_apple',
          method: 'requestPermission',
          result: LocationPermission.always.index,
        );

        // Act
        final permission = await LocationBeaconsIOS().requestPermission();

        // Assert
        expect(
          permission,
          LocationPermission.always,
        );
      });

      test('Should receive denied if permission is denied', () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_apple',
          method: 'requestPermission',
          result: LocationPermission.denied.index,
        );

        // Act
        final permission = await LocationBeaconsIOS().requestPermission();

        // Assert
        expect(
          permission,
          LocationPermission.denied,
        );
      });

      test('Should receive deniedForever if permission is denied for ever',
          () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_apple',
          method: 'requestPermission',
          result: LocationPermission.deniedForever.index,
        );

        // Act
        final permission = await LocationBeaconsIOS().requestPermission();

        // Assert
        expect(
          permission,
          LocationPermission.deniedForever,
        );
      });

      test('Should receive an exception when already requesting permission',
          () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_apple',
          method: 'requestPermission',
          result: PlatformException(
            code: 'PERMISSION_REQUEST_IN_PROGRESS',
            message: 'Permissions already being requested.',
            details: null,
          ),
        );

        // Act
        final permissionFuture = LocationBeaconsIOS().requestPermission();

        // Assert
        expect(
          permissionFuture,
          throwsA(
            isA<PermissionRequestInProgressException>().having(
              (e) => e.message,
              'description',
              'Permissions already being requested.',
            ),
          ),
        );
      });

      test('Should receive an exception when permission definitions not found',
          () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_apple',
          method: 'requestPermission',
          result: PlatformException(
            code: 'PERMISSION_DEFINITIONS_NOT_FOUND',
            message: 'Permission definitions are not found.',
            details: null,
          ),
        );

        // Act
        final permissionFuture = LocationBeaconsIOS().requestPermission();

        // Assert
        expect(
          permissionFuture,
          throwsA(
            isA<PermissionDefinitionsNotFoundException>().having(
              (e) => e.message,
              'description',
              'Permission definitions are not found.',
            ),
          ),
        );
      });

      test('Should receive an exception when android activity is missing',
          () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_apple',
          method: 'requestPermission',
          result: PlatformException(
            code: 'ACTIVITY_MISSING',
            message: 'Activity is missing.',
            details: null,
          ),
        );

        // Act
        final permissionFuture = LocationBeaconsIOS().requestPermission();

        // Assert
        expect(
          permissionFuture,
          throwsA(
            isA<ActivityMissingException>().having(
              (e) => e.message,
              'description',
              'Activity is missing.',
            ),
          ),
        );
      });
    });

    group('isLocationServiceEnabled: When checking the location service status',
        () {
      test('Should receive true if location services are enabled', () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_apple',
          method: 'isLocationServiceEnabled',
          result: true,
        );

        // Act
        final isLocationServiceEnabled =
            await LocationBeaconsIOS().isLocationServiceEnabled();

        // Assert
        expect(
          isLocationServiceEnabled,
          true,
        );
      });

      test('Should receive false if location services are disabled', () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_apple',
          method: 'isLocationServiceEnabled',
          result: false,
        );

        // Act
        final isLocationServiceEnabled =
            await LocationBeaconsIOS().isLocationServiceEnabled();

        // Assert
        expect(
          isLocationServiceEnabled,
          false,
        );
      });
    });

    group('getLastKnownPosition: When requesting the last know position', () {
      test('Should receive a position if permissions are granted', () async {
        // Arrange
        final methodChannel = MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_apple',
          method: 'getLastKnownPosition',
          result: mockPosition.toJson(),
        );

        final expectedArguments = <String, dynamic>{
          'forceLocationManager': false,
        };

        // Act
        final position = await LocationBeaconsIOS().getLastKnownPosition(
          forceLocationManager: false,
        );

        // Arrange
        expect(position, mockPosition);
        expect(methodChannel.log, <Matcher>[
          isMethodCall(
            'getLastKnownPosition',
            arguments: expectedArguments,
          ),
        ]);
      });
    });
  });
}
