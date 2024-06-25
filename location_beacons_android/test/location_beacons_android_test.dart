import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:location_beacons_android/location_beacons_android.dart';
import 'package:location_beacons_android/types/cell_position.dart';

import 'event_channel_mock.dart';
import 'method_channel_mock.dart';

Position get mockCellPosition => CellPosition(
      status: 'success',
      message: 'Message Text',
      address: 'Address Text',
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
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('$LocationBeaconsAndroid()', () {
    final log = <MethodCall>[];

    tearDown(log.clear);

    group('init: Setting API_KEY for https://opencellid.org/', () {
      const apiKey = 'API_KEY';
      test('Should set the API_KEY', () async {
        final channel = MethodChannelMock(
          channelName: 'location_beacons_android',
          methods: [
            const MethodMock(methodName: 'init'),
          ],
        );

        await LocationBeaconsAndroid().init(apiKey);

        expect(channel.log, <Matcher>[
          isMethodCall('init', arguments: apiKey),
        ]);
      });
    });

    group('checkPermission: When checking for permission', () {
      test(
          // ignore: lines_longer_than_80_chars
          'Should receive whenInUse if permission is granted when App is in use',
          () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_android',
          methods: [
            MethodMock(
              methodName: 'checkPermission',
              result: LocationPermission.whileInUse.index,
            ),
          ],
        );

        // Act
        final permission = await LocationBeaconsAndroid().checkPermission();

        // Assert
        expect(
          permission,
          LocationPermission.whileInUse,
        );
      });

      test('Should receive always if permission is granted always', () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_android',
          methods: [
            MethodMock(
              methodName: 'checkPermission',
              result: LocationPermission.always.index,
            ),
          ],
        );

        // Act
        final permission = await LocationBeaconsAndroid().checkPermission();

        // Assert
        expect(
          permission,
          LocationPermission.always,
        );
      });

      test('Should receive denied if permission is denied', () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_android',
          methods: [
            MethodMock(
              methodName: 'checkPermission',
              result: LocationPermission.denied.index,
            ),
          ],
        );

        // Act
        final permission = await LocationBeaconsAndroid().checkPermission();

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
          channelName: 'flutter.baseflow.com/geolocator_android',
          methods: [
            MethodMock(
              methodName: 'checkPermission',
              result: LocationPermission.deniedForever.index,
            ),
          ],
        );

        // Act
        final permission = await LocationBeaconsAndroid().checkPermission();

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
          channelName: 'flutter.baseflow.com/geolocator_android',
          methods: [
            MethodMock(
              methodName: 'checkPermission',
              result: PlatformException(
                code: 'PERMISSION_DEFINITIONS_NOT_FOUND',
                message: 'Permission definitions are not found.',
                details: null,
              ),
            ),
          ],
        );

        // Act
        final permissionFuture = LocationBeaconsAndroid().checkPermission();

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

    group('requestPermission: When requesting for permission', () {
      test(
          // ignore: lines_longer_than_80_chars
          'Should receive whenInUse if permission is granted when App is in use',
          () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_android',
          methods: [
            MethodMock(
              methodName: 'requestPermission',
              result: LocationPermission.whileInUse.index,
            ),
          ],
        );

        // Act
        final permission = await LocationBeaconsAndroid().requestPermission();

        // Assert
        expect(
          permission,
          LocationPermission.whileInUse,
        );
      });

      test('Should receive always if permission is granted always', () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_android',
          methods: [
            MethodMock(
              methodName: 'requestPermission',
              result: LocationPermission.always.index,
            ),
          ],
        );

        // Act
        final permission = await GeolocatorAndroid().requestPermission();

        // Assert
        expect(
          permission,
          LocationPermission.always,
        );
      });

      test('Should receive denied if permission is denied', () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_android',
          methods: [
            MethodMock(
              methodName: 'requestPermission',
              result: LocationPermission.denied.index,
            )
          ],
        );

        // Act
        final permission = await LocationBeaconsAndroid().requestPermission();

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
          channelName: 'flutter.baseflow.com/geolocator_android',
          methods: [
            MethodMock(
              methodName: 'requestPermission',
              result: LocationPermission.deniedForever.index,
            ),
          ],
        );

        // Act
        final permission = await LocationBeaconsAndroid().requestPermission();

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
          channelName: 'flutter.baseflow.com/geolocator_android',
          methods: [
            MethodMock(
              methodName: 'requestPermission',
              result: PlatformException(
                code: 'PERMISSION_REQUEST_IN_PROGRESS',
                message: 'Permissions already being requested.',
                details: null,
              ),
            ),
          ],
        );

        // Act
        final permissionFuture = LocationBeaconsAndroid().requestPermission();

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
          channelName: 'flutter.baseflow.com/geolocator_android',
          methods: [
            MethodMock(
              methodName: 'requestPermission',
              result: PlatformException(
                code: 'PERMISSION_DEFINITIONS_NOT_FOUND',
                message: 'Permission definitions are not found.',
                details: null,
              ),
            ),
          ],
        );

        // Act
        final permissionFuture = LocationBeaconsAndroid().requestPermission();

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
          channelName: 'flutter.baseflow.com/geolocator_android',
          methods: [
            MethodMock(
              methodName: 'requestPermission',
              result: PlatformException(
                code: 'ACTIVITY_MISSING',
                message: 'Activity is missing.',
                details: null,
              ),
            ),
          ],
        );

        // Act
        final permissionFuture = LocationBeaconsAndroid().requestPermission();

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

    group('getLastKnownPosition: When requesting the last know position', () {
      test('Should receive a position if permissions are granted', () async {
        // Arrange
        final methodChannel = MethodChannelMock(
          channelName: 'location_beacons_android',
          methods: [
            MethodMock(
              methodName: 'getLastKnownPosition',
              result: mockCellPosition.toJson(),
            ),
          ],
        );

        final expectedArguments = <String, dynamic>{
          'forceLocationManager': false,
        };

        // Act
        final position = await LocationBeaconsAndroid().getLastKnownPosition(
          forceLocationManager: false,
        );

        // Arrange
        expect(position, mockCellPosition);
        expect(methodChannel.log, [
          isMethodCall(
            'getLastKnownPosition',
            arguments: expectedArguments,
          ),
        ]);
      });

      test('Should receive an exception if permissions are denied', () async {
        // Arrange
        MethodChannelMock(
          channelName: 'location_beacons_android',
          methods: [
            MethodMock(
              methodName: 'getLastKnownPosition',
              result: PlatformException(
                code: 'PERMISSION_DENIED',
                message: 'Permission denied',
                details: null,
              ),
            ),
          ],
        );

        // Act
        final future = LocationBeaconsAndroid().getLastKnownPosition(
          forceLocationManager: false,
        );

        // Assert
        expect(
          future,
          throwsA(
            isA<PermissionDeniedException>().having(
              (e) => e.message,
              'description',
              'Permission denied',
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
          channelName: 'location_beacons_android',
          methods: const [
            MethodMock(
              methodName: 'isLocationServiceEnabled',
              result: true,
            ),
          ],
        );

        // Act
        final isLocationServiceEnabled =
            await LocationBeaconsAndroid().isLocationServiceEnabled();

        // Assert
        expect(
          isLocationServiceEnabled,
          true,
        );
      });

      test('Should receive false if location services are disabled', () async {
        // Arrange
        MethodChannelMock(
          channelName: 'location_beacons_android',
          methods: const [
            MethodMock(
              methodName: 'isLocationServiceEnabled',
              result: false,
            ),
          ],
        );

        // Act
        final isLocationServiceEnabled =
            await LocationBeaconsAndroid().isLocationServiceEnabled();

        // Assert
        expect(
          isLocationServiceEnabled,
          false,
        );
      });
    });

    group('getLocationAccuracy: When requesting the Location Accuracy Status',
        () {
      test('Should receive reduced accuracy', () async {
        // Arrange
        final methodChannel = MethodChannelMock(
          channelName: 'location_beacons_android',
          methods: const [
            MethodMock(
              methodName: 'getLocationAccuracy',
              result: 0,
            ),
          ],
        );

        // Act
        final locationAccuracy =
            await LocationBeaconsAndroid().getLocationAccuracy();

        // Assert
        // No method calls are made to the channel
        expect(methodChannel.log.isEmpty, true);
        expect(locationAccuracy, LocationAccuracyStatus.reduced);
      });
    });

    group('getCurrentPosition: When requesting the current position', () {
      test('Should receive a position if permissions are granted', () async {
        // Arrange
        final channel = MethodChannelMock(
          channelName: 'location_beacons_android',
          methods: [
            MethodMock(
              methodName: 'getCurrentPosition',
              result: mockCellPosition.toJson(),
            ),
          ],
        );

        const locationSettings =
            LocationSettings(accuracy: LocationAccuracy.low);

        final expectedArguments = <String, dynamic>{
          ...locationSettings.toJson(),
        };

        // Act
        final position = await LocationBeaconsAndroid().getCurrentPosition(
          locationSettings: locationSettings,
        );

        // Assert
        expect(position, mockCellPosition);
        expect(channel.log, [
          isMethodCall(
            'getCurrentPosition',
            arguments: expectedArguments,
          ),
        ]);
      });

      test('Should receive a position for each call', () async {
        // Arrange
        final channel = MethodChannelMock(
          channelName: 'location_beacons_android',
          methods: [
            MethodMock(
              methodName: 'getCurrentPosition',
              result: mockCellPosition.toJson(),
            ),
          ],
        );

        const locationSettingsFirst =
            LocationSettings(accuracy: LocationAccuracy.low);
        const locationSettingsSecond =
            LocationSettings(accuracy: LocationAccuracy.high);

        final expectedFirstArguments = <String, dynamic>{
          ...locationSettingsFirst.toJson(),
        };
        final expectedSecondArguments = <String, dynamic>{
          ...locationSettingsSecond.toJson(),
        };

        // Act
        final plugin = LocationBeaconsAndroid();
        final firstPosition = await plugin.getCurrentPosition(
          locationSettings: locationSettingsFirst,
        );
        final secondPosition = await plugin.getCurrentPosition(
          locationSettings: locationSettingsSecond,
        );

        // Assert
        expect(firstPosition, mockCellPosition);
        expect(secondPosition, mockCellPosition);
        expect(channel.log, [
          isMethodCall(
            'getCurrentPosition',
            arguments: expectedFirstArguments,
          ),
          isMethodCall(
            'getCurrentPosition',
            arguments: expectedSecondArguments,
          ),
        ]);
      });

      test('Should throw a permission denied exception if permission is denied',
          () async {
        // Arrange
        MethodChannelMock(
          channelName: 'location_beacons_android',
          methods: [
            MethodMock(
              methodName: 'getCurrentPosition',
              result: PlatformException(
                code: 'PERMISSION_DENIED',
                message: 'Permission denied',
                details: null,
              ),
            ),
          ],
        );

        // Act
        final future = LocationBeaconsAndroid().getCurrentPosition();

        // Assert
        expect(
          future,
          throwsA(
            isA<PermissionDeniedException>().having(
              (e) => e.message,
              'message',
              'Permission denied',
            ),
          ),
        );
      });

      test(
          // ignore: lines_longer_than_80_chars
          'Should throw a location service disabled exception if location services are disabled',
          () async {
        // Arrange
        MethodChannelMock(
          channelName: 'location_beacons_android',
          methods: [
            MethodMock(
              methodName: 'getCurrentPosition',
              result: PlatformException(
                code: 'LOCATION_SERVICES_DISABLED',
                message: '',
                details: null,
              ),
            ),
          ],
        );

        // Act
        final future = LocationBeaconsAndroid().getCurrentPosition();

        // Assert
        expect(
          future,
          throwsA(isA<LocationServiceDisabledException>()),
        );
      });

      test('Should throw a timeout exception when timeLimit is reached',
          () async {
        // Arrange
        MethodChannelMock(
          channelName: 'location_beacons_android',
          methods: [
            MethodMock(
              methodName: 'getCurrentPosition',
              delay: const Duration(milliseconds: 10),
              result: mockCellPosition.toJson(),
            ),
          ],
        );

        try {
          await LocationBeaconsAndroid().getCurrentPosition(
            locationSettings: const LocationSettings(
              timeLimit: Duration(milliseconds: 5),
            ),
          );

          fail('Expected a TimeoutException and should not reach here.');
        } on TimeoutException catch (e) {
          expect(e, isA<TimeoutException>());
        }
      });
    });

    group(
        // ignore: lines_longer_than_80_chars
        'getServiceStream: When requesting a stream of location service status updates',
        () {
      group('And requesting for location service status updates multiple times',
          () {
        test('Should return the same stream', () {
          final plugin = GeolocatorAndroid();
          final firstStream = plugin.getServiceStatusStream();
          final secondStream = plugin.getServiceStatusStream();

          expect(
            identical(firstStream, secondStream),
            true,
          );
        });
      });

      test(
          // ignore: lines_longer_than_80_chars
          'Should receive a stream with location service updates if permissions are granted',
          () async {
        // Arrange
        final streamController = StreamController<int>.broadcast();
        EventChannelMock(
            channelName: 'location_beacons_android/service_status_updates',
            stream: streamController.stream);

        // Act
        final locationServiceStream =
            LocationBeaconsAndroid().getServiceStatusStream();
        final streamQueue = StreamQueue(locationServiceStream);

        // Emit test events
        streamController.add(0); // disabled value in native enum
        streamController.add(1); // enabled value in native enum

        //Assert
        expect(await streamQueue.next, ServiceStatus.disabled);
        expect(await streamQueue.next, ServiceStatus.enabled);

        // Clean up
        await streamQueue.cancel();
        await streamController.close();
      });

      test(
          // ignore: lines_longer_than_80_chars
          'Should receive an exception if android activity is missing',
          () async {
        // Arrange
        final streamController =
            StreamController<PlatformException>.broadcast();
        EventChannelMock(
          channelName: 'location_beacons_android/service_status_updates',
          stream: streamController.stream,
        );

        // Act
        final positionStream =
            LocationBeaconsAndroid().getServiceStatusStream();
        final streamQueue = StreamQueue(positionStream);

        // Emit test error
        streamController.addError(PlatformException(
          code: 'ACTIVITY_MISSING',
          message: 'Activity missing',
          details: null,
        ));

        // Assert
        expect(
            streamQueue.next,
            throwsA(
              isA<ActivityMissingException>().having(
                (e) => e.message,
                'message',
                'Activity missing',
              ),
            ));

        // Clean up
        streamQueue.cancel();
        streamController.close();
      });
    });

    group('getPositionStream: When requesting a stream of position updates',
        () {
      group('And requesting for position update multiple times', () {
        test('Should return the same stream', () {
          final plugin = LocationBeaconsAndroid();
          final firstStream = plugin.getPositionStream();
          final secondStream = plugin.getPositionStream();

          expect(
            identical(firstStream, secondStream),
            true,
          );
        });

        test('Should return a new stream when all subscriptions are cancelled',
            () {
          final plugin = LocationBeaconsAndroid();

          // Get two position streams
          final firstStream = plugin.getPositionStream();
          final secondStream = plugin.getPositionStream();

          // Streams are the same object
          expect(firstStream == secondStream, true);

          // Add multiple subscriptions
          final firstSubscription = firstStream.listen((_) {});
          final secondSubscription = secondStream.listen((_) {});

          // Cancel first subscription
          firstSubscription.cancel();

          // Stream is still the same as the first one
          final cachedStream = plugin.getPositionStream();
          expect(firstStream == cachedStream, true);

          // Cancel second subscription
          secondSubscription.cancel();

          // After all listeners have been removed, the next stream
          // retrieved is a new one.
          final thirdStream = plugin.getPositionStream();
          expect(firstStream != thirdStream, true);
        });
      });

      test('PositionStream can be listened to and can be canceled', () {
        // Arrange
        final streamController =
            StreamController<Map<String, dynamic>>.broadcast();
        EventChannelMock(
          channelName: 'location_beacons_android/position_updates',
          stream: streamController.stream,
        );

        var stream = LocationBeaconsAndroid().getPositionStream(
            locationSettings: AndroidSettings(useMSLAltitude: false));
        final streamSubscription = stream.listen((_) {});

        streamSubscription.pause();
        expect(streamSubscription.isPaused, true);
        streamSubscription.resume();
        expect(streamSubscription.isPaused, false);
        streamSubscription.cancel();
      });

      test(
          // ignore: lines_longer_than_80_chars
          'Should correctly handle done event', () async {
        // Arrange
        final completer = Completer();
        completer.future.timeout(const Duration(milliseconds: 50),
            onTimeout: () =>
                fail('getPositionStream should trigger done and not timeout.'));
        final streamController =
            StreamController<Map<String, dynamic>>.broadcast();
        EventChannelMock(
          channelName: 'location_beacons_android/position_updates',
          stream: streamController.stream,
        );

        // Act
        LocationBeaconsAndroid().getPositionStream().listen(
              (_) {},
              onDone: completer.complete,
            );

        await streamController.close();

        //Assert
        await completer.future;
      });

      test(
          // ignore: lines_longer_than_80_chars
          'Should receive a stream with position updates if permissions are granted',
          () async {
        // Arrange
        final streamController =
            StreamController<Map<String, dynamic>>.broadcast();
        EventChannelMock(
          channelName: 'location_beacons_android/position_updates',
          stream: streamController.stream,
        );

        // Act
        final positionStream = LocationBeaconsAndroid().getPositionStream(
            locationSettings: AndroidSettings(useMSLAltitude: false));
        final streamQueue = StreamQueue(positionStream);

        // Emit test events
        streamController.add(mockCellPosition.toJson());
        streamController.add(mockCellPosition.toJson());
        streamController.add(mockCellPosition.toJson());

        // Assert
        expect(await streamQueue.next, mockCellPosition);
        expect(await streamQueue.next, mockCellPosition);
        expect(await streamQueue.next, mockCellPosition);

        // Clean up
        await streamQueue.cancel();
        await streamController.close();
      });

      test(
          // ignore: lines_longer_than_80_chars
          'Should continue listening to the stream when exception is thrown ',
          () async {
        // Arrange
        final streamController =
            StreamController<Map<String, dynamic>>.broadcast();
        EventChannelMock(
          channelName: 'location_beacons_android/position_updates',
          stream: streamController.stream,
        );

        // Act
        final positionStream = LocationBeaconsAndroid().getPositionStream();
        final streamQueue = StreamQueue(positionStream);

        // Emit test events
        streamController.add(mockCellPosition.toJson());
        streamController.addError(PlatformException(
          code: 'PERMISSION_DENIED',
          message: 'Permission denied',
          details: null,
        ));
        streamController.add(mockCellPosition.toJson());

        // Assert
        expect(await streamQueue.next, mockCellPosition);
        expect(
            streamQueue.next,
            throwsA(
              isA<PermissionDeniedException>().having(
                (e) => e.message,
                'message',
                'Permission denied',
              ),
            ));
        expect(await streamQueue.next, mockCellPosition);

        // Clean up
        await streamQueue.cancel();
        await streamController.close();
      });

      test(
          // ignore: lines_longer_than_80_chars
          'Should receive a permission denied exception if permission is denied',
          () async {
        // Arrange
        final streamController =
            StreamController<PlatformException>.broadcast();
        EventChannelMock(
          channelName: 'location_beacons_android/position_updates',
          stream: streamController.stream,
        );

        // Act
        final positionStream = LocationBeaconsAndroid().getPositionStream();
        final streamQueue = StreamQueue(positionStream);

        // Emit test error
        streamController.addError(PlatformException(
          code: 'PERMISSION_DENIED',
          message: 'Permission denied',
          details: null,
        ));

        // Assert
        expect(
            streamQueue.next,
            throwsA(
              isA<PermissionDeniedException>().having(
                (e) => e.message,
                'message',
                'Permission denied',
              ),
            ));

        // Clean up
        streamQueue.cancel();
        streamController.close();
      });

      test(
          // ignore: lines_longer_than_80_chars
          'Should receive a location service disabled exception if location service is disabled',
          () async {
        // Arrange
        final streamController =
            StreamController<PlatformException>.broadcast();
        EventChannelMock(
          channelName: 'location_beacons_android/position_updates',
          stream: streamController.stream,
        );

        // Act
        final positionStream = LocationBeaconsAndroid().getPositionStream();
        final streamQueue = StreamQueue(positionStream);

        // Emit test error
        streamController.addError(PlatformException(
          code: 'LOCATION_SERVICES_DISABLED',
          message: 'Location services disabled',
          details: null,
        ));

        // Assert
        expect(
            streamQueue.next,
            throwsA(
              isA<LocationServiceDisabledException>(),
            ));

        // Clean up
        streamQueue.cancel();
        streamController.close();
      });

      test(
          // ignore: lines_longer_than_80_chars
          'Should receive a already subscribed exception', () async {
        // Arrange
        final streamController =
            StreamController<PlatformException>.broadcast();
        EventChannelMock(
          channelName: 'location_beacons_android/position_updates',
          stream: streamController.stream,
        );

        // Act
        final positionStream = LocationBeaconsAndroid().getPositionStream();
        final streamQueue = StreamQueue(positionStream);

        // Emit test error
        streamController.addError(PlatformException(
          code: 'PERMISSION_REQUEST_IN_PROGRESS',
          message: 'A permission request is already in progress',
          details: null,
        ));

        // Assert
        expect(
            streamQueue.next,
            throwsA(
              isA<PermissionRequestInProgressException>(),
            ));

        // Clean up
        streamQueue.cancel();
        streamController.close();
      });

      test(
          // ignore: lines_longer_than_80_chars
          'Should receive a already subscribed exception', () async {
        // Arrange
        final streamController =
            StreamController<PlatformException>.broadcast();
        EventChannelMock(
          channelName: 'location_beacons_android/position_updates',
          stream: streamController.stream,
        );

        // Act
        final positionStream = LocationBeaconsAndroid().getPositionStream();
        final streamQueue = StreamQueue(positionStream);

        // Emit test error
        streamController.addError(PlatformException(
          code: 'LOCATION_SUBSCRIPTION_ACTIVE',
          message: 'Already subscribed to receive a position stream',
          details: null,
        ));

        // Assert
        expect(
            streamQueue.next,
            throwsA(
              isA<AlreadySubscribedException>(),
            ));

        // Clean up
        streamQueue.cancel();
        streamController.close();
      });

      test(
          // ignore: lines_longer_than_80_chars
          'Should receive a position update exception', () async {
        // Arrange
        final streamController =
            StreamController<PlatformException>.broadcast();
        EventChannelMock(
          channelName: 'location_beacons_android/position_updates',
          stream: streamController.stream,
        );

        // Act
        final positionStream = LocationBeaconsAndroid().getPositionStream();
        final streamQueue = StreamQueue(positionStream);

        // Emit test error
        streamController.addError(PlatformException(
          code: 'LOCATION_UPDATE_FAILURE',
          message: 'A permission request is already in progress',
          details: null,
        ));

        // Assert
        expect(
            streamQueue.next,
            throwsA(
              isA<PositionUpdateException>(),
            ));

        // Clean up
        streamQueue.cancel();
        streamController.close();
      });

      test('Should throw a timeout exception when timeLimit is reached',
          () async {
        // Arrange
        final streamController = StreamController<Map<String, dynamic>>();
        EventChannelMock(
          channelName: 'location_beacons_android/position_updates',
          stream: streamController.stream,
        );
        const expectedArguments = LocationSettings(
          accuracy: LocationAccuracy.low,
          distanceFilter: 0,
        );

        // Act
        final positionStream = LocationBeaconsAndroid().getPositionStream(
          locationSettings: LocationSettings(
            accuracy: expectedArguments.accuracy,
            timeLimit: const Duration(milliseconds: 5),
          ),
        );
        final streamQueue = StreamQueue(positionStream);

        streamController.add(mockCellPosition.toJson());

        await Future.delayed(const Duration(milliseconds: 5));

        // Assert
        expect(await streamQueue.next, mockCellPosition);
        expect(streamQueue.next, throwsA(isA<TimeoutException>()));
      });

      test('Should cleanup the previous stream on timeout exception', () async {
        // Arrange
        final streamController = StreamController<Map<String, dynamic>>();
        final retryController = StreamController<Map<String, dynamic>>();
        late final Stream<Position> retryStream;

        EventChannelMock(
          channelName: 'location_beacons_android/position_updates',
          stream: streamController.stream,
        );
        const locationSettings = LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(milliseconds: 5),
        );

        final geolocator = LocationBeaconsAndroid();

        // Act
        final positionStream = geolocator.getPositionStream(
          locationSettings: locationSettings,
        );

        final subscription = positionStream.listen((_) {});

        // Listen for position changes again on timeout
        subscription.onError((_) {
          EventChannelMock(
            channelName: 'location_beacons_android/position_updates',
            stream: retryController.stream,
          );
          retryStream = geolocator.getPositionStream(
            locationSettings: locationSettings,
          );
        });

        await Future.delayed(const Duration(milliseconds: 5));

        final streamQueue = StreamQueue(retryStream);
        retryController.add(mockCellPosition.toJson());

        // Assert

        // If previous stream is not properly cleaned up this will have no elements
        expect(await streamQueue.next, mockCellPosition);
      });
    });

    group(
        'requestTemporaryFullAccuracy: When requesting temporary full'
        'accuracy.', () {
      test('Should receive reduced accuracy always', () async {
        // Arrange
        final methodChannel = MethodChannelMock(
          channelName: 'location_beacons_android',
          methods: const [
            MethodMock(
              methodName: 'requestTemporaryFullAccuracy',
              result: 0,
            ),
          ],
        );

        // Act
        final accuracy =
            await LocationBeaconsAndroid().requestTemporaryFullAccuracy(
          purposeKey: 'purposeKeyValue',
        );

        // Assert
        expect(accuracy, LocationAccuracyStatus.reduced);

        expect(methodChannel.log.isEmpty, true);
      });
    });

    group('openAppSettings: When opening the App settings', () {
      test('Should receive true if the page can be opened', () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_android',
          methods: const [
            MethodMock(
              methodName: 'openAppSettings',
              result: true,
            ),
          ],
        );

        // Act
        final hasOpenedAppSettings =
            await LocationBeaconsAndroid().openAppSettings();

        // Assert
        expect(
          hasOpenedAppSettings,
          true,
        );
      });

      test('Should receive false if an error occurred', () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_android',
          methods: const [
            MethodMock(
              methodName: 'openAppSettings',
              result: false,
            ),
          ],
        );

        // Act
        final hasOpenedAppSettings =
            await LocationBeaconsAndroid().openAppSettings();

        // Assert
        expect(
          hasOpenedAppSettings,
          false,
        );
      });

          group('openLocationSettings: When opening the Location settings', () {
      test('Should receive true if the page can be opened', () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_android',
          methods: const [
            MethodMock(
              methodName: 'openLocationSettings',
              result: true,
            ),
          ],
        );

        // Act
        final hasOpenedLocationSettings =
            await LocationBeaconsAndroid().openLocationSettings();

        // Assert
        expect(
          hasOpenedLocationSettings,
          true,
        );
      });

      test('Should receive false if an error occurred', () async {
        // Arrange
        MethodChannelMock(
          channelName: 'flutter.baseflow.com/geolocator_android',
          methods: const [
            MethodMock(
              methodName: 'openLocationSettings',
              result: false,
            ),
          ],
        );

        // Act
        final hasOpenedLocationSettings =
            await LocationBeaconsAndroid().openLocationSettings();

        // Assert
        expect(
          hasOpenedLocationSettings,
          false,
        );
      });
    });
    });
  });
}
