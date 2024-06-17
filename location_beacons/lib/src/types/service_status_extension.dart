import 'package:location_beacons/location_beacons.dart';

extension ServiceStatusExtension on ServiceStatus {
  bool get isDisabled => this == ServiceStatus.disabled;
  bool get isEnabled => this == ServiceStatus.enabled;
}