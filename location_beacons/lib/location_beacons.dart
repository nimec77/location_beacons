
import 'package:location_beacons_platform_interface/location_beacons_platform_interface.dart';

class LocationBeacons {
  static LocationBeaconsPlatform get _platform =>
      LocationBeaconsPlatform.instance;

  static Future<String?> getPlatformVersion() {
    return _platform.getPlatformVersion();
  }
}
