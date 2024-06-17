import 'dart:io';

import 'package:flutter/material.dart';
import 'package:location_beacons_example/domain/repositories/location_beacons_repository.dart';

enum _ActionIndex {
  getLocationAccuracy,
  requestTemporaryFullAccuracy,
  openAppSettings,
  openLocationSettings,
  clear,
}

class LocationBeaconsPopupMenuButton extends StatelessWidget {
  final LocationBeaconsRepository locationBeaconsRepository;
  final VoidCallback onClear;

  const LocationBeaconsPopupMenuButton({
    super.key,
    required this.locationBeaconsRepository,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      iconColor: Colors.white,
      elevation: 40,
      onSelected: (value) async {
        switch (value) {
          case _ActionIndex.getLocationAccuracy:
            locationBeaconsRepository.getLocationAccuracy();
            break;
          case _ActionIndex.requestTemporaryFullAccuracy:
            locationBeaconsRepository.requestTemporaryFullAccuracy();
            break;
          case _ActionIndex.openAppSettings:
            locationBeaconsRepository.openAppSettings();
            break;
          case _ActionIndex.openLocationSettings:
            locationBeaconsRepository.openLocationSettings();
            break;
          case _ActionIndex.clear:
            onClear();
            break;
          default:
            break;
        }
      },
      itemBuilder: (_) => [
        if (Platform.isIOS)
          const PopupMenuItem(
            value: _ActionIndex.getLocationAccuracy,
            child: Text('Get Location Accuracy'),
          ),
        if (Platform.isIOS)
          const PopupMenuItem(
            value: _ActionIndex.requestTemporaryFullAccuracy,
            child: Text('Request Temporary Full Accuracy'),
          ),
        const PopupMenuItem(
          value: _ActionIndex.openAppSettings,
          child: Text('Open App Settings'),
        ),
        const PopupMenuItem(
          value: _ActionIndex.openLocationSettings,
          child: Text('Open Location Settings'),
        ),
        const PopupMenuItem(
          value: _ActionIndex.clear,
          child: Text('Clear'),
        ),
      ],
    );
  }
}
