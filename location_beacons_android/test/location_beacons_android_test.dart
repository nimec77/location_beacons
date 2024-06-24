import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:location_beacons_android/location_beacons_android.dart';

import 'method_channel_mock.dart';

Position get mockPosition => AndroidPosition(
      latitude: 52.561270,
      longitude: 5.639382,
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        500,
        isUtc: true,
      ),
      altitude: 3000.0,
      altitudeAccuracy: 0.0,
      satelliteCount: 2.0,
      satellitesUsedInFix: 2.0,
      accuracy: 0.0,
      heading: 0.0,
      headingAccuracy: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      isMocked: false,
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
  });
}
