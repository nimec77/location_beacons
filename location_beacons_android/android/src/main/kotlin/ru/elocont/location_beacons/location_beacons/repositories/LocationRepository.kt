package ru.elocont.location_beacons.location_beacons.repositories

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn
import ru.elocont.location_beacons.location_beacons.models.request.CellInfo
import ru.elocont.location_beacons.location_beacons.models.response.CellLocation
import ru.elocont.location_beacons.location_beacons.services.UnwiredLabsService
import ru.elocont.location_beacons.location_beacons.services.buildUnwiredLabsService

class LocationRepository private constructor(private val service: UnwiredLabsService) {
    var lastCellLocation: CellLocation? = null
        private set

    companion object {
        val instance: LocationRepository by lazy {
            LocationRepository(buildUnwiredLabsService())
        }
    }

    suspend fun getLocationByCellInfo(cellInfo: CellInfo) = flow {
        val response = service.getLocationByCellInfo(cellInfo)
        val cellLocation = response.body()
        emit(cellLocation)
    }.flowOn(Dispatchers.IO)
}