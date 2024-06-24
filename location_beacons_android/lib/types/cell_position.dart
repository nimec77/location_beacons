import 'package:geolocator_android/geolocator_android.dart';

class CellPosition extends Position {
  final String status;
  final String message;
  final String address;

  const CellPosition({
    required this.status,
    required this.message,
    required super.accuracy,
    required this.address,
    required super.latitude,
    required super.longitude,
    required super.timestamp,
    required super.altitude,
    required super.altitudeAccuracy,
    required super.heading,
    required super.headingAccuracy,
    required super.speed,
    required super.speedAccuracy,
    super.isMocked = false,
  });

  bool get isSuccess => status == 'success';

  factory CellPosition.fromMap(dynamic message) {
    final positionMap = message as Map<String, dynamic>;

    final position = Position.fromMap(positionMap);

    return CellPosition(
      status: positionMap['status'] ?? 'failure',
      message: positionMap['message'] ?? '',
      accuracy: position.accuracy,
      address: positionMap['address'] ?? '',
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: position.timestamp,
      altitude: position.altitude,
      altitudeAccuracy: position.altitudeAccuracy,
      heading: position.heading,
      headingAccuracy: position.headingAccuracy,
      speed: position.speed,
      speedAccuracy: position.speedAccuracy,
    );
  }
}
