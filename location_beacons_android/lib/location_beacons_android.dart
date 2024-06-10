import 'package:flutter/services.dart';
import 'package:location_beacons_platform_interface/location_beacons_platform_interface.dart';

final class LocationBeaconsAndroid extends LocationBeaconsPlatform {
  static const MethodChannel _channel =
      MethodChannel('location_beacons_android');

  static void registerWith() {
    LocationBeaconsPlatform.instance = LocationBeaconsAndroid();
  }

  @override
  Future<String?> getPlatformVersion() async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
