package ru.elocont.location_beacons.location_beacons.repository

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn
import ru.elocont.location_beacons.location_beacons.model.request.CellInfo
import ru.elocont.location_beacons.location_beacons.service.UnwiredLabsService

class LocationRepository(
    private val service: UnwiredLabsService
) {
    suspend fun getLocationByCellInfo(cellInfo: CellInfo) = flow {
        val response = service.getLocationByCellInfo(cellInfo)
        emit(response.body())
    }.flowOn(Dispatchers.IO)
}