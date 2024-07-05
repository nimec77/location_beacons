package ru.elocont.location_beacons.location_beacons.repositories

import android.content.Context
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.withContext
import ru.elocont.location_beacons.location_beacons.models.response.CellLocation
import ru.elocont.location_beacons.location_beacons.providers.LocationProvider
import ru.elocont.location_beacons.location_beacons.utils.getCurrentCellInfo
import kotlin.time.Duration

class LocationRepository(private val locationProvider: LocationProvider) {

    fun getLastKnownPosition(): CellLocation? = locationProvider.lastCellLocation

    suspend fun fetchLocations(context: Context?, interval: Duration = Duration.ZERO) = flow {
        if (context == null) {
            throw IllegalStateException("Context can't be null")
        }
        do {
            var cellLocation: CellLocation? = null
            val allCellInfo = getCurrentCellInfo(context)
            if (allCellInfo.isNotEmpty()) {
                cellLocation = withContext(Dispatchers.IO) {
                    locationProvider.getLocationByCellInfo(allCellInfo.first())
                }
            }
            emit(cellLocation)
            delay(interval)
        } while (interval > Duration.ZERO)
    }
}