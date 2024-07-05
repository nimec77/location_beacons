package ru.elocont.location_beacons.location_beacons.models.response

import com.squareup.moshi.Json

data class CellLocation(
    @Json(name = "status")
    val status: String,
    @Json(name = "message")
    val message: String?,
    @Json(name = "accuracy")
    val accuracy: Double?,
    @Json(name = "address")
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