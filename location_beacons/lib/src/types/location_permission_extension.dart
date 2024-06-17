import 'package:geolocator/geolocator.dart';

extension LocationPermissionExtension on LocationPermission {
  bool get isGranted =>
      this == LocationPermission.always ||
      this == LocationPermission.whileInUse;
  bool get isDenied => this == LocationPermission.denied;
  bool get isPermanentlyDenied => this == LocationPermission.deniedForever;
}
