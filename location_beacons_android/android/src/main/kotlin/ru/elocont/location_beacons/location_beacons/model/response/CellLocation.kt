package ru.elocont.location_beacons.location_beacons.model.response

import com.squareup.moshi.Json

data class CellLocation (
    val status: String,
    val message: String?,
    val accuracy: Int?,
    val address: String?,

    @Json(name = "lat")
    val latitude: Double? = null,

    @Json(name = "lon")
    val longitude: Double? = null
) {
    fun isSuccess() = status == "ok"
}