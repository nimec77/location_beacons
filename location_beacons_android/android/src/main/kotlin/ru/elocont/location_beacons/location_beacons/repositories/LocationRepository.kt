package ru.elocont.location_beacons.location_beacons.repositories

import ru.elocont.location_beacons.location_beacons.models.request.CellInfo
import ru.elocont.location_beacons.location_beacons.models.response.CellLocation
import ru.elocont.location_beacons.location_beacons.services.UnwiredLabsService

class LocationRepository(private val service: UnwiredLabsService) {
    var lastCellLocation: CellLocation? = null
        private set

    suspend fun getLocationByCellInfo(cellInfo: CellInfo):  CellLocation? {
        val response = service.getLocationByCellInfo(cellInfo)
        val cellLocation = response.body()
        return cellLocation
    }
}