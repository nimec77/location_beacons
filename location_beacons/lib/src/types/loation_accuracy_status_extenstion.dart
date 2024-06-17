import 'package:location_beacons/location_beacons.dart';

extension LocationAccuracyStatusExtension on LocationAccuracyStatus {
  String get name {
    switch (this) {
      case LocationAccuracyStatus.reduced:
        return 'Reduced';
      case LocationAccuracyStatus.precise:
        return 'Precise';
      case LocationAccuracyStatus.unknown:
        return 'Unknown';
    }
  }
}