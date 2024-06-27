package ru.elocont.location_beacons.location_beacons.handlers

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import ru.elocont.location_beacons.location_beacons.repositories.LocationRepository
import ru.elocont.location_beacons.location_beacons.services.buildUnwiredLabsService

class LocationHandler() {
    private val locationRepository = LocationRepository.instance

    fun onGetLastKnownPosition(call: MethodCall, result: MethodChannel.Result) {
        result.success(locationRepository.lastCellLocation?.toMap())
    }
}