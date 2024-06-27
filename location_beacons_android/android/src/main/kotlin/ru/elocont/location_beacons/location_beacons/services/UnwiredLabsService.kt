package ru.elocont.location_beacons.location_beacons.service

import retrofit2.Response
import retrofit2.http.Body
import retrofit2.http.POST
import ru.elocont.location_beacons.location_beacons.model.request.CellInfo
import ru.elocont.location_beacons.location_beacons.model.response.CellLocation

interface UnwiredLabsService {
    @POST("v2/process.php")
    suspend fun getLocationByCellInfo(@Body cellInfo: CellInfo): Response<CellLocation>
}