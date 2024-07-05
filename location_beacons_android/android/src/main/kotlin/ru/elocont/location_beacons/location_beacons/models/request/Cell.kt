package ru.elocont.location_beacons.location_beacons.models.request

import com.squareup.moshi.Json

data class Cell(
    @Json(name = "lac")
    val lac: Int,
    @Json(name = "cid")
    val cid: Int,
    @Json(name = "psc")
    val psc: Int? = null
)
