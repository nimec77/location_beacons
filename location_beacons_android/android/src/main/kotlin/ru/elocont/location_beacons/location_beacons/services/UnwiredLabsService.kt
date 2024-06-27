package ru.elocont.location_beacons.location_beacons.services

import retrofit2.Response
import retrofit2.http.Body
import retrofit2.http.POST
import ru.elocont.location_beacons.location_beacons.models.request.CellInfo
import ru.elocont.location_beacons.location_beacons.models.response.CellLocation

interface UnwiredLabsService {
    @POST("v2/process.php")
    suspend fun getLocationByCellInfo(@Body cellInfo: CellInfo): Response<CellLocation>
}