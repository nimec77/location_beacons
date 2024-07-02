package ru.elocont.location_beacons.location_beacons.handlers

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.launch
import ru.elocont.location_beacons.location_beacons.errors.ErrorCodes
import ru.elocont.location_beacons.location_beacons.interfaces.LocationBeaconsHandler
import ru.elocont.location_beacons.location_beacons.repositories.LocationRepository
import ru.elocont.location_beacons.location_beacons.types.FetchLocationStatus

class LocationHandler(private val locationRepository: LocationRepository) :
    LocationBeaconsHandler {

    private val locationScope = CoroutineScope(SupervisorJob() + Dispatchers.Main)

    private var job: Job? = null
    private var fetchLocationStatus: FetchLocationStatus = FetchLocationStatus.none
    private var context: Context? = null

    override fun startListening(context: Context, messenger: BinaryMessenger) {
        this.context = context
    }

    override fun stopListening() {
        context = null
        job?.cancel()
        job = null
        fetchLocationStatus = FetchLocationStatus.none
    }

    fun onGetLastKnownPosition(call: MethodCall, result: MethodChannel.Result) {
        result.success(locationRepository.getLastKnownPosition()?.toMap())
    }

    fun onGetCurrentPosition(call: MethodCall, result: MethodChannel.Result) {
        job?.cancel()
        job = locationScope.launch {
            locationRepository.fetchLocation(context)
                .catch {
                    it.printStackTrace()
                    result.error(
                        ErrorCodes.errorWhileAcquiringPosition.toString(),
                        it.message,
                        null
                    )
                }
                .collect { cellLocation ->
                    if (cellLocation == null) {
                        result.success(null)
                    } else {
                        if (cellLocation.isSuccess()) {
                            result.success(cellLocation.toMap())
                        } else {
                            result.error(
                                ErrorCodes.errorWhileAcquiringPosition.toString(),
                                cellLocation.message,
                                null
                            )
                        }
                    }
                }
        }
    }
}