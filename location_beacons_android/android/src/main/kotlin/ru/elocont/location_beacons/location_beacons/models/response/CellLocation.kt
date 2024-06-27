package ru.elocont.location_beacons.location_beacons.models.response

import com.squareup.moshi.Json

data class CellLocation(
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

    fun toMap(): Map<String, Any?> =
        mapOf(
            "status" to status,
            "message" to message,
            "accuracy" to accuracy,
            "address" to address,
            "latitude" to latitude,
            "longitude" to longitude
        )
}