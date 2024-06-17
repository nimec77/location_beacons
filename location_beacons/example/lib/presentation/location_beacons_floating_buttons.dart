import 'package:flutter/material.dart';
import 'package:location_beacons_example/domain/repositories/location_beacons_repository.dart';

class LocationBeaconsFloatingButtons extends StatelessWidget {
  final LocationBeaconsRepository locationBeaconsRepository;

  const LocationBeaconsFloatingButtons({
    super.key,
    required this.locationBeaconsRepository,
  });

  Color get _color =>
      locationBeaconsRepository.isListening ? Colors.green : Colors.red;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          onPressed: () {
            locationBeaconsRepository.togglePositionStreamStarted();
            locationBeaconsRepository.toggleListening();
          },
          tooltip: _positionStreamStartedText(),
          backgroundColor: _color,
          child: Icon(
            locationBeaconsRepository.isListening
                ? Icons.pause
                : Icons.play_arrow,
          ),
        ),
        const SizedBox(height: 8),
        FloatingActionButton(
          onPressed: locationBeaconsRepository.getCurrentPositions,
          child: const Icon(Icons.my_location),
        ),
        const SizedBox(height: 8),
        FloatingActionButton(
          onPressed: locationBeaconsRepository.getLastKnownPosition,
          child: const Icon(Icons.bookmark),
        ),
      ],
    );
  }

  String _positionStreamStartedText() {
    if (!locationBeaconsRepository.isPositionStreamStarted) {
      return 'Start position updates';
    }

    return locationBeaconsRepository.isPositionStreamStarted
        ? 'Resume'
        : 'Pause';
  }
}
